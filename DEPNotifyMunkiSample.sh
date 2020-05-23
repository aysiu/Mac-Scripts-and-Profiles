#!/bin/zsh

# This is just a very basic sample just so show how DEPNotify might work. The script should be run as root.
dep_log=/var/tmp/depnotify.log

# Get the currently logged in user.
currentUser=$(/usr/bin/stat -f "%Su" /dev/console)

# Make sure the Munki log exists. First, say what the location is.
munki_log=/Library/Managed\ Installs/Logs/ManagedSoftwareUpdate.log

# If the Munki log doesn't exist, create an empty file for it to start with.
if [[ ! -f $munki_log ]]; then
    /usr/bin/touch $munki_log
fi

# Since this is running as root, run the DEPNotify process as the currently logged in user instead
/usr/bin/sudo -u $currentUser /usr/bin/open -a /Applications/DEPNotify.app/Contents/MacOS/DEPNotify --args -munki -fullScreen

# Run a background run of Munki
/usr/local/munki/managedsoftwareupdate --auto

# Quit DEPNotify
/bin/echo "Command: Quit" >> $dep_log
