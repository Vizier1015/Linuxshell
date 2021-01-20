#==========================================================================================================================================================================
#============================================================================     定义变量     ============================================================================
#==========================================================================================================================================================================
echo "BUILD_NUMBER=$BUILD_NUMBER"
faild_str="the bulid_number:$BUILD_NUMBER is faild"
file_server=172.187.10.208
upload_base_dir=/data/upload
nacos_config_url="http://nacos.ene.com/nacos/v1/cs/configs?"
service_type=java
#参数判断，空参数则报错
if [ $project_name"x" == "x" ];then
  echo "project_name is null"
  echo $faild_str
  exit 1
elif [ $service_name"x" == "x" ];then
  echo "service_name is null"
  echo $faild_str
  exit 1
elif [ $service_version"x" == "x" ];then
  echo "service_version is null"
  echo $faild_str
  exit 1
elif [ $service_type"x" == "x" ];then
  echo "service_type is null"
  echo $faild_str
  exit 1
fi
source /datafs/source-files/jenkins/${service_type}/base_source.txt
source /datafs/source-files/jenkins/${service_type}/${project_name}/${service_name}_source.txt

#git_url=`eval echo "$"${service_name}_git_url`
#type=`eval echo "$"${service_name}_type`
#base_dir=`eval echo "$"${service_name}_base_dir`
#service_dir=`eval echo "$"${service_name}_service_dir`
#cmd=`eval echo "$"${service_name}_cmd`
#config_dir=`eval echo "$"${service_name}_config_dir`
config_files=`eval echo "$"${type}_config_files`

#参数判断，空参数则报错
if [ $git_url"x" == "x" ];then
  echo "git_url is null"
  echo $faild_str
  exit 1
elif [ $type"x" == "x" ];then
  echo "type is null"
  echo $faild_str
  exit 1
elif [ $base_dir"x" == "x" ];then
  echo "base_dir is null"
  echo $faild_str
  exit 1
#elif [ $service_dir"x" == "x" ];then
#  echo "service_dir is null"
#  echo $faild_str
#  exit 1
elif [ "$cmd""x" == "x" ];then
  echo "cmd is null"
  echo $faild_str
  exit 1
elif [ $config_dir"x" == "x" ];then
  echo "config_dir is null"
  echo $faild_str
  exit 1
elif [ $config_files"x" == "x" ];then
  echo "config_files is null"
  echo $faild_str
  exit 1
fi

com_config_dir="$WORKSPACE/${base_dir}/${service_dir}${config_dir}"

#设置上传具体目录的变量
upload_dir=$upload_base_dir/$project_name/$service_type/$service_name/$service_version

echo "========  project_name=$project_name    service_name=$service_name    service_version=$service_version    service_type=$service_type  ========"
#==========================================================================================================================================================================
#============================================================================     开始打包     ============================================================================
#==========================================================================================================================================================================

echo "#############  开始拉取代码  ##############"
rm -rf ${base_dir}
git clone -b ${service_version} ${git_url}
if [ $? -eq 0 ];then
  echo "#############  代码clone完成  ##############"
else
  echo "#############  代码clone失败  ##############"
  echo $faild_str
  exit 1
fi

echo "##########  开始下载配置文件  ############"
for i in ${config_files};
do
  get_url="${nacos_config_url}dataId=${i}&group=${service_name}&tenant=${project_name}"
  curl -X GET ${get_url} > ${com_config_dir}/${i}
  len=`cat ${com_config_dir}/${i}|wc -l`
  if [ ${len} -gt 2 ];then
      echo "##########  配置文件 ${i} 下载完成！  ############"
  else
      echo "##########  【ERROR】 配置文件 ${i} 下载失败，请检查url：${get_url}  ############"
      echo $faild_str
      exit 1
  fi
done

echo "###############  进入目录${WORKSPACE}/${base_dir}  ###############"
cd ${WORKSPACE}/${base_dir}
pwd
echo "###############  开始打包程序  ###############"
mvn clean package -Dmaven.test.skip=true
$cmd
if [ $? -eq 0 ];then
  echo "#############  代码打包完成  ##############"
else
  echo "#############  代码打包失败！  ##############"
  echo $faild_str
  exit 1
fi

#==========================================================================================================================================================================
#============================================================================     开始上传     ============================================================================
#==========================================================================================================================================================================
echo "###############  开始上传包  ###############"
ssh root@$file_server rm -rf $upload_dir
ssh root@$file_server mkdir -p $upload_dir
scp ${service_dir}target/${service_name}.war root@$file_server:$upload_dir/
local_md5=`md5sum ${service_dir}target/${service_name}.war |awk {'print $1'}`
remote_md5=`ssh root@$file_server md5sum $upload_dir/${service_name}.war |awk {'print $1'}`
if [ $local_md5 == $remote_md5 ];then
  echo $local_md5 > md5.txt
  scp md5.txt root@$file_server:$upload_dir/
  remote_md5txt=`curl http://$file_server/$project_name/$service_type/$service_name/$service_version/md5.txt`
  if [ $local_md5 == $remote_md5txt ];then
    echo "the bulid_number:$BUILD_NUMBER is success"
    exit 0
  else
    echo "the md5.txt upload faild"
    exit 1
  fi
else
  echo "the local md5 file is different from remote_md5 file"
  exit 1
fi


#echo "the bulid_number:$BUILD_NUMBER is faild"
#echo "the bulid_number:$BUILD_NUMBER is success"