-- @Author: FVortex
-- @Date:   2019-07-24 11:25:35
-- @Last Modified by:   TowardtheStars
-- @Last Modified time: 2019-07-24 17:19:02


local vector = {}
vector.Vector3 = {x=0, y=0, z=0, name="Vector3"}

function vector.Vector3:new(o, x, y, z)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.__add = function(l, r)
        return Vector3:new(nil, l.getX() + r.getX(), l.getY() + r.getY(), l.getZ() + r.getZ())
    end

    self.__sub = function(l, r)
        return Vector3:new(nil, l.getX() - r.getX(), l.getY() - r.getY(), l.getZ() - r.getZ())
    end

    self.__mul = function(l, r)
        if type(l) == "table" and l.name == "Vector3" and type(r) == "number" then
            return Vector3(nil, l.getX() * r, l.getY() * r, l.getZ() * r)
        else if type(r) == "table" and r.name == "Vector3" and type(l) == "number"
            return Vector3(, r.getX() * l, r.getY() * l, r.getZ() * l)
        else
            return nil
        end end
    end
    self.__newindex = nil
end

function vector.Vector:getX()
    return self.x
end

function vector.Vector:getY()
    return self.y
end

function vector.Vector:getZ()
    return self.z
end

vector.version = "1.0.0"

return vector

