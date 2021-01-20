# @Time : 2021/1/20 
# @Author : VizierBi
import os


# java的rollback初始化
def java_init(service_name, backup_dir, local_upload_dir):
    os.system("rm -rf %s%s.war" % (local_upload_dir, service_name))
    if int(os.system("cp -a %s/%s.war %s/" % (backup_dir, service_name, local_upload_dir))) == 0:
        print("回滚初始化完成，开始进行发布。")
    else:
        print("回滚初始化失败，请检查  cp -a %s/%s.war %s/" % (backup_dir, service_name, local_upload_dir))
        exit(1)


# nodejs的rollback初始化
def nodejs_init(service_name, backup_dir, local_upload_dir):
    os.system("rm -rf %s/%s" % (local_upload_dir, service_name))
    if int(os.system("cp -a %s/%s %s/" % (backup_dir, service_name, local_upload_dir))) == 0:
        print("回滚初始化完成，开始进行发布。")
    else:
        print("回滚初始化失败，请检查  cp -a %s/%s %s/" % (backup_dir, service_name, local_upload_dir))
        exit(1)
