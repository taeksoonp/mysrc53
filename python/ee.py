#!/bin/env python3

import socket
import sys
import os

def usage():
    print("usage: ee l|m|r")
    print("\tl: log")
    print("\tm: modification")
    print("\tr: repository")
    print("\tb: blame")
    print("\tci: ci")
    print("\tcic5: ci hidvr~console")
    print("\tcibr: ci br~console")
    exit(0)

cmd = '"C:/Program Files/TortoiseSVN/bin/TortoiseProc.exe" '
c5con = '/home/ts.p/nfs/hidvr/console/qt/examples/qws/console'
c5winprj = '/home/ts.p/nfs/hidvr/console/console/project_window'
brcon = '/home/ts.p/nfs/br/console/qt/examples/qws/console'
brwinprj = '/home/ts.p/nfs/br/console/console/project_window'
hienvsh = '/home/ts.p/nfs/hidvr/edvr_hddvr_hisilicon_env.sh'

if len(sys.argv) > 1:
    if sys.argv[1] == 'l':
        cmd += '/command:log /path:' + os.getcwd()
    elif sys.argv[1] == 'm':
        cmd += '/command:diff /path:' + os.getcwd()
    elif sys.argv[1] == 'r':
        cmd += '/command:repobrowser /path:' + os.getcwd()
    elif sys.argv[1] == 'b':
        cmd += '/command:blame /path:' + os.getcwd() + '/' + sys.argv[2]
    elif sys.argv[1] == 'ci':
        cmd += '/command:commit /path:' + os.getcwd()
    elif sys.argv[1] == 'cic5':
        cmd += '/command:commit /path:' + c5con + '*' + c5winprj + '*' + hienvsh
    elif sys.argv[1] == 'cibr':
        cmd += '/command:commit /path:' + brcon + '*' + brwinprj + '*' + hienvsh
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
