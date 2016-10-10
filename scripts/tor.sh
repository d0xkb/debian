#!/bin/bash
# documentation: https://www.torproject.org/docs/debian

# add tor repo
cat > /etc/apt/sources.list.d/tor.list <<EOF
deb https://deb.torproject.org/torproject.org $(lsb_release -cs) main
EOF

# add gpg key
gpg --keyserver keys.gnupg.net --recv 886DDD89
gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -

# update newly added repo and install tor
apt-get update
apt-get -y install tor deb.torproject.org-keyring

# stop tor right after installation and enable after reboot
systemctl stop tor.service && sleep 5
systemctl enable tor.service

# backup config first
mv /etc/tor/torrc /etc/tor/torrc.bak

# create tor config
cat > /etc/tor/torrc <<EOF
ORPort 9001
DirPort 9030
RelayBandwidthRate 2048 KBytes
RelayBandwidthBurst 2048 KBytes
#Nickname ididnteditheconfig
#ContactInfo 0xFFFFFFFF Random Person <nobody AT example dot com>
ExitPolicy reject *:*
EOF
