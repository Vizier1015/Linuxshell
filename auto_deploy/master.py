# @Time : 2021/1/20 
# @Author : VizierBi
import os, sys, subprocess, re, backup, deploy, rollback, check
from config import *

try:
    project_name = sys.argv[1]
    service_name = sys.argv[2]
    service_version = sys.argv[3]
    service_type = sys.argv[4]
    do = sys.argv[5]
    hosts = locals()['%s_%s_%s' % (project_name, service_type, service_name)]
    version_file_dir = "/data/backup/%s/%s/%s" % (project_name, service_type, service_name)
    version_file = "version.txt"
    local_upload_base_dir = "/data/upload/%s/%s/%s" % (project_name, service_type, service_name)
    local_upload_dir = "%s/%s" % (local_upload_base_dir, service_version)
    remote_upload_dir = "/tmp/%s" % service_name
except:
    print("有问题")

# 检测传入的参数为非空
for i in ["project_name", "service_name", "service_version", "service_type", "do"]:
    if not all([locals()[i]]):
        print(i, "参数不可为空，请检查。")
        exit(1)

# 检查操作类型
check.do(do=do)


# 组织部署动作，包括上传、部署、检测
def service_deploy(versrion):
    for host in hosts:
        # 检查远端主机工作目录是否存在
        check.check_work_dir(host=host, work_dir=eval('%s_work_dir' % service_type))
        # 上传包到远端服务器
        deploy.upload(local_upload_dir="%s/%s" % (local_upload_base_dir, versrion), service_type=service_type,
                      service_name=service_name, host=host, remote_upload_dir=remote_upload_dir)
        service_deploy = eval('deploy.%s_deploy' % service_type)
        check_deploy = eval('check.%s_check_deploy' % service_type)
        # 发布服务包
        service_deploy(host=host, remote_upload_dir=remote_upload_dir, service_dir=eval('%s_work_dir' % service_type),
                       service_name=service_name)
        # 检测对应的服务是否发布完成
        check_deploy(host=host, port=eval('%s_work_port' % service_type), service_name=service_name)


if do == "deploy":
    # 检查包是否存在
    check.check_version_service(local_upload_dir=local_upload_dir, service_name=service_name, service_type=service_type)
    # 检查是否有做过备份
    is_backup, old_version = check.check_backup(service_version=service_version, version_file_dir=version_file_dir,
                                                version_file=version_file)

    # 如果没有备份，就进行备份
    if is_backup == False:
        backup.backup(service_type=service_type, service_name=service_name, old_version=old_version,
                      service_version=service_version, local_upload_base_dir=local_upload_base_dir,
                      backup_dir="%s/%s" % (version_file_dir, old_version), version_file_dir=version_file_dir,
                      version_file=version_file)
    # 调用发布模块
    service_deploy(versrion=service_version)

elif do == "rollback":
    rollback_init = eval('rollback.%s_init' % service_type)
    rollback_version = check.check_rollback_version(version_file_dir=version_file_dir, version_file=version_file)
    print("回滚版本 %s" % rollback_version)
    # 初始化回滚需要的目录，并且将备份的包放置到待上传的目录中。
    rollback_init(service_name=service_name, backup_dir="%s/%s" % (version_file_dir, rollback_version),
                  local_upload_dir="%s/%s" % (local_upload_base_dir, rollback_version))
    # 检查包是否存在
    check.check_version_service(local_upload_dir="%s/%s" % (local_upload_base_dir, rollback_version),
                                service_name=service_name, service_type=service_type)
    # 调用发布模块
    service_deploy(rollback_version)
