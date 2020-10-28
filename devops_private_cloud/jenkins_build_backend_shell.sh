backup_dir="/backup/jenkins"
war_package=${build_content}.war
server_host=""
remote_user="root"
passwd=''
port=''
base_dir="/datafs/backend"
case $build_choice in
  deploy )
      echo "Status:$build_choice"
      echo "Version:$Version"
      cd $WORKSPACE
      pwd
      mvn clean package -pl ${build_content} -am -Dmaven.test.skip=true

      sshpass -p $passwd ssh -p${port} ${remote_user}@${server_host} mkdir -p  ${base_dir}/${build_content}/`date +"%F"`/$GIT_COMMIT/$Version

      cd ${build_content}/target
      pwd && ls -l
      echo "================准备上传${build_content}war包=============="
      scp -P${port} -r ${war_package} ${remote_user}@${server_host}:${base_dir}/${build_content}/`date +"%F"`/$GIT_COMMIT/$Version

      if [ $? -eq 0 ];then
        echo "==================项目上传成功 ====================="
      else
        echo "==================项目上传失败，请检查打包过程。 ====================="
      fi
      ;;
  rollback )
    echo "Status:$build_choice"
    echo "Version:$Version"
    echo "Time:$buildtime"
    sshpass -p $passwd ssh -p${port} ${remote_user}@${server_host} python3 /opt/scripts/devops/backend_scripts/rollback.py $Version $build_content $buildtime
esac
