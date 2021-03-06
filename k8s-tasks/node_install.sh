#!/bin/bash

sudo -i

#sysctl net.bridge.bridge-nf-call-iptables=1

apt-get -y update && apt-get install -y apt-transport-https

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get -y update && apt-get install -y git openjdk-8-jre docker.io kubeadm=1.8.0-00 kubelet=1.8.0-00 kubectl=1.8.0-00 #kubernetes-cni

kubeadm reset 
#применяем join для присоединения нода к мастеру
#$(cat /vagrant/kube.txt | grep "kubeadm join") # --skip-preflight-checks-(есди не нелали kubeadm reset)
sleep 3
