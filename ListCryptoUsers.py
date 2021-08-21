#!/usr/local/munki/munki-python
# This uses Munki's Python 3 as an example, but you can specify another Munki 3 path here

from subprocess import Popen, PIPE
from sys import exit

def get_username(uuid):
    cmd = [ '/usr/bin/dscl', '.', '-search', '/Users', 'GeneratedUID', uuid ]
    p = Popen(cmd, stdout=PIPE, stderr=PIPE, encoding='utf8')
    out, err = p.communicate()
    if err:
        print(f'ERROR: {err}')
        exit(1)
    else:
        # Separate out the output bits
        out_list = out.split("\t")
        if(len(out_list) == 3):
            return(out_list[0])
        else:
            print(f"ERROR: Couldn't determine username from {out}")
            exit(1)

def get_cryptousers():
    cmd = [ '/usr/sbin/diskutil', 'apfs', 'listCryptoUsers', '/' ]
    p = Popen(cmd, stdout=PIPE, stderr=PIPE, encoding='utf8')
    out, err = p.communicate()
    if err:
        print(f'ERROR: {err}')
        exit(1)
    else:
        # Initialize a list to return
        usernames = []
        # Separate lines of output
        out_list = out.split("\n")
        # Loop through the list but keep index numbers
        for i, item in enumerate(out_list):
            # If it's a local open directory user...
            if 'Type: Local Open Directory User' in item:
                # Get the previous line, which has the UUID
                uuid_string = (out_list[i-1])
                uuid_pieces = uuid_string.split(' ')
                if len(uuid_pieces) > 0:
                    print(f'Getting username for {uuid_pieces[1]}...')
                    username = get_username(uuid_pieces[1])
                    print(f'Adding {username} to list...')
                    usernames.append(username)
        return usernames

def main():
    usernames = get_cryptousers()
    print(f'\nCrypto Users: {usernames}')

if __name__ == "__main__":
    main()
