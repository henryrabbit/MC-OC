
robot = require("robot")
sides = require("sides")
inv = require("component").inventory_controller

local function getFuelOutputSlot(inv_size)
    return inv_size + 3
end

local function dealFuelWithGCCanister()
    inv.getStackInInternalSlot(bucket_slot).name
    inv.dropIntoSlot(sides.front, getFuelOutputSlot(size))
    while inv.getStackInInternalSlot(bucket_slot).damage ~= 1001 do
        robot.turnRight()
        inv.equip()
        if not robot.use() then
            io.stderr:write("Tank is full!")
            -- os.exit(1)
        end
        inv.equip()
        robot.turnLeft()
        inv.dropIntoSlot(sides.front, getFuelOutputSlot(size))
        inv.suckFromSlot(sides.front, getFuelOutputSlot(size))
    end
end

-- Containers that can drain all fuel remain at once
-- Such as reservoirs and tanks in ThermalExpansion
local function dealFuelWithBigTank()
    inv.getStackInInternalSlot(bucket_slot).name
    inv.dropIntoSlot(sides.front, getFuelOutputSlot(size))
    robot.turnRight()
    inv.equip()
    robot.use()
    inv.equip()
    robot.turnLeft()
end

local usable_buckets = {
    ["galacticraftcore:oil_canister_partial"] = dealFuelWithGCCanister,
    ["thermalexpansion:reservoir"] = dealFuelWithBigTank,
    ["thermalexpansion:tank"] = dealFuelWithBigTank
}

-- assume parachute chest is in front of robot
-- assume cache chest on the top of robot
local cur_slot = 1
local bucket_slot = 5
while true do
    if robot.detect() then
        local size = inv.getInventorySize(sides.front)
        -- Recycle fuel
        robot.select(bucket_slot)
        -- assume using gc canister to drain fuel
        name = inv.suckFromSlot(sides.front, getFuelOutputSlot(size)).name
        dealer = usable_buckets[name]
        if not dealer then
            io.write(name.." is not an usable fluid container!\n")
            exit(2)
        end
        dealer()

        -- Gather all items inside
        robot.select(cur_slot)
        robot.dropUp()
        for i = 1,size do
            robot.suck()
            robot.dropUp()
        end

        robot.swing()
        robot.dropUp()
    else
        os.sleep(5)
    end
end