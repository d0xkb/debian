Debian setup script for Tor relay
=================================

this is post-installation script for setting up Debian 8 (Jessie) hosted at OVH. General purpose of the script is to setup Tor non-exit relay, local DNS, firewall and NTP client.

Usage
-----
````
apt-get -y install git
git clone https://github.com/d0xkb/debian.git
cd debian
./run.sh
````

License
-----
WTFPL v2.0
