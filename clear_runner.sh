#!/bin/bash
gitlab_dir=`ls -l /data/gitlab-runner/builds/ | grep -v total | awk -F' ' '{print $9}'`
for  dir in $gitlab_dir
do
	son_list=`ls -l /data/gitlab-runner/builds/$dir | grep -v total | awk -F' ' '{print $9}'`
	for s in $son_list
	do
		grandson_list=`ls -l /data/gitlab-runner/builds/$dir/$s | grep -v total | awk -F' ' '{print $9}'`
		for g in $grandson_list
		do
			project_list=`ls -l /data/gitlab-runner/builds/$dir/$s/$g | grep -v total | awk -F' ' '{print $9}'`
			for p in $project_list
			do
				result=`find /data/gitlab-runner/builds/$dir/$s/$g -mtime +7 -type d  -name $p | wc -l`
				if [ $result -gt 0 ]; then
					rm -rf /data/gitlab-runner/builds/$dir/$s/$g/$p
					rm -rf /data/gitlab-runner/builds/$dir/$s/$g/$p.tmp
				fi
			done
			
		done		
	done
	
done


