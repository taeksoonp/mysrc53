#!/bin/env python3

import socket
import sys
import os

Hostnm = os.environ['HOSTNAME'];
if Hostnm.startswith('ptslinux'):
    HOST = '169.254.156.11'
elif Hostnm.startswith('gigacity'):
    HOST = '192.168.217.41'
else:
    HOST = '192.168.217.41'
PORT = 6821

def usage():
    print("usage: eee [-c(그대로)] <cmd args...>")
    exit(1)

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
if len(sys.argv) == 1:
    usage()
elif sys.argv[1] == '-c':
    cmd = ' '.join(sys.argv[2:]);   
else:
    cmd = os.getcwd() + '/' + sys.argv[1] + ' '.join(sys.argv[2:]);
    
s.sendto(cmd.encode(), 0, (HOST, PORT))
print(cmd)
s.close()
