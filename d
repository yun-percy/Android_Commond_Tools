#!/usr/bin/python
#-*- coding:utf-8 -*-
#此脚本使用在Android 各项处理上
#制作者：振云

import sys
import os
import common
from common import bcolors
import ConfigParser
import commands
import argparse
#-------------参数区---------------------
parse=argparse.ArgumentParser(description="this Python script is used for decode apk ")
parse.add_argument('-j',type=str,choices=['152','200b9','200rc2','200rc4','200'],help="<jar> apktool.jar to use to build the apk, default is apktool_2.0.0.jar")
parse.add_argument('files',type=str,help="<apk or jar> input jar or apk to decode it")
args=parse.parse_args()
apktool_jar='apktool V200'
#-------------函数区---------------------
def head_info():
  print """\n=====================================================
Android Apktools decode command with """+bcolors.LIGHT_BLUE+apktool_jar+bcolors.ENDC+"""
Android 反编译解包指令，打包版本为: """+bcolors.LIGHT_BLUE+apktool_jar+bcolors.ENDC+"""
解包时间为： """+bcolors.OKBLUE+time_info+bcolors.ENDC
def check():
  type="apk"
  project=sys.argv[1]
  if project.split('.')[-1]=='apk':
    pass
  elif project.split('.')[-1]=='jar':
    type="jar"
    pass
  else:
    print 'please input apk or jar files'
    sys.exit(-1)
  # print project
  if not os.path.isfile(project):
    print 'file not exist..exitting'
    sys.exit(1)
  if os.path.isdir(project+'.out'):
    time=str(common.get_time())
    os.rename(project+'.out', time+'_'+project+'.out')
  file_name=common.get_file_name(project)
  if os.path.isdir(file_name):
    time=str(common.get_time())
    os.renames(file_name, time+'_'+file_name)
def set_jar():
  global apktool_jar
  if args.j:
    common.set_apktool_jar(args.j)
    apktool_jar='apktool V'+args.j
  else:
    common.set_apktool_jar('222')
    apktool_jar='apktool V222'
#-------------流程区---------------------
check()
project=sys.argv[1]
set_jar()
time_info=common.get_time_info()
# print time,time_info
# print apktool_jar
head_info()
cmd='apktool d '+project
print cmd
(status,output)=commands.getstatusoutput(cmd)
print status,output
if status==0:
  print 'Apktool: decode '+bcolors.LIGHT_BLUE+project+bcolors.OKGREEN+' Succeeded'+bcolors.ENDC
else:
  print 'Apktool: decode '+bcolors.LIGHT_BLUE+project+bcolors.FAIL+' Failed'+bcolors.ENDC