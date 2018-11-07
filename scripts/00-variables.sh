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
#   Master Node - 4 CPUs 2 cores, 16 GB RAM, 200 GB disk
#   Worker Node - 2 CPUs 1 core, 8 GB RAM, 150 GB disk
#	Proxy  Node - 2 CPUs 1 core, 8 GB RAM, 50 GB disk
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

#ToDo add PROXY and change version of ICP
export SSH_KEY=/home/VS.LAN/bnieuwenburg
export SSH_USER=bnieuwenburg

#export PUBLIC_IP=x.x.x.x
export MASTER_IP=mastertest.vs.ccloud.vs.lan


#WORKER_IPS[0] should be the same worker at WORKER_HOSTNAMES[0]
export WORKER_IPS=("workertest.vs.ccloud.vs.lan")
export WORKER_HOSTNAMES=("icpworker1")

#PROXY
export PROXY_IP=proxytest.vs.ccloud.vs.lan


if [[ "${#WORKER_IPS[@]}" != "${#WORKER_HOSTNAMES[@]}" ]]; then
  echo "ERROR: Ensure that the arrays WORKER_IPS and WORKER_HOSTNAMES are of the same length"
  return 1
fi

export NUM_WORKERS=${#WORKER_IPS[@]}

export ARCH="$(uname -m)"
if [ "${ARCH}" != "x86_64" ]; then
  export INCEPTION_TAG="-${ARCH}"
fi

#echo ${WORKER_HOSTNAMES}
#export ARRAY_IDX=${!WORKER_IPS[*]}
#for index in $ARRAY_IDX;
#do
#    echo ${WORKER_IPS[$index]}
#done
