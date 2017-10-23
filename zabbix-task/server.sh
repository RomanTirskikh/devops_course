#!/bin/sh

# Add repos and install packages
echo "Adding repos and install zabbix server"
wget http://repo.zabbix.com/zabbix/3.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.2-1+trusty_all.deb
dpkg -i 'zabbix-release_3.2-1+trusty_all.deb'
apt-get -y update
export DEBIAN_FRONTEND=noninteractive
echo 'mysql-server mysql-server/root_password password zabbix' | debconf-set-selections
echo 'mysql-server mysql-server/root_password_again password zabbix' | debconf-set-selections
apt-get -y install mysql-server mysql-client
apt-get -y install zabbix-server-mysql zabbix-frontend-php zabbix-agent
echo "Done"

# Start the DB, set the password and install base DB
echo "Start the DB, set the password and install base DB"
service mysql start
cd /usr/share/doc/zabbix-server-mysql
echo "create database zabbix;" | mysql -u root -pzabbix
zcat create.sql.gz | mysql -uroot -pzabbix zabbix
echo "Done"

# Update configuration for Zabbix
echo "Update configuration for Zabbix"
sed -i 's/# DBPassword=/DBPassword=zabbix/g' /etc/zabbix/zabbix_server.conf
sed -i 's/DBUser=.*/DBUser=root/g' /etc/zabbix/zabbix_server.conf
sed -i "s/Hostname=Zabbix server/Hostname=`hostname`/" /etc/zabbix/zabbix_agentd.conf
echo "Done"

# Startup Zabbix Server
echo "Startup Zabbix Server"
service zabbix-server start
echo "Done"

# Setup PHP configuration
echo "Setup PHP configuration"
sed -i 's/post_max_size = 8M/post_max_size = 16M/'  /etc/php5/apache2/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 300/' /etc/php5/apache2/php.ini
sed -i 's/max_input_time = 60/max_input_time = 300/' /etc/php5/apache2/php.ini
sed -i 's/;date.timezone =/date.timezone = Europe\/Moscow/' /etc/php5/apache2/php.ini
echo "Done"

# Start Zabbix HTTP service
echo "Add vhost.conf enabled apache modules and start services"
cp /vagrant/vhost.conf /etc/apache2/sites-available/
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod headers
sudo a2ensite vhost.conf
sudo a2dissite 000-default.conf
service apache2 stop
service apache2 start
service zabbix-server restart
echo "Done"

echo "======Server zabbix node is ready======"
