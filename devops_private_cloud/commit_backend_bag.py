# @Time : 2020/9/5
# @Author : VizierBi
import os
import logging
import time

current_time = time.strftime("%Y-%m-%d")
accept_dir = '/datafs/backend/'
backend_host = '172.20.10.131'
backend_dir = '/opt/devops_test/'
build_dir = os.popen('ls -lt ' + accept_dir + " |sed -n '2p'|awk '{print $NF}'").read().replace("\n", "")
backup_dir_base = '/backup'
backup_dir = backup_dir_base + '/' + current_time + '/' + build_dir
remote_user = ' root'
commit_dir = os.popen("ls -lt " + accept_dir + "/" + build_dir + "/" + current_time + " |sed -n '2p' |awk '{print $NF}'").read().replace("\n", "")

class Logger(object):
    def __init__(self):
        self.logger = logging.getLogger('vbidev')
        self.fh = logging.FileHandler('vbi.log')
        self.formatter = logging.Formatter('%(asctime)s %(name)s %(levelname)s %(message)s')
        self.logger.setLevel(logging.INFO)
        self.fh.setFormatter(self.formatter)
        self.logger.addHandler(self.fh)

    def Info(self, message):
        self.logger.info(message)
        return 1

    def Error(self, messages):
        self.logger.error(messages)


ene_log = Logger()


def backup_war():
    # 创建备份目录
#    if not os.path.exists(backup_dir):
    if os.system("ssh root@172.20.10.131 [ -d {} ]".format(backup_dir)) != 0:
        if os.system("ssh root@172.20.10.131 mkdir -pv " + backup_dir) == 0:
            ene_log.Info("创建备份目录{}成功".format(backup_dir))
        else:
            ene_log.Error("备份目录{}创建失败，请查看创建信息".format(backup_dir))
    # 备份war包
    if os.system("ssh root@172.20.10.131 mv -f " + backend_dir + build_dir + ".war " + backup_dir) == 0:
        ene_log.Info("成功备份{}.war包".format(build_dir))
    else:
        ene_log.Error("备份{}.war失败".format(build_dir))


def updatewar():
    ene_log.Info("开始上传{}.war".format(build_dir))
    if os.system("scp -r " + accept_dir + build_dir + "/" + current_time + "/" + commit_dir + "/" + build_dir + ".war " \
                 + remote_user + '@' + backend_host + ":" + backend_dir) == 0:
        ene_log.Info("发布{}.war 成功....".format(backend_dir))
    else:
        ene_log.Error("发布{}.war 失败！！".format(backend_dir))


if __name__ == "__main__":
    backup_war()
    updatewar()
