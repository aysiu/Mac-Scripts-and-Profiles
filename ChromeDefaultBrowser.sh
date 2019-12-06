#!/bin/bash

## Note (6 Dec., 2019): This no longer seems to work in Catalina (10.15).
## If you have any PRs to fix, I'm open to reviewing and merging.

# Desired default browser string
DefaultBrowser='com.google.chrome'
#DefaultBrowser='com.apple.safari'
#DefaultBrowser='org.mozilla.firefox'

# PlistBuddy executable
PlistBuddy='/usr/libexec/PlistBuddy'

# Plist directory
PlistDirectory="$HOME/Library/Preferences/com.apple.LaunchServices"

# Plist name
PlistName="com.apple.launchservices.secure.plist"

# Plist location
PlistLocation="$PlistDirectory/$PlistName"

# Array of preferences to add
PrefsToAdd=("{ LSHandlerContentType = \"public.url\"; LSHandlerPreferredVersions = { LSHandlerRoleViewer = \"-\"; }; LSHandlerRoleViewer = \"$DefaultBrowser\"; }"
"{ LSHandlerContentType = \"public.html\"; LSHandlerPreferredVersions =  { LSHandlerRoleAll = \"-\"; }; LSHandlerRoleAll = \"$DefaultBrowser\"; }"
"{ LSHandlerPreferredVersions = { LSHandlerRoleAll = \"-\"; }; LSHandlerRoleAll = \"$DefaultBrowser\"; LSHandlerURLScheme = https; }"
"{ LSHandlerPreferredVersions = { LSHandlerRoleAll = \"-\"; }; LSHandlerRoleAll = \"$DefaultBrowser\"; LSHandlerURLScheme = http; }"
)

# lsregister location (this location appears to exist on most macOS systems)
lsregister='/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister'
# This is an alternate location, but I think anything with the location below should also have the location above
#lsregister='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister'

# Double-check the PlistLocation exists
if [ -f "$PlistLocation" ]; then

	# Initialize counter that will just keep moving us through the array of dicts
	# A bit imprecise... would be better if we could just count the array of dicts, but we'll stop when we get to a blank one
	Counter=0

	# Initialize DictResult just so the while loop begins
	DictResult='PLACEHOLDER'

	while [[ ! -z "$DictResult" ]]; do
		DictResult=$("$PlistBuddy" -c "Print LSHandlers:$Counter" "$PlistLocation")

		# Check for existing settings
		if [[ "$DictResult" == *"public.url"* ]] || [[ "$DictResult" == *"public.html"* ]] || [[ "$DictResult" == *"LSHandlerURLScheme = https"* ]] || [[ "$DictResult" == *"LSHandlerURLScheme = http"* ]]; then
			# Delete the existing. We'll add new ones in later
         	"$PlistBuddy" -c "Delete :LSHandlers:$Counter" "$PlistLocation"
         	/bin/echo "Deleting $Counter from Plist"
		fi

		# Increase counter
	  Counter=$((Counter+1))

	# End of while loop
	done

# Plist does not exist
else
	# Say the Plist does not exist
	/bin/echo "Plist does not exist. Creating directory for it."
	/bin/mkdir -p "$PlistDirectory"

# End checking whether Plist exists or not
fi

echo "Adding in prefs"
for PrefToAdd in "${PrefsToAdd[@]}"
	do
		/usr/bin/defaults write "$PlistLocation" LSHandlers -array-add "$PrefToAdd"
	done

# Check the lsregister location exists
if [ -f "$lsregister" ]; then

	/bin/echo "Rebuilding Launch services. This may take a few moments."
	# Rebuilding launch services
	"$lsregister" -kill -r -domain local -domain system -domain user
else
	/bin/echo "You may need to log out or reboot for changes to take effect. Cannot find location of lsregister at $lsregister"
fi
