#!/bin/bash

## Script that runs at login screen to check if FileVault encryption is enabled. If not, it adds a login script to launch up FileVault in System Preferences
# Requires Outset: https://github.com/chilcote/outset/
# Requires Offset: https://github.com/aysiu/offset

# Define name of openfilevault script
scriptName='openfilevault.sh'

# Define location of outset login directory
outsetDir='/usr/local/outset/login-every/'

# Check the FileVault Status
filevaultOff=$(sudo fdesetup status | grep "FileVault is Off")

# If it's not on (or even in progress), then 
if [ ! -z "$filevaultOff" ]; then

   # Make sure the outset login directory exists but the script doesn't already exist
   if [ -d "$outsetDir" ] && [ ! -f "$outsetDir"/"$scriptName" ]; then

      # Create an outset login script
      sudo echo '#!/bin/bash' >> "$outsetDir"/"$scriptName"
      sudo echo '/usr/bin/osascript <<-EOF' >> "$outsetDir"/"$scriptName"
      sudo echo 'tell application "System Preferences"' >> "$outsetDir"/"$scriptName"
      sudo echo 'activate' >> "$outsetDir"/"$scriptName"
      sudo echo 'reveal anchor "FDE" of pane id "com.apple.preference.security"' >> "$outsetDir"/"$scriptName"
      sudo echo 'end tell' >> "$outsetDir"/"$scriptName"
      sudo echo 'EOF' >> "$outsetDir"/"$scriptName"
      # Make sure the permissions are correct
      sudo chmod 755 "$outsetDir"/"$scriptName"
   
   fi

else
   # If it's on, delete the script
   if [ -f "$outsetDir"/"$scriptName" ]; then
      sudo rm "$outsetDir"/"$scriptName"
   fi

fi
