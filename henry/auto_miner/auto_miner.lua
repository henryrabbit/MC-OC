
-- 针对矿物分布稀疏的情况研发的高效率机器人自动挖矿程序，另带地牢扫描功能
-- 原理上避免了死循环。
-- 建议为机器人装备3*3*3模式的谐振电钻
-- 放置机器人时请确认机器人面朝北方，并正确输入初始x,y,z坐标参数，（后续版本将增加初始化检测）

local component = require("component")
-- using openOS
local robot = require("robot")
local sides = require("sides")
local inv = component.inventory_controller
local shell = require("shell")
local s = shell.parse(...)
local baselocation = {tonumber(s[1]),tonumber(s[2]),tonumber(s[3])}
local location = {tonumber(s[1]),tonumber(s[2]),tonumber(s[3])}
--北西南东的坐标向量
local forward_vector = {{0,-1},{-1,0},{0,1},{1,0}}
--当前面对方向
local forward = 1

local lowerbound = max(-analyze_depth, 6-ore_depth)
local upperbound = analyze_depth

dofile("auto_miner.cfg")

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
			y = y-1;
		else if str=="up" then
			y = y+1;
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
	if x!=location[1] then
		while forward_vector[forward][1]*(x-location[1])<=0 do
			turn()
		end
		while x!=location[1] do
			if move("forward")==false then
				move("up")
			end
		end
	end
	if z!=location[3] then
		while forward_vector[forward][2]*(z-location[3])<=0 do
			turn()
		end
		while z!=location[3] do
			if move("forward")==false then
				move("up")
			end
		end
	end
end

--汇报地牢坐标？？
local function find_dungeon

end

local function ore_scan( x, z, t)
	local ans = analyzer.scan(x,z)
	for i = 2, t do
		local tmp = component.geolyzer.scan(x,z)
		for j = 33+lowerbound, 33+upperbound do
			ans[j] = ans[j] + tmp[j]
		end
	end
	local minore=33
	local maxore=33
	local numore=0
	for j = 33+lowerbound, 33+upperbound do
		ans[j] = ans[j]/t
		if 4.5<ans[j] and ans[j]<5.5 then
			numore = numore+1
			minore = min(minore, j)
			maxore = max(maxore, j)
		else if 3.5<ans[j] and ans[j]<4.5 then
			numore = numore-2
		else if ans[j]>90000
			numore = numore-100000
		end end end
	end
	if numore<=-10 then 
		find_dungeon()
	end
	if numore>0 then
		return true,minore-33,maxore-33
	else
		return false,0,0
	end
end

--大范围按顺序地模糊分析寻找矿物确定前往区域
local function analyze_xz()
	local tmpforward = 1
	local x=0
	local z=0
	if ore_scan(0, 0, analyze_times) then
		return 0, 0
	end
	for i=1,analyze_radius*4 do
		for j=1,i,2 do
			x=x+forward_vector[tmpforward][1]
			z=z+forward_vector[tmpforward][2]
			if ore_scan(x, z, analyze_times) then
				return x, z
			end
		end
		tmpforward = tmpforward%4+1
	end
	return forward_vector[forward][1]*analyze_radius,forward_vector[forward][2]*analyze_radius
end

--小范围精确查找矿物确定挖掘范围
local function analyze_y()
	local a,b,c = ore_scan(0, 0, detail_analyze_times)
	return location[2]+b, location[2]+c
end

--往回丢产物
local function send_ore()
	robot.select(orebox_slot)
	swing_move("forward")
	
end

--拿电池充电
local function get_charge()

end

--初始化(不必要)，通过放置方块并检测确定前方方向并标记,通过下降检测下方基岩确定高度，xz使用相对坐标系,可初始化。
local function init_work()

end

--结束工作，收到某种信号后试图返回最开始放置机器人的地方
local function finish_work()

end

--不存在的没有设计的通信函数

--暂时不存在的主程序