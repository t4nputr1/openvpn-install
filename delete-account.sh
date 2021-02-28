#!/bin/bash

if [[ $USER != 'root' ]]; then
	echo "Maaf, Anda harus menjalankan ini sebagai root"
	exit
fi
clear

NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/openvpn/akun.conf")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		echo ""
		echo "You have no existing clients!"
		exit 1
	fi
echo ""
echo "Input the existing client you want to revoke"
echo "-----------------------------------"
echo "NO  -  USERNAME   -   EXP DATE     "
echo "-----------------------------------"
grep -E "^### " "/etc/openvpn/akun.conf" | cut -d ' ' -f 2-3 | nl -s ') '
read -p "Enter username to delete: " username

# match the selected number to a client name
CLIENT_NAME=$(grep -E "^### " "/etc/openvpn/akun.conf" | cut -d ' ' -f 2-3 | sed -n "${CLIENT_NUMBER}"p)
user=$(grep -E "^### " "/etc/openvpn/akun.conf" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
sed -i "/^### $CLIENT_NAME\$/,/^$/d" "/etc/openvpn/akun.conf"

cd /etc/openvpn/easy-rsa/ || return; ./easyrsa --batch revoke "$username"; EASYRSA_CRL_DAYS=3650 ./easyrsa gen-crl; rm -f /etc/openvpn/crl.pem; cp /etc/openvpn/easy-rsa/pki/crl.pem /etc/openvpn/crl.pem; chmod 644 /etc/openvpn/crl.pem; find /home/ -maxdepth 2 -name "$username.ovpn" -delete; rm -f "/root/$username.ovpn"; sed -i "/^$username,.*/d" /etc/openvpn/ipp.txt;
service openvpn restart
echo ""
echo " Succesfully to Delete $username "
