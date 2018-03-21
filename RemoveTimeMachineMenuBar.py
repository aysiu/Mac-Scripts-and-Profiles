#!/usr/bin/python
import subprocess

### Rationale for this: there is a built-in shell command to add to a .plist array, but there isn't a command to remove from a .plist array. And I know there is a library that allows Python to interact directly with .plist files, but I'm not quite up to speed on that yet, so this messy workaround will do in the meantime. The approach is messy, but it should work. Basically it takes the output of reading the array, and dumps that output into a variable. Then it gets all the junk out of that variable, including the offending entry (which can appear one of two ways), and then writes the modified variable back to the array, overwriting the existing array with everything but the offending entry ###

# Specify the offending entry
offendingEntryOne = '"/System/Library/CoreServices/Menu Extras/TimeMachine.menu", '

# Yes, this is messy, but for the first iteration of this script anyway, we're just going to specify the other way the offending entry could appear
offendingEntryTwo = '"/System/Library/CoreServices/Menu Extras/TimeMachine.menu"'

# Get the current menus
currentMenus = subprocess.check_output("/usr/bin/defaults read com.apple.systemuiserver menuExtras", shell=True)

# Print out the current menus
print "The output of the command is %s" % (currentMenus)

### This may be a bit sloppy. Not sure yet whether the following three commands can be combined into one command that gets rid of the parentheses, the carriage returns, the extra spaces, and the extra commas ###

# Get rid of the parentheses and the carriage returns
currentMenus = currentMenus.translate(None, '()\n')

# Get rid of the extra commas and spaces
currentMenus = currentMenus.replace(',",    "', '", "')

# Get rid of the leading space in the beginning (merely cosmetic, so commenting out for now)
#currentMenus = currentMenus.replace('    ','')

# Print out the current menus
#print "Before taking out the offending entry, it looks like %s" % (currentMenus)

# Take out the offending entry, pass one
if currentMenus.find(offendingEntryOne) != -1:
	currentMenus = currentMenus.replace(offendingEntryOne, '')
elif currentMenus.find(offendingEntryTwo) != -1:
	# Take out the offending entry, pass two
	currentMenus = currentMenus.replace(offendingEntryTwo, '')

# Print out the current menus
#print "After taking out the offending entry, it looks like %s" % (currentMenus)

# Let's write it back and then refresh the menu bar
subprocess.call("/usr/bin/defaults write com.apple.systemuiserver menuExtras -array " + currentMenus + " && /usr/bin/killall -KILL SystemUIServer", shell=True)
