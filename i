#!/usr/bin/python
#-*- coding:utf-8 -*-
#此脚本用来安装apk

import GetDeviceStatus
from common import bcolors
import common
import sys
import commands
import argparse
#-------------参数区---------------------
op=argparse.ArgumentParser(description="This Python Script is used for install Android App")
op.add_argument('file',type=str,help="input apk file to install")
option=op.parse_args()
#-------------函数区---------------------
#-------------流程区---------------------
common.check_file_exist(option.file, True)
GetDeviceStatus.cs_wait()
cmd='adb install -r '+option.file
(status,output)=commands.getstatusoutput(cmd)
if status==0:
    print 'intall '+bcolors.OKBLUE+option.file+bcolors.OKGREEN+'succeed!'
else:
    print 'intall '+bcolors.OKBLUE+option.file+bcolors.FAIL+'FAILED:'
    print output
    sys.exit(1)


