#!/bin/bash

if [[ $USER != 'root' ]]; then
	echo "Maaf, Anda harus menjalankan ini sebagai root"
	exit
fi
clear
echo -e "\n " >> /etc/openvpn/akun.conf

MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";

echo "Masukkan Nama User"
read -rp "User: " -e username
CLIENT_EXISTS=$(grep -c -E "^### $username\$" "/etc/openvpn/akun.conf")
read -p "Isikan password [$username]: " password
read -p "Berapa hari account [$username] aktif: " AKTIF
sleep 2
today="$(date +"%Y-%m-%d")"
expire=$(date -d "$AKTIF days" +"%Y-%m-%d")
echo -e "\n### $username $(date -d "$AKTIF days" +"%d-%m-%Y")">>"/etc/openvpn/akun.conf"

export MENU_OPTION="1"; export CLIENT="$username"; export PASS="$password"; bash openvpn-install.sh &> /dev/null;

clear

echo "
=================================
      DETAIL AKUN OPENVPN
---------------------------------
Host/IP   : $MYIP
Username  : $username
Password  : $password
Port      : 443
Aktif s/d : $(date -d "$AKTIF days" +"%d-%m-%Y")
=================================
Config    :  /root/$username.ovpn"
