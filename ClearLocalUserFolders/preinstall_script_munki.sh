#!/bin/bash

# Make sure not user is logged in
lastUser=$(/usr/bin/defaults read /Library/Preferences/com.apple.loginwindow lastUser)

if [ "$lastUser" != "loggedIn" ]; then

   # Exit cleanly, we can proceed
   # /bin/echo "User not logged in"
   exit 0

else

   # Exit 1, so we'll have to re-run this again
   # /bin/echo "User is logged in"
   exit 1

fi
