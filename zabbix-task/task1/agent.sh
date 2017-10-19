#!/bin/sh

# Add repos and install packages
echo "Adding repos and install"
wget http://repo.zabbix.com/zabbix/3.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.2-1+trusty_all.deb
dpkg -i 'zabbix-release_3.2-1+trusty_all.deb'
sudo apt-get -y update
export DEBIAN_FRONTEND=noninteractive
echo "Done."
echo "Installing zabbix-agent"
sudo apt-get install -y zabbix-agent &>/dev/null
sudo sed -i "s/Server=127.0.0.1/Server=tirskikh-zabbix/" /etc/zabbix/zabbix_agentd.conf
echo "Done."
echo "Starting zabbix-agent..."
sudo service zabbix-agent start
echo "Started."
echo "Restarting zabbix-agent..."
sudo service zabbix-agent restart
echo "Started."

echo "======Agent node is ready======"
