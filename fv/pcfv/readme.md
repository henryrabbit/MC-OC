openOS程序包控制器
==========

# 使用方法
pcfv < 子命令 >
## 子命令
### install
安装/升级程序/程序包
install \[-a|-l|-s\] <程序名|URL> \[安装位置\]
-a 强制将程序作为应用下载到"/usr/bin"中
-l 强制将程序作为库下载到"/usr/lib"中
-s 强制将程序作为源代码下载到当前目录中

<程序名|URL>
程序名：将自动定位至本仓库的master分支，并根据仓库中的plist.txt文件找到URL进行下载
URL：直接从URL下载

\[安装位置\]
用于自定义下载到本地的位置，若此参数不为空，则前面的\[-a|-l|-s\]无效

### help
显示帮助信息

# 安装
```
mkdir /usr/bin
cd /usr/bin
wget https://github.com/henryrabbit/MC-OC/raw/master/fv/pcfv/pcfv.lua
```
下载完成即可使用