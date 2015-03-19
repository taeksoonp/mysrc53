#!/bin/env python3
# explorer & notepad client

import socket
import sys
import os

def usage():
    print('explorer & notepad client. v1.0')
    print("usage: e [filename]")
    exit(0)

print(sys.argv)

if os.path.basename(sys.argv[0]) == 'e':
    cmd = 'notepad '
elif os.path.basename(sys.argv[0]) == '3':     
    cmd = '"C:/Program Files/BowPad/BowPad.exe" '
else:
    cmd = '"C:/Program Files (x86)/Notepad++/Notepad++.exe" '
    
if len(sys.argv) > 1:
    if sys.argv[1] in ['--help', '-h', '?']:
        usage()
    elif sys.argv[1][0] == '/': #절대 패스면
        cmd += sys.argv[1]
    else:
        cmd += os.getcwd() + '/' + sys.argv[1]

else:
    cmd = 'explorer ' + os.getcwd()

HOST = '192.168.217.41'    # The remote host
PORT = 6821              # The same port as used by the server
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.sendto(cmd.encode(), 0, (HOST, PORT))
s.close()

print('Sent:', cmd)
