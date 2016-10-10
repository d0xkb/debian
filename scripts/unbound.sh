#!/bin/bash

# install unbound if necessary
if [[ $(which unbound) != /usr/sbin/unbound ]]; then
  apt-get -y install unbound
fi

# stop tor right after installation and enable after reboot
systemctl stop unbound.service && sleep 5
systemctl enable unbound.service

# config path set
unbound -c /etc/unbound/unbound.conf

# root trust anchor for DNSSEC validation key setup
unbound-anchor -a "/var/lib/unbound/root.key"

# backup config first
mv /etc/unbound/unbound.conf /etc/unbound/unbound.conf.bak

# create unbound config
cat > /etc/unbound/unbound.conf <<EOF
server:
interface: 127.0.0.1
access-control: 127.0.0.1 allow
port: 53
do-daemonize: yes
num-threads: 1
use-caps-for-id: yes
harden-glue: yes
hide-identity: yes
hide-version: yes
EOF

# set to use local DNS resolver
chattr -i /etc/resolv.conf # allow the modification of the file
sed -i 's|nameserver|#nameserver|' /etc/resolv.conf # disable previous DNS servers
echo "nameserver 127.0.0.1" >> /etc/resolv.conf # set localhost as the DNS resolver
chattr +i /etc/resolv.conf # disallow the modification of the file

# start local DNS resolver
systemctl start unbound.service
