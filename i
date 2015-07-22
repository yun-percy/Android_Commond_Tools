#!/bin/bash
#此脚本使用在Android 各项处理上
#制作者：振云

#变量区
# set -x
PROJECT=$1
APP_INFO=/tmp/app_info
#选项区
while getopts a:b:c:h opt
do
    case "" in
    a) echo "a options";;
    b) echo "b options and the value is  " ;;
    c) echo "c options";;
	h) echo -e "a:\ta options\nb:\tb options\nc:\tc options";;
	*) echo -e "unknow options: \ninput -h to get help doc";;
    esac
done
#函数区
GET_APP_INFO(){
	dump $PROJECT
}
INSTALL_APP(){
	echo -n "installing "
	echo -ne "\033[36m$PROJECT\033[0m"
	echo "....."
	adb install -r $PROJECT
	echo "try to start $PROJECT"
	# dump -s $PROJECT
}
#流程区
INSTALL_APP

echo -e "\033[32mDone\033[0m"
