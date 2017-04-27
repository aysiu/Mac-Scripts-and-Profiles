#!/bin/bash

plugins=(
    "com.adobe.acrobat.pdfviewerNPAPI"
    "com.adobe.director.shockwave.pluginshim"
    "com.cisco_webex.plugin.gpc64"
    "com.citrix.citrixicaclientplugIn"
    "com.macromedia.Flash\ Player.plugin"
    "com.microsoft.SilverlightPlugin"
    "com.oracle.java.JavaAppletPlugin"
    )

# Loop through the plugins
for plugin in "${plugins[@]}"
    do
        # Set the policy to ask instead of off
        /usr/libexec/PlistBuddy -c "Set :ManagedPlugInPolicies:$plugin:PlugInFirstVisitPolicy 'PlugInPolicyAsk'" ~/Library/Preferences/com.apple.Safari.plist 

        # See if the disallow prompt before use dialogue exists
        current_setting=$(/usr/libexec/PlistBuddy -c "Print :ManagedPlugInPolicies:$plugin:PlugInDisallowPromptBeforeUseDialog" ~/Library/Preferences/com.apple.Safari.plist | grep -e true -e false)

        if [ "$current_setting" == false ]; then
            /usr/libexec/PlistBuddy -c "Set :ManagedPlugInPolicies:$plugin:PlugInDisallowPromptBeforeUseDialog bool true" ~/Library/Preferences/com.apple.Safari.plist 

        elif [ "$current_setting" != true ]; then
            /usr/libexec/PlistBuddy -c "Add :ManagedPlugInPolicies:$plugin:PlugInDisallowPromptBeforeUseDialog bool true" ~/Library/Preferences/com.apple.Safari.plist 

        fi
    done
