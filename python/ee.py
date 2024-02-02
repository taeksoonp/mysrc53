#!/bin/env python3

import socket, sys, os, subprocess

def usage():
    print("usage: ee <l|m|r|b|ci|up> [arg]")
    print("\tl: log [arg]")
    print("\tm: modification")
    print("\tr: repository")
    print("\tb: blame <arg>")
    print("\tci: ci")
    print("\tup: up")
    exit(0)

print('argv: %s' % sys.argv)
HOST = os.environ.get('SSH_CLIENT', 'Not set')
PORT = 6821

if os.environ['EE_Repo_type'] == 'git':
    cmd = '"C:/Program Files/TortoiseGit/bin/TortoiseGitProc.exe" '
else:
    cmd = '"C:/Program Files/TortoiseSVN/bin/TortoiseProc.exe" '

if len(sys.argv) > 1:
    if sys.argv[1] == 'l':
        cmd += '/command:log /path:' + os.getcwd()
        if len(sys.argv) > 2:
            cmd += '/' + sys.argv[2]        
    elif sys.argv[1] == 'm':
        cmd += '/command:diff /path:' + os.getcwd()
    elif sys.argv[1] == 'r':
        cmd += '/command:repobrowser /path:' + os.getcwd()
    elif sys.argv[1] == 'b':
        cmd += '/command:blame /path:' + os.getcwd() + '/' + sys.argv[2]
    elif sys.argv[1] == 'ci':
        cmd += '/command:commit /path:' + os.getcwd()
        if len(sys.argv) > 2:
            cmd += '/' + sys.argv[2]        
    elif sys.argv[1] == 'up':
        cmd += '/command:update /path:' + os.getcwd()
    else:
        usage()
else:
    usage()

if HOST == 'Not set':
    print("->>", subprocess.Popen(cmd).pid)
else:
    ipaddr = HOST.split()[0]
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.sendto(cmd.encode(), 0, (ipaddr, PORT))
    s.close()
    print('Sent:', cmd)
