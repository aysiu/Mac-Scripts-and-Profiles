#!/bin/bash

# First version notes:
# This doesn't work if the com.apple.launchservices.secure.plist hasn't already been created.
# May do a later version that creates the file if it doesn't exist.
# Also, the change doesn't seem to take effect until you log out and log back in again.
# Not sure if there's a way to force the changes to be recognized otherwise. Could be a command.

# Desired default browser string
DefaultBrowser='com.google.chrome'

## Things to change
#### LSHandlerContentType = public.url
#### LSHandlerRoleViewer = com.google.chrome
#### LSHandlerContentType = public.html
#### LSHandlerRoleAll = com.apple.safari
#### LSHandlerURLScheme = https
#### LSHandlerRoleAll = com.apple.safari
#### LSHandlerURLScheme = http
#### LSHandlerRoleAll = com.apple.safari

# Initialize counter that will just keep moving us through the array of dicts
Counter=0

# Initialize test variable
PrefsChanged=0

while [ "$PrefsChanged" -lt 4 ]; do
   DictResult=$(/usr/libexec/PlistBuddy -c "Print LSHandlers:$Counter" ~/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist)

   if [[ "$DictResult" == *"public.url"* ]]; then
      echo "Changing public.url. Counter is $Counter"
   
      /usr/libexec/PlistBuddy -c "Set :LSHandlers:$Counter:LSHandlerRoleViewer $DefaultBrowser" ~/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist
   
      PrefsChanged=$((PrefsChanged+1))
   
   elif [[ "$DictResult" == *"public.html"* ]] || [[ "$DictResult" == *"https"* ]] || [[ "$DictResult" == *"http"* ]]; then

      echo "Changing public.html or https or http. Counter is $Counter"
   
      /usr/libexec/PlistBuddy -c "Set :LSHandlers:$Counter:LSHandlerRoleAll $DefaultBrowser" ~/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist

      PrefsChanged=$((PrefsChanged+1))
   
   fi

   # Increase counter
  Counter=$((Counter+1))

done
