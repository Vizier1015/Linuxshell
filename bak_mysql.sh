#!/bin/bash
#====================================================
# Author: VizierBi
# Create Date: 2018-10-10
# Description:1）要求每天备份一次
#             2）备份数据库存放在/data/backup下
#             3）备份文件名称格式如：database_name-2018-10-10.sql
#			  4) 对1天以前所有sql文件压缩，格式gzip
#			  5）本地数据保留1周
#			  6）需要备份的数据同步到远程备份中心
#			  7）远程备份数据保留1个月
#====================================================
mysqldump='/usr/local/mysql/bin/mysqldump'
bakuser='root'
passwd='123456'
bakdir='/data/backup'
remote_dir='root@47.100.190.116:mysqlbackup/'
d1=`date +%F`
d2=`date +%d`

# 定义日志
exec &>/tmp/mysql_bak.log

echo "mysql backup begin at `date`"

# 对所有数据库进行遍历
for db in testsql1 testsql2 testsql3 testsql4 testsql5;do
	$mysqldump -u$bakuser -p$passwd -h 47.100.109.116 $db >$bakdir-$d1.sql
done

#对1天前sql文件进行压缩
find $bakdir/ -type f -name "*.sql" -mtime +1 | xargs gzip

#查找并删除超过7天的文件
find $bakdir/ -type -f -mtime +7 | xargs rm

#把当天备份的文件同步到远程

for db in testsql1 testsql2 testsql3 testsql4 testsql5;do
	rsync -a $bakdir/$db-$d1.sql $remote_dir/$db-$d2.sql
done

echo "mysql backup end at `date`"



