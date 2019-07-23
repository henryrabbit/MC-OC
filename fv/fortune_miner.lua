-- @Author: FVortex
-- @Date:   2019-07-22 18:54:54
-- @Last Modified by:   TowardtheStars
-- @Last Modified time: 2019-07-23 00:13:50

local component = require("component")
-- using openOS
local robot = require("robot")
local sides = require("sides")
local inv = component.inventory_controller

local ore_list = {}
ore_list["minecraft:diamond_ore"]=-1
ore_list["galacticraftcore:basic_block_core"]=8
ore_list["galacticraftplanets:asteroids_block"]=4

local repair_tool_side = sides.up
local ore_src_side = sides.down
local output_side = sides.up
local max_use = 300

local sleep_when_no_ores = 10


local function ore_slot()
	for i = 1,16 do
		local item_stack = inv.getStackInInternalSlot(i)
		if item_stack and ore_list[item_stack.name]
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

local function mine()
	print("Mining...")
	robot.swing()
	robot.suck()
	use_count = use_count + 1
	if use_count >= max_use
	then
		repair_tool()
		use_count = 0
	end
end

local function output()
	print("Exporting minerals...")
	for i = 1,16 do
		local item_stack = inv.getStackInInternalSlot(i)
		if item_stack and (not ore_list[item_stack.name]) then
			robot.select(i)
			inv.dropIntoSlot(output_side, 1)
		end
	end
	print("Export complete")
end

-- No filter!
local function input_ore()
	print("Importing ores...")
	local import_success = true
	for i = 1, inv.getInventorySize(ore_src_side) do
		import_success = inv.suckFromSlot(ore_src_side, i)
		if import_success then
			print("Import complete")
			break
		end
	end
	if not import_success then
		print("Nothing to import!")
		os.sleep(sleep_when_no_ores)
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
