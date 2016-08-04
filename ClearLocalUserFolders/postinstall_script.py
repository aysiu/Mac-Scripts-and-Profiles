#!/usr/bin/python

import os
import subprocess

# Define a list of protected users
protectedUsers = ['admin',
'Guest',
'Shared']

def main():

   # List the existing user directories
   startDir = '/Users'
   userDirs=os.listdir(startDir)
   for userDir in userDirs:
      userDirFull = os.path.join(startDir, userDir)
      if os.path.isdir(userDirFull):
         if userDir not in protectedUsers:
            # In theory shutil.rmtree should be able to recursively delete directories. There seems to be conflicting information on that. To be safe (or dangerous--depending on how you look at it), I'm going with the old standby of sudo rm -rf
            #print "Will delete %s" % userDirFull
            cmd = "sudo rm -rf %s" % userDirFull
            #print cmd
            subprocess.call(cmd, shell=True)

if __name__ == '__main__':
    main()
