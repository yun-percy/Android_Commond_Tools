Android下的Python脚本工具集
=============

> 平时下班回家会看看会看看python，看多了就会顺手写一些脚本练练手。后面会将一些有意思的shell脚本，"翻译"成Python脚本，并完成 功能的升级。

初始化
-----

+ git clone 到`~/bin`目录
+ cd ~/bin
+ ./Setup

调试相关
-----

`ap`            #`adb pull`和`adb push`的缩写。

+ 支持多文件传输
+ 根据本地文件是否存在来进行push和pull
+ 支持system分区自动挂载
+ 支持data等高权限的pull和push
+ 对于push到 data和system分区的权限默认赋予 777的权限
+ push完成后会自动sync

`bo`              #adb reboot bootloader重启到bootloader,支持等待连接
`re`              #adb reboot 或者fastboot reboot 取决于你处在什么模式下。支持等待连接
`reco`            #adb reboot recovery 进入recovery模式，支持等待连接
`i`               #adb install xxx.apk，安装xxx.apk，支持等待连接
`cs`              #查看连接状态，如果没有连接就会开始计时，直到连接为止
`ads`             #adb shell      登录到android 设备，支持等待连接
`m`               #一键mount system分区为可读写状态，支持　正常模式和recovery模式，配合　ap命令调试妥妥的，支持等待连接
`e:`              #打印手机错误日志（Error）级别
`extract`         #解压压缩包，支持所有格式

刷机相关
-----

`fr`

flash recoveryimage的简写，它的作用就是，刷写recovery，不论你当前处在什么模式下都行，如果你处在正常开机模式，需要root才行，支持等待连接

`s`

adb sideload xxx.zip的简写 直接 s xxx.zip 即可，支持等待连接



git 相关
-----

        push ：     #智能识别当前git分支，然后执行 git push操作,（20160121新增，自动识别当前仓库名，以前默认为origin）
        gp:         #可用扩展参数 -m : 使用 gp -m "commit message" 快速提交  -f ：使用gp -f 快速创建第一次提交
        gs：         #git status 的简写
        gd:          #git diff简写


apktool相关
------

                d xxx.apk               #apktool d xxx.apk，如果存在decode文件夹，会被自动命名为：20151012xxxx ，可用扩展参数 -j 指定 apktool.jar
                b xxxx                  #apktool b xxx	,增加自动备份功能，增加自动签名，对齐功能。可用扩展参数 -j 同上，-k 指定签名key类型
                dump xxx.apk            #aapt dump badging xxx.apk,读取本地apk的label，包名，主启动activity名。可用扩展参数 -i 打印信息，-s 在你的手机上启动这个apk
                sign                    #签名工具，根据后面接的文件进行不同处理，sign + apk: 签名单一apk sign+目录：签名目录下所有的apk，sign+zip包：签名zip包，当然，你可以指定key


欲知详情，可用-h参数

其它偏门工具
----

                make_odin               #生成一个samsung odin包　例如： make_odin recovery.img
                mkboot                  #这是github上面一个开发者写的boot.img和recovery.img解包打包工具，用shell写的，后面有时间会用python重写一遍
                deodex                  #处理当前目录下的 framework,app,priv-app目录下的odex，支持Android 5.1
                mountimage              #mount system.img工具，使用： mountimage [system.img]
                pc                      #print cert 简写，打印证书信息，支持直接打印 x509.pem/*.rsa/apk的证书信息
                login_serve             #登录到服务器，将服务器端口，服务器名称，地址保存到 ~/.serve中，即可登录到相关服务器。配合[免密码登录SSH远程服务器](http://percychen.com/linux/2014/12/09/linuxsshnocode.html)效果更佳


不是Pyhon脚本，但是很有用，方便的缩写
-----

命令|作用
----|-----
ls|使ls命令带着彩色输出
ll|以彩色的列表方式列出目录里面的全部文件
grep|类似，只是在grep里输出带上颜色
mcd|创建一个目录并进入该目录里： mcd [目录名]
cls|进入一个目录并列出它的的内容：cls[目录名]
backup|#简单的给文件创建一个备份: backup [文件] 将会在同一个目录下创建 [文件].bak
md5check|这个函数会计算它并进行比较：md5check[文件][校验值]
makescript|用你上一个运行的命令创建一个脚本：makescript [脚本名字.sh]
genpasswd|只是瞬间产生一个强壮的密码
c|清除你终端屏幕
histg|快速搜索你的命令输入历史：histg [关键字]
..|回到上层目录
...|去上两层目录
....|去上三层目录
.....|去上四层目录
cmount|按列格式化输出mount信息
sbs|安装文件在磁盘存储的大小排序，显示当前目录的文件列表。
intercept|接管某个进程的标准输出和标准错误。注意你需要安装了 strace。
meminfo|查看你还有剩下多少内存。
alias volume|显示当前音量设置。
websiteget|下载整个网站：websiteget [URL]。
listen|显示出哪个应用程序连接到网络。
port|显示出活动的端口。
ipinfo|获得你的公网IP地址和主机名。
getlocation|返回你的当前IP地址的地理位置。
kernelgraph|绘制内核模块依赖曲线图。需要可以查看图片。
busy|在那些非技术人员的眼里你看起来是总是那么忙和神秘。
findout|查找根据文件内容查找匹配项　命令结构为　find　后缀名　匹配内容，如：find java void
mc|编译recovery用的快捷命令
sj|切换java环境变量的快捷命令(switchjava)
bashrc|编辑bashrc快捷键
rename_suffix|自动重命名函数，支持批处理
download|下载文件
repo_sync|自动同步函数
