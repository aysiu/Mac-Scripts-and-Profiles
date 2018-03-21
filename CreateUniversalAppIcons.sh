#!/bin/bash

# Name of original image (place in the same folder as this script)
originalImage="originalimage.png"

# Make sure the path actually exists
if [ -f "$originalImage" ]; then

   # Define sizes and names based on https://developer.apple.com/library/content/qa/qa1686/_index.html
   appIcons=(['512']='iTunesArtwork.png' ['1024']='iTunesArtwork@2x.png' ['120']='Icon-60@2x.png' ['180']='Icon-60@3x.png' ['76']='Icon-76.png' ['152']='Icon-76@2x.png' ['40']='Icon-Small-40.png' ['80']='Icon-Small-40@2x.png' ['120']='Icon-Small-40@3x.png' ['29']='Icon-Small.png' ['58']='Icon-Small@2x.png' ['87']='Icon-Small@2x.png')
   
   # Loop through each of the desired sizes
   for newSize in "${!appIcons[@]}"
      do
         # New filename
         newName="${appIcons[$newSize]}"
         
         # Make a copy first, so we keep the original image
         /bin/cp "$originalImage" "$newName"
         
         echo -e "Resizing $newName to $newSize by $newSize\n"
         /usr/bin/sips -z "$newSize" "$newSize" "$newName"

      done

else

   /bin/echo "$originalImage does not exist or isn't properly named. Make sure it is in the same folder as this script"

fi
