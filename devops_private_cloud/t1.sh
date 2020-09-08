#!/bain/bash
filename=/datafs/web-front/lafeier
scripts=/opt/scripts/devops/commit_front_bag.py
inotifywait -mrq --format '%e' --event create  $filename | while read event
do
    case $event in CREATE) python3 $scripts ;;
    esac
done
