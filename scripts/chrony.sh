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
server ntp.neel.ch prefer iburst
server ntp-p1.obspm.fr iburst
server chronos.cru.fr iburst
server canon.inria.fr iburst

# Record the rate at which the system clock gains/losses time.
driftfile /var/lib/chrony/drift

# Enable kernel RTC synchronization.
rtcsync

# Allow step on any clock update if offset is larger than 1 second.
makestep 1 -1

# Deny NTP client requests.
deny all

# Listen for commands only on localhost.
bindcmdaddress 127.0.0.1
bindcmdaddress ::1

# Disable logging of client accesses.
noclientlog

# Send a message to syslog if a clock adjustment is larger than 0.1 seconds.
logchange 0.1
EOF
