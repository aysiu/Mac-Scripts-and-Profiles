-- Bad assumptions this script makes: That there are definitely Keynotes in the folder, that the folder it's
-- exporting to doesn't already have PowerPoint files of the same name, and that the user is using Keynote 8.1
-- or another version of Keynote that has the exact same menu options

-- How to use this:
--   1. In Automator, create an application
--   2. Drag Get Folder Contents to the workflow
--   3. Drag Run AppleScript to the workflow
--   4. Paste this code into the Run AppleScript window
--   5. Save the .app somewhere you want to use it later
--   6. Go to System Preferences > Security & Privacy > Accessibility and add your saved .app
--   7. Drag a folder full of Keynotes-to-convert onto the .app icon

on run {input, parameters}
	
	repeat with f in input
		
		tell application "Finder" to set fileExtension to name extension of f

		if fileExtension is in {"key"} then

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
		end if
		
		
	end repeat
	
	
	return input
end run
