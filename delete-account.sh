#!/bin/bash

if [[ $USER != 'root' ]]; then
	echo "Maaf, Anda harus menjalankan ini sebagai root"
	exit
fi
clear

CLIENT_NAME=$(grep -c -E "^### " "/etc/openvpn/akun.conf")
echo "Input existing client you want to revoke"
grep -E "^### " "/etc/openvpn/akun.conf" | cut -d ' ' -f 2-3 | nl -s ') '
read -p "Enter username to delete: " username

egrep "^$username" /etc/openvpn/akun.conf >/dev/null

cd /etc/openvpn/easy-rsa/ || return; ./easyrsa --batch revoke "$username"; EASYRSA_CRL_DAYS=3650 ./easyrsa gen-crl; rm -f /etc/openvpn/crl.pem; cp /etc/openvpn/easy-rsa/pki/crl.pem /etc/openvpn/crl.pem; chmod 644 /etc/openvpn/crl.pem; find /home/ -maxdepth 2 -name "$username.ovpn" -delete; rm -f "/root/$username.ovpn"; sed -i "/^$username,.*/d" /etc/openvpn/ipp.txt; /dev/null;
service openvpn restart
clear
echo " Succesfully to Delete $username "
