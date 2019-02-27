#!/bin/bash
#====================================================
# Author: VizierBi
# Create Date: 2019-02-27
# Description:监控磁盘使用状态，并报警 
#====================================================
s_name=`echo $0| awk -F '/' '{print $NF}'`

mail_user=vizier.bi@gmail.com

chk_space(){
	df -m|sed '1d'| awk -F '%|+' '$5>90 {print $7,$5}'> /tmp/chk_space.log
	n=`wc -l /tmp/chk_space.log|awk '{print $1}'`
	if [ $n -gt 0 ];then
		tag=1
		for d in `awk '{print $1}'/tmp/chk_space.log`;do
			find $d -type d | sed '1d'|xargs du -sm| sort -nr|head -3
		done > /tmp/most_space.txt
	fi
}

chk_inode(){
	df -i|sed '1d'|awk -F '%|+' '$5>90 {print $7,$5}'> /tmp/chk_inode.log
		n=`wc -l /tmp/chk_inode.log|awk '{print $1}'`
		if [ $n -gt 0 ];then
			tag=2
		fi
}

m_mail(){
	log=$1
	t_s=`date +%s`
	t_s2=`date -d "1 hours ago" +%s`
	if [! -f /tmp/$log];then
		touch /tmp/$log
		chattr +a /tmp/$log
		echo $t_s2 >> /tmp/$log
	fi
	t_s2=`tail -1 /tmp/$log|awk '{print $1}'`
	echo $t_s >> /tmp/$log
	v=$[$t_s-$t_s2]
	if [ $v -gt 1800 ];then
		python mail.py $mail_user "磁盘使用率超百分之90" "`cat $2`" 2 >/dev/null
		echo "0" > /tmp/$log.count
	else
		if [ ! -f /tmp/$log.count ];then
			echo "0" > /tmp/$log.count
		fi
		nu=`cat /tmp/$log.count`
		nu2=$[$nu+1]
		echo $nu2 > /tmp/$log.count
		if [ $nu2 -gt 30 ];then
			python mail.py $mail_user "磁盘使用率过90超30分钟"
			echo "0" > /tmp/$log.count
		fi
	fi
	}

ps aux | grep "$s_name"|grep -vE "$$|grep" > /tmp/ps.tmp
p_n=`wc -l /tmp/ps.tmp|awk '{print $1}'`

if [ $p_n -gt 0 ];then
	exit
fi

chk_space
chk_inode

if [ $tag == 1 ];then
	m_mail chk_space /tmp/most_sp.txt
elif [ $tag == 2 ];then
	m_mail chk_inode /tmp/chk_inode.log
fi

