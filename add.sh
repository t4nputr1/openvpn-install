#!/bin/bash

if [[ $USER != 'root' ]]; then
	echo "Maaf, Anda harus menjalankan ini sebagai root"
	exit
fi
clear

# get the VPS IP
#ip=`ifconfig venet0:0 | grep 'inet addr' | awk {'print $2'} | sed s/.*://`
MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;
#MYIP=$(ifconfig | grep 'inet addr:' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d: -f2 | awk '{ print $1}' | head -1)
if [ "$MYIP" = "" ]; then
	MYIP=$(wget -qO- ipv4.icanhazip.com)
fi
#MYIP=$(wget -qO- ipv4.icanhazip.com)
clear
echo ""
read -p "Isikan Client User: " username
read -p "Isikan password akun [$username]: " password
read -p "Berapa hari akun [$username] aktif: " masa_aktif

today=`date +%s`
masa_aktif_detik=$(( $masa_aktif * 86400 ))
saat_expired=$(($today + $masa_aktif_detik))
tanggal_expired=$(date -u --date="1970-01-01 $saat_expired sec GMT" +%Y/%m/%d)
tanggal_expired_display=$(date -u --date="1970-01-01 $saat_expired sec GMT" '+%d %B %Y')

export MENU_OPTION="1"; export CLIENT="$username"; export PASS="$password"; bash /root/openvpn-install.sh &> /dev/null;

mv $username.ovpn /etc/openvpn/client
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
