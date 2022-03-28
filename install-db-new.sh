#!/bin/bash
#卸载默认或已安装的mysql
echo "卸载默认或已安装的mysql"
for i in $(rpm -qa|grep mysql);do rpm -e $i --nodeps;done
rm -rf /var/lib/mysql && rm -rf /etc/my.cnf
if [ $? -eq 0 ];then
 echo "成功卸载老版本mysql."
fi
echo "++++++++++++++++++++++++++++++++++++++"
#安装 mysql8
echo "开始安装mysql8"
yum localinstall https://repo.mysql.com//mysql80-community-release-el7-1.noarch.rpm -y && yum install mysql-community-server -y
systemctl start mysqld && systemctl enable mysqld
echo "初始密码为:`grep 'temporary password' /var/log/mysqld.log`"
 
