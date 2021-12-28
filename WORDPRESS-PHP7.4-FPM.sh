#!/bin/bash

source /usr/local/vesta/data/templates/web/apache2/common/auto_installer.sh
source /usr/local/vesta/data/templates/web/apache2/common/php_pools.sh

# Current php-fpm version
php_vers=7.4

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
php_admin_value[session.save_path] = /home/$1/sessions
php_admin_value[open_basedir] = $5:/home/$1/tmp:/bin:/usr/bin:/usr/local/bin:/var/www/html:/tmp:/usr/share:/etc/phpmyadmin:/var/lib/phpmyadmin:/etc/roundcube:/var/log/roundcube:/var/lib/roundcube
php_admin_value[upload_max_filesize] = 64M
php_admin_value[max_execution_time] = 30
php_admin_value[post_max_size] = 128M
php_admin_value[memory_limit] = 256M
php_admin_value[sendmail_path] = \"/usr/sbin/sendmail -t -i -f info@$2\"
php_admin_flag[mysql.allow_persistent] = off
php_admin_flag[safe_mode] = off

env[PATH] = /usr/local/bin:/usr/bin:/bin
env[TMP] = /home/$1/tmp
env[TMPDIR] = /home/$1/tmp
env[TEMP] = /home/$1/tmp
"


# This will auto install moodle
autoinstall_latest_wordpress $user $domain

# Refresh all php pools for this domain
refresh_all $domain

# Generate php pool config file
generate_php_pool $user $php_vers $domain $pool_conf

exit 0
