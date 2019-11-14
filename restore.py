#!/bin/python3
import os
import datetime

backup_path = '/tmp/mysql_back/'
# 还原当前时间点备份文件
t_time = datetime.date.today()


def create_txt():
    extend = 'ls ' + backup_path + str(t_time) + '> sqlfile.txt'
	    extend1 = "cat sqlfile.txt | awk -F '.' '{print $1}' >sql_basename.txt"
		    os.system(extend)
			    os.system(extend1)
def extends():
	with open('sqlfile.txt', 'rb') as f:
		sql1 = f.readlines()
	with open('sql_basename.txt', 'rb') as e:
		sql2 = e.readlines()
	for sql_gzip_name in sql1:
		for sql_base_name in sql2:
			os.system('gunzip <' + sql_gzip_name + '| mysql -uroot -p12345678' + str(sql_base_name))

if __name__ == '__main__':
	create_txt()
	extends()
