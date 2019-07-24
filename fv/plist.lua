-- @Author: FVortex
-- @Date:   2019-07-24 17:07:34
-- @Last Modified by:   TowardtheStars
-- @Last Modified time: 2019-07-24 17:15:11
local plist = {}

plist["fortune_miner"] = {
    type = "app",
    list = {
        "fortune_miner/fortune_miner.lua",
        "fortune_miner/fortune_miner.cfg"
    }
}

plist["robot_pos"] = {
    type = "lib",
    list = {"lib/robot_pos.lua"},
    require = {"util"}
}

plist["util"] = {
    type = "lib",
    list = {"lib/util/vector.lua", "lib/util/directions.lua", "path.lua"}
}

return plist
