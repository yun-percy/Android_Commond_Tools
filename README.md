# Android_Shell_Tools
Some shell script use for handler Android

#安卓脚本命令集

从今天开始，我不定时的将自己这三年来写的一些快捷脚本整理优化后公布到这里，他们大多数是一些shell脚本，没有后缀名，但是能够极大的提高你的工作效率。这里面会有你要经常用到的重启命令，反编译命令，挂载命令，解包命令等等，也有你不常用的一键刷机命令，测试OTA命令，图片转换命令，等其它有趣的命令。

让我们看看shell能给我们带来什么。

这个脚本集，大部分是由本人编写，但部分也是其它大神的智，所以这个工具集采用MIT协议，请自觉遵守。

                                                        振云      于 2015年6月18日 腾讯

Setup
------

第一步也是最重要一步，将所有命令全部都初始化完成

		cd ~/bin && chmod 777 Setup && ./Setup


d,f
------

+ d

输入 d + apk/jar就能轻松将apk或者jar包反编译，例：

		d music.apk
		或者
		d android.policy.jar

如果你只输入:  

		d music

		工具会自动查找当前目录下会不会存在 music.apk 或者 music.jar
		并将其反编译

+ f

输入 f 加 apk名称就能将框架加载进来，你可以这样

		f framework-res.apk
		或者：  f framework-res.apk
		或者   f k-res.a

脚本会自动去查找匹配项

cs
-------

这不是反恐精英的缩写，是 connect status的缩写，这个脚本是用来检测手机当前状态的函数，
它有三个返回值：

		2 表示正常模式
		3 表示recovery模式
		4 表示fastboot模式

如果你的设备没有连接，它会每隔3秒，尝试获取设备当前状态，直到获取为止。这个脚本将会是后面几个脚本的核心支持

bo , re , reco
-------

这三个脚本全部建立在 cs脚本之上，通过cs的返回值，来执行相关的动作

		bo 		在任意界面重启到 bootloader(fastboot)
		re 		在任意界面重启到 正常系统
		reco 	在任意界面重启到 recovery

由于 cs 的功劳， 这三个脚本不会在设备没连接，或者没完全连接上的情况下，停止操作。它们会将设备重启到对应的界面后才停止

