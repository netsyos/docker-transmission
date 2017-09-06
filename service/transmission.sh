#!/bin/sh
exec sudo -u debian-transmission -g debian-transmission /usr/bin/transmission-daemon -f --log-debug --config-dir /etc/transmission-daemon/ --logfile /var/log/transmission.log
sleep 2
