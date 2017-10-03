#!/bin/sh
umask 022
cd /var/ombi || exit

exec sudo -u ombi mono /opt/ombi/Ombi.exe
sleep 2
