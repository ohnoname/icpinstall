#!/bin/bash

sh ./01-1-passwordless-ssh.sh
sh ./01-2-bind-mounts.sh
sh ./01-update-hosts.sh
sh ./02-ssh-setup.sh
sh ./03-install-packages.sh
sh ./04-configure-os.sh
sh ./05-firewall-config.sh
sh ./06-get-installer.sh
sh ./07-configure-installer.sh
sh ./08-install.sh
sh ./09-kubeconfig.sh