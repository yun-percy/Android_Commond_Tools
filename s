#!/usr/bin/python
#-*- coding:utf-8 -*-
#此脚本使用在Android 各项处理上
#制作者：振云

import common
from common import bcolors
import argparse
import os
import sys
import commands
import GetDeviceStatus
import time
#-------------参数区---------------------
op=argparse.ArgumentParser(description='A Sript to sideload zip file')
op.add_argument('file',type=str,help='input a zip file to flash')
option=op.parse_args()
#-------------函数区---------------------
def sideload_wait(package):
    # print GetDeviceStatus.cs()
    print_time=0
    print_time_len=1
    while GetDeviceStatus.cs()!='Sideload':
        if print_time%10!=0:
            print_time_len=len(str(print_time))
        if print_time==0:
            print "device "+bcolors.FAIL+'Not'+bcolors.ENDC+" in sideload mode,try again -->"+bcolors.WARNING_ORANGE,print_time,
        print_time_str=str(print_time)
        sys.stdout.write('\b'*print_time_len+print_time_str)
        sys.stdout.flush()
        print_time+=1
        time.sleep(0.1)
    if print_time>0:
        print bcolors.ENDC,
    cmd='adb sideload '+package
    os.system(cmd)
    print 'sideload'+bcolors.LIGHT_BLUE,package,bcolors.ENDC+'has',bcolors.OKGREEN,'Done!',bcolors.OKGREEN
#-------------流程区---------------------
package=option.file
if not os.path.isfile(package):
    print bcolors.FAIL+'Error'+bcolors.ENDC+':Can\'t find zip file: '+bcolors.OKBLUE+package+bcolors.ENDC
    sys.exit(1)
if '.zip' in package:
    sideload_wait(package)
else:
    print op.print_help()
