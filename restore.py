#!/bin/python3
import os

def extends():
	with open('sqlfile.txt', 'rb') as f:
		sql1 = f.readlines()
	with open('sql_basename.txt', 'rb') as e:
		sql2 = e.readlines()
	for sql_gzip_name in sql1:
		for sql_base_name in sql2:
			os.system('gunzip <' + sql_gzip_name + '| mysql -uroot -p12345678' + str(sql_base_name))

if __name__ == '__main__':
	extends()
