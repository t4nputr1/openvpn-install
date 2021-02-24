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

echo "================================="
echo "DETAIL AKUN OPENVPN "
echo "---------------------------------"
echo "Server IP    : $MYIP"
echo "Username     : $username"
echo "Password     : $password"
echo "Aktif Sampai : $tanggal_expired_display"
echo "Config       : http://MYIP:81/client/$username.ovpn"
echo "================================="
