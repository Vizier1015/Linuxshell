# @Time : 2020/8/31 
# @Author : VizierBi
import os
import platform
import socket
import threading

t = os.path.join(os.getcwd(), 't.txt')
ip_sum = 0
residue_ip = []


def get_os():
    os = platform.system()
    if os == "Windows":
        return "n"
    else:
        return "c"


def ping_ip(ip_all):
    l_suffix = []
    cmd = ["ping", "-{op}".format(op=get_os()),
           "1", ip_all]

    output = os.popen(" ".join(cmd)).readlines()
    # print(output)
    for s in output:
        if str(s).upper().find("TTL") >= 0:
            # ip_suffix = ip_all.split(".")[-1]
            l_suffix.append(ip_all)
            # print(l_suffix)
            # return l_suffix
    return l_suffix


def get_ip(ip_prefix):
    l2 = []
    global ip_sum
    for i in range(1, 256):
        ip = '%s.%s' % (ip_prefix, i)
        myip2 = ping_ip(ip)
        l2 += myip2
        ip_sum += 1
    print(ip_sum)
    print(l2)
    for ip_a in l2:
        # os.system("ssh-copy-id -i ~/.ssh/id_rsa.pub root@{}".format(ip_a))
        os.system("cat " + t + " | while read passwd;do sshpass -p $passwd ssh-copy-id " + ip_a + ";done")
    return l2


def get_local_ip():
    myhosts = socket.getfqdn(socket.gethostname())
    myaddr = socket.gethostbyname(myhosts)
    return myaddr


def add_ansible_host(myip_prefix):
    ss = get_ip(myip_prefix)
    for hostip in ss:
        os.system("sed -i '28i {}' /etc/ansible/hosts".format(hostip))


if __name__ == "__main__":
    myip = get_local_ip()
    myip_prefix = '.'.join(myip.split('.')[:-1])
    # get_ip(myip_prefix)
    add_ansible_host(myip_prefix)
