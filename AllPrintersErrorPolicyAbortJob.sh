#!/bin/bash

# Changes all printers' error policies to be abort-job instead of the default (stop-printer)

# Loop through all the installed printers
lpstat -s | awk -F "device for " '{print $2}' | awk -F ":" '{print $1}' | while read line; do
   # If the line isn't empty (there may be one empty line at the top)..
   if [ ! -z "$line" ]; then
      # Change the error policy to be abort-job
      echo "Changing error policy to abort job for $line"
      /usr/sbin/lpadmin -p "$line" -o printer-error-policy=abort-job
   fi
done
