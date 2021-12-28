#!/bin/sh

# This will auto install wordpress
autoinstall_latest_wordpress() {
    user=$1
    domain=$2
    # wordpress directory
    # This will auto install Wordpress if the public_html directory is empty
    # So it must be cleaned before
    if [ ! -f "/home/$user/web/$domain/public_html/index.php" ]; then
        # Clear public_html directory
        rm -rf /home/$user/web/$domain/public_html/*
        wget https://wordpress.org/latest.zip -O /home/$user/tmp/wordpress.zip
        unzip -d /home/$user/web/$domain/private/ /home/$user/tmp/wordpress.zip
        rm -rf /home/$user/tmp/wordpress.zip
        mv /home/$user/web/$domain/private/wordpress/* /home/$user/web/$domain/public_html/
        chown -R $user:$user /home/$user/web/$domain/public_html
        rm -rf /home/$user/web/$domain/private/wordpress
    fi
}

# This will auto install prestashop
autoinstall_latest_prestashop() {
    user=$1
    domain=$2
    # Check if public_html directory is not empty
    if [ ! -f "/home/$user/web/$domain/public_html/index.php" ]; then
        # If no site installed, then clear the public_html directory
        rm -rf /home/$user/web/$domain/public_html/*
        # Download prestashop
        wget https://download.prestashop.com/download/releases/prestashop_1.7.8.1.zip -O /home/$user/tmp/prestashop.zip
        # Unzip prestashop in tmp directory
        unzip -d /home/$user/web/$domain/public_html/ /home/$user/tmp/prestashop.zip
        # Remove prestashop.zip file
        rm -rf /home/$user/tmp/prestashop.zip
        # Set correct owners
        chown -R $user:$user /home/$user/web/$domain/public_html
    fi
}

# This will auto install prestashop
autoinstall_latest_nextcloud() {
    user=$1
    domain=$2
    # Nextcloud directory
    if [ ! -f "/home/$user/web/$domain/public_html/index.php" ]; then
        # Download Nextcloud
        wget https://download.nextcloud.com/server/releases/nextcloud-22.2.3.zip -O /home/$user/tmp/nextcloud.zip
        unzip -d /home/$user/web/$domain/ /home/$user/tmp/nextcloud.zip
        rm -rf /home/$user/tmp/nextcloud.zip
        # Clean public_html directory
        rm -rf /home/$user/web/$domain/public_html/*
        # Move Nextcloud site files into the correct direcotry
        mv /home/$user/web/$domain/nextcloud/* /home/$user/web/$domain/public_html/
        # Remove nextcloud folder as it is empty now and unnecessary
        rm -rf /home/$user/web/$domain/nextcloud
        # Set the correct permission
        chown -R $user:$user /home/$user/web/$domain/public_html
    fi
    
    # Nextcloud data directory
    if [ ! -d "/home/$user/web/$domain/nextcloud_data" ]; then
        # Create a seperate directory for nextcloud data
        mkdir -p /home/$user/web/$domain/nextcloud_data
        # Set the correct persmission
        chown -R $user:$user /home/$user/web/$domain/nextcloud_data
    fi
}


autoinstall_latest_moodle() {
    user=$1
    domain=$2
    # Moodle directory
    if [ ! -d "/home/$user/web/$domain/moodle" ]; then
        # Download Moodle
        wget https://download.moodle.org/download.php/direct/stable311/moodle-latest-311.zip -O /home/$user/tmp/moodle.zip
        # Unzip moodle , will auto create the /moodle directory
        unzip -d /home/$user/web/$domain/ /home/$user/tmp/moodle.zip
        # remove temporary moodle.zip file
        rm -rf /home/$user/tmp/moodle.zip
        # Set the correct owner to moodle directory
        chown -R $user:$user /home/$user/web/$domain/moodle
    fi
    
    
    # Moodle data directory
    if [ ! -d "/home/$user/web/$domain/moodledata" ]; then
        # If mooddle data direcotoru doesn't exist then create it
        mkdir -p /home/$user/web/$domain/moodledata
        # Set the correst owner
        chown -R $user:$user /home/$user/web/$domain/moodledata
    fi
}