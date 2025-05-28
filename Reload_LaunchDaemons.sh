#!/bin/zsh

# Sample script to re-enable and reload launch daemons

# Path to Launch Daemon plists
plist_path='/Library/LaunchDaemons'

# This associative array looks redundant, because the labels all match the plist names,
# but you may find this setup helpful in case you have launch daemon labels that don't
# match their corresponding plists
launchd_items=(
	"com.googlecode.munki.appusaged" "com.googlecode.munki.appusaged.plist"
	"com.googlecode.munki.authrestartd" "com.googlecode.munki.authrestartd.plist"
	"com.googlecode.munki.logouthelper" "com.googlecode.munki.logouthelper.plist"
	"com.googlecode.munki.managedsoftwareupdate-check" "com.googlecode.munki.managedsoftwareupdate-check.plist"
	"com.googlecode.munki.managedsoftwareupdate-install" "com.googlecode.munki.managedsoftwareupdate-install.plist"
	"com.googlecode.munki.managedsoftwareupdate-manualcheck" "com.googlecode.munki.managedsoftwareupdate-manualcheck.plist"
	)

# Get all disabled launchds
# Even though we're using "print-disabled," it includes enabled, too, hence the grep
disabled_launchd=$(/bin/launchctl print-disabled system | /usr/bin/grep disabled)

for launchd_label launchd_plist in ${(kv)launchd_items}; do
	# Check to see if the launch daemon is disabled
	if [[ $disabled_launchd == *"$launchd_label"* ]]; then
		echo "$launchd_label currently disabled. Re-enabling..."
		/bin/launchctl enable system/$launchd_label
	fi
	# Check to see if the launch daemon is launched
	# If a launch daemon is loaded, there will be a "state" in the output, even if the
	# state is "not running." A launch daemon can, in fact, be loaded but also not running
	launchd_check=$(/bin/launchctl print system/$launchd_label 2>&1 | /usr/bin/grep "state")
	if [[ -z $launchd_check ]]; then
		echo "$launchd_label is not launched. Launching..."
		/bin/launchctl bootstrap system $plist_path/$launchd_plist
	else
		echo "$launchd_label already launched."
	fi
done
