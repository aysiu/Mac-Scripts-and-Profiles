#!/bin/bash

# Get current date and time
currentDate=$(date +"%Y-%m-%dT%H:%M:%SZ")

# Write it back to the .plist
sudo /usr/bin/defaults write /Library/Preferences/com.barebones.textwrangler LastUpgradeAlertDate -date "$currentDate"
