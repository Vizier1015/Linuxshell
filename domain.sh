#!/bin/bash
#====================================================
# Author: VizierBi
# Create Date: 2019-05-22
# Description:判断域名是否到期 
#====================================================
mail_u=vizier.bi@gmail.com
#当前日期时间戳
t1=`date +%s`

#检测whois 命令是否存在
is_install_whois(){
	which whois > /dev/null/ 2>/dev/null
	if [$? -ne 0 ];then
		yum install -y jwhois
	fi
}
notify(){
	e_d=`whois $1|grep 'Expiry Date'|awk '{print $4}'|cut -d 'T' -f 1`
	#如果e_d的值为空，则过滤关键词'Expiration Time'
	if [ -z "$e_d" ];then
		e_d=`whois $1|grep 'Expiration Time'|awk '{print $3}'`
	fi
	#将域名过期的日期转化为时间戳
	e_t=`date -d "$e_d" +%s`
	#计算一周一共多少秒
	n=`echo "86400*7"|bc`
	e_t1=$[$e_t-$n]
	e_t2=$[$e_t+$n]
	if [ $t1 -ge $e_t1 ] && [ $t1 -lt $e_t ];then
		python mail.py $mail_u "Domain$1 will to be expired." "Domain $1 exoire date is $e_d"
	fi
}

if pgrep whois &>/dev/null;then
	killall -9 whois
fi

for d in www.vizierbi.com www.google.com;do
	notify $d &
done
