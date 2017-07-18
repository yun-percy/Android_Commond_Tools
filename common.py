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
def read_apktool_jar():
	import ConfigParser
	import os
	cp=ConfigParser.ConfigParser()
	home_path=os.environ['HOME']
	# print home_path
	cp.read(home_path+"/bin/config/env.conf")
	return cp.get('apktools', 'apktool_jar')
def read_signapk_jar():
	import ConfigParser
	import os
	cp=ConfigParser.ConfigParser()
	home_path=os.environ['HOME']
	# print home_path
	cp.read(home_path+"/bin/config/env.conf")
	return cp.get('apktools', 'signapk_jar')
def read_key_path():
	import ConfigParser
	import os
	cp=ConfigParser.ConfigParser()
	home_path=os.environ['HOME']
	# print home_path
	cp.read(home_path+"/bin/config/env.conf")
	return cp.get('folder', 'key_path')
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
def set_apktool_jar(version):
	apktool_jar='apktool'+version+'.jar'
	jar_file=open('/tmp/apktool_jar','w')
	jar_file.truncate()
	jar_file.write(apktool_jar)
	jar_file.close()
def set_sign_key(key_type):
	key=''
def check_file_exist(file,exit):
    import os
    import sys
    if not os.path.isfile(file):
        print bcolors.FAIL+'Can\'t '+bcolors.ENDC+'find the '+bcolors.OKBLUE+file
        if exit:
            sys.exit(1)
def filetypeList():
    return{
    "52617221":"RAR",
    "504B0304":"ZIP",
    "FFD8FF":"JPEG",
    "89504E47":"PNG",
    "47494638":"GIF",
    "49492A00":"TIFF",
    "424D":"Bitmap",
    "41433130":"CAD",
    "38425053":"psd",
    "7B5C727466":"rtf",
    "3C3F786D6C":"XML",
    "68746D6C3E":"HTML",
    "44656C69766572792D646174653A":"Email",
    "CFAD12FEC5FD746F":"Outlook",
    "2142444E":"Outlook_pst",
    "D0CF11E0":"Word/Excel",
    "5374616E64617264204A":"mdb",
    "FF575043":"wpd",
    "252150532D41646F6265":"eps",
    "255044462D312E":"pdf",
    "AC9EBD8F":"qdf",
    "E3828596":"pwl",
    "57415645":"Wave",
    "41564920":"AVI",
    "2E7261FD":"Real_Audio",
    "2E524D46":"Real Media",
    "000001BA":"MPEG",
    "000001B3":"MPEG",
    "6D6F6F76":"Quicktime",
    "3026B2758E66CF11":"Windows_Media",
    "4D546864":"MIDI"
    }
def byte2hex(bytes):
    num=len(bytes)
    hexstr=u""
    for i in range(num):
        t=u"%x" % bytes[i]
        if len(t)%2:
            hexstr +=u"0"
        hexstr+=t
    return hexstr.upper()
def check_file_type(file):
    import struct
    binfile=open(file,'rb')
    tl=filetypeList()
    ftype='unknown'
    for hcode in tl.keys():
        numberOfBytes=len(hcode)/2
        binfile.seek(0)
        try:
            hbytes=struct.unpack_from("B"*numberOfBytes,binfile.read(numberOfBytes))
        except Exception, e:
            # print "unknown"
            ftype="empty"
            return ftype
        f_hcode=byte2hex(hbytes)
        if f_hcode == hcode:
            ftype=tl[hcode]
            break
    binfile.close()
    return ftype
#-------------流程区---------------------