import requests
import json
import os
import datetime

if not os.path.exists('mysqldb_backup'):
    os.mkdir('mysqldb_backup')
os.chdir('mysqldb_backup')

today = datetime.date.today()
yesterday = today - datetime.timedelta(days=5)

today_file_name = "/home/******/mysqldb_backup/mysql"+str(today)+".sql"
yesterday_file_name = "/home/******/mysqldb_backup/mysql"+str(yesterday)+".sql"

response_code = os.system("/usr/bin/mysqldump -u 数据库用户名 -p数据库密码 -h 数据库IP 数据库名称 >  "
                          "/home/***/mysql_back/mysql`date+%F`.sql")

file_size = int(os.path.getsize(today_file_name))/1024

if response_code == 0:
    text = "#### Message:\n\n > - MySqlDB Backup Completed!\n\n > - SQL_file_size:"+str(round(file_size,4))+"KB"
    if os.path.exists(yesterday_file_name):
        os.remove(yesterday_file_name)
else:
    text = "#### Message:\n\n > - MySqlDB Backup Error!\n\n > - Please check the server program."


dingding_url = "https://oapi.dingtalk.com/robot/send?access_token=钉钉机器人接口token"
headers = {"Content-Type": "application/json; charset=utf-8"}

post_data = {
    "msgtype": "markdown",
     "markdown": {
     "title": "MySqlDB Backup Message",
     "text": text
     }
}

requests.post(dingding_url, headers=headers, data=json.dumps(post_data))