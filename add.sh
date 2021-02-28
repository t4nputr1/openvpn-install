#!/bin/bash

if [[ $USER != 'root' ]]; then
	echo "Maaf, Anda harus menjalankan ini sebagai root"
	exit
fi
clear

MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";
echo ""
read -p "Isikan Client User: " username
read -p "Isikan password [$username]: " password
read -p "Berapa hari akun [$username] aktif: " masa_aktif

today=`date +%s`
masa_aktif_detik=$(( $masa_aktif * 86400 ))
saat_expired=$(($today + $masa_aktif_detik))
tanggal_expired=$(date -u --date="1970-01-01 $saat_expired sec GMT" +%Y/%m/%d)
tanggal_expired_display=$(date -u --date="1970-01-01 $saat_expired sec GMT" '+%d %B %Y')

export MENU_OPTION="1"; export CLIENT="$username"; export PASS="$password"; bash openvpn-install.sh &> /dev/null;

clear

cat <<EOF
=================================
      DETAIL AKUN OPENVPN
---------------------------------
Host/IP   : $MYIP
Username  : $username
Password  : $password
Port      : 443
Aktif s/d : $tanggal_expired_display
=================================
Config    :  /root/$username.ovpn
EOF
