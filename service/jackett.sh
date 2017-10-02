#!/bin/sh
umask 022
cd /opt/jackett || exit
exec mono --debug JackettConsole.exe --NoRestart -DataFolder=/data/jackett
sleep 2
