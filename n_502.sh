#!/bin/bash
#====================================================
# Author: VizierBi
# Create Date: 2019-06-04
# Description:监控服务器1分钟内出现502状态码，超过50次则邮件报警
#====================================================
t=`date -d "-1 min" +"%Y:%H:%M:[0-5][0-9]"`
log="/data/applogs/nginx/access.log"

mail_script="/root/scripts/Linuxshell/mail2.py"
mail_user=vizier.bi@gmail.com

n=`grep $t $log|grep -c "502"`
if [ $n -gt 50 ]:then
	python $mail_script $mail_user "网站502" "1min 内出现了$n 次"
fi


