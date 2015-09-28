#!/bin/bash
#此脚本用来挂载 system分区,从而使system分区达到可读写情况
#制作者：振云

#变量区
#set -x
DEVICE_NAME=COMMON
#函数区
get_block(){
	path=$(adb shell $DEVICE_SU "ls -al dev/block/platform/*/by-name"| grep system)
	path=`echo $path | awk '{print $NF}'`
	echo -n "The system block is: "
	echo -e "\033[32m$path\033[0m"
}
mount_block(){
	mount_result=$(adb shell $DEVICE_SU "mount -o remount,rw $path /system")
	echo -n "mount system block "
	if [[ $mount_result == "" ]]; then
		echo -e "\033[32mSuccessful!\033[0m"
	else
		echo -e "\033[31mFailed!\033[0m"
		echo "error : $mount_result"
	fi
}
MOUNT_BLOCK(){
		adb shell $DEVICE_SU "mount -o remount,rw $SYSTEM_BLOCK /system"
}
#选项区

while getopts x opt
do
    case "$opt" in
    "x") set -x;;
    esac
done

#流程区

cs
mode=$?
if [[ $mode == 2 ]]; then
	# GET_DEVICE_NAME
	. getPhoneName
	MOUNT_BLOCK
elif [[ $mode == 3 ]]; then
	mount_result=$(adb shell "mount -a")
	echo -n "mount system block "
	if [[ $mount_result != "*system*" ]]; then
		echo -e "\033[32mSuccessful!\033[0m"
	else
		echo -e "\033[31mFailed!\033[0m"
		echo "error : $mount_result"
	fi
else
	echo -e "\033[33mPlease Go To Recovery Mode Or Normal Mode\033[0m"
fi
echo -e "\033[32mDone!\033[0m"

