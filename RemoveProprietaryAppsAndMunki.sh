#!/bin/bash

## Obviously, tweak this to whatever suits your organization. The framework is there—you just have to adjust what's in the removal arrays

# Remove any launch daemons for the proprietary applications
LaunchDs=(
"/Library/LaunchAgents/com.adobe.AAM.Updater-1.0.plist"
"/Library/LaunchAgents/com.symantec.uiagent.application.plist"
"/Library/LaunchDaemons/com.adobe.adobeupdatedaemon.plist"
"/Library/LaunchDaemons/com.adobe.agsservice.plist"
"/Library/LaunchDaemons/com.adobe.ARMDC.Communicator.plist"
"/Library/LaunchDaemons/com.adobe.ARMDC.SMJobBlessHelper.plist"
"/Library/LaunchDaemons/com.adobe.fpsaud.plist"
"/Library/LaunchDaemons/com.microsoft.office.licensing.helper.plist"
"/Library/LaunchDaemons/com.microsoft.office.licensingV2.helper.plist"
"/Library/LaunchDaemons/com.symantec.liveupdate.daemon.ondemand.plist"
"/Library/LaunchDaemons/com.symantec.liveupdate.daemon.plist"
"/Library/LaunchDaemons/com.symantec.sharedsettings.plist"
"/Library/LaunchDaemons/com.symantec.symdaemon.plist"
)

for LaunchD in "${LaunchDs[@]}"; do
   if [ -f "$LaunchD" ]; then
      /bin/launchctl unload "$LaunchD"
      /bin/rm -f "$LaunchD"
      /bin/echo -e "Removing $LaunchD\n"
   fi
done

# Remove proprietary applications
AppsToRemove=("/Applications/Adobe Acrobat DC"
"/Applications/Adobe Application Manager"
"/Applications/Adobe Creative Cloud"
"/Applications/Adobe Illustrator CC 2015"
"/Applications/Adobe InDesign CC 2015"
"/Applications/Adobe Photoshop CC 2015"
"/Applications/Microsoft Office 2011"
"/Applications/Microsoft Excel.app"
"/Applications/Microsoft Lync.app"
"/Applications/Microsoft Messenger.app"
"/Applications/Microsoft OneNote.app"
"/Applications/Microsoft Outlook.app"
"/Applications/Microsoft PowerPoint.app"
"/Applications/Microsoft Word.app"
"/Applications/Symantec Solutions"
"/Applications/Utilities/Adobe Application Manager"
"/Applications/Utilities/Adobe Creative Cloud"
"/Applications/Utilities/Adobe Installers"
)

for AppToRemove in "${AppsToRemove[@]}"; do
   if [ -a "$AppToRemove" ]; then
      # /bin/echo -e "Removing $AppToRemove\n"
      /bin/rm -rf "$AppToRemove"
      /bin/echo -e "Removing $AppToRemove\n"
   fi
done

# Receipt wildcard array
RECEIPTTESTS=(
"com.adobe.acrobat.AcrobatDCUpd*"
"com.adobe.acrobat.DC.*"
"com.adobe.armdc.app.pkg"
"com.adobe.EdgeCode"
"com.adobe.PDApp.AdobeApplicationManager.installer.pkg"
"com.adobe.pkg.Reflow"
"com.adobe.pkg.Scout"
"com.microsoft.mau.all.autoupdate*"
"com.microsoft.merp.all.errorreporting*"
"com.microsoft.office.all.automator.pkg*"
"com.microsoft.office.all.clipart_search9.pkg.*"
"com.microsoft.office.all.core.pkg.*"
"com.microsoft.office.all.dcc.pkg.*"
"com.microsoft.office.all.dock.pkg.*"
"com.microsoft.office.all.equationeditor.pkg.*"
"com.microsoft.office.all.excel.pkg.*"
"com.microsoft.office.all.fix_permissions.pkg.*"
"com.microsoft.office.all.fonts.pkg.*"
"com.microsoft.office.all.graph.pkg.*"
"com.microsoft.office.all.launch.pkg.*"
"com.microsoft.office.all.licensing.pkg.*"
"com.microsoft.office.all.ooxml.pkg.*"
"com.microsoft.office.all.outlook.pkg.*"
"com.microsoft.office.all.powerpoint.pkg.*"
"com.microsoft.office.all.proofing_*"
"com.microsoft.office.all.quit.pkg.*"
"com.microsoft.office.all.required_office.pkg.*"
"com.microsoft.office.all.setupasst.pkg.*"
"com.microsoft.office.all.sharepointbrowserplugin.pkg.*"
"com.microsoft.office.all.slt_std.pkg.*"
"com.microsoft.office.all.vb.pkg.*"
"com.microsoft.office.all.word.pkg.*"
"com.microsoft.office.en.automator_workflow.pkg.*"
"com.microsoft.office.en.clipart.pkg.*"
"com.microsoft.office.en.core_resources.pkg.*"
"com.microsoft.office.en.core_themes.pkg.*"
"com.microsoft.office.en.dcc_resources.pkg.*"
"com.microsoft.office.en.equationeditor_resources.pkg.*"
"com.microsoft.office.en.excel_resources.pkg.*"
"com.microsoft.office.en.excel_templates.pkg.*"
"com.microsoft.office.en.excel_webqueries.pkg.*"
"com.microsoft.office.en.fonts_fontcollection.pkg.*"
"com.microsoft.office.en.graph_resources.pkg.*"
"com.microsoft.office.en.langregister.pkg.*"
"com.microsoft.office.en.outlook_resources.pkg.*"
"com.microsoft.office.en.outlook_scriptmenuitems.pkg.*"
"com.microsoft.office.en.powerpoint_guidedmethods.pkg.*"
"com.microsoft.office.en.powerpoint_resources.pkg.*"
"com.microsoft.office.en.query.pkg.*"
"com.microsoft.office.en.readme.pkg.*"
"com.microsoft.office.en.required.pkg.*"
"com.microsoft.office.en.setupasst_resources.pkg.*"
"com.microsoft.office.en.sharepointbrowserplugin_resources.pkg.*"
"com.microsoft.office.en.solver.pkg.*"
"com.microsoft.office.en.sounds.pkg.*"
"com.microsoft.office.en.vb_resources.pkg.*"
"com.microsoft.office.en.word_resources.pkg.*"
"com.microsoft.office.en.word_templates.pkg.*"
"com.microsoft.office.en.word_wizards.pkg.*"
"com.microsoft.package.Fonts"
"com.microsoft.package.Frameworks"
"com.microsoft.package.Microsoft_AutoUpdate.app"
"com.microsoft.package.Microsoft_Excel.app"
"com.microsoft.package.Microsoft_Outlook.app"
"com.microsoft.package.Microsoft_PowerPoint.app"
"com.microsoft.package.Microsoft_Word.app"
"com.microsoft.package.Proofing_Tools"
"com.microsoft.lync.all.lync.pkg.*"
"com.microsoft.lync.all.meetingjoinplugin.pkg.*"
"com.microsoft.msgr.all.messenger.pkg.*"
"com.microsoft.office.en.flip4mac.pkg.*"
"com.microsoft.office.en.powerpoint_templates.pkg.*"
"com.microsoft.office.en.silverlight.pkg.*"
"com.microsoft.pkg.licensing*"
"com.symantec.*"
"com.Symantec.*"
)

# Remove receipts for proprietary applications
for RECEIPTTEST in "${RECEIPTTESTS[@]}"; do
   # /bin/echo -e "Processing $RECEIPTTEST\n"
   RECEIPTWILD=$(pkgutil --pkgs="$RECEIPTTEST")
    if [ ! -z "$RECEIPTWILD" ]; then
    for ARECEIPT in $RECEIPTWILD; do
        /usr/sbin/pkgutil --forget "$ARECEIPT"
        /bin/echo -e "Forgetting $ARECEIPT\n"
    done
    fi
done

# Remove Munki (list from https://github.com/munki/munki/wiki/Removing-Munki)
/bin/echo -e "Removing Munki\n"
/bin/launchctl unload /Library/LaunchDaemons/com.googlecode.munki.*
/bin/rm -rf "/Applications/Utilities/Managed Software Update.app"
/bin/rm -rf "/Applications/Managed Software Center.app"
/bin/rm -f /Library/LaunchDaemons/com.googlecode.munki.*
/bin/rm -f /Library/LaunchAgents/com.googlecode.munki.*
/bin/rm -rf "/Library/Managed Installs"
/bin/rm -f /Library/Preferences/ManagedInstalls.plist
/bin/rm -rf /usr/local/munki
/bin/rm /etc/paths.d/munki
/usr/sbin/pkgutil --forget com.googlecode.munki.admin
/usr/sbin/pkgutil --forget com.googlecode.munki.app
/usr/sbin/pkgutil --forget com.googlecode.munki.core
/usr/sbin/pkgutil --forget com.googlecode.munki.launchd


CrashPlanUninstall="/Library/Application Support/CrashPlan/Uninstall.app/Contents/Resources/uninstall.sh"

# See if CrashPlan uninstall exists... we could call it, but the uninstall doesn't change that often, so we're going to do a copy-and-paste instead
if [ -f "$CrashPlanUninstall" ]; then

   /bin/bash "$CrashPlanUninstall"

# End checking for CrashPlan
fi
