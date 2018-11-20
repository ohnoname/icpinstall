#!/bin/bash
# Constructs hosts file

# Get the variables
source 00-variables.sh

# Back up old hosts file
sudo cp /etc/hosts /etc/hosts.bak

echo "127.0.0.1 localhost" | sudo tee /etc/hosts
echo "" | sudo tee -a /etc/hosts

echo "fe00::0 ip6-localnet" | sudo tee -a /etc/hosts
echo "ff00::0 ip6-mcastprefix" | sudo tee -a /etc/hosts
echo "ff02::1 ip6-allnodes" | sudo tee -a /etc/hosts
echo "ff02::2 ip6-allrouters" | sudo tee -a /etc/hosts
echo "ff02::3 ip6-allhosts" | sudo tee -a /etc/hosts
echo "" | sudo tee -a /etc/hosts

# Loop through the array
for ((i=0; i < $NUM_MASTERS; i++)); do
  echo "${MASTER_IPS[i]} ${MASTER_HOSTNAMES[i]}" | sudo tee -a /etc/hosts
done

# Loop through the array
for ((i=0; i < $NUM_WORKERS; i++)); do
  echo "${WORKER_IPS[i]} ${WORKER_HOSTNAMES[i]}" | sudo tee -a /etc/hosts
done

# Loop through the array
for ((i=0; i < $NUM_PROXYS; i++)); do
  echo "${PROXY_IPS[i]} ${PROXY_HOSTNAMES[i]}" | sudo tee -a /etc/hosts
done

echo "" | sudo tee -a /etc/hosts

sudo cp /etc/hosts ~/master-hosts
sudo chown $USER ~/master-hosts

sudo cp /etc/hosts ~/worker-hosts
sudo chown $USER ~/worker-hosts

sudo cp /etc/hosts ~/proxy-hosts
sudo chown $USER ~/proxy-hosts

for ((i=0; i < $NUM_MASTERS; i++)); do
  # Remove old instance of host
  ssh-keygen -R ${MASTER_IPS[i]}
  ssh-keygen -R ${MASTER_HOSTNAMES[i]}

  # Do not ask to verify fingerprint of server on ssh
  ssh-keyscan -H ${MASTER_IPS[i]} >> ~/.ssh/known_hosts
  ssh-keyscan -H ${MASTER_HOSTNAMES[i]} >> ~/.ssh/known_hosts

  # Copy over file
  sudo scp -i ${SSH_KEY} ~/master-hosts  ${SSH_USER}@${MASTER_HOSTNAMES[i]}:~/master-hosts

  # Replace MASTER hosts with file
  ssh -i ${SSH_KEY} ${SSH_USER}@${MASTER_HOSTNAMES[i]} 'sudo cp /etc/hosts /etc/hosts.bak; sudo mv ~/master-hosts /etc/hosts'
done

for ((i=0; i < $NUM_WORKERS; i++)); do
  # Remove old instance of host
  ssh-keygen -R ${WORKER_IPS[i]}
  ssh-keygen -R ${WORKER_HOSTNAMES[i]}

  # Do not ask to verify fingerprint of server on ssh
  ssh-keyscan -H ${WORKER_IPS[i]} >> ~/.ssh/known_hosts
  ssh-keyscan -H ${WORKER_HOSTNAMES[i]} >> ~/.ssh/known_hosts

  # Copy over file
  sudo scp -i ${SSH_KEY} ~/worker-hosts  ${SSH_USER}@${WORKER_HOSTNAMES[i]}:~/worker-hosts

  # Replace worker hosts with file
  ssh -i ${SSH_KEY} ${SSH_USER}@${WORKER_HOSTNAMES[i]} 'sudo cp /etc/hosts /etc/hosts.bak; sudo mv ~/worker-hosts /etc/hosts'
done

for ((i=0; i < $NUM_PROXYS; i++)); do
  # Remove old instance of host
  ssh-keygen -R ${PROXY_IPS[i]}
  ssh-keygen -R ${PROXY_HOSTNAMES[i]}

  # Do not ask to verify fingerprint of server on ssh
  ssh-keyscan -H ${PROXY_IPS[i]} >> ~/.ssh/known_hosts
  ssh-keyscan -H ${PROXY_HOSTNAMES[i]} >> ~/.ssh/known_hosts

  # Copy over file
  sudo scp -i ${SSH_KEY} ~/proxy-hosts  ${SSH_USER}@${PROXY_HOSTNAMES[i]}:~/proxy-hosts

  # Replace proxy hosts with file
  ssh -i ${SSH_KEY} ${SSH_USER}@${PROXY_HOSTNAMES[i]} 'sudo cp /etc/hosts /etc/hosts.bak; sudo mv ~/proxy-hosts /etc/hosts'
done
