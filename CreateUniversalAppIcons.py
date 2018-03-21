#!/usr/bin/python

import os
from shutil import copyfile
import subprocess

# Name of original image (place in the same folder as this script)
originalImage="originalimage.png"

# Main function
def main():

   if os.path.isfile(originalImage):

      # Define sizes and names based on https://developer.apple.com/library/content/qa/qa1686/_index.html
      appIcons = {'512': 'iTunesArtwork.png', '1024': 'iTunesArtwork@2x.png', '120': 'Icon-60@2x.png', '180': 'Icon-60@3x.png', '76': 'Icon-76.png', '152': 'Icon-76@2x.png', '40': 'Icon-Small-40.png', '80': 'Icon-Small-40@2x.png', '120': 'Icon-Small-40@3x.png', '29': 'Icon-Small.png', '58': 'Icon-Small@2x.png', '87': 'Icon-Small@2x.png'}

      # Loop through sizes and names
      for newSize, newName in appIcons.items():
         print "Creating %s with size %s x %s" % (newName, newSize, newSize)
      
         # Make a copy of the original image to modify
         copyfile(originalImage, newName)
      
         # Resize the new copy
         cmd = '/usr/bin/sips -z ' + newSize + ' ' + newSize + ' ' + newName
         subprocess.call(cmd, shell=True)
   else:
      print "%s is not in the same folder as this script" % originalImage

if __name__ == '__main__':
   main()
