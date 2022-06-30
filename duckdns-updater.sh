#!/bin/bash

## ACTUALIZADOR DE IP EN DUCKDNS.ORG
##
## Es necesario tener disponible el comando dig para resolver peticiones de dominio 
## Es necesario tener disponible el comando curl para transferir datos a través del protocolo https 


domain="DOMINIO"
token="T-O-K-E-N"
logfile="duckdns.log"
timewait=10

## Lista de servidores para preguntar IP WAN
server_ip=("ifconfig.me" "ifconfig.co" "icanhazip.com" "ipecho.net/plain" "ipinfo.io/ip")
rand_server=$(($RANDOM % ${#server_ip[@]}))

## Elección de servidor DNS al que preguntar
dnsserver=$(echo "ns$(( 1 + $RANDOM % 6)).duckdns.org")
ip_dns="$(dig @"$dnsserver" "$domain".duckdns.org +short)"

## IP WAN
ip="$(curl -s ${server_ip[$rand_server]})"

## Resultado de la operación de actualización de IP en duckdns
result="NO"

if [ "$ip" != "$ip_dns" ];
then
        result="$(curl -s "https://www.duckdns.org/update?domains=$domain&token=$token&ip=")"
        fecha=$(date +"%F %T")
        echo $fecha  ${server_ip[$rand_server]} $dnsserver $ip_dns $ip $result >> $logfile

        sleep $timewait

        ip_nueva="$(dig @"$dnsserver" "$domain".duckdns.org +short)"

        if [ "$ip_nueva" != "$ip" ] && [ $result = "OK" ];
        then
                fecha=$(date +"%F %T")
                echo $fecha "Error: "$ip" no actualizada correctamente" >> $logfile
        fi
fi
