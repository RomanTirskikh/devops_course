#!/bin/bash

sudo -i

sysctl net.bridge.bridge-nf-call-iptables=1

apt-get -y update && apt-get install -y apt-transport-https

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get -y update && apt-get install -y git openjdk-8-jre docker.io kubelet kubeadm kubectl kubernetes-cni

kubeadm reset && kubeadm init --apiserver-advertise-address=$(ifconfig enp0s9|xargs|awk '{print $7}'|sed -e 's/[a-z]*:/''/') > /vagrant/kube.txt #--skip-preflight-checks 
sleep 10

su - ubuntu | mkdir -p /home/ubuntu/.kube && sudo cp /etc/kubernetes/admin.conf /home/ubuntu/.kube/config && sudo chown ubuntu:ubuntu /home/ubuntu/.kube/config
sleep 3

#su - ubuntu | kubectl apply -f https://git.io/weave-kube & sleep 3

#wget https://storage.googleapis.com/golang/go1.9.1.linux-amd64.tar.gz && tar -C /usr/local -xzf go1.9.1.linux-amd64.tar.gz && cat <<EOF >>/home/ubuntu/.bashrc
#export PATH=$PATH:/usr/local/go/bin
#EOF

#git clone https://github.com/creationix/nvm.git /home/ubuntu/.nvm && cat <<EOF >>/home/ubuntu/.bashrc
#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#EOF

#su - ubuntu | nvm install node && nvm run node --version && npm install --global gulp-cli


#sudo su - ubuntu
#git clone https://github.com/kubernetes/heapster.git && kubectl create -f ./heapster/deploy/kube-config/influxdb/ && kubectl create -f ./heapster/deploy/kube-config/rbac/heapster-rbac.yaml && kubectl apply -f https://git.io/weave-kube && kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/alternative/kubernetes-dashboard.yaml
#sleep 3
#kubectl proxy --address $(ifconfig enp0s8|xargs|awk '{print $7}'|sed -e 's/[a-z]*:/''/') --port=9090 --accept-hosts='^10.19.12.*$' &  sleep 3

#su - ubuntu | git clone https://github.com/kubernetes/heapster.git #install Heapster on Kubernetes
#sleep 3
#su - ubuntu | kubectl create -f ./heapster/deploy/kube-config/influxdb/ #install Heapster on Kubernetes
#sleep 3
#su - ubuntu | kubectl create -f ./heapster/deploy/kube-config/rbac/heapster-rbac.yaml #install Heapster on Kubernetes
#sleep 3
#su - ubuntu | kubectl apply -f https://git.io/weave-kube #install Weave on Kubernetes
#sleep 3
#su - ubuntu | kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/alternative/kubernetes-dashboard.yaml #install Dashboard on Kubernetes
#
#$ kubectl -n kube-system edit service kubernetes-dashboard
#You should see yaml representation of the service. Change type: ClusterIP to type: NodePort and save file. If it's already changed go to next step.
#Next we need to check port on which Dashboard was exposed.
#$ kubectl -n kube-system get service kubernetes-dashboard
#
#
#!!!ONLY HTTPS ACCESS!!! su - ubuntu | kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml #install Dashboard on Kubernetes
#su - ubuntu | kubectl -n kube-system delete $(kubectl -n kube-system get pod -o name | grep dashboard) #Once installed, the deployment is not automatically updated. In order to update it you need to delete the deployment's pods and wait for it to be recreated. After recreation, it should use the latest image.
#sleep 3


#kubectl --kubeconfig /etc/kubernetes/admin.conf proxy --disable-filter=true --address=10.253.129.226 --port=80 
#kubectl proxy --disable-filter=true --address $(ifconfig enp0s8|xargs|awk '{print $7}'|sed -e 's/[a-z]*:/''/') --port=9090 --accept-hosts='^10.19.12.*$'
#Привет, да, конечно, тебе нужен доступ к API кубера, тогда через /ui будет дашбоард
#либо експоузить через Service, для этого надо сменить тип на NodePort
