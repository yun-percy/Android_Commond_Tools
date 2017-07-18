#!/usr/bin/python
#-*- coding:utf-8 -*-

"This Python is used for get git status"

#-------------导入区---------------------
import os
import sys
import commands
import common
from common import bcolors
#-------------参数区---------------------
branch="Unknown"
change_file=[]
delete_file=[]
add_file=[]
branches=[]

#-------------函数区---------------------
def get_branch_status():
    untracked_line=None
    endline=None
    modified_file=None
    delete_file_name=None
    global branch
    remote=None
    cmd='git status'
    (status,output)=commands.getstatusoutput(cmd)
    if status==0:
        for line in output.split('\n'):
            # print line
            if "On branch" in line or "位于分支" in line:
                branch=line.split()[-1]
            if "modified:" in line or "修改：" in line:
                modified_file=str(line.split()[1])
                change_file.append(modified_file)
            if "Untracked files:" in line :
                "记录当前Untracked files所在的行号"
                untracked_line=output.split(os.linesep).index(line)
            if "no changes added to commit" in line or "修改尚未加入提交" in line :
                endline=output.split(os.linesep).index(line)
            if "nothing added to commit" in line:
                endline=output.split(os.linesep).index(line)
            if "Your branch is up-to-date with" in line:
                remote_tmp=line.replace("'","").split()[-1]
                remote=remote_tmp.split(os.sep)[0]
            if "您的分支与上游分支" in line:
                remote_tmp=line.replace("'","").split()[-2]
                remote=remote_tmp.split(os.sep)[0]

            if "deleted:" in line:
                delete_file_name=str(line.split()[1])
                delete_file.append(delete_file_name)
        if untracked_line and endline:
            for x in xrange(untracked_line,endline):
                if x+3< endline :
                    if output.split('\n')[x+3]:
                        add_file.append(output.split('\n')[x+3])
        if change_file or delete_file or add_file:
            print "Remote:\t",bcolors.OKBLUE,remote,bcolors.ENDC,"\tBranch:\t",bcolors.FAIL,branch,bcolors.ENDC
            # print change_file
            if change_file:
                for change_file_name in change_file:
                    print "modified:\t",bcolors.LIGHT_BLUE,change_file_name,bcolors.ENDC
            if add_file:
                for add_file_name in add_file:
                    print "Untracked:\t",bcolors.OKGREEN,add_file_name,bcolors.ENDC
            if delete_file:
                for delete_file_name in delete_file:
                    print "deleted:\t",bcolors.FAIL,delete_file_name,bcolors.ENDC
        else:
            print "Remote:\t",bcolors.OKBLUE,remote,bcolors.ENDC,"\tBranch:\t",bcolors.OKGREEN,branch,bcolors.ENDC
            print "nothing to commit, working directory clean"
        #print output
    else:
        print "Not a git directorys"
        sys.exit(-1)
def get_all_branch():
    global branch
    branches=[]
    cmd="git branch -a"
    (status,output)=commands.getstatusoutput(cmd)
    if status==0:
        # print output
        for line in output.split(os.linesep):
            if "remotes/" in line:
                # print line
                branch_tmp=line.replace("*","").strip().split(os.sep)[-1]
                branches.append(branch_tmp)
    else:
        sys.exit(-1)
    branches=list(set(branches))
    branches.remove(branch)
    if branches:
        print "Other Availale Branch:%s%s%s" % (bcolors.WARNING_ORANGE," ".join(branches),bcolors.ENDC)
#-------------流程区---------------------
def main():
    get_branch_status()
    get_all_branch()
if __name__ == '__main__':
    main()
