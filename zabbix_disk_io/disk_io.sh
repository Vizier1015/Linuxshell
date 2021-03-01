#!/bin/bash
############################################################
# $Name:         disk_discovery.sh
# $Function:     DISK DISCOVERY
# $Author:       Xiaoliu.liu 1377133225@qq.com
# $organization: Xiaoliu.liu
# $Create Date:  2019/3/17
# $Description:  Monitor DISK DISCOVERY
############################################################

Device=$1
DISK=$2

case $DISK in

#每秒读请求被合并次数
rrqm_s)
        iostat -dxkt 1 2 | grep "\b$Device\b" | awk 'NR==2{print $2}'
;;

#每秒写请求被合并次数
wrqm_s)
        iostat -dxkt 1 2 | grep "\b$Device\b" | awk 'NR==2{print $3}'
;;

#每秒完成的读次数
r_s)
        iostat -dxkt 1 2 | grep "\b$Device\b" | awk 'NR==2{print $4}'
;;

#每秒完成的写次数
w_s)
        iostat -dxkt 1 2 | grep "\b$Device\b" | awk 'NR==2{print $5}'
;;

#每秒读数据量(MB)
rkb_s)
        iostat -dxmt 1 2 | grep "\b$Device\b" | awk 'NR==2{print $6}'
;;

#每秒写数据量(MB)
wkb_s)
        iostat -dxmt 1 2 | grep "\b$Device\b" | awk 'NR==2{print $7}'
;;

#平均每次IO请求的扇区大小
avgrq_sz)
        iostat -dxkt 1 2 | grep "\b$Device\b" | awk 'NR==2{print $8}'
;;

#平均每次IO请求的队列长度(越短越好)
avgqu_sz)
        iostat -dxkt 1 2 | grep "\b$Device\b" | awk 'NR==2{print $9}'
;;

#平均每次IO请求等待时间(毫秒)
await)
        iostat -dxkt 1 2 | grep "\b$Device\b" | awk 'NR==2{print $10}'
;;

#读的平均耗时(毫秒)
r_await)
        iostat -dxkt 1 2 | grep "\b$Device\b" | awk 'NR==2{print $11}'
;;

#写入平均耗时(毫秒)
w_await)
        iostat -dxkt 1 2 | grep "\b$Device\b" | awk 'NR==2{print $12}'
;;

#平均每次IO请求处理时间(毫秒)
svctm)
        iostat -dxkt 1 2 | grep "\b$Device\b" | awk 'NR==2{print $13}'
;;

#IO队列非空比例
util)
        iostat -dxkt 1 2 | grep "\b$Device\b" | awk 'NR==2{print $14}'
;;

#IOPS
iops)
    iostat -dk 1 2 | grep "\bsda\b" | awk 'NR==2{print $2}'
;;
esac
