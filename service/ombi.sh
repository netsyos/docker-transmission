#!/bin/sh
umask 022
cd /opt/ombi || exit

exec sudo -u ombi mono Ombi.exe
sleep 2
