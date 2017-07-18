#!/usr/bin/python
#-*- coding:utf-8 -*-
#此脚本使用在Android 各项处理上
#制作者：振云
import commands
import sys
from common import bcolors
import time
result={
        "device":"Normal",
        "recovery":"Recovery",
        "fastboot":"Fastboot",
        "offline":"Offline",
        'host':"Host",
        "sideload":"Sideload",
        "unauthorized":"Unauthorized"
        }
print_time=1
def print_status(cs_status):
    global print_time
    if print_time > 1:
        print ""+bcolors.ENDC
    print "the status is "+bcolors.OKGREEN+"Connected"+bcolors.ENDC+",and in the "+bcolors.LIGHT_BLUE+cs_status+bcolors.ENDC
def cs():
    (status,output)=commands.getstatusoutput('adb devices')
    output=output.strip()
    output=output.strip('\t')
    output=output.strip('\n')
    output=output.strip('\r')
    i=1
    while output[-i].isalpha():
        i+=1
    i-=1
    # print '111'+output[-1]+'22222'
    if output[-i:]!='attached':
        status=result[output[-i:]]
        # print output[-i:]
        return status.strip()
    else:
        (status,output)=commands.getstatusoutput('fastboot devices')
        output=output.strip()
        if len(output)!=0:
            while output[-i].isalpha():
                i+=1
            i-=1
            status=result[output[-i:]]
            return  status.strip()
        else :
            return result['offline']
def cs_wait():
    status=cs()
    # print status
    global print_time
    print_time=0
    print_time_len=1
    try:
        while status=='Offline' or status=='Unauthorized':
            if print_time%10!=0:
                print_time_len=len(str(print_time))
            if print_time==0:
                print "device "+bcolors.FAIL+status+bcolors.ENDC+" ,try again -->"+bcolors.WARNING_ORANGE,print_time,
            print_time_str=str(print_time)
            sys.stdout.write('\b'*print_time_len+print_time_str)
            sys.stdout.flush()
            print_time+=1
            status=cs()
            time.sleep(0.1)
    except KeyboardInterrupt:
        print "\nOperation canceled."
        sys.exit(0)

    # print_status(status+' Mode')
    # print status
    if status=='Normal':
        print_status(status+' Mode')
        return 0
    elif status=='Recovery' or status=='Sideload':
        print_status(status+' Mode')
        return 1
    elif status== 'Fastboot':
        print_status(status+' Mode')
        return 2
    elif status=='Sideload':
        print_status(status+' Mode')
        return 3
    elif status=='Offline':
        print "device not connected...."
#print status





#check_status(status)
