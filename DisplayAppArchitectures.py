#!/usr/local/munki/munki-python
# This is just an example of a relocatable Python 3 to use. Sub in your own if necessary.

'''
Displays what architectures the installed apps are and displays a summary of how many apps
are each particular architecture type
'''

import plistlib
from subprocess import Popen, PIPE
from sys import exit

def main():
    print("Running system_profiler command. This may take a few minutes to complete...")
    cmd = [ '/usr/sbin/system_profiler', 'SPApplicationsDataType', '-xml' ]
    p = Popen(cmd, stdout=PIPE, stderr=PIPE)
    out, err = p.communicate()
    if err:
        print(f'Error running {cmd}: {err}')
        exit(1)
    else:
        print('Converting system_profiler output to dictionary...')
        try:
            xml_contents = plistlib.loads(out)
        except:
            print('Error converting data...')
            exit(1)
        try:
            applications = xml_contents[0]['_items']
        except:
            print('Error getting items from dictionary...')
            exit(1)
        print('Getting data into more digestible form...')
        # Dictionary to store processed data
        arch_kinds = {}
        # Loop through the applications
        for application in applications:
            arch_kind = application['arch_kind']
            app_name = application['_name']
            # Add the architecture kind as a dictionary key if necessary
            if arch_kind not in arch_kinds.keys():
                arch_kinds[arch_kind] = []
            arch_kinds[arch_kind].append(app_name)
        # Show all apps and what category they belong to
        for key, value in arch_kinds.items():
            print(key)
            print(value)
            print("\n")
        # Show subtotals summary
        for key, value in arch_kinds.items():
            value_total = len(value)
            if value_total == 1:
                app_desc = 'app'
            else:
                app_desc = 'apps'
            print(f'{key}: {value_total} {app_desc}')

if __name__ == "__main__":
    main()
