#!/bin/bash

# exit immediately if a command/pipeline exits with a non-zero status
set -e
set -o pipefail

# set variables
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PACKAGES="vim curl htop iftop iptraf tcpdump iotop ccze unzip apt-transport-https"

# initial root check
if [[ "$EUID" -ne 0 ]]; then
	echo "Run this script as root." 1>&2
	exit 1
fi

# locale setup
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8

# update and upgrade via apt
apt-get update
apt-get -y dist-upgrade

# additional packages installation
apt-get -y install $PACKAGES

# .bashrc setup
cp -p $DIR/scripts/.bashrc ~/.bashrc
source ~/.bashrc

# chrony setup
bash $DIR/scripts/chrony.sh

# tor setup
bash $DIR/scripts/tor.sh

# iptables setup
bash $DIR/scripts/iptables.sh

# unbound setup
bash $DIR/scripts/unbound.sh

# change from graphical.target (default) to multi-user.target
if [[ $(systemctl get-default) != multi-user.target ]]; then
  systemctl set-default multi-user.target
fi

# cleaning via apt
apt-get autoclean
apt-get -y autoremove

# some folder deletions
[ -d "/var/log/puppetlabs/" ] && rm -rf /var/log/puppetlabs/
[ -d "unattended-upgrades/" ] && rm -rf /unattended-upgrades/
[ -f "/var/log/alternatives.log" ] && rm -f /var/log/alternatives.log
[ -f "/var/log/bootstrap.log" ] && rm -f /var/log/bootstrap.log

tput bold; echo "done, please reboot"; tput sgr0
