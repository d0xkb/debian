#!/bin/bash

#install unbound
apt-get -y install unbound

#stop tor right after installation and enable after reboot
systemctl stop unbound.service && sleep 5
systemctl enable unbound.service

#config path set
unbound -c /etc/unbound/unbound.conf

#root trust anchor for DNSSEC validation key setup
unbound-anchor -a "/var/lib/unbound/root.key"

#create unbound config
cat >> /etc/unbound/unbound.conf <<EOF
server:
interface: 127.0.0.1
access-control: 127.0.0.1 allow
port: 53
do-daemonize: yes
num-threads: 2
use-caps-for-id: yes
harden-glue: yes
hide-identity: yes
hide-version: yes
EOF

#set to use local DNS resolver
chattr -i /etc/resolv.conf #allow the modification of the file
sed -i 's|nameserver|#nameserver|' /etc/resolv.conf #disable previous DNS servers
echo "nameserver 127.0.0.1" >> /etc/resolv.conf #set localhost as the DNS resolver
chattr +i /etc/resolv.conf #disallow the modification of the file

#start local DNS resolver
systemctl start unbound.service
