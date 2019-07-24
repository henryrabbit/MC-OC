-- @Author: FVortex
-- @Date:   2019-07-24 12:46:14
-- @Last Modified by:   TowardtheStars
-- @Last Modified time: 2019-07-24 13:30:05


-- For openOS

local shell = require("shell")
local fs = require("filesystem")

local lib_path = "/usr/lib"

local function create_dir(dir_name)
    return shell.execute(string.format("mkdir %s", dir_name))
end

local function to_usr_lib()
    if not fs.exists(lib_path) then
        create_dir(lib_path)
    end
    return shell.setWorkingDirectory(lib_path)
end

local function download_file(file_url)
    print(string.format("Downloading %s", file_url))
    return shell.execute(string.format("wget %s", file_url))
end

local function download_list(url_list, root_url)
    local s = true
    if not root_url then root_url = "" end
    for k, v in ipairs(url_list) do
        s = download_file(string.format("%s%s", root_url, v))
        if not s then return false end
    end
    return true
end

local function remove_dir(dir)
    return shell.execute(string.format("rm -rf %s", dir))
end

src_url = "https://github.com/henryrabbit/MC-OC/raw/fvortex/fv/robot_pos/"
files = {"directions.lua", "init.lua", "position.cfg", "vector.lua"}

to_usr_lib()
remove_dir("robot_pos")
create_dir("robot_pos")
shell.setWorkingDirectory(string.format("%s/%s",lib_path,"robot_pos"))
download_list(files, src_url)


end


