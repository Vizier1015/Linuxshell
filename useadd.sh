#!/bin/bash
#====================================================
# Author: VizierBi
# Create Date: 2018-10-16
# Description:批量添加10个以vizier开头用户，随机生成密码
#====================================================
. /etc/init.d/functions
user="vizier_"
filepath="/tmp/user.log"
for num in `seq -w 10`;do
	passwd="`echo "test$RANDOM"|md5sum|cut -c3-8`"
	useradd $user$num &>/dev/null &&\
	echo -e "$user${num}:$passwd" >>$filepath
	if [ $? -eq 0 ];then
		action "$user$num is ok" /bin/true
	else
		action "$user$num is not ok" /bin/false
	fi
done

echo --------------------------------
chpasswd <$filepath
cat $filepath && >$filepath
