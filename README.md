# plex-db-speedup for Plexguide Docker install
Cleans up Plex databases and increases PRAGMA setting to improve use of large remote video storage

Instructions: Enter the following from whatever directory you choose.
I recommend starting from the /opt/appdata/plex/scripts directory, but your choice.

Note: sqlite installation is rquired. Script checks for and installs sqlite if not installed, but be aware it will either have to be installed previously or will be installed during the script execution.

git clone https://github.com/timekills/plex-db-speedup.git

cd plex-db-speedup

chmod a+x plexdbfix.sh

./plexdbfix.sh 
