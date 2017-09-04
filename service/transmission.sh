#!/bin/sh
service transmission-daemon stop
pkill -9 -f transmission
exec transmission-daemon --config-dir /etc/transmission-daemon --logfile /var/log/transmission.log
