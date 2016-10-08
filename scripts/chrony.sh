#!/bin/bash
#documentation: https://chrony.tuxfamily.org/manual.html

#install chrony if necessary
if [[ $(which chronyd) != /usr/sbin/chronyd ]]; then
   apt-get -y install chrony
fi

#disable systemd ntp and standartize on UTC timezone
timedatectl set-ntp false
timedatectl set-timezone UTC

#check link to localtime
if [[ $(readlink -f /etc/localtime) != /usr/share/zoneinfo/UTC ]]; then
  rm -f /etc/localtime
  ln -s /usr/share/zoneinfo/UTC /etc/localtime
fi

#stop chrony right after installation and enable after reboot
systemctl stop chrony.service && sleep 5
systemctl enable chrony.service

#backup config first
mv /etc/chrony/chrony.conf /etc/chrony/chrony.conf.bak

#create chrony config
cat > /etc/chrony/chrony.conf <<EOF
# NTP servers list.
server 0.pool.ntp.org iburst
server 1.pool.ntp.org iburst
server 2.pool.ntp.org iburst
server 3.pool.ntp.org iburst

# Record the rate at which the system clock gains/losses time.
driftfile /var/lib/chrony/drift

# Enable kernel RTC synchronization.
rtcsync

# Keep RTC to use UTC.
rtconutc

# If offset is larger than 0.1 second, adjust time in first 10 updates.
makestep 0.1 10

# Deny NTP client requests.
deny all

# Listen for commands only on localhost.
bindcmdaddress 127.0.0.1
bindcmdaddress ::1

# Send a message to syslog if a clock adjustment is larger than 0.1 second.
logchange 0.1
EOF
