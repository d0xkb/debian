#!/bin/bash
#documentation: https://chrony.tuxfamily.org/manual.html

#install chrony if necessary
if [[ $(which chronyd) != /usr/sbin/chronyd ]]; then
   apt-get -y install chrony
fi

#disable systemd ntp and set FR timezone
timedatectl set-ntp false
timedatectl set-timezone Europe/Paris

#stop chrony right after installation and enable after reboot
systemctl stop chrony.service && sleep 5
systemctl enable chrony.service

#backup config first
mv /etc/chrony/chrony.conf /etc/chrony/chrony.conf.bak

#create chrony config
cat > /etc/chrony/chrony.conf <<EOF
# NTP servers list.
server ntp-p1.obspm.fr prefer iburst
server chronos.cru.fr iburst
server canon.inria.fr iburst

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
