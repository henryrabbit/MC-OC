-- @Author: FVortex
-- @Date:   2019-07-24 16:35:26
-- @Last Modified by:   TowardtheStars
-- @Last Modified time: 2019-07-24 17:19:43

local path = {}

function path.join( ... )
    local args = { ... }
    local s = ""
    for i = 1,..,#args do
        s = string.format("%s/%s", s, args[i])
    end
    return s
end

function path.split(str)
    local result = {}
    local split_pos = string.find(str, "/")
    local entry
    while split_pos do
        table.insert(result, string.sub(str, 1, split_pos - 1))
        str = string.sub(str, split_pos+1)
    end
    return result
end

path.version = "1.0.0"

return path