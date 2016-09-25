Debian 8 post-installation script
=================================
this is post-installation script for setting up Debian 8 hosted at OVH. General purpose of the script is to setup tor relay, local DNS, firewall and public NTP server.

Usage
-----
````
apt-get -y install git
git clone https://github.com/d0xkb/debian.git
cd debian && chmod +x run.sh
./run.sh
````

License
-----
WTFPL v2.0
