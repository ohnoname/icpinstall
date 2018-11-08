#!/bin/bash
# User steps for password-less communications

source ./00-variables.sh

# Generate RSA key
ssh-keygen -b 4096 -t rsa -f ~/.ssh/id_rsa -N ""

# Move RSA key to masters
for ((i=0; i < $NUM_MASTERS; i++)); do
  # Prevent SSH identity prompts
  # If host IP exists in known hosts remove it
  ssh-keygen -R ${MASTER_IPS[i]}
  # Add host IP to known hosts
  ssh-keyscan -H ${MASTER_IPS[i]} | tee -a ~/.ssh/known_hosts
  
  # Copy over key (Will prompt for password)
  scp ~/.ssh/id_rsa.pub ${SSH_USER}@${MASTER_IPS[i]}:~/id_rsa.pub
  ssh ${SSH_USER}@${MASTER_IPS[i]} 'mkdir -p ~/.ssh; cat ~/id_rsa.pub | tee -a ~/.ssh/authorized_keys'
done

# Move RSA key to workers
for ((i=0; i < $NUM_WORKERS; i++)); do
  # Prevent SSH identity prompts
  # If host IP exists in known hosts remove it
  ssh-keygen -R ${WORKER_IPS[i]}
  # Add host IP to known hosts
  ssh-keyscan -H ${WORKER_IPS[i]} | tee -a ~/.ssh/known_hosts
  
  # Copy over key (Will prompt for password)
  scp ~/.ssh/id_rsa.pub ${SSH_USER}@${WORKER_IPS[i]}:~/id_rsa.pub
  ssh ${SSH_USER}@${WORKER_IPS[i]} 'mkdir -p ~/.ssh; cat ~/id_rsa.pub | tee -a ~/.ssh/authorized_keys'
done

# Move RSA key to proxys
for ((i=0; i < $NUM_PROXYS; i++)); do
  # Prevent SSH identity prompts
  # If host IP exists in known hosts remove it
  ssh-keygen -R ${PROXY_IPS[i]}
  # Add host IP to known hosts
  ssh-keyscan -H ${PROXY_IPS[i]} | tee -a ~/.ssh/known_hosts
  
  # Copy over key (Will prompt for password)
  scp ~/.ssh/id_rsa.pub ${SSH_USER}@${PROXY_IPS[i]}:~/id_rsa.pub
  ssh ${SSH_USER}@${PROXY_IPS[i]} 'mkdir -p ~/.ssh; cat ~/id_rsa.pub | tee -a ~/.ssh/authorized_keys'
done

echo IdentityFile ~/.ssh/id_rsa | tee -a ~/.ssh/config
