#!/bin/env python3
# explorer & notepad client

import socket
import sys
import os

if os.path.basename(sys.argv[0]) == 'e':
    cmd = 'notepad '
else:
    cmd = '"C:/Program Files/BowPad/BowPad.exe" '

if len(sys.argv) > 1:
    if sys.argv[1] == '--help' or sys.argv[1] == '?':
        print('explorer & notepad client. v1.0')
        exit(0)
    else:
        cmd += os.getcwd() + '/' + sys.argv[1]

else:
    cmd = 'explorer ' + os.getcwd()

HOST = '192.168.217.41'    # The remote host
PORT = 6821              # The same port as used by the server
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.sendto(cmd.encode(), 0, (HOST, PORT))
s.close()

print(sys.argv[0])
print('Sent:', cmd)
