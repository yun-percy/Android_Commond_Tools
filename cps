#!/usr/bin/python
#-*- coding:utf-8 -*-
#此脚本使用在Android 各项处理上
#制作者：振云
import commands
import os
import common
import sys
import argparse
#-------------参数区---------------------
LOCAL_PATH=os.environ['PWD']
op=argparse.ArgumentParser(description='修改图片的脚本，支持批量，默认按照原来的长宽比。超出以居中形式裁剪')
op.add_argument('file',type=str,help='文件所在路径和文件名')
op.add_argument('width',type=int,help='目标长度')
op.add_argument('height',type=int,help='目标宽度')
options=op.parse_args()
print LOCAL_PATH
source_file=options.file
target_width=options.width
target_height=options.height
outdir=os.path.join(LOCAL_PATH,'out')
target_file=os.path.join(outdir,source_file)
#-------------函数区---------------------
def change_length():
    cmd='convert -resize '+str(target_width)+'x'+str(target_height_fit)+' '+source_file+' '+target_file
    print cmd
    (status,output)=commands.getstatusoutput(cmd)
    print status,output
def check_env():
    if os.path.isdir(outdir):
        pass
    else:
        common.mkdir(outdir)
    if os.path.isfile(source_file):
        pass
    else:
        print target_file+' Not Found! exit....'
        sys.exit(2)
#-------------流程区---------------------
check_env()
cmd='identify '+options.file
print cmd
(status,output)=commands.getstatusoutput(cmd)
print status,output
PIC_INFO=output.split()
print PIC_INFO
PIC_NAME=PIC_INFO[0]
PIC_TYPE=PIC_INFO[1]
PIC_SIZE=PIC_INFO[2]
PIC_LARGE=PIC_INFO[7]
print "图片名称：\t"+PIC_NAME
print "图片类型：\t"+PIC_TYPE
print "图片尺寸：\t"+PIC_SIZE
print "图片大小：\t"+PIC_LARGE
source_file_width=int(PIC_SIZE.split('x')[0])
source_file_height=int(PIC_SIZE.split('x')[-1])
print source_file_height,source_file_width
if target_height < source_file_height:
    target_height_fit=(target_width*source_file_height/source_file_width)
else:
    target_height_fit=target_height
print '\033[0;31m '+ str(target_height_fit)+' \033[0m'
change_length()
