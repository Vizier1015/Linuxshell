#!/bin/bash
grep -E "JAVA|JRE" /etc/profile && echo "java环境已存在，退出自动部署" && exit 1
base_dir=/opt

jdk_url=http://115.159.220.230:9012/jdk-8u211-linux-x64.tar.gz
tomcat_url=http://115.159.220.230:9012/apache-tomcat-8.5.38.tar.gz
for i in {$jdk_url,$tomcat_url};do wget $i;done
echo "jdk and tomcat download success!"

jdk_gz_name=`ls |grep "jdk1."`
tomcat_gz_name=`ls |grep "tomcat"`
for i in {$jdk_gz_name,$tomcat_gz_name};do tar -xf $i -C $base_dir;done

jdk_dir=`ls $base_dir | grep "jdk1."`
echo "JAVA_HOME=$base_dir/$jdk_dir" >> /etc/profile
echo "JRE_HOME=$base_dir/$jdk_dir/jre" >> /etc/profile
echo "export PATH=\$JAVA_HOME/bin:\$JRE_HOME/bin:\$PATH" >> /etc/profile
source /etc/profile

java -version && echo "auto deploy success!!"

