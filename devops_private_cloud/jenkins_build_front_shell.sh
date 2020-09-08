base_dir="/datafs/web-front"
project="lafeier"
backup_dir="/backup/jenkins"
build_dir_name="dist"
server_host="58.x.x.x.x"
remote_user="xxx"
passwd='xxxxx'
port='xxxxxx'
zip_name='lafeier.zip'
PATH=/opt/nodejs/v12.16.2/bin:$PATH
node_version=`node -v`
echo "========================NODE版本  $node_version"
cnpm install
cnpm run build
pwd && dir

echo "==================远端目录 ${base_dir}/${project} ====================="
echo "==================远端服务器 ${remote_user}@${server_host} ====================="

rm -rf ${project}
mv ${build_dir_name} ${project}
zip -r $zip_name ${project} 
sshpass -p $passwd ssh -p${port} ${remote_user}@${server_host} mkdir -p  ${base_dir}/${project}/`date +"%F"`/$GIT_COMMIT/

echo "==================开始上传目录 ====================="
#sshpass -p Ene#2019 ssh -p58029 root@58.246.63.134
scp -P${port} -r ${zip_name} ${remote_user}@${server_host}:${base_dir}/${project}/`date +"%F"`/$GIT_COMMIT/

if [ $? -eq 0 ];then
    echo "==================项目上传成功 ====================="
else
    echo "==================项目上传失败，请检查打包过程。 ====================="
fi
