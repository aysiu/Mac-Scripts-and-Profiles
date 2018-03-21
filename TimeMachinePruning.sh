#!/bin/bash

####################################
#### Start user-defined variables ####

    # Define the Time Machine Backup location
    backupLocation="/PATH/TO/TIMEMACHINEBACKUPS/FOLDERABOVEDATENAMEDFOLDERS"

    # Define how many days back you want to keep
    thresholdDays=60

#### End user-defined variables ####
####################################

# Get threshold date in timestamp form
thresholdTimestamp=$(/bin/date -j -v -"$thresholdDays"d "+%s")

# Change directories to Time Machine Backups
/usr/bin/cd "$backupLocation"

# Loop through the Time Machine Backup folders
for f in *; do

    # Ignore "Latest"
    if [ "$f" != "Latest" ]; then

        # Get just the date part of the name
        testDate=${f:0:10}
    
        # Get the timestamp of the date
        testTimestamp=$(/bin/date -j -u -f "%Y-%m-%d" "$testDate" "+%s")

        # Compare it to the threshold timestamp    
        if [ "$thresholdTimestamp" -gt "$testTimestamp" ]; then

            /bin/echo "Going to delete $backupLocation/$f"
            /usr/bin/tmutil delete "$backupLocation/$f"

        # End comparison of timestamps
        fi

    # End checking not Latest folder
    fi

# End looping through folders
done
