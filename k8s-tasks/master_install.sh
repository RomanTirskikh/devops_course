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

#позволяет даунгрэйд к указанной версии
#!!!!!!!kubeadm upgrade apply v1.8.0 --force

######!!!создаем сеть для нодов!!!#####
#kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.0/Documentation/kube-flannel.yml
#!!su - ubuntu | kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.8.0/Documentation/kube-flannel.yml
#!!su - ubuntu | kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.8.0/Documentation/kube-flannel-rbac.yml

#By default, your cluster will not schedule pods on the master for security reasons. 
#If you want to be able to schedule pods on the master, e.g. for a single-machine Kubernetes cluster for development, run:
#kubectl taint nodes --all node-role.kubernetes.io/master-

######!!!устанавливаем роль для dashboard!!!#####
#su - ubuntu | kubectl create -f /vagrant/kube-dashboard-rbac.yml
######!!!создаем сертификаты
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
#устанавливаем dashboard
#!!!ONLY HTTPS ACCESS!!! su - ubuntu | kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
#правим конфиг dashboard
# kubectl -n kube-system edit service kubernetes-dashboard
# маняем 
# type: ClusterIP
# на
# type: NodePort
# сохраняем
# сторим на каком порту крутится теперь сервис dashboard
# kubectl -n kube-system get service
##kubernetes-dashboard   NodePort    10.103.192.44    <none>        443:!!!32314!!!/TCP 
# теперь на https://hostname:!!!PORT!!! крутится наш dashboard
###############
#устанавливаем альтернативный dashboard
#!!!ONLY HTTP ACCESS!!! kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/alternative/kubernetes-dashboard.yaml
###############
#устанавливаем heapster и grafana желательно после подключения нодов
#su - ubuntu | git clone https://github.com/kubernetes/heapster.git && kubectl create -f ./heapster/deploy/kube-config/rbac/heapster-rbac.yaml && kubectl create -f ./heapster/deploy/kube-config/influxdb/ 
###############
#!!! НЕ ОБЯЗАТЕЛЬНО!!! запускаем dashboard локально
#kubectl proxy
#!!! НЕ ОБЯЗАТЕЛЬНО!!!вываливаем dashboard наружу
#kubectl proxy --disable-filter=true --address $(ifconfig enp0s8|xargs|awk '{print $7}'|sed -e 's/[a-z]*:/''/') --port=9090 --accept-hosts='^10.19.12.*$'

#$ kubectl -n kube-system edit service kubernetes-dashboard
#You should see yaml representation of the service. Change type: ClusterIP to type: NodePort and save file. If it's already changed go to next step.
#Next we need to check port on which Dashboard was exposed.
#$ kubectl -n kube-system get service kubernetes-dashboard
#!!!ONLY HTTPS ACCESS!!! su - ubuntu | kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml #install Dashboard on Kubernetes
#su - ubuntu | kubectl -n kube-system delete $(kubectl -n kube-system get pod -o name | grep dashboard) #Once installed, the deployment is not automatically updated. In order to update it you need to delete the deployment's pods and wait for it to be recreated. After recreation, it should use the latest image.
#sleep 3

#Привет, да, конечно, тебе нужен доступ к API кубера, тогда через /ui будет дашбоард
#либо експоузить через Service, для этого надо сменить тип на NodePort

# софт для разработки 
#wget https://storage.googleapis.com/golang/go1.9.1.linux-amd64.tar.gz && tar -C /usr/local -xzf go1.9.1.linux-amd64.tar.gz && cat <<EOF >>/home/ubuntu/.bashrc
#export PATH=$PATH:/usr/local/go/bin
#EOF
#git clone https://github.com/creationix/nvm.git /home/ubuntu/.nvm && cat <<EOF >>/home/ubuntu/.bashrc
#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#EOF
#su - ubuntu | nvm install node && nvm run node --version && npm install --global gulp-cli

########!!!!!!!!!ConfigMap For Nginx!!!!!!!!!!!!###########
#kubectl create configmap nginx-configmap --from-file=/vagrant/nginx_configmap.yml
