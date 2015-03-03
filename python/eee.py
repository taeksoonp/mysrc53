#!/bin/env python3

import socket
import sys
import os

HOST = '192.168.217.41'  # The remote host
PORT = 6821  # The same port as used by the server
cmd = 'python '
configg_path = 'C:/ProgramData/Digital Image World/Control Center/config/'


def usage():
    print("usage: eee s")
    print("\ts:sendconfigg")
    exit(0)

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
if len(sys.argv) > 1:
    if sys.argv[1] == 's':
        cmd += 'shutil.copyfile("' + os.getcwd() + '/release/config.exe","' +\
            configg_path + 'config.exe")\n'
        s.sendto(cmd.encode(), 0, (HOST, PORT))
        print('Sent:', cmd)

        cmd = 'explorer ' + configg_path
        s.sendto(cmd.encode(), 0, (HOST, PORT))
        print('Sent:', cmd)
    else:
        usage()
else:
    usage()

s.close()
