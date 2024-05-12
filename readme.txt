May 9, 2024
This seems to build and start a zabbix container that also has mdns.
I haven't tested it as zabbix yet, but container start and mdns works.
now i'll try to move it into docker-compose to see zabbix work along the ui and db. then see if mdsn w/in zabbix works.

docker build -t entrypoint-demo:latest .
docker run --network host -it entrypoint-demo:latest
turns out if host and container are running avahi w/ refector on, then i don't need the --network host

docker build -t mdns-zabbix-ext:latest -f MdnsDockerfile .
docker-compose -f mdns-docker-compose.yml up

#standalone server for troubleshooting
docker run -d --name zabbix-server-pgsql   --network zabbix-net   -p 10051:10051   -e DB_SERVER_HOST=zabbix-postgres-server   -e POSTGRES_USER=zabbix   -e POSTGRES_PASSWORD=saltzabbix80time   -e POSTGRES_DB=zabbix   -e ZBX_ENABLE_SNMP_TRAPS=true   --restart unless-stopped   mdns-zabbix-ext:latest

docker network create zabbix-net --driver bridge --subnet 172.20.0.0/16

docker-compose -f mdns-docker-compose.yml up --remove-orphans

docker-compose -f mdns-docker-compose.yml up --force-recreate

Success ???? I hope!

bwilly@salt-r420:~/docker-test$ docker exec -it 9adcb2e2480b bash
9adcb2e2480b:/var/lib/zabbix# ps aux
PID   USER     TIME  COMMAND
    1 root      0:00 /sbin/tini -- /usr/bin/docker-entrypoint.sh /usr/sbin/zabbix_server --foreground -c /etc/zabbix
   11 messageb  0:00 dbus-daemon --system
   14 root      0:00 avahi-daemon: running [9adcb2e2480b.local]
   15 root      0:00 tail -f /dev/null
   16 root      0:00 /usr/sbin/zabbix_server --foreground -c /etc/zabbix/zabbix_server.conf


=======================

docker build -t ubuntu-mdns-zabbix-ext:latest -f MdnsDockerfile .


