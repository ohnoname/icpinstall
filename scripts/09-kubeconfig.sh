#!/bin/bash

source 00-variables.sh

set -e

cd /opt/ibm-cloud-private-3.1.0

# Get kubectl
sudo docker run -e LICENSE=accept --net=host -v /usr/local/bin:/data ibmcom/kubernetes${INCEPTION_TAG}:v1.11.1 cp /kubectl /data

# Make config directory
mkdir -p ~/.kube
sudo cp cluster/cfc-certs/kubecfg.* ~/.kube/
sudo chown -R $USER  ~/.kube/

#Set kube config
kubectl config set-cluster cfc-cluster --server=https://172.17.16.10:8001 --insecure-skip-tls-verify=true
kubectl config set-context kubectl --cluster=cfc-cluster
kubectl config set-credentials user --client-certificate=$HOME/.kube/kubecfg.crt --client-key=$HOME/.kube/kubecfg.key
kubectl config set-context kubectl --user=user
kubectl config use-context kubectl
