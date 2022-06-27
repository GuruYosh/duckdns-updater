#!/bin/bash

domain="DOMINIO"
token="T-O-K-E-N"
logfile="duckdns.log"

server_ip=("ifconfig.me" "ifconfig.co" "icanhazip.com" "http://ipecho.net/plain")
rand_server=$(($RANDOM % ${#server_ip[@]}))

dnsserver=$(echo "ns$(( 1 + $RANDOM % 6)).duckdns.org")
ip_dns="$(dig @"$dnsserver" "$domain".duckdns.org +short)"

ip="$(curl -s ${server_ip[$rand_server]})"

result="NO"

if [ "$ip" != "$ip_dns" ];
then
	result="$(curl -s "https://www.duckdns.org/update?domains=$domain&token=$token&ip=")"
	fecha=$(date +"%F %T")
	echo $fecha  ${server_ip[$rand_server]} $dnsserver $ip_dns $ip $result >> $logfile

	sleep 10
	
	ip_nueva="$(dig @"$dnsserver" "$domain".duckdns.org +short)"

	if [ "$ip_nueva" != "$ip" ] && [ $result = "OK" ]; 
	then
			echo "Error: $ip no actualizada correctamente" >> $logfile
	fi
fi