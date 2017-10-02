#!/bin/sh
umask 022
cd /opt/NzbDrone || exit
exec mono --debug NzbDrone.exe -terminateexisting -nobrowser -data=/var/sonarr
sleep 2
