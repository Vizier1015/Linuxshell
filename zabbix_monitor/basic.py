# @Time : 2020/9/21 
# @Author : VizierBi
import psutil
import sys


def memissue():
    # print("内存信息")
    mem = psutil.virtual_memory()
    free_mem = mem.free / 1024 / 1024
    print('%.1f' % free_mem)


def cuplist():
    cpu_id = psutil.cpu_times().idle
    cpu_user = psutil.cpu_times().user
    cpu_nice = psutil.cpu_times().nice
    use_time_p = (1 - float(cpu_id / (cpu_id + cpu_user + cpu_nice))) * 100
#    print(cpu_id)
    print("%.2f" % float(use_time_p))


def disk_residue():
    diskusage = psutil.disk_usage('/')
    disk_free = diskusage.free / 1024 / 1024 / 1024
    print("%.1f" % disk_free)


if __name__ == "__main__":
    if sys.argv[1] == 'mem':
        memissue()
    if sys.argv[1] == 'cpu':
        cuplist()
    if sys.argv[1] == 'disk':
        disk_residue()

