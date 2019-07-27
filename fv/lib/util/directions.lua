-- @Author: FVortex
-- @Date:   2019-07-24 11:07:07
-- @Last Modified by:   TowardtheStars
-- @Last Modified time: 2019-07-24 17:19:58


local _directions = {}
_directions.north = 0
_directions.west = 1
_directions.south = 2
_directions.east = 3
_directions.Direction = {dir = 0}
local sides = require("sides")

local vector = require("robot_pos/vector3")

function _directions.Direction:new(o, offset_dir)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.dir = offset_dir or directions.north
    return o
end

function _directions.Direction:getVector()
    if self.dir == directions.north then
        return Vector3:new(nil, 0, 0, -1)
    else
        if self.dir == directions.south then
            return Vector3:new(nil, 0, 0, 1)
        else
            if self.dir == directions.east then
                return Vector3:new(nil, 1, 0, 0)
            else
                if self.dir == directions.west then
                    return Vector3:new(nil, -1, 0, 0)
                else
                    return nil
                end
            end
        end
    end
end

function _directions.Direction:getSide(side)
    dir = self.dir
    if side == sides.front then return dir end
    if side == sides.left then return _directions.Direction:new(, (dir + 1) % 4) end
    if side == sides.right then return _directions.Direction:new(,(dir - 1) % 4) end
    if side == sides.back then return _directions.Direction:new(, (dir + 2) % 4) end
    return nil
end


local directions = setmetatable(_directions, {
    __newindex = nil
})

directions.version = "1.0.0"

return directions


