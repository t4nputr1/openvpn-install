#!/bin/bash

if [[ $USER != 'root' ]]; then
	echo "Maaf, Anda harus menjalankan ini sebagai root"
	exit
fi
clear

echo "-----------------------------------"
echo "USERNAME              EXP DATE     "
echo "-----------------------------------"

while read expired
do
	AKUN="$(echo $expired | cut -d: -f1)"
	ID="$(echo $expired | grep -v nobody | cut -d: -f3)"
	exp="$(chage -l $AKUN | grep "Account expires" | awk -F": " '{print $2}')"
	if [[ $ID -ge 1000 ]]; then
		printf "%-21s %2s\n" "$AKUN" "$exp"
	fi
done < /etc/openvpn/akun.conf
echo "-----------------------------------"
read -p "Enter username to delete: " username

egrep "^$username" /etc/openvpn/akun.conf >/dev/null

cd /etc/openvpn/easy-rsa/ || return; ./easyrsa --batch revoke "$username"; EASYRSA_CRL_DAYS=3650 ./easyrsa gen-crl; rm -f /etc/openvpn/crl.pem; cp /etc/openvpn/easy-rsa/pki/crl.pem /etc/openvpn/crl.pem; chmod 644 /etc/openvpn/crl.pem; find /home/ -maxdepth 2 -name "$username.ovpn" -delete; rm -f "/root/$username.ovpn"; sed -i "/^$username,.*/d" /etc/openvpn/ipp.txt; /dev/null;
service openvpn restart
clear
echo " Succesfully to Delete $username "
