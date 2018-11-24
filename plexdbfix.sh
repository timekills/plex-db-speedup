#!/bin/bash
#
######################################################################################################
# Cleans up Plex databases and increases PRAGMA setting to improve use of large remote video storage #
# 1. git clone https://github.com/timekills/plex-db-speedup.git                                      #
# 2. cd plex-db-speedup                                                                              #
# 3. chmod a+x plexdbfix.sh                                                                          #
# 4. ./plexdbfix.sh                                                                                 #
######################################################################################################

PLEX_DATABASE="/opt/appdata/plex/database/Library/Application Support/Plex Media Server/Plug-in Support/Databases/com.plexapp.plugins.library.db"
PLEX_DATABASE_BLOBS="/opt/appdata/plex/database/Library/Application Support/Plex Media Server/Plug-in Support/Databases/com.plexapp.plugins.library.blobs.db"
PLEX_DATABASE_TRAKT="/opt/appdata/plex/database/Library/Application Support/Plex Media Server/Plug-in Support/Databases/com.plexapp.plugins.trakttv.db"

SQLITE3="/usr/bin/sqlite3"
SQLDUMP="/tmp/dump.sql"
BACKUPDIR="/opt/appdata/plex/maintenance"

if [ ! -d "$BACKUPDIR" ] ; then
  mkdir /opt/appdata/plex/maintenance
fi

if [ ! -e "$SQLDUMP" ] ; then
  touch /tmp/dump.sql
fi

NO_FORMAT="\033[0m"
C_ORANGE1="\033[38;5;214m"
C_SPRINGGREEN3="\033[38;5;41m"
C_RED1="\033[38;5;196m"
C_YELLOW1="\033[38;5;226m"
C_DODGERBLUE1="\033[38;5;33m"
C_PURPLE="\033[38;5;129m"
echo -e "${C_RED1}Stopping Plex Docker Container${NO_FORMAT}"
docker stop plex
wait
echo -e "${C_PURPLE}Starting Maintenance${NO_FORMAT}"

#
rm $BACKUPDIR/*
rm $SQLDUMP
#
echo -e "${C_PURPLE}Copying Plex databases${NO_FORMAT}"
cp -f "$PLEX_DATABASE" "$BACKUPDIR/com.plexapp.plugins.library.db-$(date +"%Y-%m-%d")"
cp -f "$PLEX_DATABASE_BLOBS" "$BACKUPDIR/com.plexapp.plugins.library.blobs.db-$(date +"%Y-%m-%d")"
cp -f "$PLEX_DATABASE_TRAKT" "$BACKUPDIR/com.plexapp.plugins.trakttv.db-$(date +"%Y-%m-%d")"
#
echo -e "${C_PURPLE}PRAGMA optimize main database & cache size set to 500000${NO_FORMAT}"
$SQLITE3 "$PLEX_DATABASE" "PRAGMA optimize"
$SQLITE3 "$PLEX_DATABASE" vacuum
$SQLITE3 "$PLEX_DATABASE" .dump > "$SQLDUMP"
rm "$PLEX_DATABASE"
$SQLITE3 "$PLEX_DATABASE" < "$SQLDUMP"
$SQLITE3 -header -line "$PLEX_DATABASE" "PRAGMA default_cache_size = 500000"
$SQLITE3 "$PLEX_DATABASE" "PRAGMA optimize"
rm "$SQLDUMP"
#
echo -e "${C_PURPLE}PRAGMA optimize blob database${NO_FORMAT}"
$SQLITE3 "$PLEX_DATABASE_BLOBS" "PRAGMA optimize"
$SQLITE3 "$PLEX_DATABASE_BLOBS" vacuum
$SQLITE3 "$PLEX_DATABASE_BLOBS" .dump > "$SQLDUMP"
rm "$PLEX_DATABASE_BLOBS"
$SQLITE3 "$PLEX_DATABASE_BLOBS" < "$SQLDUMP"
$SQLITE3 "$PLEX_DATABASE_BLOBS" "PRAGMA optimize"
rm "$SQLDUMP"
#
echo -e "${C_PURPLE}PRAGMA optimize Trakt database${NO_FORMAT}"
$SQLITE3 "$PLEX_DATABASE_TRAKT" "PRAGMA optimize"
$SQLITE3 "$PLEX_DATABASE_TRAKT" vacuum
$SQLITE3 "$PLEX_DATABASE_TRAKT" .dump > "$SQLDUMP"
rm "$PLEX_DATABASE_TRAKT"
$SQLITE3 "$PLEX_DATABASE_TRAKT" < "$SQLDUMP"
$SQLITE3 "$PLEX_DATABASE_TRAKT" "PRAGMA optimize"
rm "$SQLDUMP"
chown -R root:root "/opt/appdata/plex/database/Library/Application Support/Plex Media Server/Plug-in Support/Databases/"
#
rm -rf "/opt/appdata/plex/database/Library/Application Support/Plex Media Server/Codecs/"*
#
echo 3 > /proc/sys/vm/drop_caches && swapoff -a && swapon -a
#
echo -e "${C_SPRINGGREEN3}Starting Plex Docker Container${NO_FORMAT}"
docker start plex
wait

#
echo -e "${C_PURPLE}Maintenance Finished${NO_FORMAT}!"
exit
