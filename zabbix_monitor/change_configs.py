# @Time : 2020/8/26 
# @Author : VizierBi
import os
# import socket
#from all_ene_autorestart import configs
#from all_ene_autorestart import check_service_type
import configs
import check_service_type


config_file = os.path.join(os.getcwd(), 'zabbix_agentd.conf')
ene_log = configs.Logger()


def make_conf_file():
    # 将当前主机名添加到zabbix conf文件中
    if os.system("sed -i 's/{hostname}/%s/g' %s " % (check_service_type.Hostname, config_file)) == 0:
        ene_log.Info("生成新的zabbix_agent.conf 文件成功...")
        os.system("cp -f " + config_file + configs.zabbix_agent_dir)
        os.system("chown zabbix:zabbix " + configs.zabbix_agent_dir + "/zabbix_agentd.conf")
    else:
        ene_log.Error("出现错误请检查原因")


# 替换完config文件进行zabbix重启
def restart_zab():
    os.system("systemctl restart zabbix-agent")
    if os.system("systemctl status zabbix-agent |grep running") == 0:
        ene_log.Info("zabbix重启成功")
    else:
        ene_log.Error("zabbix服务异常，请手动检查")
    return 1


if __name__ == '__main__':
    make_conf_file()
    restart_zab()
