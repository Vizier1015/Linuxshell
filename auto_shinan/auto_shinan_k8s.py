import os
import sys
import config

scripts_1_str = os.popen(config.k8s_exec_shell_1)
scripts_1 = scripts_1_str.read().replace("\n", "")
scripts_2_str = os.popen(config.k8s_exec_shell_2)
scripts_2 = scripts_2_str.read().replace("\n", "")
scripts_3_str = os.popen(config.k8s_exec_shell_3)
scripts_3 = scripts_3_str.read().replace("\n", "")
scripts_4_str = os.popen(config.k8s_exec_shell_4)
scripts_4 = scripts_4_str.read().replace("\n", "")

container_lis = [scripts_1, scripts_2, scripts_3, scripts_4]


# shell_scripts =
def check_status():
    for i in container_lis:
        if sys.argv[1] == 'status':
            os.system('kubectl exec -it ' + str(i) + " -- ps -ef")


def exec_scripts():
    if sys.argv[1] == 'start':
        os.system('kubectl exec -it ' + scripts_1 + " -- nohup sh ele_update.sh >/dev/null 2>&1 &")
        os.system('kubectl exec -it ' + scripts_2 + " -- nohup sh exception_data_update.sh >/dev/null 2>&1 &")
        os.system('kubectl exec -it ' + scripts_3 + " -- nohup sh power_switch_update.sh >/dev/null 2>&1 &")
        os.system('kubectl exec -it ' + scripts_4 + " -- nohup sh yesterday_update.sh >/dev/null 2>&1 &")
#        print('kubectl exec -it ' + scripts_4 + " bash  4.sh")

if __name__ == '__main__':
    check_status()
    exec_scripts()
