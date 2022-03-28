#!/bin/bash
if [ ! $1 ];then
  echo "要指定redis密码"
  exit 1
else
  echo "指定的redis密码为$1"
fi

yum -y install centos-release-scl
yum -y install devtoolset-9-gcc devtoolset-9-gcc-c++ devtoolset-9-binutils
echo "source /opt/rh/devtoolset-9/enable" >>/etc/profile
source /etc/profile
curl -s https://redis.io/download/release|grep -w "download-link"| grep -w "download.redis.io" | awk -F - '{print $3}' > /root/version.txt
sed -i "s@.tar.gz'>@@g" /root/version.txt
version=`cat /root/version.txt`
cd /usr/local && wget https://download.redis.io/releases/redis-${version}.tar.gz && tar -xvzf redis-${version}.tar.gz
cd /usr/local/redis-$version/ && make
mkdir -p /usr/local/redis/{etc,data}
pwd
make PREFIX=/usr/local/redis install
cp /usr/local/redis-${version}/redis.conf /usr/local/redis/etc
sed -i 's/daemonize no/daemonize yes/g' /usr/local/redis/etc/redis.conf
#sed -i 'N;22 i bind 0.0.0.0' /usr/local/redis/etc/redis.conf
sed -i 's/bind 127.0.0.1 -::1/bind 0.0.0.0/g' /usr/local/redis/etc/redis.conf

sed -i "902i requirepass $1" /usr/local/redis/etc/redis.conf
sed -i 's/logfile ""/logfile \/data\/redis\/logs/g'  /usr/local/redis/etc/redis.conf
cat > /lib/systemd/system/redis.service << EOF
[Unit]
Description=redis.server
After=network.target

[Service]
Type=forking
PIDFILE=/var/run/redis_6379.pid
ExecStart=/usr/local/redis/bin/redis-server /usr/local/redis/etc/redis.conf
ExecRepload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF
echo "export PATH=$PATH:/usr/local/redis/bin" >> /etc/profile
source /etc/profile
