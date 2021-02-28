#!/bin/bash

if [[ $USER != 'root' ]]; then
	echo "Maaf, Anda harus menjalankan ini sebagai root"
	exit
fi
clear
echo -e "\n " >> /etc/openvpn/akun.conf

MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";
echo ""
read -p "Isikan Client User: " username
egrep "^$username" /etc/openvpn/akun.conf >/dev/null
if [ $? -eq 0 ]; then
	echo "Username [$username] is available , try another Username!"
	exit 1
else
read -p "Isikan password [$username]: " password
read -p "Berapa hari account [$username] aktif: " AKTIF

today="$(date +"%Y-%m-%d")"
expire=$(date -d "$AKTIF days" +"%Y-%m-%d")
useradd -M -N -s /bin/false -e $expire $username
echo $username:$password | chpasswd

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
Aktif s/d : $(date -d "$AKTIF days" +"%d-%m-%Y")
=================================
Config    :  /root/$username.ovpn
EOF
