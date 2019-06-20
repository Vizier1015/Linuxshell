#!/bin/bash
#====================================================
# Author: VizierBi
# Create Date: 2019-06-19
# Description:zabbix 端口监控脚本 
#====================================================
CONFIG_FILE=/etc/zabbix/script/port.conf
Check(){
	grep -vE '(^ *#|^$)' ${CONFIF_FILE}|grep -vE '^*[0-9]+' &> /dev/null
	if [ $? -eq 0 ];then
		echo Error: ${CONFIG_FILE} Contains Invalid Port.
		exit 1
	else
		portarray=($(grep -vE '(^ *#|^$)' ${CONFIG_FILE} | grep -E '^ *[0-9]+'))
	fi
}

PortDiscovery(){
	length=${#portarray[@]}
	printf "{\n"
	printf '\t'"\"data\":["
	for ((i=0;i< $length;i++))
		do
			printf '\n\t\t{'
			printf "\"{#TCP_PORT}\":\"${portarray[$i]}\"}"
			if [ $i -lt $[$length-1] ];then
				printf ','
			fi
		done
	printf "\n\t]\n"
	printf "}\n"
}
port(){
    Check
    PortDiscovery
		}
port
