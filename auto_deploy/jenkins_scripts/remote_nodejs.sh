project_name=wenzhou
service_type=nodejs
jenkins_job=prod_${service_type}
upload_server=xxxxxxxx
upload_base_dir=/data/upload
deploy_script_dir=/data/scripts/deploy

#参数判断，空参数则报错
if [ $project_name"x" == "x" ];then
  echo "project_name is null"
  exit 1
elif [ $service_name"x" == "x" ];then
  echo "service_name is null"
  exit 1
elif [ $service_version"x" == "x" ];then
  echo "service_version is null"
  exit 1
elif [ $service_type"x" == "x" ];then
  echo "service_type is null"
  exit 1
fi

upload_dir=$upload_base_dir/$project_name/$service_type/$service_name/$service_version

if [ ${do} == "rollback" ];then
  cd ${deploy_script_dir}
  python master.py ${project_name} ${service_name} ${service_version} ${service_type} ${do}
  exit 0
fi

echo -e "\033[5;34m project_name=$project_name    service_name=$service_name    service_version=$service_version    service_type=$service_type \033[0m"

#调用本地jenkins进行打包并传参
curl -s --user xxxxxxxxx/job/$jenkins_job/buildWithParameters?token=123456&project_name=$project_name&service_name=$service_name&service_version=$service_version&service_type=$service_type"
#因为调用本地jenkins加上本地jenkins启动构建需要一定时间，这里等待N秒
sleep 15
#获取本地jenkins打包的build_number号，用作后续查看打包状态。
build_number=`curl -s --user xxxxxxxxxx/job/$jenkins_job/lastBuild/consoleText"|grep BUILD_NUMBER|grep -v "+ echo BUILD_NUMBER"|awk -F"=" {'print $2'}`
echo $build_number

#通过build_number查看本地jenkins构建日志，用于判断构建是否完成或失败。
for i in `seq 30`
do
number=$i
build_result=`curl -s --user xxxxxxxx/job/$jenkins_job/$build_number/consoleText"|grep "the bulid_number:$build_number is" | grep -v "faild_str"|tail -n 1|awk {'print $NF'}`
if [ $build_result"x" == "x" ];then
#  echo -e "\033[5;34m the job is building , plase wait...... \033[0m"
  echo -e "\033[5;34m 本地jenkins构建中，请耐心等待…… \033[0m"
  sleep 60
else
  if [ $build_result == "success" ];then
#    echo -e "\033[5;34m the build is success!! \033[0m"
    echo -e "\033[5;34m 本地jenkins构建完成！ \033[0m"
    break
  elif [ $build_result == "faild" ];then
#    echo -e "\033[5;31m the build is faild , please check the local jenkins   http://192.168.1.157:9999/job/prod_backend-test/$build_number/consoleText \033[0m"
    echo -e "\033[5;31m 本地jenkins构建失败，请查看本地jenkins构建日志   http://192.168.1.157:9999/job/prod_backend-test/$build_number/consoleText \033[0m"
    exit 1
  fi
fi
if [ $number == "20" ];then
#  echo -e "\033[5;31m the build is time out, please check the local jenkins   http://192.168.1.157:9999/job/prod_backend-test/$build_number/consoleText \033[0m"
  echo -e "\033[5;31m 等待本地jenkins构建超时，请查看本地jenkins构建日志   http://192.168.1.157:9999/job/prod_backend-test/$build_number/consoleText \033[0m"
  exit 1
fi
done


rm -rf $upload_dir
mkdir -p $upload_dir
echo -e "\033[5;34m 正在下载$service_name包…… \033[0m"
wget -t 20 -c -P $upload_dir/ http://$upload_server/$project_name/$service_type/$service_name/$service_version/$service_name.zip
remote_md5=`curl http://$upload_server/$project_name/$service_type/$service_name/$service_version/md5.txt`
local_md5=`md5sum $upload_dir/${service_name}.zip |awk {'print $1'}`
if [ $local_md5 == $remote_md5 ];then
  echo -e "\033[5;34m md5码校验完成，${service_name}已成功下载到本地！ \033[0m"
else
  echo -e "\033[5;31m ${service_name}下载失败 \033[0m"
  exit 1
fi

echo -e "\033[5;34m 开始解压前端压缩包。 ${service_name}.zip \033[0m"
unzip -d ${upload_dir}/tmp $upload_dir/${service_name}.zip
index_line=`find ${upload_dir}/tmp -name index.html |wc -l`
if [ ${index_line} -eq 1 ];then
  index_dir=`find ${upload_dir}/tmp -name index.html | awk -F"/index.html" {'print $1'}`
else
  echo -e "\033[5;31m ${service_name}.zip 解压失败，可能是因为目录中有多个index.html。 \033[0m"
  exit 1
fi

mv ${index_dir} ${upload_dir}/${service_name}
ls ${upload_dir}/${service_name}/index.html
if [ $? -eq 0 ];then
  echo -e "\033[5;34m 前端包解压完成，准备进行 ${do} \033[0m"
else
  echo -e "\033[5;31m ${service_name}.zip 解压失败，可能是因为index.html不在解压后的根目录${upload_dir}/${service_name}/ \033[0m"
  exit 1
fi

cd ${deploy_script_dir}
python master.py ${project_name} ${service_name} ${service_version} ${service_type} ${do}