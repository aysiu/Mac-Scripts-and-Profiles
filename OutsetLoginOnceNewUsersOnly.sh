#!/bin/bash

# To be used in conjunction with Outset: https://github.com/chilcote/outset
# Allows a login-once script to apply to only new users and not existing users

# Name of Outset script
OUTSET_SCRIPT='ChromeDefaultBrowser.sh'

# Modified from Elliot Jordan's template for a dock outset login-once
# https://macadmins.slack.com/files/elliotjordan/F43LVD8HL/preinstall.txt

# Get list of active users
# From https://www.jamf.com/jamf-nation/discussions/3736/dscl-command-to-list-local-users-but-exclude-system-accounts#responseChild17416
USER_LIST=$(dscl /Local/Default -list /Users uid | awk '$2 >= 100 && $0 !~ /^_/ { print $1 }')

# Loop through list of users
for THIS_USER in $USER_LIST; do

   # Determine the user home directory
   USER_HOME=$(dscl . -read "/Users/$THIS_USER" NFSHomeDirectory | awk '{print $2}')

   # Define the .plist location based on the home directory
   ONCE_PLIST="$USER_HOME/Library/Preferences/com.github.outset.once.plist"

   # Change the .plist to add in a fake instance of the outset script with right now's date/time
   sudo defaults write "$ONCE_PLIST" "/usr/local/outset/login-once/$OUTSET_SCRIPT" -date "$(date)"
   
   # Change ownership back to the original owner
   sudo chown "$THIS_USER" "$ONCE_PLIST"
   
   # change the permission back to original permissions, in case those got modified
   sudo chmod 600 "$ONCE_PLIST"

# End looping through list of users
done
