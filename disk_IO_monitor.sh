#!/bin/bash
#====================================================
# Author: VizierBi
# Create Date: 2019-03-18
# Description:监控磁盘IO使用率 查找出造成磁盘使用率高的进程 
#====================================================
if ! which iostat &> /dev/null;then
	yum install -y sysstat
fi

if ! which iotop &>/dev/null;then
	yum install -y iotop
fi

#定义记录日志

logdir=/tmp/iolog
[ -d $logdir ] || mkdir $logdir

#定义日志名字

dt=`date +%F`
#定义获取IO函数

get_io(){
	iostat -dx 15 > $logdir/iostat.log
	sum=0
	for ut in `grep "^$1" $logdir/iostat.log|awk '{print $NF}'|cut -d. -f1`;do
		sum=$[$sum+$ut]
	done
	echo $[$sum/5]
	}
while true;do
	#获取所有设备，对所有设备名遍历
	for d in `iostat -dx|egrep -v '^$|Device:|CPU\)'|awk '{print $1}'`;do
		io=`get_io $d`
		#将使用率大于50的（测试）记录在日志内
		if [ $io -ge 50 ];then
			date >> $logdir/dt
			cat $logdir/iostat.log >>$logdir/$dt
			iotop -obn2 >> $logdir/$dt
			echo "########################################" >>$logdir/$dt
		fi
	done
	sleep 10
done
