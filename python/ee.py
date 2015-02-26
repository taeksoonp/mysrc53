#!/bin/env python3

import socket
import sys
import os


def usage():
    print("usage: ee l|m|r")
    print("\tl: log")
    print("\tm: modification")
    print("\tr: repository")
    print("\tci: ci")
    exit(0)

cmd = '"C:/Program Files/TortoiseSVN/bin/TortoiseProc.exe" '
if len(sys.argv) > 1:
    if sys.argv[1] == '--help' or sys.argv[1] == '?':
        usage()
    elif sys.argv[1] == 'l':
        cmd += '/command:log /path:' + os.getcwd()
    elif sys.argv[1] == 'm':
        cmd += '/command:diff /path:' + os.getcwd()
    elif sys.argv[1] == 'r':
        cmd += '/command:repobrowser /path:' + os.getcwd()
    elif sys.argv[1] == 'ci':
        cmd += '/command:commit /path:' + os.getcwd()
    else:
        usage()
else:
    usage()

HOST = '192.168.217.41'  # The remote host
PORT = 6821  # The same port as used by the server

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.sendto(cmd.encode(), 0, (HOST, PORT))
s.close()

print('Sent:', cmd)
