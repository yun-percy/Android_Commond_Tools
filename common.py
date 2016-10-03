#!/usr/bin/python
#-*- coding:utf-8 -*-
#此脚本使用在Android 各项处理上
#制作者：振云
class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    LIGHT_BLUE = '\033[36m'
    WARNING_ORANGE = '\033[33m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'
#-------------参数区---------------------
#-------------函数区---------------------
def mkdir(path):
    # 引入模块
    import os
    # 去除首位空格
    path=path.strip()
    # 去除尾部 \ 符号
    path=path.rstrip("\\")
    # 判断路径是否存在
    # 存在     True
    # 不存在   False
    isExists=os.path.exists(path)
    # 判断结果
    if not isExists:
        # 如果不存在则创建目录
        print '目录 '+path+' 创建成功'
        # 创建目录操作函数
        os.makedirs(path)
        return True
    else:
        # 如果目录存在则不创建，并提示目录已存在
        # print '目录 '+path+' 已存在'
        return False
def get_time():
	import time
	system_time=time.time()
	localtime=time.localtime(system_time)
	time=time.strftime('%Y%m%d%H%M%S',localtime)
	return time
def get_time_info():
	import time
	cn_dict =['一','二','三','四','五','六','日']
	system_time=time.time()
	localtime=time.localtime(system_time)
	weekday=int(time.strftime('%w'))
	time_info_tmp=time.strftime('%Y年%m月%d日%H时%M分 周',localtime)
	time_info=time_info_tmp+cn_dict[weekday-1]
	return time_info
def get_file_name(file):
	import os
	suffix=os.path.splitext(file)[1]
	file_name=file.strip(suffix)
	return file_name
def get_file_name_only(file):
	import os
	suffix=os.path.splitext(file)[1]
	file_name=file.strip(suffix).split('/')[-1]
	return file_name
def check_file_exist(file,exit):
    import os
    import sys
    if not os.path.isfile(file):
        print bcolors.FAIL+'Can\'t '+bcolors.ENDC+'find the '+bcolors.OKBLUE+file
        if exit:
            sys.exit(1)
#-------------流程区---------------------
