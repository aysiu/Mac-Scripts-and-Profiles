#!/usr/bin/python

import os
import subprocess

# You can get ffmpeg from https://www.ffmpeg.org/download.html
# Path to ffmpeg binary
ffmpeg='/usr/local/bin/ffmpeg'

# Directory of movies to convert to audio
source='/PATH/TO/WHERE/THE/ORIGINAL/MOVIE/FILES/ARE'

# Directory to put output audio files
destination='/PATH/TO/WHERE/YOU/WANT/COMBINED/MP3S/TO/GO'

# Main
def main():

	# First, test to make sure the ffmpeg binary exists. If it doesn't, there's no point in even running any of the rest of this script
	if os.path.isfile(ffmpeg):

		# Make sure the destination directory exists to output things
		if os.path.isdir(destination):

			# Loop through the pkgsinfo
			if os.path.isdir(source):
				for root, dirs, files in os.walk(source):
					for dir in dirs:
						# Skip directories starting with a period
						if dir.startswith("."):
							dirs.remove(dir)
						fulldir = os.path.join(root, dir)
						print "We are now in %s" % dir
						# Make a temporary directory to store converted files
						tempdir=os.path.join(destination, 'tempfiles', dir)
						if not os.path.isdir(tempdir):
							os.makedirs(tempdir)
						# When the os.walk happens for files, it doesn't necessarily sort the files, so we'll put them into a list to sort and go through later
						mp3s=[]
						for subroot, subdirs, subfiles in os.walk(fulldir):
							for file in subfiles:
								# Skip files that start with a period
								if file.startswith("."):
									continue
								# Get the full path to the file
								fullfile = os.path.join(subroot, file)
								# Get basename without the file extension
								filebase=os.path.splitext(file)[0]
								# Create path to output .mp3
								newmp3=os.path.join(tempdir, filebase)
								newmp3+='.mp3'
								# Convert this movie file to .mp3
								cmd = [ ffmpeg, '-y', '-i', fullfile, '-f', 'mp3', '-ab', '192000', '-vn',  newmp3 ]
								print "Creating %s" % newmp3
								proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
								# Append the full path of the file to the list
								mp3s.append(newmp3)
								# Wait a second for the command to complete
								# time.sleep(1)
								proc.wait()
						# Path to concat text file
						concat=os.path.join(destination, 'tempfiles', dir)
						concat+='.txt'
						# Open file to write names of mp3s to concat
						f=open(concat, "w+")
						# Sort the list
						mp3s.sort()
						# Loop through the list and add those paths to the text file for concat
						for mp3 in mp3s:
							f.write("file '" + mp3 + "'\n")
						# Close text file
						f.close()
						# Name for combined mp3
						outputmp3=os.path.join(destination, dir)
						outputmp3+='.mp3'
						
						# Combine all the mp3s
						print "Combining %s" % concat
						cmd = [ ffmpeg, '-y', '-f', 'concat', '-safe', '0', '-i', concat, '-c', 'copy', outputmp3 ]
						print "Creating %s" % outputmp3
						proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
						# Wait a few seconds for the command to complete
						#time.sleep(4)
						proc.wait()
			else:
				print "%s is not a valid path to find files to convert." % source
		else:
			print "%s is not a valid destination directory." % destination
	else:
		print "The path %s to ffmpeg is invalid, so the script can't be run." % ffmpeg

if __name__ == '__main__':
	main()
