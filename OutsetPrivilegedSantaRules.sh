#!/bin/bash

# This is a login-privileged-every script for Outset that configures Santa to block (after login) certain apps, depending
# on what user they are. Since all Apple software is whitelisted by default by certificate, in order to block these apps,
# you have to block based on binary hash instead. Since Apple software will update over time, keeping a static list of
# hashes isn't helpful. So this calculates the hash based on what versions are currently installed.

# User not to block apps for
safe_user='USERNOTTOBLOCKAPPSFOR'

# Array of offending apps to get hashes for
apps_to_block=(
	"/Applications/App Store.app"
	"/Applications/FaceTime.app"
	"/Applications/Mail.app"
	"/Applications/Maps.app"
	"/Applications/Messages.app"
	"/Applications/Safari.app"
	"/Applications/Siri.app"
)

# Get current user
current_user=$(/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }')

# Loop through each of the apps to block
for app_to_block in "${apps_to_block[@]}"
	do
		# Check that the path actually exists
		if [[ -a "$app_to_block" ]]; then
			# If it exists, get the offending hash
			offending_hash=$(/usr/local/bin/santactl fileinfo "$app_to_block" --key SHA-256)
			
			# Put in rule
			if [[ "$current_user" == "$safe_user" ]]; then
				# Allow this
				/usr/local/bin/santactl rule --whitelist --sha256 "$offending_hash" 
			else
				# Block this
				/usr/local/bin/santactl rule --blacklist --sha256 "$offending_hash" 
			fi
		fi
done
