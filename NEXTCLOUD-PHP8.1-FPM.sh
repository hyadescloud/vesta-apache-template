#!/bin/bash

source /usr/local/vesta/data/templates/web/apache2/common/auto_installer.sh
source /usr/local/vesta/data/templates/web/apache2/common/php_pools.sh

# Current php-fpm version
php_vers=8.1

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
php_admin_value[open_basedir] = $5:/home/$1/web/$2/nextcloud:/home/$1/web/$2/nextcloud_data:/home/$1/tmp:/bin:/usr/bin:/usr/local/bin:/tmp:/usr/share:/opt/bin:/sbin:/usr/bin:/usr/local/sbin
php_admin_value[upload_max_filesize] = 4192M
php_admin_value[max_execution_time] = 300
php_admin_value[post_max_size] = 5000M
php_admin_value[memory_limit] = 512M
php_admin_value[sendmail_path] = \"/usr/sbin/sendmail -t -i -f info@$2\"
php_admin_value[output_buffering] = off


env[PATH] = /usr/local/bin:/usr/bin:/bin
env[TMP] = /home/$1/tmp
env[TMPDIR] = /home/$1/tmp
env[TEMP] = /home/$1/tmp
"

# Fixing permissions
chown -R $1:$1 /home/$1/tmp
chown -R $1:$1 /home/$1/sessions

# This will auto install Nextcloud
autoinstall_latest_nextcloud $user $domain

# Refresh all php pools for this domain
refresh_all $domain

# Generate php pool config file
generate_php_pool $user $php_vers $domain "$pool_conf"


exit 0
