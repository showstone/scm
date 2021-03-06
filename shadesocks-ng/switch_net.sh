# /bin/sh
shadesock_config_base_dir="/Users/shichengyuan/repo/scm/shadesocks-ng/"
shadesock_work_dir="/Users/shichengyuan/.ShadowsocksX-NG/"

shadesock_config_dir_place="default"

echo "paras: "$*
if [ x$1 != x ]
then
	if [ $1 == "d" ]
	then
   		shadesock_config_dir_place="default"
   	fi
   	if [ $1 == "e" ]
	then
   		shadesock_config_dir_place="eleme-aliyun"
   	fi
   	echo $shadesock_config_dir_place
else
   echo "no argu"
fi


shadesock_config_dir=${shadesock_config_base_dir}${shadesock_config_dir_place}"/"

shadesocks_default_config_dir="/Applications/ShadowsocksX-NG.app/Contents/Resources/"
user_rule_config="user-rule.txt"
run_status="run_status.dat"

customer_rule_config=${shadesock_work_dir}${user_rule_config}
run_status_file=${shadesock_config_base_dir}${run_status}

# bak config 
# rm old config
# 有记录状态，则根据状态来判断
if [ -f $run_status_file ]; then
	last_status=$(head -1 ${run_status_file})
	backup_dir=${shadesock_config_base_dir}${last_status}
	if [ ! -d $backup_dir ]; then
		mkdir $backup_dir
	fi
	cp -f $customer_rule_config $backup_dir
	echo "backup to:"${backup_dir}
fi
# 默认情况下，复制到数据备份目录
if [ ! -f $run_status_file ] && [ -d $shadesock_config_base_dir ]; then
	backup_dir=${shadesock_config_base_dir}"backup/" 
	if [ ! -d $backup_dir ]; then
		mkdir $backup_dir
	fi
	echo "backup to:"${backup_dir}
	cp -f $customer_rule_config $backup_dir
fi


# kill shadesocks process
ps axu | grep ShadowsocksX-NG | grep -v grep  | awk '{print $2}' | xargs kill -9

cd $shadesock_config_dir

# load config
defaults import com.qiuyuzhou.ShadowsocksX-NG com.qiuyuzhou.ShadowsocksX-NG.plist

# rm old config
if [ -d $shadesock_work_dir ]; then
	rm -r $shadesock_work_dir
fi

# override config
# rm old config
if [ -d $shadesock_work_dir ]; then
	rm -r $shadesock_work_dir
fi

# override global rule file
shadesocks_default_gfw_rule_config=${shadesocks_default_config_dir}"gfwlist.txt"
if [ -f $shadesocks_default_gfw_rule_config ]; then
	rm $shadesocks_default_gfw_rule_config
fi
echo "-----------------"
echo $shadesocks_default_gfw_rule_config
pwd
ln gfwlist.txt $shadesocks_default_gfw_rule_config

shadesocks_default_user_rule_config=${shadesocks_default_config_dir}"user-rule.txt"
if [ -f $shadesocks_default_user_rule_config ]; then
	rm $shadesocks_default_user_rule_config
fi
ln user-rule.txt $shadesocks_default_user_rule_config

# start shadesocks
/Applications/ShadowsocksX-NG.app/Contents/MacOS/ShadowsocksX-NG &
sleep 1

# override customer userrule file
if [ -f $customer_rule_config ]; then
	rm $customer_rule_config
fi
pwd
ln  user-rule.txt $customer_rule_config

# record status
if [ -f $run_status_file ];then
	rm ${run_status_file}
fi
echo ${shadesock_config_dir_place} > ${run_status_file}
echo "switch env:"${shadesock_config_dir_place}

# kill shadesocks process
ps axu | grep ShadowsocksX-NG | grep -v grep  | awk '{print $2}' | xargs kill -9

slepp 3
# start shadesocks
/Applications/ShadowsocksX-NG.app/Contents/MacOS/ShadowsocksX-NG &

