sudo su - ubuntu
/usr/bin/kubectl create -f /home/ubuntu/heapster/deploy/kube-config/influxdb/ --openapi-validation=true && sleep 3
/usr/bin/kubectl create -f /home/ubuntu/heapster/deploy/kube-config/rbac/heapster-rbac.yaml --openapi-validation=true && sleep 3