#!/bin/bash

MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";
clear

read -p "Isikan Client User: " username
egrep "^$username" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
	echo "Client [$username] sudah ada!"
	exit 1
else
	read -p "Isikan password akun [$username]: " password
	read -p "Berapa hari akun [$username] aktif: " masa_aktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"

export MENU_OPTION="1"
export CLIENT="$username"
export PASS="$password"
./openvpn-install.sh

mv $username.ovpn /etc/openvpn/client
mkdir -p /home/vps/public_html/client
cp /etc/openvpn/client/$username.ovpn /home/vps/public_html/client
clear
echo "
=================================
DETAIL AKUN OPENVPN 
---------------------------------
Server IP    : $MYIP
Username     : $username
Password     : $password
Aktif Sampai : $exp
Config       : http://MYIP:81/client/$username.ovpn
================================="
echo ""
