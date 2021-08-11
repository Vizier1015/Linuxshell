#!/bin/bash
yum groupinstall "Development Libraries" -y
yum groupinstall "Development Tools" -y
yum groupinstall "System Administration Tools" --setopt=group_package_types=mandatory,default,optional -y
yum install ncurses-devel zlib-devel texinfo gtk+-devel gtk2-devel qt-devel tcl-devel tk-devel libX11-devel kernel-headers kernel-devel -y
yum install -y wget
yum install -y vim
yum -y install yum-utils
yum install sysstat -y
yum install -y bash-completion
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum install -y docker-ce
systemctl enable docker && systemctl start docker
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
#同步时间
yum install chrony net-tools wget vim -y
systemctl enable chronyd && systemctl start chronyd
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime  -y
#修改系统参数
sed -i'' 's,SELINUX=enforcing,SELINUX=disabled,g' /etc/selinux/config
setenforce 0
systemctl stop libvirtd.service && systemctl disable libvirtd.service && systemctl status libvirtd.service
sh -c 'echo " * hard nofile 65536 " >> /etc/security/limits.conf'
sh -c 'echo " * soft nofile 65536 " >> /etc/security/limits.conf'
sh -c 'echo " * soft nproc  65536 " >> /etc/security/limits.conf'
sh -c 'echo " * hard nproc  65536 " >> /etc/security/limits.conf'
sh -c 'echo " * soft nproc  1024000" >> /etc/security/limits.d/20-nproc.conf'
sh -c 'echo " * hard nproc  1024000" >> /etc/security/limits.d/20-nproc.conf'
#pip 加速 
cat <<EOF> /etc/pip.conf
[global]
index-url = http://mirrors.aliyun.com/pypi/simple/
[install]
trusted-host=mirrors.aliyun.com
EOF
#docker加速
mkdir -p /etc/docker/
cd /etc/docker/
cat <<EOF> /etc/docker/daemon.json
{
 "registry-mirrors": ["https://iby0an85.mirror.aliyuncs.com"]
}
EOF
#安装vm需要的软件
yum install -y acpid
systemctl enable acpid.service &  systemctl start acpid.service 
yum install -y epel-release.noarch
yum install -y cloud-init
yum install -y cloud-utils-growpart
yum clean all
yum makecache
yum -y install centos-release-scl
yum -y install devtoolset-9-gcc devtoolset-9-gcc-c++ devtoolset-9-binutils
#scl enable devtoolset-9 bash
echo "source /opt/rh/devtoolset-9/enable" >>/etc/profile
yum install -y lrzsz
yum install -y net-tools
yum install -y gcc
yum -y install openssl-devel bzip2-devel expat-devel gdbm-devel readline-devel sqlite-devel
yum install libffi-devel -y
yum install -y git
systemctl stop firewalld && systemctl disable firewalld
sed -i 's/enforcing/disabled/g' /etc/selinux/config
setenforce 0
#reboot
