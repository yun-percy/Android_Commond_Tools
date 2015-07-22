#!/bin/bash
#此脚本为 git push的懒人脚本,比如第一次推送, 一键推送.一键推送详细模式
#制作者：振云

#变量区
# set -x

#函数区

#选项区

while getopts im:fh opt
do
    case "$opt" in
    m) echo -n "your commit message is "
		echo -e "\033[36m\"$OPTARG\"\033[0m"
		git add .
		git commit -m "$OPTARG"
		push
		;;
    f)
	git init
	git add --all
	git commit -m "first commit "
	read -p "请输入远程仓库地址: " REMOTE
	git remote add origin $REMOTE
	push
	;;
    i) echo "show logs:"
	git status
	echo
	echo -e "\033[33mAre you Confirm to git push this Change ?\033[0m"
	echo  -n "press"
	echo -ne "\033[32m AnyKey \033[0m"
	echo -n "To Continue OR"
	echo -ne "\033[31m Ctrl + C  \033[0m"
	echo -n "Cancle It : "
	read -n 1
;;
	h) echo -e "a:\ta options\nb:\tb options\nc:\tc options";;
	*) echo -e "unknow options: \ninput -h to get help doc";;
    esac
done
shift $[ $OPTIND -1 ]
#流程区

echo -e "\033[32mDone!\033[0m"

