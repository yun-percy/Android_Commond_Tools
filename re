#!/usr/bin/python
#-*- coding:utf-8 -*-
#此脚本使用在Android 各项处理上
#制作者：振云
import GetDeviceStatus
import commands
status=GetDeviceStatus.cs_wait()
# print status
if status==2:
	output=commands.getoutput('fastboot reboot')
	print output
else:
	output=commands.getoutput('adb reboot')
	print output
