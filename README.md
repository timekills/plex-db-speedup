# plex-db-speedup for Plexguide Docker install
Cleans up Plex databases and increases PRAGMA setting to improve use of large remote video storage

# Update 13 JAN 18: When I ran this recently it appeared to cause some corruption in the latest/current Plex edition. BACK UP YOUR DATABASE before using until further testing is completed!

Note: sqlite installation is required. Script checks for and installs sqlite if not installed, but be aware it will either have to be installed previously or will be installed during the script execution.

You may notice a few errors the first time it is run reference "Error: no such collation sequence: naturalsort" That is okay; it is fixed during the DB clean-up portion and the next time it is run you shouldn't see those errors again.



Instructions: Enter the following from whatever directory you choose.
I recommend starting from the /opt/appdata/plex/scripts directory, but your choice.

git clone https://github.com/timekills/plex-db-speedup.git

cd plex-db-speedup

chmod a+x plexdbfix.sh

./plexdbfix.sh 
