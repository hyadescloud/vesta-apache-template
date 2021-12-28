#!/bin/bash

# This will loop for each php versions
# The function php_fpm_pool_cleaner
refresh_all() {
    # Get domain firt var
    domain=$1
    
    # Declare each php versions
    declare -A php_versions;
    
    # List of each version of php
    php_versions[56]=5.6
    php_versions[70]=7.0
    php_versions[71]=7.1
    php_versions[72]=7.2
    php_versions[73]=7.3
    php_versions[74]=7.4
    php_versions[80]=8.0
    php_versions[81]=8.1

    
    for phpv in "${php_versions[@]}"
    do
        php_fpm_pool_cleaner $phpv $domain
    done
}

# This will be executed for each pools
php_fpm_pool_cleaner() {
    # Get vars
    php_version=$1
    conf_filename=$2 # Is the domain name for vestacp
    
    php_service= php$php_version-fpm
    pool_file="/etc/php/$php_version/fpm/pool.d/$conf_filename.conf"
    
    if [ -f "$pool_file" ]; then
        rm $pool_file
        service $php_service restart
    fi
}


generate_php_pool() {
    user_dir=$1
    php_version=$2
    domain=$3
    pool_conf=$4



    pool_file="/etc/php/$php_version/fpm/pool.d/$domain.conf"
    
    write_file=0
    if [ ! -f "$pool_file" ]; then
        write_file=1
    else
        user_count=$(grep -c "/home/$user_dir/" $pool_file)
        if [ $user_count -eq 0 ]; then
            write_file=1
        fi
    fi
    if [ $write_file -eq 1 ]; then
        echo "$pool_conf" > $pool_file
        service php$php_version-fpm restart
    fi
    if [ -f "/etc/php/$php_version/fpm/pool.d/www.conf" ]; then
        rm /etc/php/$php_version/fpm/pool.d/www.conf
    fi
}