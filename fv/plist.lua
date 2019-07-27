-- @Author: FVortex
-- @Date:   2019-07-24 17:07:34
-- @Last Modified by:   TowardtheStars
-- @Last Modified time: 2019-07-24 18:03:27
local plist = {}

plist["fortune_miner"] = {
    _type = "app",
    list = {
        "fortune_miner/fortune_miner.lua",
        "fortune_miner/fortune_miner.cfg"
    }
}

plist["robot_pos"] = {
    _type = "lib",
    list = {"robot_pos.lua"},
    _require = {"util"}
}

plist["util"] = {
    _type = "lib",
    dir_list = {"util"}
    list = {
        "util/vector.lua",
        "util/directions.lua",
        "path.lua"
    }
}

return plist
