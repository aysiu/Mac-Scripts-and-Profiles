#!/usr/bin/python

import os

# MunkiPkg directory
munkipkgdir='/PATH/TO/munkipkgs'

# Prefixes of Printers
printer_prefixes=['Printer', 'Copier']

# Main
def main():

	# Make sure the munkipkg directory exists
	if os.path.isdir(munkipkgdir):

		# Create an empty dictionary to store results
		printer_ip_list={}

		# Loop through the folders in munkipkgdir
		for root, dirs, files in os.walk(munkipkgdir):
			for dir in dirs:
				# Look for only the directories that start with the printer prefixes
				if dir.startswith(tuple(printer_prefixes)):
					fulldir = os.path.join(root, dir)
					#print "We are now in %s" % dir
					for subroot, subdirs, subfiles in os.walk(fulldir):
						for file in subfiles:
							if file == 'postinstall':
								# Get the full path to the file
								fullfile = os.path.join(subroot, file)
								#print "Full file is %s" % fullfile
								for line in open(fullfile):
									if "'-v', '" in line:
										printer_ip=line.replace("'-v', '", "").replace("',", "").replace("\n","").strip()
									elif "'-p', '" in line:
										printer_name=line.replace("'-p', '", "").replace("',", "").replace("\n","").strip()
								if printer_ip and printer_name:
									printer_ip_list[printer_name]=printer_ip
		for printer in sorted(printer_ip_list):
			print "%s - %s" % (printer,printer_ip_list[printer])
	else:
		print "%s is not a valid directory." % munkipkgdir

if __name__ == '__main__':
	main()
