#!/bin/bash
#此脚本用来合并framework的odex文件
#制作者：振云

#变量区
# set -x

#函数区
DEX_FRAMEWORK(){
	for i in *.odex; do
		echo $i
		dextra.ELF64  -dextract $i
		ret1=$?
		mv *classes.dex classes.dex
		ret2=$?
		jar=`echo $i |sed 's/\(.*\)\..*$/\1/'`
		ret3=$?
		zip -m ${jar}.jar classes.dex
		ret4=$?
		if [ $ret1 == 0 ] && [ $ret2 == 0 ] && [ $ret3 == 0 ] && [ $ret4 == 0 ]
			then
			echo -e "\033[32mDone!\033[0m"
			rm $i
		fi
		mv ${jar}.jar out/
	done
}
DEX_BOOT_OAT(){
	dextra.ELF64  -dextract $1
	ret0=$?
	if [[ $ret0 != 0 ]]; then
		echo -e "\033[31mdeodex failed... exiting\033[0m"
		exit
	fi
	for i in *@classes.dex
	do
		jar_name=`echo $i | awk -F @ '{print $(NF-1)}'`
		ret1=$?
		echo jar_name
		mv $i classes.dex
		ret2=$?
		zip -m $jar_name classes.dex
		ret3=$?
		if [ $ret1 == 0 ] && [ $ret2 == 0 ] && [ $ret3 == 0 ]
			then
			echo -e "\033[32mDone!\033[0m"
			rm $i
		fi
		mv $jar_name out/
	done
}
CHECK_JAR(){
	for i in *.jar
	do
		ret=$(zipinfo $i | grep classes.dex)
		if [[ "$ret" != "" ]]; then
			echo "$i already have dex file"
			mv $i out
		fi
	done
}
#选项区
if [ ! -d "out" ]; then
  	mkdir out
fi
while getopts ab:ch opt
do
    case "$opt" in
    a) echo "dex all odex in this dirctory"
	DEX_FRAMEWORK
	;;
    b) echo "dex $OPTARG in this dirctory "
	DEX_BOOT_OAT $OPTARG
	;;
    c) echo "check jar,if it have classes.dex then mv it to out "
	CHECK_JAR
;;
	h) echo -e "a:\ta options\nb:\tb options\nc:\tc options";;
	*) echo -e "unknow options: \ninput -h to get help doc";;
    esac
done

#流程区

echo -e "\033[32mDone!\033[0m"
