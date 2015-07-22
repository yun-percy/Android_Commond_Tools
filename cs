#!/bin/bash
#此脚本使用在Android 各项处理上
#制作者：振云

#变量区
# set -x
TRYING_TIMES=1
MODE="null"
output_infomation(){
	echo -n "The device "
	echo -ne "\033[32mConnected\033[0m"
	echo -n ",and in the "
	echo -e "\033[36m$MODE Mode\033[0m"

}
check_android_status(){
result1=$(adb devices)
# echo result1:$result1
result2=`echo $result1|awk '{print $NF}'`
# echo "result2:$result2"
case "$result2" in
	"device" )
		MODE="Normal"
		output_infomation
		return 2
		;;
	"recovery" )
		MODE="Recovery"
		output_infomation
		return 3
		;;
	* )
		result3=$(fastboot devices)
		result4=`echo $result3|awk '{print $NF}'`
		if [[ "$result4" == "fastboot" ]]; then
			MODE="Fastboot/Bootloader"
			output_infomation
			return 4
		else
			echo -n "The device "
			echo -ne "\033[31m NOT Connected \033[0m"
			echo -n " Trying again --> "
			echo -e "\033[33m$TRYING_TIMES\033[0m"
			sleep 2
			((TRYING_TIMES++))
			check_android_status
		fi
		;;
	# *)

		# default
esac
}

#流程区

adb start-server
check_android_status

