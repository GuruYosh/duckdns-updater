# duckdns-updater

Actualiza IP de la WAN en [duckdns.org](https://www.duckdns.org/) sólo si es necesario.

- Verifica IP actual en el DNS en alguno de los DNS públicos de duckdns.org
    - ns1.duckdns.org ... ns6.duckdns.org
- Verifica IP pública de la WAN con una petición aleatoria a uno de los siguientes servidores:
    - ifconfig.me
    - ifconfig.co
    - icanhazip.com
    - ipecho.net/plain
    - ipinfo.io/ip
- __Sólo si IP del DNS y la IP de la WAN son diferentes se actualiza la IP para el dominio en duckdns.org__
- Después de actualizar la IP espera unos segundos para verificar que se ha actualizado.









