-- @Author: FVortex
-- @Date:   2019-07-22 18:54:54
-- @Last Modified by:   TowardtheStars
-- @Last Modified time: 2019-07-23 14:10:58

local component = require("component")
local robot = require("robot")
local sides = require("sides")
local inv = component.inventory_controller

dofile("fortune_miner.cfg")


local function ore_slot()
	for i = 1,16 do
		local item_stack = inv.getStackInInternalSlot(i)
		if item_stack and ore_list[item_stack.name]
		then
			if type(ore_list[item_stack.name]) == "table" then
				if ore_list[item_stack.name][item_stack.damage] then
					return i
				end
			else
				return i
			end
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

local swing_func = nil
local function mine()
	print("Mining...")
	local swing_result = true
	swing_result, str = swing_func()
	robot.suck()
	if swing_result then
		use_count = use_count + 1
		if use_count >= max_tool_use
		then
			repair_tool()
			use_count = 0
		end
	else
		print("Mining failed.")
		print(string.format("Reason: %s", str))
	end
end

local output_func = nil
local function output()
	print("Exporting minerals...")
	for i = 1,16 do
		local item_stack = inv.getStackInInternalSlot(i)
		if item_stack and (not ore_list[item_stack.name]) then
			robot.select(i)
			output_func()
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
		print(string.format("Nothing to import! Robot will sleep for %d second(s).", sleep_when_no_ores))
		os.sleep(sleep_when_no_ores)
	end
end

-- Convert config into function settings
if (output_side == sides.front) then
	output_func = robot.drop
else if (output_side == sides.up) then
	output_func = robot.dropUp
else if (output_side == sides.down) then
	output_func = robot.dropDown
end end end

local place_func = nil
if swing_side == sides.front then
	swing_func = robot.swing
	place_func = robot.place
else if qswing_side == sides.up then
	swing_func = robot.swingUp
	place_func = robot.placeUp
else if swing_side == sides.down then
	swing_func = robot.swingDown
	place_func = robor.placeDown
else
	print("Invalid swing side settings! Please check swing_side settings. Valid sides: up, front, down")
end end end

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
			place_func()
		else
			output()
			input_ore()
		end
	end
end
