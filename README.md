# MC-OC
 田园牧鸽服务器的OCmod lua代码仓库（试行版）

用于将本地写的代码push至github后，周期性自动更新到服务器。

现已接入oppm

## 接入方法
- 在openOS中安装oppm软件包
    + 制作并向机器中插入oppm软盘
    + 确保你的电脑“们”联网（游戏内和游戏外的都要联网）
    + 在命令行中输入`install oppm`
    + 等待安装完成
- 注册此repo
    + 安装完oppm之后，在命令行中输入`oppm register https://github.com/henryrabbit/MC-OC`

然后就可以愉快地下载程序啦！

## 程序清单
安装方法：
`oppm install <程序包名>`

下列程序的标题就是程序包名

`Note：此处程序包列表不一定是最新，最新列表请于programs.cfg中查看`

### view3dm
一个用来把3dm文件用全息投影图展示的程序，需要全息投影仪（任意等级）来工作

使用方法：请在游戏中电脑命令行输入`view3dm`查看/看源码自带的帮助信息字符串

### print3d-fv
用于3d打印的程序，需要3d打印机来工作

在Sangar的print3d程序的基础上修改而来，增加了许多选项

模型格式：由Sangar定义的3dm格式，[模版](https://github.com/henryrabbit/MC-OC/blob/master/fv/models/example.3dm)

使用方法：请在游戏中电脑命令行输入`print3d`查看/看源码自带的帮助信息字符串

### midi-fv
用于播放midi音乐(.mid)的程序

在Sangar的midi程序的基础上修改而来，增加了许多选项

使用方法：请在游戏中电脑命令行输入`midi`查看/看源码自带的帮助信息字符串

### robot-recycle-gc-parachute-chest
用于回收Galacticraft的伞降箱的机器人程序

要求机器人组件：物品栏升级、物品栏控制器升级

- 使用方法
    + 机器人面对伞降箱着陆地点
    + 机器人上方放置带有物品栏的方块
    + 机器人右侧放一个GC或其他mod的水箱，要求机器人右侧的水箱中的液体可以快速被抽空(>1000mB/s)
    + 机器人附近有一个充电器可以给机器人供电
- 效果
    + 伞降箱内部全部物品都会被转移到机器人上方的“箱子”里
    + 伞降箱内部燃料会被转移到机器人右侧的水箱里
    + 伞降箱将会被破坏并被转移到机器人上方的“箱子”里

### robot-fortune_miner
用于自动使用时运镐子处理矿石

使用方法见配置文件
