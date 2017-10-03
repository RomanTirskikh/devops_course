#!/bin/bash

sudo sleep 10
sudo cp /home/vagrant/share/tomcat_proxy.conf /etc/nginx/conf.d
sudo nginx -s reload

#sudo ip addr show eth1 | grep 'inet ' | awk '{ print $2; }' | sed 's/\/.*$//' >> /home/vagrant/share/ip_addr.txt
#sudo yum -y install wget 
#wget http://dl.fedoraproject.org/pub/epel/beta/7/x86_64/epel-release-7-0.2.noarch.rpm 
#sudo yum -y install epel-release-7-0.2.noarch.rpm 
#sudo yum -y update 
#sudo yum -y install kernel-headers-$(uname -r) kernel-devel gcc* nfs-utils libnfsidmap rpcbind.x86_64
#sleep 2
#sudo systemctl enable rpcbind
#sleep 2
#sudo systemctl enable nfs-server
#sleep 2
#sudo systemctl start rpcbind
#sleep 2
#sudo systemctl start nfs-server
#sleep 2
#sudo systemctl start rpc-statd
#sleep 2
#sudo systemctl start nfs-idmapd
#sleep 2
#sudo mkdir /mnt/share
#sleep 2
#sudo chmod 777 /mnt/share
#sleep 2
#sudo echo "/mnt/share *(rw)" >> /etc/exports
#sleep 5
#sudo exportfs -r
#sleep 5
#sudo exportfs -v
#sleep 5
#sudo firewall-cmd --permanent --zone public --add-service mountd
#sleep 5
#sudo firewall-cmd --permanent --zone public --add-service rpc-bind
#sleep 5
#sudo firewall-cmd --permanent --zone public --add-service nfs
#sleep 5
#sudo firewall-cmd --reload
#sleep 5

#sudo mount –t nfs 10.19.9.232:/sharefiles1 /mnt/shared1
#*:/sharefiles1 /mnt/shared1 nfs rw,sync,hard,intr 0 0
#cd /opt
#sudo wget -c wget http://download.virtualbox.org/virtualbox/5.1.26/VBoxGuestAdditions_5.1.26.iso -O VBoxGuestAdditions_5.1.26.iso
#cd /opt
#sudo mount VBoxGuestAdditions_5.1.26.iso -o loop /mnt
#cd /mnt
#sudo sh VBoxLinuxAdditions.run --nox11
#sudo systemctl enable vboxadd.service
#sudo reboot

#sudo mkdir /media/share
#sudo mount -t vboxfs share /media/share

# sudo yum -y groupinstall 'Development Tools' ;
