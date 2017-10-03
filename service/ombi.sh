#!/bin/sh
umask 022
cd /var/ombi || exit

if [ ! -f /var/ombi/Ombi.sqlite ]; then
  if [ -f /var/ombi/PlexRequests.sqlite ]; then # migrate existing db
    mv /var/ombi/PlexRequests.sqlite /var/ombi/Ombi.sqlite
  else
    sqlite3 Ombi.sqlite "create table aTable(field1 int); drop table aTable;" # create empty db
  fi
fi

# check for Backups folder in config
if [ ! -d /var/ombi/Backup ]; then
  echo "Creating Backup dir..."
  mkdir /var/ombi/Backup
fi

ln -s /var/ombi/Ombi.sqlite /opt/ombi/Ombi.sqlite
ln -s /var/ombi/Backup /opt/ombi/Backup

exec mono /opt/ombi/Ombi.exe
sleep 2
