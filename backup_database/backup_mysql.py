# @Time : 2021/1/21 
# @Author : VizierBi
import os
import datetime
import config

DB_user = 'root'
DB_passwd = '123456'
backup_path = '/data/mysql/backup/'
t_time = datetime.date.today()
t_backup_path = backup_path + str(t_time)


def get_databases():
    b_list = []
    for dbs in os.popen(config.mysql_initbasedata_shell):
        b_list.append(dbs)
    b_list1 = []
    for db in b_list:
        b_list1.append(db.strip())
    return b_list1


def backupsql():
    if not os.path.exists(t_backup_path):
        os.mkdir(t_backup_path)
    db = get_databases()
    for db in db:
        os.system("mysqldump -u" + DB_user + " -p\'" + DB_passwd + "\' " + db \
                  + " --skip-lock-tables" + "|gzip  > " + t_backup_path + "/" + db + ".sql.tar.gz")


if __name__ == '__main__':
    backupsql()