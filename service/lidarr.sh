#!/bin/sh
umask 022
cd /app/lidarr || exit
exec mono --debug Lidarr.exe -terminateexisting -nobrowser -data=/var/lidarr
sleep 2
