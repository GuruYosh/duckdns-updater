#!/bin/bash

## ACTUALIZADOR DE IP EN DUCKDNS.ORG
##
## Es necesario tener disponible el comando dig para resolver peticiones de dominio 
## Es necesario tener disponible el comando curl para transferir datos a través del protocolo https 


domain="DOMINIO"
token="T-O-K-E-N"
logfile="/var/log/duckdns.log"    # Lugar recomendado, El usuario que lanza el script debe tener permisos de escritura en el fichero
timewait=10

function loguear {
	echo $(date +"%F %T") $1 >> $logfile
}


if ! [ $(which dig) ] || ! [ $(which curl) ]; then
	loguear "Los comandos dig y curl deben estar instalados en el sistema"
	exit 1
fi


server_ip=("ifconfig.me" "ifconfig.co" "icanhazip.com" "ipecho.net/plain" "ipinfo.io/ip")
rand_server=$(($RANDOM % ${#server_ip[@]}))

dnsserver=$(echo "ns$(( 1 + $RANDOM % 6)).duckdns.org")
ip_dns="$(dig @"$dnsserver" "$domain".duckdns.org +short)"

ip="$(curl -s ${server_ip[$rand_server]})"

result="NO"

if [ "$ip" != "$ip_dns" ];
then
	result="$(curl -s "https://www.duckdns.org/update?domains=$domain&token=$token&ip=")"

	loguear "${server_ip[$rand_server]} $dnsserver $ip_dns $ip $result"

	sleep $timewait

	ip_nueva="$(dig @"$dnsserver" "$domain".duckdns.org +short)"
	
	if [ "$ip_nueva" != "$ip" ] && [ $result = "OK" ];
	then
        	loguear "Error $ip no actualizada correctamente"
		exit 1
	fi
fi
