#!/bin/sh
umask 022
cd /opt/jackett || exit
export XDG_CONFIG_HOME=/var/jackett
exec mono --debug JackettConsole.exe --NoRestart
sleep 2
