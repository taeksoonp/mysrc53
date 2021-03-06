#!/bin/env python3

import socket, sys, os
import fcntl, struct #to get eth0pc

def usage():
    print("usage: ee l|m|r")
    print("\tl: log")
    print("\tm: modification")
    print("\tr: repository")
    print("\tb: blame")
    print("\tci: ci")
    print("\tcic5: ~prj/trunk의 'console, Makefile, spotosd, project_window, edvr_hddvr_hisilicon_env.sh'을 commit한다")
    print("\tcibr <branch>: ~prj/<branch>의 'console, Makefile, spotosd, project_window, edvr_hddvr_hisilicon_env.sh'을 commit한다")
    exit(0)

print('argv: %s' % sys.argv)
HOST = os.environ['SSH_CLIENT'].split()[0]
PORT = 6821

def con(br):
    return '/home/tsp/prj/' + br + '/console/qt/examples/qws/console' 

def winprj(br):
    return '/home/tsp/prj/' + br + '/console/console/project_window'    
    
def topmk(br):
    return '/home/tsp/prj/' + br + '/console/Makefile'

def spotosd(br):
    return '/home/tsp/prj/' + br + '/console/qt/examples/qws/spotosd' 

def hienvsh(br):
    return '/home/tsp/prj/' + br + '/edvr_hddvr_hisilicon_env.sh'

def cic5(br):    
    return con(br) + '*' + winprj(br) + '*' + topmk(br) + '*' + \
        spotosd(br) + '*' + hienvsh(br)
cmd = '"C:/Program Files/TortoiseSVN/bin/TortoiseProc.exe" '

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
        cmd += '/command:commit /path:' + cic5('trunk')
    elif sys.argv[1] == 'cibr':
        cmd += '/command:commit /path:' + cic5(sys.argv[2])
    else:
        usage()
else:
    usage()

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.sendto(cmd.encode(), 0, (HOST, PORT))
s.close()

print('Sent:', cmd)
