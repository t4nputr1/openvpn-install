#!/bin/bash
# Created By M Fauzan Romandhoni 
# Sshinjector.net
# For Bussines E-Mail: m.fauzan58@yahoo.com
# TELP/WA : +6283875176829

if [[ $USER != 'root' ]]; then
	echo "Maaf, Anda harus menjalankan ini sebagai root"
	exit
fi
clear

MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";
# Squid
apt-get -y install squid3
wget -O /etc/squid/squid.conf https://raw.githubusercontent.com/t4nputr1/openvpn-install/master/squid.conf
sed -i "s/ipserver/$MYIP/g" /etc/squid/squid.conf
service squid restart
