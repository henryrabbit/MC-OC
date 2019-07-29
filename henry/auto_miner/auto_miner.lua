
-- 针对矿物分布稀疏的情况研发的高效率机器人自动挖矿程序，另带地牢扫描功能
-- 原理上避免了死循环。
-- 建议为机器人装备3*3*3模式的谐振电钻
-- 放置机器人时请确认机器人面朝北方，并正确输入初始x,y,z坐标参数，（后续版本将增加初始化检测）
dofile("auto_miner.cfg")
local component = require("component")
-- using openOS
local robot = require("robot")
local sides = require("sides")
local computer = require("computer")
local inv = component.inventory_controller

local location = {baselocation[1], baselocation[2], baselocation[3]}
print(location[1],location[2],location[3])

--北西南东的坐标向量
local forward_vector = {{0,-1},{-1,0},{0,1},{1,0}}
--当前面对方向
local forward = 1

local lowerbound = math.max(-analyze_depth, 6-ore_depth)
local upperbound = analyze_depth


--试图向某个方向先挖掘后移动并返回是否成功
local function move( str )
	local flag
	if str=="down" then 
		robot.swingDown()
		flag=robot.down()
	else if str=="up" then
		robot.swingUp()
		flag=robot.up()
	else 
		robot.swing()
		flag=robot.forward()
	end end
	if flag then
		if str=="down" then 
			location[2] = location[2] - 1
		else if str=="up" then
			location[2] = location[2] + 1
		else 
			location[1] = location[1] + forward_vector[forward][1]
			location[3] = location[3] + forward_vector[forward][2]
		end end
	else
		return false
	end
end

--向左转
local function turn()
	if robot.turnLeft() then
		forward = forward % 4 + 1
		return true
	else return false
	end
end


--判断并拿电池充电
local function get_charge()
	robot.select(empty_slot)
	inv.equip()
	local tmp = inv.getStackInInternalSlot(empty_slot).Energy
	inv.equip()
	robot.select(1)
	if computer.energy()>10000 and tmp>200000 then
		return
	end
	robot.swingUp()
	robot.swingDown()
	while robot.detectUp() or robot.detectDown() do
		move("forward")
		robot.swingUp()
		robot.swingDown()
	end
	robot.select(powerbox_slot)
	robot.placeDown()
	robot.select(empty_slot)
	robot.suckDown()
	robot.select(powerbox_slot)
	robot.swingDown()
	robot.select(empty_slot)
	robot.placeDown()
	move("up")
	robot.select(charger_slot)
	robot.placeDown()
	robot.select(empty_slot)
	inv.equip()
	robot.dropDown()
	while not robot.suckDown() do
		os.sleep(2)
	end
	inv.equip()
	robot.select(charger_slot)
	robot.swingDown()
	robot.select(poweraccepter_slot)
	robot.placeDown()
	component.redstone.setOutput(sides.down,15)
	while computer.energy()<computer.maxEnergy()-100 do
		os.sleep(5)
	end
	component.redstone.setOutput(sides.down,0)
	robot.swingDown()
	move("down")
	robot.select(empty_slot)
	robot.swingDown()
	robot.select(powerbox_slot)
	robot.placeDown()
	robot.select(empty_slot)
	robot.dropDown()
	robot.select(powerbox_slot)
	robot.swingDown()
	robot.select(1)
end

--躲避障碍走向指定的y坐标
local function moveto_y( y )
	while location[2] < y do
		if move("up")==false then
			turn()
			move("forward")
		end
	end		
	while location[2] > y do
		if move("down")==false then
			turn()
			move("forward")
		end
	end	
end

--躲避障碍走向指定的x,z坐标
local function move_xz( x, z )
	if x~=location[1] then
		while forward_vector[forward][1]*(x-location[1])<=0 do
			turn()
		end
		while x~=location[1] do
			if move("forward")==false then
				move("up")
			end
			if x%100==0 then
				get_charge()
			end
		end
	end
	if z~=location[3] then
		while forward_vector[forward][2]*(z-location[3])<=0 do
			turn()
		end
		while z~=location[3] do
			if move("forward")==false then
				move("up")
			end
			if z%100==0 then
				get_charge()
			end
		end
	end
end

--汇报地牢坐标？？
local function find_dungeon()
	return
end

local function noise( x, y, z)
	return math.sqrt(x*x+y*y+z*z)/16
end

local function ore_scan( x, z)
	print("scanning",x,z)
	local minore=33
	local maxore=33
	local unsurenum=upperbound - lowerbound + 1
	local ans = {}
	local flag = false
	while unsurenum>0 do
		local tmp = component.geolyzer.scan(x,z)
		for j = 33+lowerbound, 33+upperbound do
			local tmpnoi = noise(x,j-33,z)
			if not ans[j] then
				if tmp[j]<=2+tmpnoi then
					ans[j]=0
					unsurenum = unsurenum-1
				else if tmp[j]<5-tmpnoi or tmp[j]>90000 then
					find_dungeon()
					return false,0,0
				else if tmp[j]>4+tmpnoi and tmp[j]<5+tmpnoi then
					ans[j]=1
					unsurenum = unsurenum - 1
					minore = math.min(minore,j)
					maxore = math.max(maxore,j)
					flag=true
				else if tmp[j]>5+tmpnoi then
					ans[j]=2
					unsurenum = unsurenum-1
				end end end end			
			end
		end
	end
	if flag then print("findore!") end
	return flag,minore-33,maxore-33
end

--大范围按顺序地模糊分析寻找矿物确定前往区域
local function analyze_xz()
	local tmpforward = 1
	local x=0
	local z=0
	if ore_scan(0, 0, analyze_times) then
		return location[1],location[3]
	end
	--蛇形搜索，从近到远遍历。
	for i=1,analyze_radius*4 do
		for j=1,i,2 do
			x=x+forward_vector[tmpforward][1]
			z=z+forward_vector[tmpforward][2]
			if ore_scan(x, z) then
				return location[1]+x, location[3]+z
			end
		end
		tmpforward = tmpforward%4+1
	end
	return location[1]+forward_vector[forward][1]*analyze_radius,location[3]+forward_vector[forward][2]*analyze_radius
end

--小范围精确查找矿物确定挖掘范围
local function analyze_y()
	local a,b,c = ore_scan(0, 0)
	return location[2]+b, location[2]+c
end

--往回丢产物
local function send_ore()
	robot.select(8)
	if not inv.getStackInInternalSlot(i) then
		robot.select(1)
		return
	end
	robot.swingDown()
	while robot.detectDown() do
		move("forward")
		robot.swingDown()
	end
	robot.select(orebox_slot)
	robot.placeDown()
	for i=1,16 do
		if ore_slot[i] then			
			if inv.getStackInInternalSlot(i) then
				robot.select(i)
				for j = 1,inv.getStackInInternalSlot(i).size do
					robot.dropDown()
				end
			end
		end
	end
	robot.select(orebox_slot)
	robot.swingDown()
	robot.select(1)
end

--初始化，通过放置方块并检测确定前方方向并标记.
-- 其实还可以通过下降检测下方基岩确定高度，但是反正你得初始化坐标，我就懒得写了。
local function init_work()
	robot.select(orebox_slot)
	while true do
		robot.swing()
		ans=component.geolyzer.scan(0,-1)[33]
		robot.place()
		ans=component.geolyzer.scan(0,-1)[33]-ans
		robot.swing()
		if ans>10 then
			robot.select(1)
			return
		else
			robot.turnLeft()
		end
	end
end

--结束工作，收到某种信号后试图返回最开始放置机器人的地方
local function finish_work()
	move_xz(baselocation[1], baselocation[3])
	moveto_y(baselocation[2])
	computer.shutdown()
end

--不存在的没有设计的通信函数

--偷工减料的劣质主程序
init_work()
moveto_y(ore_depth)
send_ore()
get_charge()
while true do
	local tox,toz = analyze_xz()
	move_xz(tox,toz)
	moveto_y(ore_depth)
	send_ore()
	get_charge()
	local miny,maxy = analyze_y()
	print("scaninghere",miny,maxy)
	moveto_y(miny)
	moveto_y(maxy)
	moveto_y(ore_depth)
	send_ore()
	get_charge()
end