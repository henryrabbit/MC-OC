local component = require("component")
local robot = require("robot")
local computer = require("computer")
local sides = require("sides")
local inv = component.inventory_controller
local tnk = component.tank_controller

local function init()
    local bucket_slot = 1
    local tank_slot = 2
end

local function copy()
    robot.select(bucket_slot)
    inv.equip()
    for i = 1, 10 do
        robot.use(sides.bottom)
        robot.use(sides.front)
    end
    inv.equip()
    robot.select(tank_slot)
    robot.drop()
    robot.suck()
    inv.equip()
    robot.use(sides.back)
    robot.up()
    for i = 1, 15 do
        robot.use(sides.right)
    end
    robot.down()
end

init()
while true do
    fd = tnk.getTankCapacity(sides.right)
    if fd.capacity - fd.amount > 15000 then
        copy()
    end
end