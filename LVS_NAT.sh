#!/bin/bash
#====================================================
# Author: VizierBi
# Create Date: 2019-03-21
# Description:LVS NAT 模型脚本 
#====================================================
VIP=172.16.193.174
RIP1=172.16.193.179
RIP2=172.16.193.180

case $1 in
start)
	echo "Start LVS as the mode NAT"
	echo "1" > /proc/sys/net/ipv4/ip_forward #开启LVS服务器的IP路由转发功能
	/sbin/ipvsadm -A -t $VIP:80 -s rr
	/sbin/ipvsadm -a -t $VIP:80 -r $RIP1 -m
	/sbin/ipvsadm -a -t $VIP:80 -r $RIP2 -m
	/sbin/ipvsadm 
	;;
stop)
	echo "Stop LVS"
	echo "0" > /proc/sys/net/ipv4/ip_forward
	/sbin/ifconfig eth0:0 down
	;;
*)
	echo "Usage:$0 {start|stop}"
	exit 1
esac

