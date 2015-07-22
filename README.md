# Android_Shell_Tools
Some shell script use for handler Android

#安卓脚本命令集

从今天开始，我不定时的将自己这三年来写的一些快捷脚本整理优化后公布到这里，他们大多数是一些shell脚本，没有后缀名，但是能够极大的提高你的工作效率。这里面会有你要经常用到的重启命令，反编译命令，挂载命令，解包命令等等，也有你不常用的一键刷机命令，测试OTA命令，图片转换命令，等其它有趣的命令。

让我们看看shell能给我们带来什么。

这个脚本集，大部分是由本人编写，但部分也是其它大神的智慧，所以这个工具集采用MIT协议，请自觉遵守。

                                                        振云      于 2015年6月18日 腾讯

Setup
------

第一步也是最重要一步，将所有命令全部都初始化完成

		cd ~/bin && chmod 777 Setup && ./Setup

它做了什么?

+ 配置好51-android rulues 解决99%的手机连接问题

+ 替换原系统弱爆了的bashrc

+ 一键给你搭建好linux的源码编译环境

+ 安装 git-cola gitk 等git工具,安装 wget/trimage工具

d,b,i,f,dump
------

+ d (decode apk)

输入 d + apk/jar就能轻松将apk或者jar包反编译，例：

		d music.apk
		或者
		d android.policy.jar

如果你只输入:

		d music

		工具会自动查找当前目录下会不会存在 music.apk 或者 music.jar
		并将其反编译

+ b (build apk)

输入 b + 文件夹 就能轻松将一个文件夹回编译成一个apk,输出在 out目录下,当然,加入了智能查找目标的功能<br>
以及自动使用TOS 的密钥签名和自动对其功能,为了不冲掉前面的回编译结果,还加入了自动备份功能.

		b music

+ dump

输入 dump + apk 就能轻松查看应用的名称,包名,主启动类名

输入 dump -s +apk 还能启动你手机上的这个apk(前提是你的手机安装了这个apk,配合下文中的i脚本,效果杠杆的)

		dump -s music.apk    #打印这个music的名称,包名,主启动类名,并且尝试在你的手机上启动它

+ i

输入 i + apk 就能将这个apk安装到你的手机,并且启动它

		i music.apk  安装并启动music.apk



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

bo , re , reco , p
-------

这三个脚本全部建立在 cs脚本之上，通过cs的返回值，来执行相关的动作

		bo 		在任意界面重启到 bootloader(fastboot)
		re 		在任意界面重启到 正常系统
		reco 	在任意界面重启到 recovery

由于 cs 的功劳， 这三个脚本不会在设备没连接，或者没完全连接上的情况下，停止操作。它们会将设备重启到对应的界面后才停止

+ p

将 update.zip 推送到 sdcard/里面去，你只需要这样写：

		p update.zip sdcard/

将 system/etc/apn.conf 抽取到本地，你只需要这样写

		p system/etc/apn.conf .

当连接状态不佳的时候，这个脚本会反复的推送/抽取，直到完成目的。（由于cs的功劳）

+ m

挂载你手机上的 system目录,使你能对system文件夹里面的文件进行增删,支持正常模式和recovery.使用;

		m

+ sign

输入 sign + apk 就能将这个apk签名,例:

		sign music.apk


GIT相关
-----

push

将当前commit的内容.推送的当前分支里面去,这个脚本会检查当前分支是什么,然后推送到远程的当前分支里面去

		push

gp

git push 的简写,目前支持两种模式

		gp -i  #查看当前修改
		gp -m "commit message" #一键推送
		gp -im "commit message" #上面两种相加
		gp -f #第一次推送,默认信息为 first commit


文件夹介绍
=======

+ Android_test_package/

里面有三个zip文件,三个刷机包,一个是recovery下的文件管理器,一个是正常刷机包(但是什么都不会改动,只是一个空包),一个错误刷机包

+ apktools

里面有四个版本的apktools, 可以自由切换

+ icons

ubuntu下醒目的文件夹图标

+ keys

一般签名

+ security

TOS的dd签名密钥

+ tools

一些linux下的Android可执行文件: aapt  adb  dexopt fastboot mkbootimg signapk.jar zipalign
