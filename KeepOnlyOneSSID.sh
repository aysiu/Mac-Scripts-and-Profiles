#!/bin/bash

# Define the SSID to keep
permanentSSID='NAMEOFSSIDYOUWANTTOKEEP'

# Find the wireless network hardware port name
# Code to get next line after "Wi-Fi" is from http://superuser.com/a/298125
# Code to get only the text after "Device: " is from http://unix.stackexchange.com/a/24151
wifiport=$(/usr/sbin/networksetup -listallhardwareports | /usr/bin/grep -A1 "Wi-Fi" | /usr/bin/sed -n -e 's/^.*Device: //p')

# If it's not empty...
if [ ! -z "$wifiport" ]; then 

	# Find all the preferred networks
	oldpreferred=$(/usr/sbin/networksetup -listpreferredwirelessnetworks "$wifiport")

	# Loop through the preferred networks
	while read line; do
		if [[ "${line}" != "Preferred networks on en0:" && "${line}" != "$permanentSSID" ]]; then
				# Remove it from the preferred wireless networks
				/usr/sbin/networksetup -removepreferredwirelessnetwork "$wifiport" "${line}"
				# Also delete it from the system keychain
				/usr/bin/security delete-generic-password -a "${line}"
		fi
	done < <(/bin/echo "$oldpreferred")

# End checking for wifi interface
fi
