#!/bin/bash
user_name=$1
psw_file=/etc/openvpn/psw-file
backup_dir=/backup/openvpn/`date +%F`
unlock_user=root
lock_user=nobody
if [ ${user_name}'x' == 'x' ];then
    echo "请输入用户名!!"
    exit 1
fi

grep "${user_name}" ${psw_file} 
if [ $? -eq 0 ];then
    echo "用户已存在!!"
else
    mkdir -p ${backup_dir}
    \cp ${psw_file} ${backup_dir}/
    chown ${unlock_user}:${unlock_user} ${psw_file}
    chmod 600 ${psw_file}
    psw=`< /dev/urandom tr -dc 0-9-A-Z-a-z|head -c8;echo`
    echo "${user_name} ${psw}"
    echo "${user_name} ${psw}" >> ${psw_file}
    chmod 400 ${psw_file}
    chown ${lock_user}:${lock_user} ${psw_file}
fi
