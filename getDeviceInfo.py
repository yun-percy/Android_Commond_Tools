#!/usr/bin/python
#-*- coding:utf-8 -*-
#此脚本使用在Android 各项处理上
#制作者：振云
import sys
import commands
import GetDeviceStatus
from common import bcolors
su=['','su -c']
build_type=['eng','userdebug','user']
output=commands.getoutput('adb start-server')
device_name=commands.getoutput('adb shell "getprop" |  grep \'ro.product.model\' | awk \'{print $NF}\' | tr -d \'[]\'|tr -d "\\r"')
def Is_Device_Root():
    (status,output)=commands.getstatusoutput('adb shell su -c "ls data"')
    if "su: not found" in output:
        status=GetDeviceStatus.cs_wait()
        if status == 1:
            return 0
        return -1
    elif "exec failed for ls data" in output:
        return 0
    else:  return 1
def Get_System_Block(su):
    # root_status=Is_Device_Root()
    (status,output)=commands.getstatusoutput('adb shell '+su+' \"ls /dev/block/platform/*/by-name/system\"')
    if "No such file or directory" in output:
        (status,output)=commands.getstatusoutput('adb shell '+su+' \"ls /dev/block/platform/*/by-name/SYSTEM\"')
        if "No such file or directory" in output:
            (status,output)=commands.getstatusoutput('adb shell '+su+' \"ls /dev/block/platform/*/by-name/APP\"')
    print status, output
    return output.strip()
def GetRecoveryBlock():
    root_status=Is_Device_Root()
    ls_never=True
    cmd='adb shell '+su[root_status]+' \"ls /dev/block/platform/*/by-name/recovery --color=never\"'
    (status,output)=commands.getstatusoutput(cmd)
    if "Aborting" in output:
        ls_never=False
        print "try to use normal ls"
        cmd='adb shell '+su[root_status]+' \"ls /dev/block/platform/*/by-name/recovery \"'
        (status,output)=commands.getstatusoutput(cmd)
    if "No such file or directory" in output:
        if ls_never:
            (status,output)=commands.getstatusoutput('adb shell '+su[root_status]+' \"ls /dev/block/platform/*/by-name/RECOVERY --color=never\"')
        else:
            (status,output)=commands.getstatusoutput('adb shell '+su[root_status]+' \"ls /dev/block/platform/*/by-name/RECOVERY \"')
        if "No such file or directory" in output:
            if ls_never:
                (status,output)=commands.getstatusoutput('adb shell '+su[root_status]+' \"ls /dev/block/platform/*/by-name/SOS --color=never\"')
            else :
                (status,output)=commands.getstatusoutput('adb shell '+su[root_status]+' \"ls /dev/block/platform/*/by-name/SOS \"')
            if "No such file or directory" in output:
                print "Can't get recovery block!"
                sys.exit(1)
    # print status,output
    return output.strip()
def Mount_System_Block():
    status=GetDeviceStatus.cs_wait()
    if status==0:
        root_status=Is_Device_Root()
        system_block=Get_System_Block(su[root_status])
        cmd='adb shell '+su[root_status]+' \"mount -o remount,rw '+system_block+' /system\"'
        print cmd
        output=commands.getoutput(cmd)
        if output=='':
            print 'mount system'+bcolors.OKGREEN+' Done !'+bcolors.ENDC
        else :
            print 'mount system'+bcolors.FAIL+' Failed!'+bcolors.ENDC
            print output
            sys.exit(1)
    elif status==1:
        cmd='adb shell \"mount -a\"'
        # print cmd
        (status,output)=commands.getstatusoutput(cmd)
        print output
        if not 'system' in output:
            print 'mount system'+bcolors.OKGREEN+' Done !'+bcolors.ENDC
        else :
            print 'mount system'+bcolors.FAIL+' Failed!'+bcolors.ENDC
            print output
            sys.exit(1)
    else :
        print 'Please Go To Recovery Mode Or Normal Mode'
#print "=========================================="
#print "ro.build.device=",device_name
#root_status=Is_Device_Root()
#print "ro.build.type=",build_type[root_status]k
