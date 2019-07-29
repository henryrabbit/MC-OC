local component = require("component")
local shell = require("shell")

addresses = {}
for address in component.list("printer3d") do
  table.insert(addresses, address)
  print(#addresses .. ": " .. address)
end
if #addresses > 1 then
  io.write("Choose printer: ")
  local index
  repeat
    index = tonumber(io.read("*n"))
    if not (index and addresses[index]) then
      io.write("\nInvalid index!\nChoose printer: ")
    end
  until index and addresses[index]
  component.setPrimary("printer3d", addresses[index])
end

local printer = component.printer3d

local help_msg = [[Usage: print3d [options] FILE [FILE2 [FILE3 ...] ]
FILE : .3dm file to print, if u want to print more than 1 file, seperate them with space

-x, -y, -z : Reverse the model on axis x|y|z
-t : Only print activated state (into the deactivated state of print result)
-f : Only print deactivated state (If along with -t, this will be ignored)
-r : Reverse redstone feature of the print result ([1,15] -> false, 0/false -> true)
-b : Reverse the buttonMode of model
-c : Reverse the collidable attribute of both state of model

--label : Set label of the result
--tooltip : Set tooltip of the result
--light : Set light level of the print result

]]

local args, ops = shell.parse(...)
if #args < 1 then
  io.write(help_msg)
  os.exit(0)
end

local reverse_x = ops.x
local reverse_y = ops.y
local reverse_z = ops.z

-- Should print only 1 state
local force_state = ops.f or ops.t
-- Which state to print
local state_forced = ops.t or false -- (nil == false) is false

local function readData(path)
  local file, reason = io.open(path, "r")
  if not file then
    io.stderr:write("Failed opening file: " .. reason .. "\n")
    os.exit(1)
  end

  local rawdata = file:read("*all")
  file:close()
  local data, reason = load("return " .. rawdata)
  if not data then
    io.stderr:write("Failed loading model: " .. reason .. "\n")
    os.exit(2)
  end
  return data()
end

local function printData(data)
  io.write("Configuring...\n")
  printer.reset()
  if data.label then
    printer.setLabel(ops.label or data.label)
  end
  if data.tooltip then
    printer.setTooltip(ops.tooltip or data.tooltip)
  end
  if data.lightLevel and printer.setLightLevel then -- as of OC 1.5.7
    printer.setLightLevel(tonumber(ops.light) or data.lightLevel)
  end
  if data.emitRedstone then
    if ops.r then
      printer.setRedstoneEmitter(data.emitRedstone ~= 0)
      -- if data.emitRedstone is false, this will not be executed
    else
      printer.setRedstoneEmitter(data.emitRedstone)
    end
  end
  if data.buttonMode then
    if ops.b then
      printer.setButtonMode(not data.buttonMode)
    else
      printer.setButtonMode(data.buttonMode)
    end
  end
  if data.collidable and printer.setCollidable then
    if ops.c then
      printer.setCollidable(not data.collidable[1], not data.collidable[2])
    else
      printer.setCollidable(not not data.collidable[1], not not data.collidable[2])
    end
  end

  for i, shape in ipairs(data.shapes or {}) do
    if reverse_x then
      shape[1] = 16 - shape[1]
      shape[4] = 16 - shape[4]
    end
    if reverse_y then
      shape[2] = 16 - shape[2]
      shape[5] = 16 - shape[5]
    end
    if reverse_z then
      shape[3] = 16 - shape[3]
      shape[6] = 16 - shape[6]
    end
    if not force_state or shape.state == state_forced then
      -- if force_state, then always state is false
      -- else, use shape.state
      local result, reason = printer.addShape(shape[1], shape[2], shape[3], shape[4], shape[5], shape[6], shape.texture, not (force_state or not shape.state), shape.tint)
      if not result then
        io.write("Failed adding shape: " .. tostring(reason) .. "\n")
      end
    end
  end

  io.write("Label: '" .. (printer.getLabel() or "not set") .. "'\n")
  io.write("Tooltip: '" .. (printer.getTooltip() or "not set") .. "'\n")
  if printer.getLightLevel then -- as of OC 1.5.7
    io.write("Light level: " .. printer.getLightLevel() .. "\n")
  end
  io.write("Redstone level: " .. select(2, printer.isRedstoneEmitter()) .. "\n")
  io.write("Button mode: " .. tostring(printer.isButtonMode()) .. "\n")
  if printer.isCollidable then -- as of OC 1.5.something
    io.write("Collidable: " .. tostring(select(1, printer.isCollidable())) .. "/" .. tostring(select(2, printer.isCollidable())) .. "\n")
  end
  io.write("Shapes: " .. printer.getShapeCount() .. " inactive, " .. select(2, printer.getShapeCount()) .. " active\n")

  local result, reason = printer.commit(count)
  if result then
    io.write("Job successfully committed!\n")
  else
    io.stderr:write("Failed committing job: " .. tostring(reason) .. "\n")
  end
end

for i, v in ipairs(args) do
  printData(readData(v))
end


