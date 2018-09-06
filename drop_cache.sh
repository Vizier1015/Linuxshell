#!/bin/bash
#====================================================
# Author: VizierBi
# Create Date: 2018-09-06
# Description:清理内存脚本 
#====================================================
used=`free -m | awk 'NR==2'|awk '{print $3}'`
free=`free -m | awk 'NR==2'|awk '{print $4}'`
echo "====================================" >> drop_cache.log
date >> drop_cache.log
echo "Memory usage | [ Use:${used}M][Free:${free}]" >> drop_cache.log
if [ $free -lt 1000 ];then
	sync && echo 1 > /proc/sys/vm/drop_caches
	echo "OK" >> drop_cache.log
else
	echo "Nothing to do"
fi


