#!/bin/bash

# Caveat: Works only once this way to change defaults... won't work again until after you change it through the GUI

# Desired default browser string
DefaultBrowser='com.google.chrome'
#DefaultBrowser='com.apple.safari'
#DefaultBrowser='org.mozilla.firefox'

# PlistBuddy executable
PlistBuddy='/usr/libexec/PlistBuddy'

# Plist Location
PlistLocation="$HOME/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist"

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
   # A bit imprecise... would be better if we could just count the array of dicts
   Counter=0

   # Initialize test variable
   PrefsChanged=0

   while [ "$PrefsChanged" -lt 4 ]; do
      DictResult=$("$PlistBuddy" -c "Print LSHandlers:$Counter" "$PlistLocation")

      if [[ "$DictResult" == *"public.url"* ]]; then
         echo "Changing public.url. Counter is $Counter"
   
         "$PlistBuddy" -c "Set :LSHandlers:$Counter:LSHandlerRoleViewer $DefaultBrowser" "$PlistLocation"
   
         PrefsChanged=$((PrefsChanged+1))
   
      elif [[ "$DictResult" == *"public.html"* ]] || [[ "$DictResult" == *"https"* ]] || [[ "$DictResult" == *"http"* ]]; then

         echo "Changing public.html or https or http. Counter is $Counter"
   
         "$PlistBuddy" -c "Set :LSHandlers:$Counter:LSHandlerRoleAll $DefaultBrowser" "$PlistLocation"

         PrefsChanged=$((PrefsChanged+1))
   
      fi

      # Increase counter
     Counter=$((Counter+1))

      # Put in a safe guard just in case, for some reason, there aren't all the dicts we're looking for
      if [ "$Counter" -eq 50 ]; then
         # Set the PrefsChanged to 4, even though not all 4 got changed. We just don't want an infinite loop
         PrefsChanged=4
      fi

   done

   echo "Rebuilding Launch services. This may take a few moments."
   # Rebuilding launch services
   /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# Plist does not exist
else
   # Say the Plist does not exist
   echo "Plist does not exist"

# End checking whether Plist exists or not
fi
