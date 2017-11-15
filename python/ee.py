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
jjcon = '/home/tsp/prj/console/qt/examples/qws/console'
jjwinprj = '/home/tsp/prj/console/console/project_window'
jjtopmk = '/home/tsp/prj/console/Makefile'
jjspotosd = '/home/tsp/prj/console/qt/examples/qws/spotosd'

c5con = '/home/tsp/prj/hidvr/console/qt/examples/qws/console'
c5winprj = '/home/tsp/prj/hidvr/console/console/project_window'
c5topmk = '/home/tsp/prj/hidvr/console/Makefile'
c5spotosd = '/home/tsp/prj/hidvr/console/qt/examples/qws/spotosd'

hienvsh = '/home/tsp/prj/hidvr/edvr_hddvr_hisilicon_env.sh'
Hostnm = os.environ['HOSTNAME'];
 
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
        if Hostnm.startswith('ptslinux'):
            cmd += '/command:commit /path:' + jjcon + '*' + jjwinprj + '*' + hienvsh +\
            '*' + jjtopmk + '*' + jjspotosd
        else:
            cmd += '/command:commit /path:' + c5con + '*' + c5winprj + '*' + hienvsh +\
            '*' + c5topmk + '*' + c5spotosd
    elif sys.argv[1] == 'cic7550':
        jjcon += '7550'
        cmd += '/command:commit /path:' + jjcon + '*' + jjwinprj + '*' + hienvsh +\
        '*' + jjtopmk + '*' + jjspotosd
    else:
        usage()
else:
    usage()

if Hostnm.startswith('ptslinux'):
    HOST = '169.254.156.11'
elif Hostnm.startswith('gigacity'):
    HOST = '192.168.217.41'
else:
    HOST = '192.168.217.41'
PORT = 6821

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.sendto(cmd.encode(), 0, (HOST, PORT))
s.close()

print('Sent:', cmd)
