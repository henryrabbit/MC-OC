-- @Author: FVortex
-- @Date:   2019-07-27 16:28:45
-- @Last Modified by:   TowardtheStars
-- @Last Modified time: 2019-07-27 23:30:49

-- Use holograms to display .3dm files defined by Sangar
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
  io.write("Choose hologram: ")
  local index
  repeat
    index = tonumber(io.read("*n"))
    if not (index and addresses[index]) then
      io.write("\nInvalid index!\nChoose hologram: ")
    end
  until index and addresses[index]
  component.setPrimary("hologram", addresses[index])
end

if #addresses == 0 then
    io.stderr:write("This program need at least 1 hologram to run. \nBut no available hologram device attached.")
    os.exit(3)
end

local hologram = component.hologram
local args, ops = shell.parse(...)

if #args < 1 then
  io.write([[Usage: view3dm [options] FILE
    --x, --y, --z : Set the offset coordinates for the model, must be positive or 0
    -t : Show model when state=true
    -u : Show model in uniformed color(index 1)
    --scale : Set the scale of hologram, range:[0.33, 3]
    --c1, --c2, --c3: Set the palette of hologram, value in RGB code.
    --xt, --yt, --zt : Set the offset translation, 0 by default
    --[texture name]: Specify the color id for texture
]])
  os.exit(0)
end

local file, reason = io.open(args[1], "r")
if not file then
  io.stderr:write("Failed opening file: " .. args[1] .. "\n Reason:".. reason .. "\n")
  os.exit(1)
end

io.write("Loading file...\n")

local rawdata = file:read("*all")
file:close()
local data, reason = load("return " .. rawdata)
if not data then
  io.stderr:write("Failed loading model: " .. reason .. "\n")
  os.exit(2)
end
data = data()
io.write("Load complete!")
-- Copy ends here
-----------------------------------------------------------

local off_xt = tonumber(ops.xt) or 0
local off_yt = tonumber(ops.yt) or 0
local off_zt = tonumber(ops.zt) or 0

hologram.setTranslation(off_xt, off_yt, off_zt)

local off_x = tonumber(ops.x) or 0
local off_y = tonumber(ops.y) or 0
local off_z = tonumber(ops.z) or 0

-- local loop = tonumber(ops.l)
local state = ops.t or false
local uni_color = ops.u
local scale = tonumber(ops.scale)
if scale then
    hologram.setScale(scale)
    io.write(string.format("Scale: %f\n", hologram.getScale()))
end

local function spc_check(i, c)
    c = tonumber(c) or hologram.getPaletteColor(i)
    hologram.setPaletteColor(i, c)
    io.write(string.format("Set palette color %d to %d.\n", i, c))
end

spc_check(1, ops.c1)
-- For mods with higher tier hologram?
if hologram.maxDepth() > 1 then
    spc_check(2, ops.c2)
    spc_check(3, ops.c3)
end

local function showHolo(state)
    local color_count = 1
    hologram.clear()
    for i, shape in ipairs(data.shapes or {}) do
        io.write(i.."/"..#(data.shapes).."\r")
        if (shape.state ~= state) or (shape.state == nil) then
            -- Get color settings from shell or automatically allocate colors to shapes
            local color = uni_color or tonumber(ops[shape.texture])
            if not color then
                color = color_count + 1
                color_count = (color_count + 1) % 3
            end
            for x = shape[1], shape[4]-1 do
                for z = shape[3], shape[6]-1 do
                    hologram.fill(x + 1 + off_x, z + 1 + off_z, shape[2] + 1 + off_y, shape[5] + off_y , color)
                end
            end
        end
    end
end

io.write("Generating...")
showHolo(state)
io.write("Generation complete!")





