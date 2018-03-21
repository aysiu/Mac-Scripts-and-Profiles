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
   /bin/echo -e "Current user is $currentUser\n"

   # Get path of the user's Dock
   # By default (unless the sys admin has modified the User Template, in which case, why even have a login-once script?)
   # there is no com.apple.dock.plist, so we're checking to see if it doesn't exist (good) or if it's been created only within
   # the threshold period (also good)
   currentUserDock="/Users/$currentUser/Library/Preferences/com.apple.dock.plist"
   
   # Set up a test variable, since there are two instances that yield a positive result
   recentlyCreated=0
   
   if [ -f "$currentUserDock" ]; then

      /bin/echo -e "User Dock exists\n"

      # Get the creation date (in UNIX timestamp) of the current user dock
      dockCreationTimestamp=$(/usr/bin/stat -f%B "$currentUserDock")
      /bin/echo -e "Dock was created $dockCreationTimestamp\n"
   
      # Get today's date from [threshold] minutes ago into a UNIX timestamp
      thresholdTimestamp=$(/bin/date -j -v -"$threshold"M +%s)
      /bin/echo -e "$threshold minutes ago is $thresholdTimestamp\n"
      
      # Check to see if the folder was created in the last [threshold] minutes
      if [ "$dockCreationTimestamp" -gt "$thresholdTimestamp" ]; then
         recentlyCreated=1
         /bin/echo -e "The user Dock was created within the last $threshold minutes\n"

      else
         /bin/echo -e "The user Dock was created more than $threshold minutes ago\n"

      fi

   else
      recentlyCreated=1
      /bin/echo -e "There is no user Dock (which means the user just logged in and this script somehow ran before the Dock could be created)\n"

   # End checking the user dock exists   
   fi

   if [ "$recentlyCreated" == 1 ]; then
   
      # This is where your code would go
      /bin/echo -e "The use Dock is either non-existent or only recently created, so you can probably run your script.\n"
   fi

else
   /bin/echo -e "\nThe threshold is not an integer\n"

# End checking whether the threshold is an integer or not
fi
