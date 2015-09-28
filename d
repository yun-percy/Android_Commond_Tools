#!/bin/bash
#此脚本使用在Android 各项处理上
#制作者：振云
. envsetup
#变量区
# set -/x
PROJECT=$1
PROJECT_APK=$PROJECT.apk
PROJECT_JAR=$PROJECT.jar
LOACAL_PATH=`pwd`
OUT_PATH="$LOACAL_PATH/out"
PROJECT_TYPE=`echo $PROJECT| awk -F . '{print $NF}'`
REAL_NAME=`echo $PROJECT |sed 's/\(.*\)\..*$/\1/'`
#选项区

while getopts a:b:c:h opt
do
    case "$opt" in
    a) echo "a options";;
    b) echo "b options and the value is $OPTARG" ;;
    c) echo "c options";;
	h) echo -e "a:\ta options\nb:\tb options\nc:\tc options";;
	*) echo -e "unknow options: \ninput -h to get help doc";;
    esac
done
#函数区
HEAD_INFO(){
  echo ''
  echo '====================================================='
  echo "Android Apktools decode command with $APKTOOLS_JAR"
  echo "Android 反编译解包指令，打包版本为: $APKTOOLS_JAR"
  echo "解包时间为： $DATE_INFO "
  echo
  echo
}
CHECK_PROJECT(){
  if [ "$PROJECT_TYPE" == "jar" ] || [ "$PROJECT_TYPE" == "apk" ]; then
      echo "Firsh check Past"
  else
    echo -e "\033[31m$PROJECT isn't a Android file ! \033[0m"
    exit
  fi
  if [ ! -f "$PROJECT" ]; then
    echo -e "\033[33mError: Can't find $PROJECT\033[0m"
    if [ -f "$PROJECT_APK" ] || [ -f "$PROJECT_JAR" ]; then
      if [[ -f $PROJECT_JAR ]]; then
        PROJECT=$PROJECT_JAR
      else
        PROJECT=$PROJECT_APK
      fi
      echo -n "but I find a "
      echo -ne "\033[33mapk/jar \033[0m"
      echo -n "named as you input,Do you means decode "
      echo -ne "\033[32m$PROJECT\033[0m"
      echo "?"
      echo -n "input "
      echo -ne "\033[33mn/N\033[0m"
      echo -n " cancle decode "
      echo -ne "\033[32m$PROJECT\033[0m"
      echo ",press any key to continue: "
      read -n 1 confirm_decode
      if  [ "$confirm_decode" == "n" ] || [ "$confirm_decode" == "N" ] ; then
        exit
      fi
      CHECK_PROJECT
    else
      echo "exitting ....."
      exit
    fi
  fi
  PROJECT_TYPE=`echo $PROJECT| awk -F . '{print $NF}'`
  REAL_NAME=`echo $PROJECT |sed 's/\(.*\)\..*$/\1/'`
}
DECODE_FOLDER_CHECK(){
  if [[ $PROJECT_TYPE == "jar" ]]; then
    DECODE_FOLDER=$PROJECT.out
  else
    DECODE_FOLDER=$REAL_NAME
  fi
  if [ -d "$DECODE_FOLDER" ]; then
    echo -n "I find the decode folder has "
    echo -ne "\033[31mexist \033[0m"
    echo -n "in this folder, "
    echo -n "I will move it to "
    echo -e "\033[33m${DATE}_${DECODE_FOLDER}\033[0m"
    mv $DECODE_FOLDER ${DATE}_${DECODE_FOLDER}
    echo -e "\033[32mnow decode will go on\033[0m"
  fi
}
DECODE_PROJECT(){
  apktool d ${LOACAL_PATH}/${PROJECT}
  ret=$?
  if [[ $ret == 1 ]]; then
    echo -e "\033[31mError: Decode Failed\033[0m"
  fi
}
#流程区
HEAD_INFO # 打印头部信息
CHECK_PROJECT #智能检查apk/jar 是否存在
DECODE_FOLDER_CHECK #检查反编译目录是否存在
DECODE_PROJECT #反编译 apk/jar
echo -e "\033[32mDone!\033[0m"