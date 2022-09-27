local component = require("component")
local robot = require("robot")
local computer = require("computer")
local sides = require("sides")
local inv = component.inventory_controller
local tk = component.tank_controller

local function init()
    local bucket_slot = 1
    local tank_slot = 2
    local full_tank_slot = 3
end

local function copy()
    robot.select(bucket_slot)
    inv.equip()
    for i = 1, 10 do
        tk.fill(1000)
        inv.equip()
        robot.use(sides.front)
        inv.equip()
    end
    robot.select(tank_slot)
    robot.drop()
    robot.select(full_tank_slot)
    for i = 1, 9 do
        robot.suck(1)
        tk.drain(10000)
        robot.transferTo(tank_slot)
        flag = true
        while flag do
            fd = tk.getFluidInTank(sides.down)
            if fd[1].capacity - fd[1]+.amount > 10000 then
                flag = false
            else
                os.sleep(1)
            end
        end
        robot.fillDown(10000)
    end    
    robot.suck(1)
    tk.drain(10000)
    robot.transferTo(tank_slot)
end

init()
while true do
    copy()
end