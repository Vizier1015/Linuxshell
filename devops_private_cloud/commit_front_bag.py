# @Time : 2020/9/3
# @Author : VizierBi
import os
import time
import logging

project_name = 'lafeier'
zip_name = 'lafeier.zip'
current_time = time.strftime("%Y-%m-%d")
accept_dir = '/datafs/web-front/lafeier/'
front_host = '172.20.10.121'
#front_dir = '/opt/devops_test/'
front_dir = '/var/www/html/'
newest_file = os.popen("ls -lt " + accept_dir + current_time + "| sed -n '2p'|awk '{print $NF}'").read().replace("\n", "")
remote_user = ' root'
backup_dir = '/backup/'
current_dir = os.getcwd()
wechat_file = 'XYA9tGJUv6.txt'
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


def backoldfile():
    ene_log.Info("开始备份前端{}项目".format(project_name))
    os.system("ssh root@172.20.10.121 rm -rf " + backup_dir + project_name + '/' + current_time + '/lafeier')
    os.system("ssh root@172.20.10.121 mkdir -pv /backup/" + project_name + '/' + current_time)
    if os.system("ssh root@172.20.10.121 mv -f " + front_dir + project_name + " " + backup_dir + project_name + '/' + current_time) == 0:
        ene_log.Info("备份前端{}项目成功".format(project_name))
    else:
        ene_log.Error("备份失败，请手动检查")


def unzipcode():
    ene_log.Info("开始解压{}....".format(zip_name))
    os.system("rm -rf " + current_dir + "/" + project_name)
    if os.system("unzip " + accept_dir + current_time + '/' + newest_file + '/' +zip_name) == 0:
        ene_log.Info("解压成功！")
        os.system("cp " + current_dir + "/" + wechat_file + " " + project_name)
    else:
        ene_log.Error("解压失败！请检查")


def updateos():
    ene_log.Info("开始发布{}...".format(project_name))
    if os.system("scp -r " + current_dir + '/' + project_name + remote_user + '@' + \
                 front_host + ":" + front_dir) == 0:
        ene_log.Info("前端{}项目发布成功...".format(project_name))
    else:
        ene_log.Error("前端{}发布失败，请手动查看原因...".format(project_name))


if __name__ == '__main__':
    backoldfile()
    unzipcode()
    updateos()
