#!/bin/python3
import os
ip_suffix = ['111', '121', '131', '132', '141', '151', '161', '162', '171', '211', '21', '31', '41', '42', '43']
for i in ip_suffix:
    os.system("sed -i '28i 172.189.10.{}' /etc/ansible/hosts".format(i))
