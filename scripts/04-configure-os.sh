#!/bin/bash

# Get the variables
source 00-variables.sh

# Disable SELinux
sudo setenforce 0

# Set VM max map count (see max_map_count https://www.kernel.org/doc/Documentation/sysctl/vm.txt)
sudo sysctl -w vm.max_map_count=262144
echo vm.max_map_count=262144 | sudo tee -a /etc/sysctl.conf

# Sync time
sudo yum install -y ntpdate
sudo ntpdate -s time.nist.gov

# Start docker
sudo service docker restart

for ((i=0; i < $NUM_WORKERS; i++)); do
  # Disable SELinux
  ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo setenforce 0

  # Set VM max map count
  ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo sysctl -w vm.max_map_count=262144
  ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} "echo vm.max_map_count=262144 | sudo tee -a /etc/sysctl.conf"

  # Sync time
  ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo yum install -y ntpdate
  ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo ntpdate -s time.nist.gov

  # Start docker
  ssh ${SSH_USER}@${WORKER_HOSTNAMES[i]} sudo service docker restart

done

for ((i=0; i < $NUM_PROXYS; i++)); do
  # Disable SELinux
  ssh ${SSH_USER}@${PROXY_HOSTNAMES[i]} sudo setenforce 0

  # Set VM max map count
  ssh ${SSH_USER}@${PROXY_HOSTNAMES[i]} sudo sysctl -w vm.max_map_count=262144
  ssh ${SSH_USER}@${PROXY_HOSTNAMES[i]} "echo vm.max_map_count=262144 | sudo tee -a /etc/sysctl.conf"

  # Sync time
  ssh ${SSH_USER}@${PROXY_HOSTNAMES[i]} sudo yum install -y ntpdate
  ssh ${SSH_USER}@${PROXY_HOSTNAMES[i]} sudo ntpdate -s time.nist.gov

  # Start docker
  ssh ${SSH_USER}@${PROXY_HOSTNAMES[i]} sudo service docker restart

done


