#!/bin/bash

# Wait a few seconds
/bin/sleep 3

# Check to see if MathType is installed. We don't want to make any changes if MathType is installed
if [ ! -f "/Applications/MathType 6/MathType.app/Contents/Info.plist" ]; then
    
    # Logic
    # If it's not installed, let's go ahead and update stuff
    # 1. Old version exists, new version doesn't exist - replace
    # 2. Old version exists and new version exists - do nothing
    # 3. Old version doesn't exit and new version doesn't exist - do nothing
    # 4. New version in only - do nothing
    
    # Array of office apps to replace in Dock
    office_apps=(
        "Microsoft Word"
        "Microsoft Excel"
        "Microsoft PowerPoint"
        "Microsoft Outlook"
    )

    # Initialize a test variable... we don't want to kill the dock unless we've made any changes
    changes_made=0

    # Loop through the list of Office apps
    for office_app in "${office_apps[@]}"
        do

            # Create the %20 version of the office app name
            no_spaces="${office_app/ /%20}"

            # See if the old version is in there
            old_version=$(/usr/local/bin/dockutil --list | /usr/bin/grep -n "Microsoft%20Office%202011/$no_spaces.app")
    
            # See if the new version is in there
            new_version=$(/usr/local/bin/dockutil --list | /usr/bin/grep -n "/Applications/$no_spaces.app")

            # If there is an old version but no new version...
            if [ ! -z "$old_version" ] && [ -z "$new_version" ]; then

                # Update the old version to the new one
                /bin/echo "Replacing 2011 version of $office_app"
                /usr/local/bin/dockutil --add /Applications/"$office_app".app --replacing "$office_app" --no-restart
                
                # If the changes made is still 0, make it 1
                if [ "$changes_made" == 0 ]; then
                    changes_made=1
                # End checking if no changes had been made before
                fi
            # End checking if the old version of the Office app is there but not the new version
            fi

        # End looping through the Office apps
        done

    # If there were changes made, kill the Dock
    if [ "$changes_made" == 1 ]; then
        /usr/bin/killall Dock
    # End checking changes have been made
    fi
    
# End checking MathType isn't installed
fi
