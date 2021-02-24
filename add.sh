#!/bin/bash

if [[ $USER != 'root' ]]; then
	echo "Maaf, Anda harus menjalankan ini sebagai root"
	exit
fi
clear

MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";

read -p "Isikan Client User: " username
read -p "Isikan password akun [$username]: " password
read -p "Berapa hari akun [$username] aktif: " masa_aktif

today=`date +%s`
masa_aktif_detik=$(( $masa_aktif * 86400 ))
saat_expired=$(($today + $masa_aktif_detik))
tanggal_expired=$(date -u --date="1970-01-01 $saat_expired sec GMT" +%Y/%m/%d)
tanggal_expired_display=$(date -u --date="1970-01-01 $saat_expired sec GMT" '+%d %B %Y')

export MENU_OPTION="1"
export CLIENT="$username"
export PASS="$password"
./openvpn-install.sh

mv $username.ovpn /etc/openvpn/client
mkdir -p /home/vps/public_html/client
cp /etc/openvpn/client/$username.ovpn /home/vps/public_html/client
clear

cat <<EOF
=================================
DETAIL AKUN OPENVPN
---------------------------------
Server IP    : $MYIP
Username     : $username
Password     : $password
Aktif Sampai : $tanggal_expired_display
Config       : http://MYIP:81/client/$username.ovpn
=================================
EOF
