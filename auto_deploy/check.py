# @Time : 2021/1/20 
# @Author : VizierBi
import os, subprocess, time


# 检测执行类型
def do(do):
    if do == "deploy" or do == "roolback":
        print("操作类型为{}，检测通过".format(do))
    else:
        print("操作类型为{}, 检测失败")


# 检测待上线版本是否存在于本地上传目录

# 检查待发布的版本是否已有包存在
def check_version_service(local_upload_dir, service_name, service_type):
    if service_type == "java":
        if int(os.system("ls %s/%s.war" % (local_upload_dir, service_name))) != 0:
            print("服务包 %s/%s.war 不存在，请检查。" % (local_upload_dir, service_name))
            exit(1)
    elif service_type == "nodejs":
        if int(os.system("ls %s/%s" % (local_upload_dir, service_name))) != 0:
            print("服务包 %s/%s 不存在，请检查。" % (local_upload_dir, service_name))
            exit(1)
    else:
        print("服务类型为 %s ，检测不通过，请检查服务类型是否准确和是否均为小写，目前仅支持 java ，nodejs" % service_type)
        exit(1)


# 检查是否已经备份
def check_backup(service_version, version_file_dir, version_file):
    if int(os.system("ls %s/%s" % (version_file_dir, version_file))) == 0:
        old_version = subprocess.getoutput("tail -n 1 %s/%s" % (version_file_dir, version_file))
        if len(old_version) > 2:
            if old_version == service_version:
                is_backup = True
            else:
                is_backup = False
        else:
            print("版本文件异常，请手动检查 %s/%s" % (version_file_dir, version_file))
            exit(1)
    else:
        is_backup = False
        old_version = ""
    return is_backup, old_version


# 服务的工作目录检测
def check_work_dir(host, work_dir):
    if int(os.system("ssh root@%s ls %s" % (host, work_dir))) != 0:
        print("主机 %s 的服务工作目录 %s 不存在，请检查。" % (host, work_dir))
        exit(1)


# 获取并检测生产包的当前所属用户和组
def check_service_usergroup(host, work_dir):
    service_user = subprocess.getoutput("ssh root@%s ls -al %s | sed -n 2p |awk {'print $3'}" % (host, work_dir))
    service_group = subprocess.getoutput("ssh root@%s ls -al %s | sed -n 2p |awk {'print $4'}" % (host, work_dir))
    if int(os.system("ssh root@%s cat /etc/passwd | awk -F':' {'print $1'}| grep -w %s" % (host, service_user))) != 0:
        print("正在为 %s 赋予对应的权限，但是获取到的用户为 %s ，该用户在系统中未能匹配到，请检查。" % (work_dir, service_user))
        exit(1)
    if int(os.system("ssh root@%s cat /etc/group | grep -w %s" % (host, service_group))) != 0:
        print("正在为 %s 赋予对应的权限，但是获取到的用户为 %s ，该用户在系统中未能匹配到，请检查。" % (work_dir, service_group))
        exit(1)
    return service_user, service_group


# java发布后检测
def java_check_deploy(host, port, service_name):
    for i in range(20):
        curl_code = subprocess.getoutput(
            "curl -o /dev/null -s -w '%%{http_code}\\n' http://%s:%s/%s/main" % (host, port, service_name))
        if int(curl_code) == 200:
            print("java服务 %s 在 %s 主机中发布完成" % (service_name, host))
            break
        if i == 19:
            print("java服务 %s 在 %s 主机中没有发布成功，curl http://%s:%s/%s/main 的返回值非200" % (
            service_name, host, host, port, service_name))
            exit(1)
        time.sleep(2)


# nodejs发布后检测
def nodejs_check_deploy(host, port, service_name):
    print("前端服务需要手动进行检测。")


# 检测回滚的版本号
def check_rollback_version(version_file_dir, version_file):
    rollback_version = subprocess.getoutput("tail -n 2 %s/%s | head -n 1" % (version_file_dir, version_file))
    if len(rollback_version) < 3:
        print("回滚需要的版本检测失败，请确认操作步骤是否正确。")
        exit(1)
    return rollback_version
