#!/usr/bin/python
#-*- coding:utf-8 -*-
#此脚本使用在Android 各项处理上
#制作者：振云
import argparse
import random
import common
import sys
import os
from common import bcolors
import commands
#-------------参数区---------------------
parse=argparse.ArgumentParser(description="this Python script is used for build apk ")
parse.add_argument('-k',type=str,choices=['platform','test','shared','media','zte'],help="<key> Key to use to sign the apk, default is platform key")
parse.add_argument('-j',type=str,choices=['152','200b9','200rc2','200rc4','200'],help="<jar> apktool.jar to use to build the apk, default is apktool_2.0.0.jar")
parse.add_argument('files',type=str,help="<apk or jar> input jar or apk to decode it")
args=parse.parse_args()
apktool_jar='apktool V200'
signapk_jar='null'
key_pem='null'
key_pk8='null'
project_name='null'
#-------------函数区---------------------
def set_jar():
	global apktool_jar
	if args.j:
		common.set_apktool_jar(args.j)
		apktool_jar='apktool V'+args.j
	else:
		common.set_apktool_jar('200')
		apktool_jar='apktool V200'
def set_signkey():
	global signapk_jar,key_pem,key_pk8
	signapk_jar=common.read_signapk_jar()
	key_path=common.read_key_path()
	print args.k
	if args.k=='zte':
		key_pem=key_path+'/zte/platform.x509.pem'
		key_pk8=key_path+'/zte/platform.pk8'
		print key_pem,key_pk8
	elif args.k and args.k!='platform':
		key_pem=key_path+'/'+args.k+'.x509.pem'
		key_pk8=key_path+'/'+args.k+'.pk8'
		print key_pem,key_pk8
	else:
		key_pem=key_path+'/platform.x509.pem'
		key_pk8=key_path+'/platform.pk8'
		print key_pem,key_pk8
def check():
	if os.path.isdir(project):
		pass
	else:
		print "The Target: "+bcolors.LIGHT_BLUE+project+bcolors.ENDC+" is "+bcolors.FAIL+"Not Exist"+bcolors.ENDC
		sys.exit(1)
def backup_project(project):
	print project
	if os.path.isfile('out/'+project):
		time=str(common.get_time())
		os.renames('out/'+project, 'out/'+time+'_'+project)
def build_jar_apk():
	global project_name
	project_name=common.get_file_name_only(project)
	if '.out' in project:
		backup_project(project_name)
		cmd='apktool b '+project+' -o out/'+project_name
		print cmd
		(status,output)=commands.getstatusoutput(cmd)
		print status,output
		if status ==0:
			print 'build '+bcolors.OKBLUE+project+bcolors.OKGREEN+' Done!'+bcolors.ENDC
			print 'OutPut---->'+bcolors.OKGREEN+os.getcwd()+'/out/'+project_name+bcolors.ENDC
			sys.exit(0)
		else:
			print bcolors.FAIL+'Build FAIL!'+bcolors.ENDC
			sys.exit(1)
	else :
		backup_project(project_name+'.apk')
		cmd='apktool b '+project+' -o out/'+project_name+'_decode.apk'
		print cmd
		(status,output)=commands.getstatusoutput(cmd)
		print status,output
		if status ==0:
			print 'build '+bcolors.OKBLUE+project+bcolors.OKGREEN+' Done!'+bcolors.ENDC
		else:
			print bcolors.FAIL+'Build FAIL!'+bcolors.ENDC
			sys.exit(1)
def sign_apk():
	cmd='java -jar '+signapk_jar+' '+key_pem+' '+key_pk8+' out/'+project_name+'_decode.apk'+' out/'+project_name+'_sign.apk'
	print cmd
	(status,output)=commands.getstatusoutput(cmd)
	if status ==0:
		print 'Sign '+bcolors.OKBLUE+project+bcolors.OKGREEN+' Done!'+bcolors.ENDC
	else:
		print bcolors.FAIL+'Sign FAIL!'+bcolors.ENDC
		sys.exit(1)
def zipalign_apk():
	print "starting zipalign ...."
	cmd='zipalign 4 out/'+project_name+'_sign.apk out/'+project_name+'.apk'
	# print cmd
	(status,output)=commands.getstatusoutput(cmd)
	# print status,output
	if status ==0:
		print 'zipalign '+bcolors.OKBLUE+project+bcolors.OKGREEN+' Done!'+bcolors.ENDC
	else:
		print bcolors.FAIL+'zipalign FAIL!'+bcolors.ENDC
		sys.exit(1)
def delete_orign_files():
	import shutil
	if os.path.isdir(project+'/build'):
		shutil.rmtree(project+'/build')
	if os.path.isdir(project+'/original'):
		shutil.rmtree(project+'/original')
def head_info():
	print """\n=====================================================
Android Apktools build command with """+bcolors.LIGHT_BLUE+apktool_jar+bcolors.ENDC+"""
Android 反编译打包指令，打包版本为: """+bcolors.LIGHT_BLUE+apktool_jar+bcolors.ENDC+"""
打包时间为： """+bcolors.OKBLUE+time_info+bcolors.ENDC

#-------------流程区---------------------
set_jar()
set_signkey()
time_info=common.get_time_info()
head_info()
common.mkdir('out')
project=sys.argv[1]
check()
print 'building '+bcolors.OKBLUE+project+bcolors.ENDC+' .......'
build_jar_apk()
sign_apk()
zipalign_apk()
delete_orign_files()
print 'OutPut---->'+bcolors.OKGREEN+os.getcwd()+'/out/'+project_name+'.apk'+bcolors.ENDC