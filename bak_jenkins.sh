#!/bin/bash

exec &> /tmp/bgw/jenkinsbackup.log
d1=`date +%F`
bak_dir='/root/bakxml'
mkdir -pv $bak_dir/$d1


for i in `ls /root/.jenkins/jobs`;do
	if [ ! -f "/root/.jenkins/jobs/$i/config.xml" ];then
		echo "$i 没有config 文件"
	else
	    mkdir -p $bak_dir/$d1/$i
		cp /root/.jenkins/jobs/$i/config.xml $bak_dir/$d1/$i
		if [ $? -eq 0 ];then
			echo "获取config文件" 
		fi
	fi
done

cd /root/bakxml
tar -zcvf "$d1.tar.gz" "$d1"
rm -rf $bak_dir/$d1/













#cp -ir /root/.jenkins/jobs/*  $bak_dir/$d1
#cd /root/bakxml 
#tar cvf $d1.tar.gz $d1/
#rm -rf $d1/
