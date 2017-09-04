#!/bin/sh
service transmission-daemon stop
exec transmission-daemon --config-dir /etc/transmission-daemon --logfile /var/log/transmission.log
