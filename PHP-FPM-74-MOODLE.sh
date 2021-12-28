#!/bin/bash
# Adding php pool conf
user="$1"
domain="$2"
ip="$3"
home_dir="$4"
docroot="$5"

pool_conf="[$2]

listen = /run/php/php7.4-fpm-$2.sock
listen.owner = $1
listen.group = $1
listen.mode = 0666

user = $1
group = $1

pm = ondemand
pm.max_children = 16
request_terminate_timeout = 30s
pm.max_requests = 4000
pm.process_idle_timeout = 10s
pm.status_path = /status

php_admin_value[upload_tmp_dir] = /home/$1/tmp
php_admin_value[session.save_path] = /home/$1/sessions
php_admin_value[open_basedir] = none
php_admin_value[upload_max_filesize] = 64M
php_admin_value[max_execution_time] = 30
php_admin_value[post_max_size] = 128M
php_admin_value[memory_limit] = 128M
php_admin_value[sendmail_path] = \"/usr/sbin/sendmail -t -i -f info@$2\"
php_admin_flag[mysql.allow_persistent] = off
php_admin_flag[safe_mode] = off
php_admin_flag[register_globals] = off
php_admin_value[max_input_vars] = 5000

env[PATH] = /usr/local/bin:/usr/bin:/bin
env[TMP] = /home/$1/tmp
env[TMPDIR] = /home/$1/tmp
env[TEMP] = /home/$1/tmp
"

# Create a session path
if [ ! -d "/home/$1/sessions" ]; then
	mkdir -p /home/$1/sessions
	chown -R $1:$1 /home/$1/sessions
fi



# Moodle directory
if [ ! -d "/home/$1/web/$2/moodle" ]; then
	#mkdir -p /home/$1/web/$2/moodle
	#chown -R $1:$1 /home/$1/web/$2/moodle
	#mkdir -p /home/$1/packages
	wget https://download.moodle.org/download.php/direct/stable311/moodle-latest-311.zip -O /home/$1/tmp/moodle.zip
	unzip -d /home/$1/web/$2/ /home/$1/tmp/moodle.zip
	rm -rf /home/$1/tmp/moodle.zip
        chown -R $1:$1 /home/$1/web/$2/moodle
fi


# Moodle data directory
if [ ! -d "/home/$1/web/$2/moodledata" ]; then 
        mkdir -p /home/$1/web/$2/moodledata
        chown -R $1:$1 /home/$1/web/$2/moodledata
fi

pool_file_56="/etc/php/5.6/fpm/pool.d/$2.conf"
pool_file_70="/etc/php/7.0/fpm/pool.d/$2.conf"
pool_file_71="/etc/php/7.1/fpm/pool.d/$2.conf"
pool_file_72="/etc/php/7.2/fpm/pool.d/$2.conf"
pool_file_73="/etc/php/7.3/fpm/pool.d/$2.conf"
pool_file_74="/etc/php/7.4/fpm/pool.d/$2.conf"

if [ -f "$pool_file_56" ]; then
    rm $pool_file_56
    service php5.6-fpm restart
fi

if [ -f "$pool_file_70" ]; then
    rm $pool_file_70
    service php7.0-fpm restart
fi

if [ -f "$pool_file_71" ]; then
    rm $pool_file_71
    service php7.1-fpm restart
fi

if [ -f "$pool_file_72" ]; then
    rm $pool_file_72
    service php7.2-fpm restart
fi

if [ -f "$pool_file_73" ]; then
    rm $pool_file_73
    service php7-3-fpm restart
fi

write_file=0
if [ ! -f "$pool_file_74" ]; then
  write_file=1
else
  user_count=$(grep -c "/home/$1/" $pool_file_74)
  if [ $user_count -eq 0 ]; then
    write_file=1
  fi
fi
if [ $write_file -eq 1 ]; then
    echo "$pool_conf" > $pool_file_74
    service php7.4-fpm restart
fi
if [ -f "/etc/php/7.4/fpm/pool.d/www.conf" ]; then
    rm /etc/php/7.4/fpm/pool.d/www.conf
fi


exit 0
