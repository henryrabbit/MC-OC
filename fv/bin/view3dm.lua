-- @Author: FVortex
-- @Date:   2019-07-27 16:28:45
-- @Last Modified by:   TowardtheStars
-- @Last Modified time: 2019-07-27 17:32:41

local component = require("component")
local shell = require("shell")
--------------------------------------------------
-- Mostly copied from OpenPrograms/Sangar-Programs/print3d.lua on Github
-- With a little alternation by myself

addresses = {}
for address in component.list("hologram") do
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
  component.setPrimary("hologram", addresses[index])
end

local hologram = component.hologram
local args, ops = shell.parse(...)

if #args < 1 then
  io.write("Usage: view3dm FILE [count]\n")
  os.exit(0)
end

local file, reason = io.open(args[1], "r")
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
data = data()

-- Copy ends here
-----------------------------------------------------------
io.write("Loading shapes...\n")


local off_x = ops.x or 1
local off_y = ops.y or 1
local off_z = ops.z or 1

local loop = ops.l
local state = ops.t or false
local uni_color = ops.u

local function spc_check(i, c)
    hologram.setPaletteColor(i, c or hologram.getPaletteColor(i))
end

spc_check(1, ops.c1)
spc_check(2, ops.c2)
spc_check(3, ops.c3)

local function showHolo(state)
    local color_count = 1
    hologram.clear()
    for i, shape in ipairs(data.shapes or {}) do
        if shape.state == state then
            -- Get color settings from shell or automatically allocate colors to shapes
            local color = ops[shape.texture]
            if not color then
                color = color_count
                color_count = (color_count + 1) % 3
            end
            for x = shape[1], shape[4]-1 do
                for z = shape[3], shape[6]-1 do
                    hologram.fill(x, z, shape[2], shape[5]-1, uni_color or color + 1)
                end
            end
        end
    end
end

hologram.setTransformation(off_x, off_y, off_z)

if loop then
    while true do
        state = not state
        showHolo(state)
        os.sleep(loop)
    end
else
    showHolo(state)
end




