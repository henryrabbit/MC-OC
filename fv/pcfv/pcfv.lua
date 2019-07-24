-- @Author: FVortex
-- @Date:   2019-07-24 12:46:14
-- @Last Modified by:   TowardtheStars
-- @Last Modified time: 2019-07-24 17:48:52


-- For openOS
local package_control = {}

local shell = require("shell")
local fs = require("filesystem")

local help_message = "
pcfv < 子命令 >
======================
子命令
--------------
install
安装/升级程序/程序包
install [-a|-l|-s] <程序名|URL> [安装位置]
-a 强制将程序作为应用下载到\"/usr/bin\"中
-l 强制将程序作为库下载到\"/usr/lib\"中
-s 强制将程序作为源代码下载到当前目录中

<程序名|URL>
程序名：将自动定位至本仓库的master分支，并根据仓库中的plist.txt文件找到URL进行下载
URL：直接从URL下载

[安装位置]
用于自定义下载到本地的位置，若此参数不为空，则前面的[-a|-l|-s]无效

--------------
help
显示帮助信息
"

local bin_path = "/usr/bin"
local lib_path = "/usr/lib"
local src_url = "https://github.com/henryrabbit/MC-OC/raw/master/fv"
local plist_url = "https://github.com/henryrabbit/MC-OC/raw/master/fv/plist.lua"

function package_control.create_dir(dir_name)
    return shell.execute(string.format("mkdir %s", dir_name))
end

function package_control.remove_dir(dir)
    return shell.execute(string.format("rm -rf %s", dir))
end

function package_control.to_dir(dir)
    if not fs.exists(dir) then
        create_dir(dir)
    end
    return shell.setWorkingDirectory(dir)
end


local function package_control.download_file(file_url)
    print(string.format("Downloading %s", file_url))
    return shell.execute(string.format("wget %s", file_url))
end

local function package_control.download_list(url_list, root_url)
    local s = true
    if not root_url then root_url = "" end
    for k, v in ipairs(url_list) do
        s = download_file(string.format("%s%s", root_url, v))
        if not s then return false end
    end
    return true
end

local function read_env()
    src_url = os.getenv("PCFV_SRC_REPO") or src_url
    plist_url = os.getenv("PCFV_PLIST") or src_url
    bin_path = os.getenv("PCFV_BIN_PATH") or bin_path
    lib_path = os.getenv("PCFV_LIB_PATH") or lib_path
end

read_env()

local cur_dir = shell.getWorkingDirectory()

package_control.to_dir("/etc")
os.remove("/etc/plist.lua")
package_control.download_file(plist_url)

plist = dofile("/etc/plist.lua")

local args, ops = shell.parse(...)
local target = ""
if args[1] == "install" then
    pack = plist[args[2]]
    if ops[a] then target = bin_path end
    if ops[l] then target = lib_path end
    if ops[s] then target = cur_dir  end
    if args[3] then target = args[3] end
    package_control.to_dir(target)

    for k,v in pairs(pack) do
        if v then
            package_control.create_dir(k)
        else
            package_control.download_file(k)
        end
    end

    package_control.to_dir(cur_dir)
end

if args[1] == "help" then print(help_message) end



