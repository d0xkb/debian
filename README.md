Debian setup script for Tor relay
=================================

this is personalized post-installation script for setting up Debian 8 (Jessie) hosted at OVH. General purpose of the script is to setup Tor non-exit relay, local DNS, firewall and NTP client.

Usage
-----
````
cd $(mktemp -d)
wget https://github.com/d0xkb/debian/archive/master.zip
unzip master.zip && cd debian-master
bash run.sh
````

License
-----
WTFPL v2.0
