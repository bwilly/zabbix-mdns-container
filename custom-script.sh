#!/bin/bash
ls

#touch /var/log/docker-bwilly.log

# Test writing to /tmp/dbus_errors.log
echo "1. Testing log writing to /var/log/docker-bwilly.log" >>  /var/log/docker-bwilly.log

#mkdir -p /run/dbus
#mkdir -p /run/dbus && \
#dbus-daemon --system


# Create necessary directories
#mkdir -p /run/dbus
# Create necessary directories and ensure permissions are correct
mkdir -p /run/dbus /var/run/dbus

# Checking for a stale dbus PID file
if [ -f /run/dbus/dbus.pid ]; then
    # Read the PID from the file
    PID=$(cat /run/dbus/dbus.pid)
    
    # Check if this PID is actually still in use
    if ! ps -p $PID > /dev/null; then
        echo "DBus PID file is stale, removing..."
        rm -f /run/dbus/dbus.pid
    else
        echo "DBus is already running with PID $PID"
    fi
else
    echo "No PID file for DBus found."
fi


# Execute custom logging script
/mylog.sh

# Start dbus-daemon
dbus-daemon --system

# Start avahi-daemon
avahi-daemon --no-drop-root --daemonize --debug

# Tail /dev/null to keep the container running
tail -f /dev/null &

#/mylog.sh; dbus-daemon --system; avahi-daemon --no-drop-root --daemonize --debug; tail -f /dev/null


#sleep infinity

# Replace 'sleep infinity' with the line below to start Zabbix server
#exec "$@"
# Execute the parent image's ENTRYPOINT using tini
exec /usr/bin/tini -- /usr/bin/docker-entrypoint.sh "$@"
