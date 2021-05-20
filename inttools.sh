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
