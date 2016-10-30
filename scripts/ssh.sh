#!/bin/bash

# set variables
key="/root/.ssh/authorized_keys"
perm="600"

# install publis ssh key and set permissions
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO273ebwYHLk/mhuXeNIqCtef3xa1iznD+EU81tjZJys d0xkb@d0xkbs-MacBook-Air.local" > $key

# check permissions and correct if needed
if [[ $(stat -c %a "$key") != $perm ]]; then
  chmod $perm $key
fi

# disable password authentification
if [[ $(sshd -T |grep passwordauth |awk '{print $2}') != no ]]; then
  sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
  systemctl restart sshd.service
fi
