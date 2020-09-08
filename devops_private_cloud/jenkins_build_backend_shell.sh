base_dir="/datafs/backend"

backup_dir="/backup/jenkins"
war_package=${build_content}.war
server_host="xxxx"
remote_user="xxxx"
passwd='xxxxx'
port='xxxxx'
cd $WORKSPACE
pwd
mvn clean package -pl ${build_content} -am -Dmaven.test.skip=true

sshpass -p $passwd ssh -p${port} ${remote_user}@${server_host} mkdir -p  ${base_dir}/${build_content}/`date +"%F"`/$GIT_COMMIT/

cd ${build_content}/target 
pwd && ls -l
echo "================准备上传${build_content}war包=============="
scp -P${port} -r ${war_package} ${remote_user}@${server_host}:${base_dir}/${build_content}/`date +"%F"`/$GIT_COMMIT/

if [ $? -eq 0 ];then
    echo "==================项目上传成功 ====================="
else
    echo "==================项目上传失败，请检查打包过程。 ====================="
fi
