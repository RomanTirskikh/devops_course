#!/bin/sh

# Update packages
echo "*-==========Update packages==========-*"
sudo apt-get -y update && sudo apt-get -y upgrade
echo "Done"

# Edditing hosts & hostnames
#echo "*-==========Edditing hosts & hostnames==========-*"
#sudo cat <<EOF >> /etc/hosts
#$(ifconfig eth1|xargs|awk '{print $7}'|sed -e 's/[a-z]*:/''/') $(hostname).moscow.epam.com $(hostname)
#EOF
#echo "Done"

# installing Java8
echo "*-==========installing Java8==========-*"
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:webupd8team/java && apt-get update
sudo echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
sudo echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections
sudo apt-get install -y oracle-java8-installer
echo "Done"

# Making folders
echo "*-==========Making folders==========-*"
mkdir -p /home/vagrant/ELK/releases/beats/filebeat
mkdir -p /home/vagrant/ELK/releases/beats/packetbeat
mkdir -p /home/vagrant/ELK/releases/beats/topbeat
mkdir -p /home/vagrant/ELK/releases/beats/winlogbeat
echo "Done"

# Installing Elasticsearch
echo "*-==========Installing Elasticsearch==========-*"
cd /home/vagrant/ELK/releases/
sudo wget https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/2.2.0/elasticsearch-2.2.0.deb > /dev/null 2>&1
sudo dpkg -i elasticsearch-2.2.0.deb
sudo sed -i "s|*.cluster.name: .*|cluster.name: $(hostname)|" /etc/elasticsearch/elasticsearch.yml 
sudo sed -i "s|*.node.name: .*|node.name: tirskikh-elk-agent|" /etc/elasticsearch/elasticsearch.yml 
sudo update-rc.d elasticsearch defaults 95 10
sudo /etc/init.d/elasticsearch start
echo "Done"

# Checking Elasticsearch avilability
echo "*-==========Checking Elasticsearch avilability==========-*"
echo $(curl http://localhost:9200)
echo "Done"

# Installing Logstash
echo "*-==========Installing Logstash==========-*"
cd /home/vagrant/ELK/releases/
sudo wget https://download.elastic.co/logstash/logstash/packages/debian/logstash_2.2.0-1_all.deb > /dev/null 2>&1
sudo dpkg -i logstash_2.2.0-1_all.deb
sudo touch /etc/logstash/conf.d/input-beats.conf
sudo chmod 666 /etc/logstash/conf.d/input-beats.conf
sudo cat <<EOF > /etc/logstash/conf.d/input-beats.conf
input {
      beats {
        port => 5044
      }
}
EOF
sudo chmod 644 /etc/logstash/conf.d/input-beats.conf
sudo touch /etc/logstash/conf.d/output-elasticsearch.conf
sudo chmod 666 /etc/logstash/conf.d/output-elasticsearch.conf
sudo cat <<EOF > /etc/logstash/conf.d/output-elasticsearch.conf
output {
      elasticsearch {
        hosts => ["localhost:9200"]
        sniffing => true
        manage_template => false
        index => "%{[@metadata][beat]}-%{+YYYY.MM.dd}"
        document_type => "%{[@metadata][type]}"
      }
}
EOF
sudo chmod 644 /etc/logstash/conf.d/output-elasticsearch.conf
echo "Done"

# Checking Logstash avilability
echo "*-==========Checking Logstash avilability==========-*"
sudo service logstash configtest
sudo service logstash restart
sudo update-rc.d logstash defaults 96 9
echo $(netstat -a | grep 5044)
echo "Done"

# Installing Kibana
echo "*-==========Installing Logstash==========-*"
sudo wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo echo "deb http://packages.elastic.co/kibana/4.4/debian stable main" | sudo tee -a /etc/apt/sources.list
sudo apt-get -y update && sudo apt-get -y install kibana
sudo update-rc.d kibana defaults 95 10
sudo service kibana start
echo "Done"

# Checking Kibana avilability
echo "*-==========Checking Kibana avilability==========-*"
echo $(curl http://localhost:5601)
echo "Done"

# Installing Beats Dashboard
echo "*-==========Installing Beats==========-*"
cd /home/vagrant/ELK/releases/beats/
sudo curl -L -O http://download.elastic.co/beats/dashboards/beats-dashboards-1.1.0.zip
sudo apt-get install -y unzip
sudo unzip beats-dashboards-1.1.0.zip > /dev/null 2>&1
cd beats-dashboards-1.1.0/
./load.sh > /dev/null 2>&1
echo "Done"

# Checking Beats Dashboard avilability
echo "*-==========Checking Beats avilability==========-*"
echo $(curl http://localhost:5601)
echo "Done"

# Installing Topeats
echo "*-==========Installing Topeats==========-*"
cd /home/vagrant/ELK/releases/beats/topbeat/
sudo curl -L -O https://download.elastic.co/beats/topbeat/topbeat_1.1.0_amd64.deb
sudo dpkg -i topbeat_1.1.0_amd64.deb
echo "Done"

# Adding index templates for Topbeat
echo "*-==========Adding index tmplates for Topbeat==========-*"
sudo curl -XPUT 'http://localhost:9200/_template/topbeat' -d@/etc/topbeat/topbeat.template.json > /dev/null 2>&1
echo $(curl -XPUT 'http://localhost:9200/_template/topbeat' -d@/etc/topbeat/topbeat.template.json)
echo "Done"

echo "======Server ELK is ready======"
