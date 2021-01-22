# @Time : 2021/1/21 
# @Author : VizierBi
# 本模块为基础模块，查询mysql现有库以及基础库
import os
mysql_datadir_shell = "cat /etc/my.cnf|grep datadir|awk -F = '{print $2}'"

mysql_datadir = os.popen(mysql_datadir_shell).read().replace("\n", "")
mysql_initbasedata_shell = "du " + mysql_datadir + "| sort -nr|awk -F / '{print $NF}'|sed -n '2,$p'|grep -v mysql| grep -v performance_schema| grep -v sys"

