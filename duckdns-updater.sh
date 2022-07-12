#!/bin/bash

## ACTUALIZADOR DE IP EN DUCKDNS.ORG
##
## Es necesario tener disponible el comando dig para resolver peticiones de dominio 
## Es necesario tener disponible el comando curl para transferir datos a través del protocolo https 


domain="DOMINIO"
token="T-O-K-E-N"
logfile="/var/log/duckdns.log"    # Lugar recomendado, El usuario que lanza el script debe tener permisos de escritura en el fichero
timewait=10

error=0

# Función para loguear información en el fichero logfile proporcionado

function loguear {
	echo $(date +"%F %T") $1 >> $logfile
}

# Función para validar IP obtenida

function isValidIpAddr() {
    # return code only version
	# https://stackoverflow.com/questions/13777387/check-for-ip-validity/
    # Autor: zpangwin & shannonman & Mitch Frazier

    local ipaddr="$1";
    [[ ! $ipaddr =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]] && return 1;
    for quad in $(echo "${ipaddr//./ }"); do
        (( $quad >= 0 && $quad <= 255 )) && continue;
        return 1;
    done
}

# Comandos necesarios para poder ejecutar el script

if ! [ $(which dig) ] || ! [ $(which curl) ]; then
	loguear "Los comandos dig y curl deben estar instalados en el sistema"
	exit 1
fi

# Servidores para obtener la IP (WAN)

server_ip=("ifconfig.me" "ifconfig.co" "icanhazip.com" "ipecho.net/plain" "ipinfo.io/ip")
rand_server=$(($RANDOM % ${#server_ip[@]}))

# Obtenemos IP de la WAN

ip="$(curl -s ${server_ip[$rand_server]})"

isValidIpAddr $ip

error=$(( $error + $? ))

# DNS de duckdns

dnsserver=$(echo "ns$(( 1 + $RANDOM % 6)).duckdns.org")

# Obtenemos IP del DNS

ip_dns="$(dig @"$dnsserver" "$domain".duckdns.org +short)"

isValidIpAddr $ip_dns

error=$(( $error + $? ))

if [ $error -ne 0 ];
then
	loguear "Error al obtener IP @(${server_ip[$rand_server]} $dnsserver): $ip $ip_dns"
	exit 2
fi

result="NO"

if [ "$ip" != "$ip_dns" ];
then
	# Actualizamos IP en servidor DNS de duckdns

	result="$(curl -s "https://www.duckdns.org/update?domains=$domain&token=$token&ip=")"

	loguear "${server_ip[$rand_server]} $dnsserver $ip_dns $ip $result"

	sleep $timewait

	# Obtenemos nuevamente la IP del DNS para ver si ha cambiado correctamente

	ip_nueva="$(dig @"$dnsserver" "$domain".duckdns.org +short)"

	isValidIpAddr $ip_nueva

	error=$(( $error + $? ))

	if [ "$ip_nueva" != "$ip" ] && [ $result = "OK" ] && [ $error -eq 0 ];
	then
        loguear "Error IP ($ip) no actualizada correctamente"
		exit 3
	else 
		if [ "$ip_nueva" != "$ip" ] && [ $result = "OK" ] && [ $error -ne 0 ];
		then
			loguear "Error al obtener IP @($dnsserver): $ip_nueva"
			exit 4
		fi
	fi
fi
