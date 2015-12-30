#!/usr/bin/python
#-*- coding:utf-8 -*-
#此脚本使用在Android 各项处理上
#制作者：振云
import argparse
import sys
import commands
import os
from common import bcolors
#-------------参数区---------------------
parse=argparse.ArgumentParser(description="this Python script is used for analysis apk ")
parse.add_argument('-m',type=str,help="<commit> use gp -m \"commit message\" to commit your change.if your do not git add . it's will exec \"git add -A\" to add all change,otherwise,skipping git add")
parse.add_argument('-f',action='store_true',help="<first commit> it's equal: git add -a ;git commit -m \"first commit\",git remote add origin xxxxx.git ;push")
# parse.add_argument('files',type=str,help="<apk> input apk to dump it")
args=parse.parse_args()
#-------------函数区---------------------
def git_init():
	cmd='git init'
	(status,output)=commands.getstatusoutput(cmd)
	if status !=0:
		print 'Git: init '+bcolors.FAIL+'Failed:'+bcolors.ENDC
		print output
		sys.exit(1)
def git_remote(git_path):
	cmd='git remote add origin '+git_path
	(status,output)=commands.getstatusoutput(cmd)
	if status !=0:
		print 'Git: remote '+bcolors.FAIL+'Failed:'+bcolors.ENDC
		print output
		sys.exit(1)
def git_add():
	cmd='git status'
	(status,output)=commands.getstatusoutput(cmd)
	# print status,output
	if "要提交的变更" in output:
		pass
	else:
		cmd='git add -A'
		# print cmd
		(status,output)=commands.getstatusoutput(cmd)
		# print status,output
def git_commit(message):
	cmd='git commit -m \"'+message+'\"'
	# print cmd
	(status,output)=commands.getstatusoutput(cmd)
	# print status,output
	if status !=0:
		print 'Git: commit '+bcolors.FAIL+'Failed:'+bcolors.ENDC
		print output
		sys.exit(1)
def git_push():
	(status,output)=commands.getstatusoutput('push')
	# print status,output
	if status !=0:
		print 'Git: push '+bcolors.FAIL+'Failed:'+bcolors.ENDC
		print output
		sys.exit(1)
	print output
#-------------流程区---------------------
# print args.m
if args.f and args.m:
	print '只能输入一个参数'
if args.m:
	print "start to commit,Your commit message is:"+bcolors.LIGHT_BLUE+args.m+bcolors.ENDC
	git_add()
	git_commit(args.m)
	git_push()
if args.f:
	if os.path.isdir('.git'):
		print '.git exist.....  init '+bcolors.FAIL+'Failed'+bcolors.ENDC
		sys.exit(1)
	git_init()
	git_add()
	git_commit('firsh commit')
	remote_path=raw_input('请输入远程仓库地址: ')
	git_remote(remote_path)
	git_push()
