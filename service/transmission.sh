#!/bin/sh
service transmission-daemon stop
exec sudo -u debian-transmission transmission-daemon --log-debug --config-dir /etc/transmission-daemon --logfile /var/log/transmission.log
sleep 2
