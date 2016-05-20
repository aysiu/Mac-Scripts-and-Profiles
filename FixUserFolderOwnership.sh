#!/bin/bash

## Just in case you're copying folders over as root and the ownership of folders changes, this script will change the ownership back,
## assuming that the short name is the same as the user folder name, which it usually is

# Change to the /Users directory
cd /Users

# Loop through each user
for user in *; do

  # Make an exception for the Shared folder
  if [ "$user" != "Shared" ]; then

    # Change ownership
    chown -R "$user" /Users/"$user"

  fi

done
