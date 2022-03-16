#!/bin/bash

source /usr/local/vesta/data/templates/web/apache2/common/auto_installer.sh
source /usr/local/vesta/data/templates/web/apache2/common/php_pools.sh

# Current php-fpm version
php_vers=8.0

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
request_terminate_timeout = 300s
pm.max_requests = 4000
pm.process_idle_timeout = 10s
pm.status_path = /status


php_admin_value[upload_tmp_dir] = /home/$1/tmp
php_admin_value[session.save_path] = /home/$1/sessions
php_admin_value[open_basedir] = $5:/home/$1/web/$2/nextcloud:/home/$1/web/$2/nextcloud_data:/home/$1/tmp:/bin:/usr/bin:/usr/local/bin:/var/www/html:/tmp:/usr/share:/etc/phpmyadmin:/var/lib/phpmyadmin:/etc/roundcube:/var/log/roundcube:/var/lib/roundcube
php_admin_value[upload_max_filesize] = 4192M
php_admin_value[max_execution_time] = 300
php_admin_value[post_max_size] = 5000M
php_admin_value[memory_limit] = 512M
php_admin_value[sendmail_path] = \"/usr/sbin/sendmail -t -i -f info@$2\"
php_admin_value[output_buffering] = off
php_admin_flag[mysql.allow_persistent] = off
php_admin_flag[safe_mode] = off

php_admin_value[opcache.enable] = 1
php_admin_value[opcache.save_comments] = 1
php_admin_value[opcache.interned_strings_buffer] = 64
php_admin_value[opcache.memory_consumption] = 128
php_admin_value[opcache.max_accelerated_files] = 10000
php_admin_value[opcache.validate_timestamps] = 0
php_admin_value[opcache.revalidate_freq] = 60


env[PATH] = /usr/local/bin:/usr/bin:/bin
env[TMP] = /home/$1/tmp
env[TMPDIR] = /home/$1/tmp
env[TEMP] = /home/$1/tmp
"


# This will auto install Nextcloud
autoinstall_latest_nextcloud $user $domain

# Refresh all php pools for this domain
refresh_all $domain

# Generate php pool config file
generate_php_pool $user $php_vers $domain "$pool_conf"


exit 0
