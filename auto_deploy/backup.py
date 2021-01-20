# @Time : 2021/1/20 
# @Author : VizierBi
import os


# 备份模块
# 只有在发布新版本时才会将版本号写入版本文件，回滚、同一版本号多次发布的不会将新版本写入
def backup(service_type, service_name, old_version, service_version, local_upload_base_dir, backup_dir,
           version_file_dir, version_file):
    os.system("mkdir -p %s" % backup_dir)
    # 如果是第一次发布该服务的，直接将版本号写入版本文件。
    if not all([old_version]):
        if int(os.system("echo %s >> %s/%s" % (service_version, version_file_dir, version_file))) == 0:
            print("当前发布服务为新服务，无需备份。已将新版本号 %s 写入版本文件。" % (service_version))
            return
        else:
            print("版本文件写入失败，请检查。")
            exit(1)
    if service_type == "java":
        if int(os.system("mv %s/%s/%s.war %s" % (local_upload_base_dir, old_version, service_name, backup_dir))) == 0:
            print("%s.war 备份完成。" % service_name)
        else:
            print("%s.war 备份到 %s 失败，请检查。" % (service_name, backup_dir))
            exit(1)
    # 非第一次发布该服务的，先将服务进行备份，然后再将需要发布的新版本号写入版本文件
    else:
        if int(os.system("mv %s/%s/%s %s" % (local_upload_base_dir, old_version, service_name, backup_dir))) == 0:
            print("%s 备份完成。" % service_name)
        else:
            print("%s 备份到 %s 失败，请检查。" % (service_name, backup_dir))
            exit(1)
    if int(os.system("echo %s >> %s/%s" % (service_version, version_file_dir, version_file))) == 0:
        print("老版本 %s 备份完成，已将新版本号 %s 写入版本文件。" % (old_version, service_version))
    else:
        print("版本文件写入失败，请检查。")
        exit(1)
