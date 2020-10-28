# @Time : 2020/10/28 
# @Author : VizierBi
import sys
import logging
import os
import time

rollback_version = sys.argv[1]
rollback_service = sys.argv[2]
rollback_time = sys.argv[3]
backend_dir_base = '/opt/apache-tomcat-8.5.38/webapps'
backup_dir = '/backup/' + rollback_time + '/' + rollback_service + '/' + rollback_version


class Logger(object):
    def __init__(self):
        self.logger = logging.getLogger('vbidev')
        self.fh = logging.FileHandler('rollback.log')
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


def rollback():
    ene_log.Info("现在开始回滚{}服务，回滚版本时间{},回滚版本{}".format(rollback_service, rollback_time, rollback_version))
    # 将目前版本放到/tmp目录下
    if os.system("ssh root@172.20.10.213 mv -f " + backend_dir_base + "/" + rollback_service + '.war ' + ' /tmp') == 0:
        ene_log.Info("成功将要回滚的{}服务移除..".format(rollback_service))
        if os.system("ssh root@172.20.10.213 mv -f " + backup_dir + '/' + rollback_service + '.war ' + backend_dir_base) == 0:
            ene_log.Info("回滚{}动作完成".format(rollback_service))
            time.sleep(15)
            if os.system("curl http://172.20.10.213:8080/" + rollback_service + '/main') == 0:
                ene_log.Info("回滚{}成功...".format(rollback_service))
        else:
            ene_log.Error("回滚{}失败...请手动检查！！！！".format(rollback_service))
    else:
        ene_log.Error("移除{}服务出现问题，请手动检查！！！！！".format(rollback_service))


if __name__ == '__main__':
    rollback()

