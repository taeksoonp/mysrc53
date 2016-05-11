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

if len(sys.argv) > 1:
    if sys.argv[1] in ['--help', '-h', '?']:
        usage()

    request = os.path.basename(sys.argv[0])
    filename = os.path.basename(sys.argv[1])
    if request == 'e':
        if filename[-3:] == '.ui':
            cmd = '"D:/Qt/4.8.6/bin/designer.exe" '
        elif filename[-3:] == '.ts':
            cmd = '"D:/Qt/4.8.6/bin/linguist.exe" '
        elif filename[-4:] == '.cpp' or filename[-2:] == '.c' or filename == 'Makefile':
            cmd = 'C:/bin2/eclipse-cpp-mars-R-win32-x86_64/eclipse/eclipse.exe '
        else:
            cmd = '"C:/Program Files (x86)/Notepad++/Notepad++.exe" '

# d: default
    else:
        cmd = 'notepad '

    if sys.argv[1][0] == '/':  # 절대 패스면
        cmd += sys.argv[1]
    else:
        cmd += os.getcwd() + '/' + sys.argv[1]

else:
    cmd = 'explorer ' + os.getcwd()

HOST = '192.168.217.41'  # The remote host
PORT = 6821  # The same port as used by the server
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.sendto(cmd.encode(), 0, (HOST, PORT))
s.close()

print('Sent:', cmd)
