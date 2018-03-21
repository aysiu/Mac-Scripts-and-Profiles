#!/bin/bash

# To be used in conjunction with Outset: https://github.com/chilcote/outset
# Allows a login-once script to apply to only new users and not existing users

# Name of Outset script
OUTSET_SCRIPT='ChromeDefaultBrowser.sh'

# Modified from Elliot Jordan's template for a dock outset login-once
# https://macadmins.slack.com/files/elliotjordan/F43LVD8HL/preinstall.txt

# Get list of active users
# From https://www.jamf.com/jamf-nation/discussions/3736/dscl-command-to-list-local-users-but-exclude-system-accounts#responseChild17416
USER_LIST=$(/usr/bin/dscl /Local/Default -list /Users uid | /usr/bin/awk '$2 >= 100 && $0 !~ /^_/ { print $1 }')

# Loop through list of users
for THIS_USER in $USER_LIST; do

   # Determine the user home directory
   USER_HOME=$(/usr/bin/dscl . -read "/Users/$THIS_USER" NFSHomeDirectory | /usr/bin/awk '{print $2}')

   # Define the .plist location based on the home directory
   ONCE_PLIST="$USER_HOME/Library/Preferences/com.github.outset.once.plist"

   # Change the .plist to add in a fake instance of the outset script with right now's date/time
   /usr/bin/defaults write "$ONCE_PLIST" "/usr/local/outset/login-once/$OUTSET_SCRIPT" -date "$(date)"
   
   # Change ownership back to the original owner
   /usr/sbin/chown "$THIS_USER" "$ONCE_PLIST"
   
   # change the permission back to original permissions, in case those got modified
   /bin/chmod 600 "$ONCE_PLIST"

# End looping through list of users
done
