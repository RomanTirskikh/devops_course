#!/bin/sh

# Installing Topbeats
echo "*-==========Installing Topbeatseats==========-*"
mkdir -p /home/vagrant/ELK/releases/beats/topbeat
cd /home/vagrant/ELK/releases/beats/topbeat/
sudo curl -L -O https://download.elastic.co/beats/topbeat/topbeat_1.1.0_amd64.deb > /dev/null 2>&1
sudo dpkg -i topbeat_1.1.0_amd64.deb
echo "Done"

# Configuring Topbeats
echo "*-==========Configuring Topbeatseats==========-*"
sudo sed -i "s|elasticsearch:|#elasticsearch:|" /etc/topbeat/topbeat.yml
sudo sed -i "s|hosts: \[\"localhost:9200\"\].*|#hosts: \[\"localhost:9200\"\]|" /etc/topbeat/topbeat.yml
sudo sed -i "s|#logstash:|logstash:|" /etc/topbeat/topbeat.yml 
sudo sed -i "s|#hosts: \[\"localhost:5044\"\]|hosts: \[\"tirskikh-elk-server.moscow.epam.com:5044\"\]|" /etc/topbeat/topbeat.yml 
echo "Done"

# Starting Topbeats
echo "*-==========Starting Topbeatseats==========-*"
sudo /etc/init.d/topbeat start
echo "Done"

echo "======Agent ELK is ready======"