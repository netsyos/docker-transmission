#!/bin/sh
umask 022
cd /opt/Radarr || exit
exec mono --debug Radarr.exe -terminateexisting -nobrowser -data=/var/radarr
sleep 2
