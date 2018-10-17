#!/bin/bash
#====================================================
# Author: VizierBi
# Create Date: 2018-10-17
# Description:自动封解IP 
#====================================================
t1=`date -d "-1 min" +%Y:%H:%M`
log=/data/applogs/nginx/access.log

block_ip(){
	egrep "$t1:[0-5]+" $log >/tmp/tmp_last_min.log
	
	#记录一分钟内访问高于100的IP
	awk '{print $1}' /tmp/tmp_last_min.log|sort -n|uniq -c|sort -n|awk '$1>100{print $2}' > /tmp/bad_ip.list
	#计算ip数量
	n=`wc -l /tmp/bad_ip.list|awk '{print $1}'`
	#当ip大于0使用iptables封
	if [ $n -ne 0 ];then
		for ip in `cat /tmp/bad_ip.list`;do
			iptables -I INPUT -s $ip -j REJECT
		done
	    echo "`date`封掉的IP有" >> /tmp/block_ip.log
		cat /tmp/bad_ip.list >> /tmp/block_ip.log
	fi

}
unblock_ip(){
	#将包数小于5的ip记录到临时文件并标记为白名单IP
	iptables -nvL INPUT|sed '1d'|awk '$1<5 {print $8}' > /tmp/good_ip.list
	n=`wc -l /tmp/good_ip.list|awk '{print $1}'`
	if [ $n -ne 0 ];then
		for ip in `cat /tmp/good_ip.list`;do
			iptables -D INPUT -s $ip -j REJECT
		done
	fi
	iptables -Z
}
#获取当前分钟数
t=`date +%M`
#每隔30分钟执行解IP

if [ $t == 0 ];then
	unblock_ip
	block_ip
else
	block_ip
fi


