#!/bin/bash
#====================================================
# Author: VizierBi
# Create Date: 2018-12-27
# Description: 
#====================================================
contact='root@localhost'
notify(){
	subject="$(hostname) to be $1 :vip floating"
	body="$(date +'%F %T'): vrrp transition.$(hostname) change to be $1"
	echo $body | mail -s "$subject" $contact
}

case $1 in
	master)
		notify master
		;;
	backup)
		notify backup
		;;
	fault)
		notify fault
		;;
	*)
		echo "Usage: $(basename $0) {master|backup|fault}"
		;;
esac

