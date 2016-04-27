#!/bin/bash

##################################################
##################################################
## Define threshold in minutes (must be an integer)
threshold=2

##################################################
##################################################

# Check that the threshold is in an integer, since it's user-defined
if [[ "$threshold" =~ ^[0-9]+$ ]];then 
	echo -e "\nThreshold is $threshold minutes ago\n"

	# Get the current user's home directory
	currentUser=$(/bin/ls -l /dev/console | /usr/bin/awk '/ / { print $3 }')
	echo -e "Current user is $currentUser\n"

	# Get the creation date of the current user's home directory
	homeDirectory="/Users/$currentUser"
	echo -e "Home directory is $homeDirectory\n"

	# Double-check that the home directory exists with that name (it should)
	if [ -d "$homeDirectory" ]; then
	
		# Get the creation time of the home directory
		homeCreationDate=$(/usr/bin/GetFileInfo -d "$homeDirectory")
		echo -e "Home was created $homeCreationDate\n"

		# Get it into a UNIX timestamp
		homeCreationTimestamp=$(/bin/date -j -f "%m/%d/%Y %T" "$homeCreationDate" +%s)
		echo -e "Home was created $homeCreationTimestamp\n"
	
		# Get today's date from [threshold] mintues ago into a UNIX timestamp
		thresholdTimestamp=$(/bin/date -j -v -"$threshold"M +%s)
		echo -e "$threshold minutes ago is $thresholdTimestamp\n"
		
		# Check to see if the folder was created in the last ten minutes
		if [ "$homeCreationTimestamp" -gt "$thresholdTimestamp" ]; then
			echo -e "This directory was just created in the last $threshold minutes\n"

		else
			echo -e "This directory was created more than $threshold minutes ago\n"

		fi

	# End checking the home directory exists	
	fi

else
	echo -e "\nThe threshold is not an integer\n"

# End checking whether the threshold is an integer or not
fi
