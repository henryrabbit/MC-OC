-- @Author: FVortex
-- @Date:   2019-07-22 18:54:54
-- @Last Modified by:   TowardtheStars
-- @Last Modified time: 2019-07-22 23:18:26

local component = require("component")
-- using openOS
local robot = require("robot")
local sides = require("sides")
local inv = component.inventory_controller

local ore_list = {"minecraft:diamond_ore","galacticraftcore:basic_block_core","galacticraftplanets:asteroids_block"}

local repair_tool_side = sides.up
local ore_src_side = sides.down
local output_side = sides.up
local max_use = 300


local function ore_slot()
	for i = 1,16 do
		local item_stack = inv.getStackInternalSlot(i)
		if item_stack and item_stack.name in ore_list
		then
			return i
		end
	end
	return nil
end

local function repair_tool()
	inv.equip()
	inv.dropIntoSlot(repair_tool_side, 1)
	inv.equip()
end

local use_count = 0

local function mine():
	robot.swing()
	robot.suck()
	use_count = use_count + 1
	if use_count >= max_use
	then
		repair_tool()
		use_count = 0
	end
end

local output():
	for i = 1,16 do
		local item_stack = inv.getStackInternalSlot(i)
		if item_stack and (not (item_stack.name in ore_list))
		then
			inv.dropIntoSlot(output_side, 1)
		end
end

local input_ore():
	for i = 1, inv.getInventorySize(ore_src_side) do
		inv.suckFromSlot(ore_src_side, i)
	end
end

while (true)
do
	placed_block, des = robot.detect()
	if (placed_block)
	then
		mine()
		output()
	else
		slot = ore_slot()
		if slot then
			robot.select(slot)
			robot.place()
		else
			input_ore()
		end
	end
end
