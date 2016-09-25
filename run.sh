#!/bin/bash

#initial root check
if [ "$EUID" -ne 0 ]; then
	echo "Run this script as root." 1>&2
	exit 1
fi

#update and upgrade via apt
apt-get update
apt-get -y upgrade

#packages
packages="vim curl htop iftop iptraf tcpdump iotop ccze unzip"

#additional packages installation
apt-get -y install $packages

#get current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#.bashrc setup
cp -p $DIR/scripts/.bashrc ~/.bashrc
source ~/.bashrc

#chrony setup
bash $DIR/scripts/chrony.sh

#tor setup
bash $DIR/scripts/tor.sh

#iptables setup
bash $DIR/scripts/iptables.sh

#unbound setup
bash $DIR/scripts/unbound.sh

#change from graphical.target (default) to multi-user.target
if [[ $(systemctl get-default) != multi-user.target ]]; then
  systemctl set-default multi-user.target
fi

#cleaning via apt
apt-get autoclean
apt-get -y autoremove

#some deletions
[ -d "/var/log/puppetlabs/" ] && rm -rf /var/log/puppetlabs/
[ -e "/var/log/alternatives.log" ] && rm -f /var/log/alternatives.log
[ -e "/var/log/bootstrap.log" ] && rm -f /var/log/bootstrap.log

tput bold; echo "done, please reboot"; tput sgr0
