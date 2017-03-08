#!/bin/bash

## Just in case you're copying folders over as root and the ownership of folders changes, this script will change the ownership back,
## assuming that the short name is the same as the user folder name, which it usually is

# Get list of active users
# From https://www.jamf.com/jamf-nation/discussions/3736/dscl-command-to-list-local-users-but-exclude-system-accounts#responseChild17416
USER_LIST=$(dscl /Local/Default -list /Users uid | awk '$2 >= 100 && $0 !~ /^_/ { print $1 }')

# Loop through list of users
for THIS_USER in $USER_LIST; do

   # Determine the user home directory
   USER_HOME=$(dscl . -read "/Users/$THIS_USER" NFSHomeDirectory | awk '{print $2}')

   # Change ownership back to the original owner
   sudo chown -R "$THIS_USER" "$USER_HOME"

# End looping through list of users
done
