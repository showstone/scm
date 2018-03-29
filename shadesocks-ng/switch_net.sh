# /bin/sh
shadesock_config_base_dir="/Users/shichengyuan/repo/scm/shadesocks-ng/"
shadesock_work_dir="/Users/shichengyuan/.ShadowsocksX-NG/"

shadesock_config_dir=${shadesock_config_base_dir}"eleme-aliyun/"
#shadesock_config_dir=${shadesock_config_base_dir}"default/"

shadesocks_default_user_rule_config="/Applications/ShadowsocksX-NG.app/Contents/Resources/user-rule.txt"
user_rule_config="user-rule.txt"
customer_rule_config=${shadesock_work_dir}${user_rule_config}

# bak config 
# rm old config
if [ -d $shadesock_config_dir ]; then
	cp -f $customer_rule_config ${shadesock_config_dir}${user_rule_config}
fi
if [ ! -d $shadesock_config_dir ] && [ -d $shadesock_work_dir ]; then
	backup_dir = $shadesock_work_dir"backup"
	mkdir $backup_dir
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

# override global customer userrule file
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
echo "switch env"


