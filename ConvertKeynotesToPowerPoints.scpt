-- Bad assumptions this script makes: That there are definitely Keynotes and only Keynotes in the folder,
-- that Keynote defaults to exporting files to another folder, and that the folder it's exporting to doesn't
-- already have files of the same name, and that the user is using Keynote 8.1 or another version of Keynote
-- that has the exact same menu options

-- Loop through the files in the folder of Keynotes to convert
tell application "Finder"
	set fl to files of folder POSIX file "/Users/USERNAME/Desktop/NAMEOFFOLDERWITHKEYNOTES" as alias list
end tell
repeat with f in fl
	tell application "Keynote"
		open f
		activate
	end tell
	
	tell application "System Events"
		click menu item "PowerPoint…" of ((process "Keynote")'s (menu bar 1)'s ¬
			(menu bar item "File")'s (menu "File")'s ¬
			(menu item "Export To")'s (menu "Export To"))
	end tell
	
	tell application "System Events"
		set window_name to name of first window of (first application process whose frontmost is true)
	end tell
	
	tell application "System Events"
		-- Click the “Next…” button.
		delay 0.3
		click UI element 9 of sheet 1 of window 1 of application process "Keynote"
		
		-- Click the “Export” button.
		delay 0.3
		click UI element "Export" of sheet 1 of window 1 of application process "Keynote"
	end tell
	tell application "Keynote"
		activate
		close every document without saving
	end tell
end repeat
