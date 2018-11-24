# plex-db-speedup for Plexguide Docker install
Cleans up Plex databases and increases PRAGMA setting to improve use of large remote video storage

Instructions: Enter the following from whatever directory you choose.
I recommend starting from the /opt/appdata/plex/scripts directory

git clone https://github.com/timekills/plex-db-speedup.git

cd plex-db-speedup

chmod a+x plexdbfix.sh

./plexdbfix.sh 
