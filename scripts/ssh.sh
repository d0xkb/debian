#!/bin/bash

# set variables
key="/root/.ssh/authorized_keys"
perm="600"

# install ssh key and set permissions
cat > $key <<EOF
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO273ebwYHLk/mhuXeNIqCtef3xa1iznD+EU81tjZJys
EOF

# check ssh key permissions and correct them if needed
if [[ $(stat -c %a "$key") != $perm ]]; then
  chmod $perm $key
fi

# disable password authentification and restart ssh service
if [[ $(sshd -T |grep passwordauth |awk '{print $2}') != "no" ]]; then
  sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
  systemctl restart ssh.service
fi
