#!/bin/bash
ls

#touch /var/log/docker-bwilly.log

# Test writing to /tmp/dbus_errors.log
echo "1. Testing log writing to /var/log/docker-bwilly.log" >>  /var/log/docker-bwilly.log

mkdir -p /run/dbus
#mkdir -p /run/dbus && \
#dbus-daemon --system


#sleep infinity
