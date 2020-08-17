stat daily_tasks.log | sed -n '7p'|awk -F. '{print $1}' > time.txt
sed -i 's/^Change://g' time.txt
sed 's/^[ \t]*//g' time.txt
