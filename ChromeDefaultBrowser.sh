#!/bin/zsh

## Note (6 Dec., 2019): The old version that used lsregister no longer worked as of
## Catalina (10.15). The version that doesn't use lsregister does appear to work in
## Ventura (13.4.1), as long as you reboot. Otherwise, trying to run lsregister afterwards
## may prevent System Settings from launching up

# Desired default browser string
DefaultBrowser='com.google.chrome'
#DefaultBrowser='com.microsoft.edgemac'
#DefaultBrowser='org.mozilla.firefox'
#DefaultBrowser='com.apple.safari'

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

# Double-check the PlistLocation exists
if [[ -f "$PlistLocation" ]]; then

    # Initialize counter that will just keep moving us through the array of dicts
    # A bit imprecise... would be better if we could just count the array of dicts, but we'll stop when we get to a blank one
    Counter=0

    # Initialize DictResult just so the while loop begins
    DictResult='PLACEHOLDER'

    while [[ ! -z "$DictResult" ]]; do
        DictResult=$("$PlistBuddy" -c "Print LSHandlers:$Counter" "$PlistLocation")

        # Check for existing settings
        if [[ "$DictResult" == *"public.url"* || "$DictResult" == *"public.html"* || "$DictResult" == *"LSHandlerURLScheme = https"* || "$DictResult" == *"LSHandlerURLScheme = http"* ]]; then
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

/bin/echo "You may need to reboot for changes to take effect."
