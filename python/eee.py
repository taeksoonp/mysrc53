#!/bin/env python3

import socket
import sys
import os

Hostnm = os.environ['HOSTNAME'];
if Hostnm.startswith('ptslinux'):
    HOST = '192.168.56.1'
elif Hostnm.startswith('gigacity'):
    HOST = '192.168.217.41'
else:
    HOST = '192.168.217.41'
PORT = 6821
config_base = 'C:/ProgramData/Digital Image World/Control Center/config/'

def usage():
    print("usage: eee <sendconfig[-showme] model version | byebye>")
    exit(1)

def sendit(where):
    cmd = 'python shutil.copyfile("' + os.getcwd() + '/release/config.exe","' \
        + where + '/config.exe")\n'
    s.sendto(cmd.encode(), 0, (HOST, PORT))
    print('Sent:', cmd)

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
if len(sys.argv) > 3:
    config_path = config_base + 'Config(W)(%s)(%s)' % (sys.argv[2], sys.argv[3])
    if sys.argv[1] == 'sendconfig':  # + model, version
        sendit(config_path)

    elif sys.argv[1] == 'sendconfig-showme':
        sendit(config_base)
        cmd = 'explorer ' + config_base
        s.sendto(cmd.encode(), 0, (HOST, PORT))
    else:
        usage()

elif len(sys.argv) > 1 and sys.argv[1] == 'byebye':
    cmd = 'byebye'
    s.sendto(cmd.encode(), 0, (HOST, PORT))

else:
    usage()

s.close()
