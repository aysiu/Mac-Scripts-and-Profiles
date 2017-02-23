#!/bin/bash

# Caveat: Works only once this way to change defaults... won't work again until after you change it through the GUI

# Desired default browser string
DefaultBrowser='com.google.chrome'
#DefaultBrowser='com.apple.safari'
#DefaultBrowser='org.mozilla.firefox'

# PlistBuddy executable
PlistBuddy='/usr/libexec/PlistBuddy'

# Plist location
PlistLocation="$HOME/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist"

# lsregister location (this location appears to exist on most macOS systems)
lsregister='/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister'
# This is an alternate location, but I think anything with the location below should also have the location above
#lsregister='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister'

## Things to change
#### LSHandlerContentType = public.url
#### LSHandlerRoleViewer = com.apple.safari
#### LSHandlerContentType = public.html
#### LSHandlerRoleAll = com.apple.safari
#### LSHandlerURLScheme = https
#### LSHandlerRoleAll = com.apple.safari
#### LSHandlerURLScheme = http
#### LSHandlerRoleAll = com.apple.safari

# Double-check the PlistLocation exists
if [ -f "$PlistLocation" ]; then

   # Initialize counter that will just keep moving us through the array of dicts
   # A bit imprecise... would be better if we could just count the array of dicts, but we'll stop when we get to a blank one
   Counter=0

   # Initialize DictResult just so the while loop begins
   DictResult='PLACEHOLDER'

   while [[ ! -z "$DictResult" ]]; do
      DictResult=$("$PlistBuddy" -c "Print LSHandlers:$Counter" "$PlistLocation")

      if [[ "$DictResult" == *"public.url"* ]]; then
         echo "Changing public.url. Counter is $Counter"

         # Apparently, sometimes it's LSHandlerRoleViewer and other times LSHandlerRoleAll, so let's check...
         if [[ "$DictResult" == *"LSHandlerRoleViewer"* ]]; then
            "$PlistBuddy" -c "Set :LSHandlers:$Counter:LSHandlerRoleViewer $DefaultBrowser" "$PlistLocation"
         elif [[ "$DictResult" == *"LSHandlerRoleAll"* ]]; then
            "$PlistBuddy" -c "Set :LSHandlers:$Counter:LSHandlerRoleAll $DefaultBrowser" "$PlistLocation"            
         fi

      elif [[ "$DictResult" == *"public.html"* ]] || [[ "$DictResult" == *"LSHandlerURLScheme = https"* ]] || [[ "$DictResult" == *"LSHandlerURLScheme = http"* ]]; then

         echo "Changing public.html or https or http. Counter is $Counter"

         "$PlistBuddy" -c "Set :LSHandlers:$Counter:LSHandlerRoleAll $DefaultBrowser" "$PlistLocation"

      fi

      # Increase counter
     Counter=$((Counter+1))

   # End of while loop
   done

   # Check the lsregister location exists
   if [ -f "$lsregister" ]; then

      echo "Rebuilding Launch services. This may take a few moments."
      # Rebuilding launch services
      "$lsregister" -kill -r -domain local -domain system -domain user
   else
      echo "You may need to log out or reboot for changes to take effect. Cannot find location of lsregister at $lsregister"
   fi

# Plist does not exist
else
   # Say the Plist does not exist
   echo "Plist does not exist"

# End checking whether Plist exists or not
fi
