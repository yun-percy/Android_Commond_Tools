#!/bin/bash
#此脚本用来 DIY ROM 用
#制作者：陈云
#变量区
FILE_PATH=`pwd`
PROJECT=$1
TARGET_PATH=$2
#函数区
DONE(){
	echo -n "The "
	echo -ne "\033[33m$PROJECT\033[0m"
	echo -n " has transl delivery to "
	echo -e "\033[32m$TARGET_PATH\033[0m"
}
PUSH(){
	echo "attempt push $PROJECT to $TARGET_PATH"
	cs
	adb push $PROJECT $TARGET_PATH
	if [[ $? == 0 ]]; then
		DONE
		return 0
	else
		echo -e "\033[31mdelivery failed!\033[0m"
		return 1
	fi
}
PULL(){
	adb pull $PROJECT $TARGET_PATH
	if [[ $? == 0 ]]; then
		DONE
		return 0
	else
		echo -e "\033[31mdelivery failed!\033[0m"
		return 1
	fi
}
PUSH_OR_PULL(){
	if [ ! -f "$PROJECT" ]; then
		cs
		ret=$(adb shell "ls $PROJECT")
		if [[ "$ret" == "" ]]; then
			echo -e "\033[31mCan't find $PROJECT in PC nor Android Devices!\033[0m"
			return 1
		else
			PULL
		fi
	elif [[ -d "$PROJECT" ]]; then
		PUSH
	else
		PUSH
	fi
}
#主体流程区
echo "==========================="
echo
echo "Android push/pull Tools "
echo "p +  file/path +path/file"
echo
echo "==========================="
PUSH_OR_PULL


