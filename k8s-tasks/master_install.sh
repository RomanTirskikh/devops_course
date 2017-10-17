#!/bin/bash

sudo -i

#sysctl net.bridge.bridge-nf-call-iptables=1

apt-get -y update && apt-get install -y apt-transport-https #ubuntu-desktop

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get -y update && apt-get install -y git openjdk-8-jre docker.io kubeadm=1.8.0-00 kubelet=1.8.0-00 kubectl=1.8.0-00

kubeadm reset && kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=$(ifconfig enp0s9|xargs|awk '{print $7}'|sed -e 's/[a-z]*:/''/') > /vagrant/kube.txt && sleep 3

su - ubuntu | mkdir -p /home/ubuntu/.kube && sudo cp /etc/kubernetes/admin.conf /home/ubuntu/.kube/config && sudo chown ubuntu:ubuntu /home/ubuntu/.kube/config
sleep 3

######!!!создаем сеть для нодов, выполняем от пользователя!!!######
#kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.0/Documentation/kube-flannel.yml
######!!!Для версии 1.8.0 использовал flanel 0.8.0
#kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.8.0/Documentation/kube-flannel.yml
#kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.8.0/Documentation/kube-flannel-rbac.yml

######!!!позволяет запускать поды на мастере (single-mode)!!!######
#kubectl taint nodes --all node-role.kubernetes.io/master-

######!!!устанавливаем роль для dashboard, чтобы зайти без credentials!!!######
#su - ubuntu | kubectl create -f /vagrant/kube-dashboard-rbac.yml

######!!!создаем сертификаты для dashboard!!!######
#Generate private key and certificate signing request
#$ mkdir certs
#$ cd certs
#$ openssl genrsa -des3 -passout pass:x -out dashboard.pass.key 2048
#...
#$ openssl rsa -passin pass:x -in dashboard.pass.key -out dashboard.key
# Writing RSA key
#$ rm dashboard.pass.key
#$ openssl req -new -key dashboard.key -out dashboard.csr
#...
#Country Name (2 letter code) [AU]: US
#...
#A challenge password []:
#...
#Generate SSL certificate
#The self-signed SSL certificate is generated from the dashboard.key private key and dashboard.csr files.
#$ openssl x509 -req -sha256 -days 365 -in dashboard.csr -signkey dashboard.key -out dashboard.crt
#The dashboard.crt file is your certificate suitable for use with Dashboard along with the dashboard.key private key.
#$ kubectl create secret generic kubernetes-dashboard-certs --from-file=$HOME/certs -n kube-system

######!!!устанавливаем dashboard!!!######
#!!!ONLY HTTPS ACCESS!!! su - ubuntu | kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
######!!!правим конфиг dashboard!!!######
# kubectl -n kube-system edit service kubernetes-dashboard
# маняем 
# type: ClusterIP
# на
# type: NodePort
# сохраняем
# сторим на каком порту крутится теперь сервис dashboard
# kubectl -n kube-system get service
##kubernetes-dashboard   NodePort    10.103.192.44    <none>        443:!!!PORT!!!/TCP 
# теперь на https://hostname:!!!PORT!!! крутится наш dashboard

######!!!альтернативный dashboard!!!######
#!!!ONLY HTTP ACCESS!!! kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/alternative/kubernetes-dashboard.yaml

######!!!устанавливаем heapster и grafana желательно после подключения нодов(если только не single-mode)!!!######
#su - ubuntu | git clone https://github.com/kubernetes/heapster.git && kubectl create -f ./heapster/deploy/kube-config/rbac/heapster-rbac.yaml && kubectl create -f ./heapster/deploy/kube-config/influxdb/ 

######!!!НЕ ОБЯЗАТЕЛЬНО!!!запускаем dashboard локально!!!######
# kubectl proxy
######!!! НЕ ОБЯЗАТЕЛЬНО!!!вываливаем dashboard наружу!!!######
#kubectl proxy --disable-filter=true --address $(ifconfig enp0s8|xargs|awk '{print $7}'|sed -e 's/[a-z]*:/''/') --port=9090 --accept-hosts='^10.19.12.*$'

######!!!Once installed, the deployment is not automatically updated.!!!#######
#In order to update it you need to delete the deployment's pods and wait for it to be recreated. 
#After recreation, it should use the latest image.
#kubectl -n kube-system delete $(kubectl -n kube-system get pod -o name | grep dashboard)

#######!!!!!!!!!ConfigMap For Nginx!!!!!!!!!!!!#######
#kubectl create configmap nginx-configmap --from-file=/vagrant/nginx_configmap.yml

#######позволяет даунгрэйд к указанной версии!!!#######
#!!!!!!!kubeadm upgrade apply v1.8.0 --force
