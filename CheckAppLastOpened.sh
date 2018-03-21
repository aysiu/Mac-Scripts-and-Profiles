#!/bin/bash

##### User-defined input ######
# Fill in the hours ago you want to place to the threshold. Default is 30 days or 720 hours
threshold=720

# Application to check last opening of
appToCheck='/Applications/Automator.app/'

##### End user-defined input ######

# Check the last date and time that the app was opened
lastOpened=$(/usr/bin/mdls "$appToCheck" | /usr/bin/grep kMDItemLastUsedDate  | /usr/bin/awk -F "= " '{print $2}')

# Convert that to a UNIX Timestamp / Epoch
lastOpenedTimestamp=$(/bin/date -j -f '%Y-%m-%d %H:%M:%S +0000' "$lastOpened" +%s)

# Get the timestamp of the threshold
thresholdTimestamp=$(/bin/date -j -v -"$threshold"H +%s)

# Compare the two
if [ "$lastOpenedTimestamp" -lt "$thresholdTimestamp" ]; then
   
   # If it hasn't been opened since before the threshold date, say so or do something
   /bin/echo "$appToCheck hasn't been opened since $lastOpened"
   
   # By default, this just echoes feedback, but you may want to perform an action... put the action here

else
   
   # If it has been opened since the threshold date, say so or do something
   /bin/echo "$appToCheck was recently opened at $lastOpened"
   
   # By default, this just echoes feedback, but you may want to perform an action... put the action here

# End comparing the two timestamps   
fi
