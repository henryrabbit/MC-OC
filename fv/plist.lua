-- @Author: FVortex
-- @Date:   2019-07-24 17:07:34
-- @Last Modified by:   TowardtheStars
-- @Last Modified time: 2019-07-24 17:46:55
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
    list = {"robot_pos.lua" = false},
    require = {"util"}
}

plist["util"] = {
    type = "lib",
    list = {
        "util"=true,
        "util/vector.lua"=false,
        "util/directions.lua"=false,
        "path.lua"=false
    }
}

return plist
