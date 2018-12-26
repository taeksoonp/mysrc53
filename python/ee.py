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
    print("\tcic5: ci hidvr~console")
    print("\tcibr: ci br~console")
    exit(0)

#
# get eth0 gw ipaddr
#
Hostnm = socket.gethostname()
ipaddr = socket.gethostbyname(Hostnm)
iface = 'eth0'
nmask = fcntl.ioctl(socket.socket(socket.AF_INET, socket.SOCK_DGRAM), 35099,\
                     struct.pack('256s', iface.encode('utf-8')))[20:24]
ipaddr1 = bytearray(socket.inet_aton(ipaddr))
ipaddr1[3] = (ipaddr1[3] & nmask[3]) + 1 
eth0pc = socket.inet_ntoa(ipaddr1)

def con(br):
    return '/home/tsp/prj/console' + br + '/qt/examples/qws/console' 

def winprj(br):
    return '/home/tsp/prj/console' + br + '/console/project_window'    
    
def topmk(br):
    return '/home/tsp/prj/console' + br + '/Makefile'

def spotosd(br):
    return '/home/tsp/prj/console' + br + '/qt/examples/qws/spotosd' 

hienvsh = '/home/tsp/prj/hidvr/edvr_hddvr_hisilicon_env.sh'
def cic5(n):    
    if (n <= 0):
        br = ''
    else:
        br = str(n)
    return con(br) + '*' + winprj(br) + '*' + topmk(br) + '*' + \
        spotosd(br) + '*' + hienvsh 
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
        cmd += '/command:commit /path:' + cic5(0)
    elif sys.argv[1] == 'cic8822':
        cmd += '/command:commit /path:' + cic5(8822)
    elif sys.argv[1] == 'cic7550':
        cmd += '/command:commit /path:' + cic5(7550)
    elif sys.argv[1] == 'cic6205':
        cmd += '/command:commit /path:' + cic5(6205)
    else:
        usage()
else:
    usage()

if Hostnm.startswith('ptslinux'):
    HOST = eth0pc
else:
    HOST = '192.168.217.41'
PORT = 6821

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.sendto(cmd.encode(), 0, (HOST, PORT))
s.close()

print('Sent:', cmd)
