# @Time : 2021/1/19 
# @Author : VizierBi
import os
import subprocess
import time
import check


# 上传服务包函数
def upload(local_upload_dir, service_type, service_name, host, remote_upload_dir):
    os.system("ssh root@{} rm -rf {}".format(host, remote_upload_dir))
    os.system("ssh root@{} mkdir -p {}".format(host, remote_upload_dir))
    if service_type == 'java':
        os.system("scp {}/{}.war root@{}:/%s".format(local_upload_dir, service_type, host, remote_upload_dir))
        local_md5 = subprocess.getoutput("md5sum %s/%s.war | awk '{print $1}'" % (local_upload_dir, service_name))
        remote_md5 = subprocess.getoutput(
            "ssh root@%s md5sum %s/%s.war |awk {'print $1'}" % (host, remote_upload_dir, service_name))
    else:
        os.system("scp -r %s/%s root@%s:/%s/" % (local_upload_dir, service_name, host, remote_upload_dir))
        local_md5 = subprocess.getoutput(
            "find %s/%s/ -type f -exec md5sum {} + | awk '{print $1}' | sort | md5sum|awk {'print $1'}" % (
                local_upload_dir, service_name))
        remote_md5 = subprocess.getoutput(
            "ssh root@%s find %s/%s/ -type f -exec md5sum {} + | awk '{print $1}' | sort | md5sum|awk {'print $1'}" % (
                host, remote_upload_dir, service_name))
    if local_md5 == remote_md5:
        print("包已上传到远端服务器 %s/%s" % (remote_upload_dir, service_name))
    else:
        print("上传失败")
        exit(1)


# java
def java_deploy(host, remote_upload_dir, service_dir, service_name):
    service_user, service_group = check.check_service_usergroup(host=host, work_dir=service_dir)
    if int(os.system("ssh root@%s chown %s:%s -R %s/%s.war" % (
            host, service_user, service_group, remote_upload_dir, service_name))) != 0:
        print("为 %s/%s.war chown %s:%s 失败，请检查。" % (remote_upload_dir, service_name, service_user, service_group))
        exit(1)
    # 删除服务包，并且通过ls解压目录的方法判断是否停止成功
    os.system("ssh root@%s rm -f %s/%s.war" % (host, service_dir, service_name))
    for i in range(6):
        if int(os.system("ssh root@%s ls %s/%s" % (host, service_dir, service_name))) != 0:
            print("服务已成功停止。")
            break
        if i == 9:
            print("服务 %s/%s.war 停止失败（%s 目录依然存在），请检查后再重新运行上线。" % (service_dir, service_name, service_name))
            exit(1)
        time.sleep(5)
