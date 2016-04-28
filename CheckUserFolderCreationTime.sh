#!/bin/bash

##################################################
##################################################
## Define threshold in minutes (must be an integer--recommended less than 700 minutes)
threshold=2

##################################################
##################################################

# Check that the threshold is in an integer, since it's user-defined
if [[ "$threshold" =~ ^[0-9]+$ ]];then 
	echo -e "\nThreshold is $threshold minutes ago\n"

	# Get the current user's home directory
	currentUser=$(/bin/ls -l /dev/console | /usr/bin/awk '/ / { print $3 }')
	echo -e "Current user is $currentUser\n"

   # Get path of the user's Dock
   # By default (unless the sys admin has modified the User Template, in which case, why even have a login-once script?)
   # there is no com.apple.dock.plist, so we're checking to see if it doesn't exist (good) or if it's been created only within
   # the threshold period (also good)
   currentUserDock="/Users/$currentUser/Library/Preferences/com.apple.dock.plist"
   
   if [ -f "$currentUserDock" ]; then

      echo -e "User Dock exists\n"

   	# Get the creation date (in UNIX timestamp) of the current user dock
		dockCreationTimestamp=$(/usr/bin/stat -f%B "$currentUserDock")
		echo -e "Dock was created $dockCreationTimestamp\n"
	
		# Get today's date from [threshold] minutes ago into a UNIX timestamp
		thresholdTimestamp=$(/bin/date -j -v -"$threshold"M +%s)
		echo -e "$threshold minutes ago is $thresholdTimestamp\n"
		
		# Check to see if the folder was created in the last [threshold] minutes
		if [ "$dockCreationTimestamp" -gt "$thresholdTimestamp" ]; then
			echo -e "The user Dock was created within the last $threshold minutes\n"

		else
			echo -e "The user Dock was created more than $threshold minutes ago\n"

		fi

   else
      echo -e "There is no user Dock (which means the user just logged in and this script somehow ran before the Dock could be created)\n"

	# End checking the user dock exists	
	fi

else
	echo -e "\nThe threshold is not an integer\n"

# End checking whether the threshold is an integer or not
fi
