#!/bin/bash
#====================================================
# Author: VizierBi
# Create Date: 2019-03-12
# Description:监控TCP连接数 
#====================================================
ARGS=1
if [ $# -ne 1 ];then
	echo "Plz input an arguement:"
fi
case $1 in 
	ESTABLISHED)
		result=`netstat -an | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}' | grep -w "ESTABLISHED" |cut -d" " -f2`
		echo $result
		;;
	TIME_WAIT)
		result=`netstat -an | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}' | grep -w "TIME_WAIT" |cut -d" " -f2`
		echo $reslut
		;;
	LISTEN)
		result=`netstat -an | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}' | grep -w "LISTEN" |cut -d" " -f2`
		echo $result
		;;
	*)
	
	echo "Usage:$0(TIME_WAIT|ESTABLISHED|LISTEN)"
	;;
esac
