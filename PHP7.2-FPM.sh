#!/bin/bash


source common/auto_installer.sh
source common/php_pools.sh

# Current php-fpm version
php_vers=7.2

# Adding php pool conf
user="$1"
domain="$2"
ip="$3"
home_dir="$4"
docroot="$5"

pool_conf="[$2]

listen = /run/php/php$php_vers-fpm-$2.sock
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
php_admin_value[session.save_path] = /home/$1/tmp
php_admin_value[open_basedir] = $5:/home/$1/tmp:/bin:/usr/bin:/usr/local/bin:/var/www/html:/tmp:/usr/share:/etc/phpmyadmin:/var/lib/phpmyadmin:/etc/roundcube:/var/log/roundcube:/var/lib/roundcube
php_admin_value[upload_max_filesize] = 80M
php_admin_value[max_execution_time] = 20
php_admin_value[post_max_size] = 80M
php_admin_value[memory_limit] = 256M
php_admin_value[sendmail_path] = \"/usr/sbin/sendmail -t -i -f info@$2\"
php_admin_flag[mysql.allow_persistent] = off
php_admin_flag[safe_mode] = off

env[PATH] = /usr/local/bin:/usr/bin:/bin
env[TMP] = /home/$1/tmp
env[TMPDIR] = /home/$1/tmp
env[TEMP] = /home/$1/tmp
"

pool_file_56="/etc/php/5.6/fpm/pool.d/$2.conf"
pool_file_70="/etc/php/7.0/fpm/pool.d/$2.conf"
pool_file_71="/etc/php/7.1/fpm/pool.d/$2.conf"
pool_file_72="/etc/php/7.2/fpm/pool.d/$2.conf"
pool_file_73="/etc/php/7.3/fpm/pool.d/$2.conf"
pool_file_74="/etc/php/7.4/fpm/pool.d/$2.conf"
pool_file_80="/etc/php/8.0/fpm/pool.d/$2.conf"

# Refresh all php pools for this domain
refresh_all $domain

# Generate php pool config file
generate_php_pool $user $php_vers $domain $pool_conf

exit 0
