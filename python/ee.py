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
c5con = '/home/tsp/prj/hidvr/console/qt/examples/qws/console'
c5winprj = '/home/tsp/prj/hidvr/console/console/project_window'
brcon = '/home/tsp/prj/br/console/qt/examples/qws/console'
brwinprj = '/home/tsp/prj/br/console/console/project_window'
hienvsh = '/home/tsp/prj/hidvr/edvr_hddvr_hisilicon_env.sh'
c5topmk = '/home/tsp/prj/hidvr/console/Makefile'
 
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
        cmd += '/command:commit /path:' + c5con + '*' + c5winprj + '*' + hienvsh + '*' + c5topmk
    elif sys.argv[1] == 'cibr':
        cmd += '/command:commit /path:' + brcon + '*' + brwinprj + '*' + hienvsh
    else:
        usage()
else:
    usage()

Hostnm = os.environ['HOSTNAME'];
if Hostnm.startswith('ptslinux'):
    HOST = '192.168.137.1'
elif Hostnm.startswith('gigacity'):
    HOST = '192.168.217.41'
else:
    HOST = '192.168.217.41'
PORT = 6821

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.sendto(cmd.encode(), 0, (HOST, PORT))
s.close()

print('Sent:', cmd)
