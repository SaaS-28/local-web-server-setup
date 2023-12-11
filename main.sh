#!/bin/bash

# Update the list of packages
sudo apt update

# Upgrade the installed packages
sudo apt upgrade -y

# Name of the network interface
INTERFACE_NAME="enp0s3"  #                                                                                                      *! Replace with your interface name, you may not even have to do it

# Desired IP address, network mask and gateway
IP_ADDRESS="your ip"  #                                                                                                         *! Replace with the ip of the machine
NETMASK="24"
GATEWAY="your gateway"  #                                                                                                       *! Replace with the gateway of your network

# Create configuration file for systemd-networkd
CONFIG_FILE="/etc/systemd/network/50-static.network"
echo "[Match]" | sudo tee "$CONFIG_FILE" > /dev/null
echo "Name=$INTERFACE_NAME" | sudo tee -a "$CONFIG_FILE" > /dev/null
echo "" | sudo tee -a "$CONFIG_FILE" > /dev/null
echo "[Network]" | sudo tee -a "$CONFIG_FILE" > /dev/null
echo "Address=$IP_ADDRESS/$NETMASK" | sudo tee -a "$CONFIG_FILE" > /dev/null
echo "Gateway=$GATEWAY" | sudo tee -a "$CONFIG_FILE" > /dev/null

# Restart the network service
sudo systemctl restart systemd-networkd

# Wait until the network service is fully started
echo "Waiting for the network service to reboot"
sudo systemctl is-active --quiet apache2 && echo "The network service is restarted." || sleep 5

# Check if Apache2 is already installed
if dpkg -l | grep -q apache2; then
    echo "Apache2 is already installed."
else
    # If Apache2 is not installed, download and install
    echo "Apache2 is not installed. Im downloading and installing."
    sudo apt install -y apache2
fi

# Enable necessary module for the web server
sudo a2enmod alias

#                                                                                                                               *! Make sure to change your-site with the name of your site and replace the version of php with the version you want to use
content="<VirtualHost *:80>

    ServerAdmin webmaster@your-site
    ServerName your-site
    DocumentRoot /var/www/html/your-site
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined

    <FilesMatch \.php$>
        SetHandler application/x-httpd-php8.2
    </FilesMatch>

</VirtualHost>"

file_path="/etc/apache2/sites-available/name-of-your-site.conf"

# Creating and configuring the .conf file for the web server
echo "$content" | sudo tee "$file_path" > /dev/null

# Creating the directory for your web site files
sudo mkdir /var/www/html/name-of-your-site #                                                                                    *! Change "name-of-your-site" with the name of your site

sudo chown -R $USER:$USER /var/www/html/name-of-your-site #                                                                     *! Change "name-of-your-site" with the name of your site

sudo a2ensite name-of-your-site.conf #                                                                                          *! Change "name-of-your-site" with the name of your site

# Restarting apache
sudo systemctl restart apache2

# Wait until the Apache service is fully started
echo "Waiting for the Apache service to reboot"
sudo systemctl is-active --quiet apache2 && echo "The Apache service is restarted." || sleep 5

# Installing and enabeling php
sudo apt install php libapache2-mod-php -y
sudo a2enmod php8.2 #                                                                                                           *! Make Sure to replace the version of php with the version you want to use

# Restarting apache
sudo systemctl restart apache2

# Wait until the Apache service is fully started
echo "Waiting for the Apache service to reboot"
sudo systemctl is-active --quiet apache2 && echo "The Apache service is restarted." || sleep 5
