#!/bin/bash

# Get the last user
lastUserName=$(/usr/bin/defaults read /Library/Preferences/com.apple.loginwindow lastUserName)

# Remove the keychains for that user
/bin/rm -rf /Users/"$lastUserName"/Library/Keychains/*
/bin/rm -rf /Users/"$lastUserName"/Library/Keychains/.f*

# Add to log file
/bin/echo "$(/bin/date) - Keychain deleted for $lastUserName" >> /Library/Logs/RemoveKeychains.log
