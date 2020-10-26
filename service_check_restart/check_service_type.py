# @Time : 2020/8/26 
# @Author : VizierBi
import socket
import os
from all_ene_autorestart import configs
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
    tomcat = 8080
    nginx = 80


def check_service():
    elif os.system('echo ' + Hostname + '| grep mysql') == 0:
        servicename = 'mysqld'
        vbi = CheckService(servicename, str(SerPorts.mysql.value))
        vbi.check_ports()
        vbi.checkprocess()
    elif os.system("echo " + Hostname + " |grep postgresql") == 0:
        servicename = 'postgresql-11'
        vbi = CheckService(servicename, str(SerPorts.postgresql.value))
        vbi.check_ports()
        vbi.checkprocess()
    elif os.system("echo " + Hostname + " |grep rabbitmq") == 0:
        servicename = 'rabbitmq'
        vbi = CheckService(servicename, str(SerPorts.rabbitmq.value))
        vbi.check_ports()
        vbi.checkprocess()
    elif os.system("echo " + Hostname + " |grep redis ") == 0:
        servicename = 'redis'
        vbi = CheckService(servicename, str(SerPorts.redis.value))
        vbi.checkprocess()
        vbi.check_ports()
    elif os.system("echo " + Hostname + " |grep mongodb") == 0:
        servicename = " mongodb"
        vbi = CheckService(servicename, str(SerPorts.mongodb.value))
        vbi.check_ports()
        vbi.checkprocess()
    elif os.system("echo " + Hostname + " |grep backend") == 0:
        servicename = "tomcat"
        vbi = CheckService(servicename, str(SerPorts.tomcat.value))
        vbi.check_ports()
        vbi.checkprocess()
    elif os.system("echo " + Hostname + " |grep front") == 0:
        servicename = "nginx"
        vbi = CheckService(servicename, str(SerPorts.nginx.value))
        vbi.check_ports()
        vbi.checkprocess()
    else:
	autore_log.Info("此服务器运行的为混合服务，将进行检测有哪些服务在运行...")
	host_sets = {"k8s-master": {"mysql", "redis"},
                     "k8s-node1": {"tomcat", "nginx"}
                     }
	if Hostname in host_sets.keys():
            auto("当前主机{}存在的服务有{}".format(Hostname, host_sets[Hostname]))
            for i in host_sets[Hostname]:
                if os.system("ps -ef|grep " + i + '|grep -v grep') == 0:
                    autore_log.Info("{}进程存在，服务正常".format(i))
                else:
                    autore_log.Error("{}进程消失，服务异常，正在重启服务".format(i))
                    os.system("systemctl restart " + i)
                    if os.system("ps -ef|grep " + i + '|grep -v grep') == 0:
                        autore_log.Info("{}进程存在，重启服务成功".format(i))
                    else:
                        autore_log.Error("重启{}失败，请手动检测！！！！".format(i))

class CheckService(object):
    def __init__(self, servicename, port):
        self.port = port
        self.servicename = servicename

    def check_ports(self):
        if os.system("netstat -lntp |grep " + self.port) == 0:
            autore_log.Info("{}端口存在，服务正常".format(self.servicename))
        else:
            autore_log.Error("{}端口killed,服务异常".format(self.servicename))
            if self.servicename == 'postgresql':
                os.system("systemctl restart postgresql-11")
            elif self.servicename == "rabbitmq":
                pass
            else:
                os.system("systemctl restart " + self.servicename)
            if os.system("netstat -lntp |grep " + self.port) == 0 and os.system(
                    "ps -ef| grep " + self.servicename) == 0:
                autore_log.Info("{} 服务启动成功".format(self.servicename))

    def checkprocess(self):
        if os.system("ps -ef|grep " + self.servicename + "| grep -v grep") == 0:
            autore_log.Info("{} 进程存在".format(self.servicename))
        else:
            autore_log.Error("{}进程被kill，服务异常".format(self.servicename))
            if self.servicename == "nginx":
                autore_log.Info("此服务为nginx服务,需要使用特使启动方式启动")
                os.system("nginx")
            os.system("systemctl restart " + self.servicename)
            if os.system("netstat -lntp |grep " + self.port) == 0 and os.system(
                    "ps -ef| grep " + self.servicename) == 0:
                autore_log.Info("{} 服务启动成功".format(self.servicename))


if __name__ == '__main__':
    check_service()
