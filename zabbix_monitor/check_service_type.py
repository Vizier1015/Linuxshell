# @Time : 2020/8/26 
# @Author : VizierBi
import socket
import os
import configs
import logging
from enum import Enum

Hostname = socket.gethostname()
autore_log = configs.Logger()


class SerPorts(Enum):
    mysql = 3306
    redis = 6379
    rabbitmq = 5672
    postgresql = 5432
    mongodb = 27017


def check_service():
    if os.system('echo ' + Hostname + ' |grep mysql') == 0:
        servicename = 'mysql'
        vbi = CheckService(servicename, '3306')
        vbi.check_ports()
        vbi.checkprocess()
    if os.system("echo " + Hostname + " |grep ansible") == 0:
        servicename = 'postgresql'
        vbi = CheckService(servicename, str(SerPorts.postgresql.value))
        vbi.check_ports()
        vbi.checkprocess()
    if os.system("echo " + Hostname + " |grep rabbitmq") == 0:
        servicename = 'rabbitmq'
        vbi = CheckService(servicename, '5672')
        vbi.check_ports()
        vbi.checkprocess()
    if os.system("echo " + Hostname + " |grep redis ") == 0:
        servicename = 'redis'
        vbi = CheckService(servicename, SerPorts.redis.value)
        vbi.checkprocess()
        vbi.check_ports()
    if os.system("echo " + Hostname + " |grep mongodb") == 0:
        servicename = " mongodb"
        vbi = CheckService(servicename, SerPorts.mongodb.value)
        vbi.check_ports()
        vbi.checkprocess()


class CheckService(object):
    def __init__(self, servicename, port):
        self.servicename = servicename
        self.port = port

    def check_ports(self):
        print("netstat -lntp |grep" + self.port)
        if os.system("netstat -lntp |grep " + self.port) == 0:
            autore_log.Info("{}端口存在，服务正常".format(self.servicename))
        else:
            autore_log.Error("{}端口killed,服务异常".format(self.servicename))
            # os.system("/usr/local/redis-3.2.4/src/./redis-server ../redis.conf")
            if os.system("netstat -lntp |grep " + self.port) == 0 and os.system(
                    "ps -ef| grep " + self.servicename) == 0:
                autore_log.Info("{} 服务启动成功".format(self.servicename))

    def checkprocess(self):
        if os.system("ps -ef|grep " + self.servicename) == 0:
            autore_log.Info("{} 进程存在".format(self.servicename))
        else:
            autore_log.Error("{}进程被kill，服务异常".format(self.servicename))
            # os.system("/usr/local/redis-3.2.4/src/./redis-server ../redis.conf")
            if os.system("netstat -lntp |grep " + self.port) == 0 and os.system(
                    "ps -ef| grep " + self.servicename) == 0:
                autore_log.Info("{} 服务启动成功".format(self.servicename))


if __name__ == '__main__':
    check_service()

