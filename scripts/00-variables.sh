#!/bin/bash
# ----------------------------------------------------------------------------------------------------\\
# Description:
#   A basic installer for IBM Cloud Private-CE 3.1.0 on RHEL 7.4
# ----------------------------------------------------------------------------------------------------\\
# Note:
#   This assumes all VMs were provisioned to be accessable with the same SSH key
#   All scripts should be run from the master node
# ----------------------------------------------------------------------------------------------------\\
# System Requirements:
#   Tested against RHEL 7.4 (Conclusion Cloud - KVM-RHE7.4-Srv-x64)
#   Master Node - 4 CPUs 2 cores, 16 GB RAM, 250 GB disk
#   Worker Node - 2 CPUs 1 core, 8 GB RAM, 150 GB disk
#	Proxy  Node - 2 CPUs 1 core, 8 GB RAM, 150 GB disk
#   Requires sudo access
# ----------------------------------------------------------------------------------------------------\\
# Docs:
#   Installation Steps From:
#    - https://www.ibm.com/support/knowledgecenter/SSBS6K_3.1.0/installing/prep_cluster.html
#    - https://www.ibm.com/support/knowledgecenter/SSBS6K_3.1.0/installing/install_containers_CE.html
#
#   Wiki:
#    - https://www.ibm.com/developerworks/community/wikis/home?lang=en#!/wiki/W1559b1be149d_43b0_881e_9783f38faaff
#    - https://www.ibm.com/developerworks/community/wikis/home?lang=en#!/wiki/W1559b1be149d_43b0_881e_9783f38faaff/page/Connect
# ----------------------------------------------------------------------------------------------------\\

export SSH_KEY=~/.ssh/id_rsa
export SSH_USER=aommeren

#export PUBLIC_IP=x.x.x.x
export MASTER_IPS=("172.17.16.10")
export MASTER_HOSTNAMES=("icpmaster1")

#WORKER_IPS[0] should be the same worker at WORKER_HOSTNAMES[0]
export WORKER_IPS=("172.17.16.11")
export WORKER_HOSTNAMES=("icpworker1")

#PROXY
export PROXY_IPS=("172.17.16.12")
export PROXY_HOSTNAMES=("icpproxy1")

if [[ "${#MASTER_IPS[@]}" != "${#MASTER_HOSTNAMES[@]}" ]]; then
  echo "ERROR: Ensure that the arrays MASTER_IPS and MASTER_HOSTNAMES are of the same length"
  return 1
fi

if [[ "${#WORKER_IPS[@]}" != "${#WORKER_HOSTNAMES[@]}" ]]; then
  echo "ERROR: Ensure that the arrays WORKER_IPS and WORKER_HOSTNAMES are of the same length"
  return 1
fi

if [[ "${#PROXY_IPS[@]}" != "${#PROXY_HOSTNAMES[@]}" ]]; then
  echo "ERROR: Ensure that the arrays PROXY_IPS and PROXY_HOSTNAMES are of the same length"
  return 1
fi

export NUM_MASTERS=${#WORKER_IPS[@]}
export NUM_WORKERS=${#WORKER_IPS[@]}
export NUM_PROXYS=${#PROXY_IPS[@]}


export ARCH="$(uname -m)"
if [ "${ARCH}" != "x86_64" ]; then
  export INCEPTION_TAG="-${ARCH}"
fi
