-- @Author: FVortex
-- @Date:   2019-07-24 10:09:36
-- @Last Modified by:   TowardtheStars
-- @Last Modified time: 2019-07-24 12:17:52


-- This is a positioning API for robots from OpenComputers
-- If you want to makesure this functions properly
-- Don't use anything that spins or moves the robot is "robot" package!


local robot = require("robot")
local component = require("component")
local sides = require("sides")

local directions = dofile("./direction.lua")
local vector_api = dofile("./vector.lua")

robot.direction = directions.north
robot.position = vector_api.Vector3(,0,0,0)

dofile("position.cfg")

function robot.getX(absolute)
    if absolute then
        return x + origin_x
    else
        return x
    end
end

function robot.getY(absolute)
    if absolute then
        return y + origin_y
    else
        return y
end

function robot.getZ(absolute)
    if absolute then
        return z + origin_z
    else
        return z
    end
end

function robot.getPos(absolute)
    if absolute then
        return pos + robot.getOffsetPos()
    else
        return pos
    end
end

function robot.setOffsetPos(x, y, z)
    origin_x = x or origin_x
    origin_y = y or origin_y
    origin_z = z or origin_z
end

function robot.getOffsetPos()
    return {origin_x, origin_y, origin_z}
end

function robot.getOffsetX()
    return origin_x
end

function robot.getOffsetY()
    return origin_y
end

function robot.getOffsetZ()
    return origin_z
end

function robot.setOffsetX(x)
    origin_x = x
end

function robot.setOffsetY(y)
    origin_y = y
end

function robot.setOffsetZ(z)
    origin_z = z
end

-- Override from here
robot.forward = nil
robot.back = nil
robot.up = nil
robot.down = nil
robot.turnLeft = nil
robot.turnRight = nil
robot.turnAround = nil

function robot.forward()
    local r, str = component.robot.move(sides.front)
    if r then robot.position = robot.position + robot.direction:getVector() end
    return r, str
end


function robot.back()
    local r, str = component.robot.move(sides.back)
    if r then robot.position = robot.position - robot.direction:getVector() end
    return r, str
end


function robot.up()
    local r, str = component.robot.move(sides.up)
    if r then robot.position = robot.position + vector_api.Vector3(, 0, 1, 0) end
    return r, str
end


function robot.down()
    local r, str = component.robot.move(sides.down)
    if r then robot.position = robot.position + vector_api.Vector3(, 0, -1, 0) end
    return r, str
end


function robot.turnLeft()
    local r = component.robot.turn(false)
    robot.direction = robot.direction.getSide(sides.left)
    return r
end


function robot.turnRight()
    local r = component.robot.turn(true)
    robot.direction = robot.direction.getSide(sides.right)
    return r
end


function robot.turnAround()
    local turn = math.random() < 0.5 and robot.turnLeft or robot.turnRight
    local r = turn() and turn()
    return r
end

return robot


