# @Time : 2020-08-12
# @Author : VizierBi
import os
import logging
import configs
import time
import datetime
container_name = os.popen(configs.container_name_shell).read().replace("\n", "")


class Logger(object):
    def __init__(self):
        self.logger = logging.getLogger('vbidev')
        self.fh = logging.FileHandler('vbi.log')
        self.formatter = logging.Formatter('%(asctime)s %(name)s %(levelname)s %(message)s')
        self.level = self.logger.setLevel(logging.INFO)
        self.fh.setFormatter(self.formatter)
        self.logger.addHandler(self.fh)

    def Info(self, message):
        self.logger.info(message)
        return 1

    def Error(self, messages):
        self.logger.error(messages)


#eneerror = Logger()
enelog = Logger()


def checkprocess():
    present_time = time.time()
    enelog.Info("当前时间戳为{},文件时间戳为{}, 差值为{}".format(present_time,timeStamp,(present_time - timeStamp)))
    if os.system('docker exec ' + str(container_name) + ' bash -c ' + "'ps -ef |grep -w python3'") == 0:
        enelog.Info("loadforecast 进程存活，检测正常")
    else:
        enelog.Error("locadforecast 进程被杀死,出现异常")
        os.system('docker restart ' + str(container_name))


def timecompare():
    present_time = time.time()
    if present_time - timeStamp > 60:
        enelog.Error("当前时间戳为{},文件时间戳为{}, 差值为{}".format(present_time,timeStamp,(present_time - timeStamp)))
        enelog.Error("locadforecast 日志文件长时间未更改,出现异常。开始重启docker")
        os.system('docker restart ' + str(container_name))


def exec_shell():
    os.system("docker exec " + str(container_name) + ' bash -c ' + "'cd /apps/scripts && sh makefile.sh'")


if __name__ == "__main__":
    exec_shell()
    log_time = os.popen("docker exec " + str(container_name) + ' bash -c ' + "'cd /apps/scripts && sh makefile.sh'").read().replace("\n", "")
    timeArray = time.strptime(str(log_time), "%Y-%m-%d %H:%M:%S")
    timeStamp = int(time.mktime(timeArray))
    checkprocess()
    timecompare()
