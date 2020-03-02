#!/bin/env python3
# explorer & notepad client

import socket, sys, os
import fcntl, struct #to get eth0pc

def usage():
    print('explorer & notepad client. v1.0')
    print("usage: e [filename]")
    print('HOST:', HOST)
    exit(0)

print('argv: %s' % sys.argv)
HOST = os.environ['SSH_CLIENT'].split()[0]
PORT = 6821

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
        else:
            cmd = '"C:/Program Files/Notepad++/Notepad++.exe" '

# d: default
    else:
        cmd = 'notepad '

    if sys.argv[1][0] == '/':  # 절대 패스면
        cmd += sys.argv[1]
    else:
        cmd += os.getcwd() + '/' + sys.argv[1]

else:
    cmd = 'explorer ' + os.getcwd()

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.sendto(cmd.encode(), 0, (HOST, PORT))
s.close()

print('Sent:', cmd)
