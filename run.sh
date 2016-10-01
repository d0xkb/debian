#!/bin/bash

#error return
err="exit 1"

#initial root check
if [ "$EUID" -ne 0 ]; then
	echo "Run this script as root." 1>&2
	$err
fi

#locale setup
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8

#update and upgrade via apt
apt-get update
apt-get -y dist-upgrade

#packages
packages="vim curl htop iftop iptraf tcpdump iotop ccze unzip"

#additional packages installation
apt-get -y install $packages

#get current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#.bashrc setup
cp -p $DIR/scripts/.bashrc ~/.bashrc || $err
source ~/.bashrc

#chrony setup
bash $DIR/scripts/chrony.sh || $err

#tor setup
bash $DIR/scripts/tor.sh || $err

#iptables setup
bash $DIR/scripts/iptables.sh || $err

#unbound setup
bash $DIR/scripts/unbound.sh || $err

#change from graphical.target (default) to multi-user.target
if [[ $(systemctl get-default) != multi-user.target ]]; then
  systemctl set-default multi-user.target
fi

#cleaning via apt
apt-get autoclean
apt-get -y autoremove

#some folder deletions
[ -d "/var/log/puppetlabs/" ] && rm -rf /var/log/puppetlabs/
[ -d "unattended-upgrades/" ] && rm -rf /unattended-upgrades/
[ -e "/var/log/alternatives.log" ] && rm -f /var/log/alternatives.log
[ -e "/var/log/bootstrap.log" ] && rm -f /var/log/bootstrap.log

#remove unnecessary users
userdel -r uucp 2>/dev/null
userdel -r www-data 2>/dev/null
userdel -r irc 2>/dev/null
userdel -r games 2>/dev/null
userdel -r news 2>/dev/null
userdel -r lp 2>/dev/null
userdel -r backup 2>/dev/null
userdel -r proxy 2>/dev/null
userdel -r gnats 2>/dev/null
userdel -r list 2>/dev/null
userdel -r systemd-resolve 2>/dev/null
userdel -r debian 2>/dev/null

#home for nobody user
mkdir -p /nonexistent

tput bold; echo "done, please reboot"; tput sgr0
