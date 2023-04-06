# duckdns-updater

Update the WAN public IP in [duckdns.org](https://www.duckdns.org/) only if necessary.

- Check current IP in the DNS in one of the duckdns.org public DNS
    - ns1.duckdns.org ... ns9.duckdns.org
- Check WAN public IP with a random request to one of the following servers:
    - ifconfig.me
    - ifconfig.co
    - icanhazip.com
    - ipecho.net/plain
    - ipinfo.io/ip
    - api.ipify.org
- __Only if the IP resolved by the DNS and the WAN IP are different, the IP is updated at duckdns domain server__
- After updating the IP, wait a few seconds to verify that it has been updated successfully.

--------------

Actualiza IP de la WAN en [duckdns.org](https://www.duckdns.org/) sólo si es necesario.

- Verifica IP actual en el DNS en alguno de los DNS públicos de duckdns.org
    - ns1.duckdns.org ... ns9.duckdns.org
- Verifica IP pública de la WAN con una petición aleatoria a uno de los siguientes servidores:
    - ifconfig.me
    - ifconfig.co
    - icanhazip.com
    - ipecho.net/plain
    - ipinfo.io/ip
    - api.ipify.org
- __Sólo si la IP resuelta por el DNS y la IP de la WAN son diferentes se actualiza la IP para el dominio en duckdns.org__
- Después de actualizar la IP espera unos segundos para verificar que se ha actualizado.
