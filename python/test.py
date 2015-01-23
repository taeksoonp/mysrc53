#!/bin/env python
# Echo client program
import socket
import sys
import os

cmd = ''
if (len(sys.argv) > 1):
	args = sys.argv
	del(args[0]) 
	cmd = ' '.join(sys.argv)
else:
	cmd = 'explorer ' + os.getcwd()

HOST = '192.168.217.41'    # The remote host
PORT = 6821              # The same port as used by the server
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.sendto(cmd, (HOST, PORT))
#data = s.recv(1024)
s.close()
print('Sent:', cmd)
