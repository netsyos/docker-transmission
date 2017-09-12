#!/bin/sh
exec sudo -u couchpotato python /opt/couchpotato/CouchPotato.py --config_file=/etc/couchpotato/config.ini --data_dir=/var/couchpotato
sleep 2
