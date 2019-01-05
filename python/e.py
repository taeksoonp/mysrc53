#!/bin/env python3
# explorer & notepad client

import socket, sys, os
import fcntl, struct #to get eth0pc

def usage():
    print('explorer & notepad client. v1.0')
    print("usage: e [filename]")
    exit(0)

print(sys.argv)

#
# get eth0 gw ipaddr
#
Hostnm = socket.gethostname()
ipaddr = socket.gethostbyname(Hostnm)

if Hostnm == 'ptslinux':
    iface = 'eth0'
else:
    iface = 'enp2s0f0'
nmask = fcntl.ioctl(socket.socket(socket.AF_INET, socket.SOCK_DGRAM), 35099,\
                     struct.pack('256s', iface.encode('utf-8')))[20:24]
ipaddr1 = bytearray(socket.inet_aton(ipaddr))
ipaddr1[3] = (ipaddr1[3] & nmask[3]) + 1 
eth0pc = socket.inet_ntoa(ipaddr1)

if len(sys.argv) > 1:
    if sys.argv[1] in ['--help', '-h', '?']:
        usage()

    request = os.path.basename(sys.argv[0])
    filename = os.path.basename(sys.argv[1])
    if request == 'e':
        if filename[-3:] == '.ui':
            cmd = '"D:/Qt/4.8.6/bin/designer.exe" '
        elif filename[-3:] == '.ts':
            cmd = '"D:/Qt/4.8.6/bin/linguist.exe" '
#        elif filename[-4:] == '.cpp' or filename[-2:] == '.c' or filename == 'Makefile':
#            cmd = '`~Eclipse_home`~/eclipse.exe '
        else:
            cmd = '"C:/Program Files/Notepad++/Notepad++.exe" '

# d: default
    else:
        cmd = 'notepad '

    if sys.argv[1][0] == '/':  # 절대 패스면
        cmd += sys.argv[1]
    else:
        cmd += os.getcwd() + '/' + sys.argv[1]

else:
    cmd = 'explorer ' + os.getcwd()

if Hostnm.startswith('ptslinux'):
    HOST = eth0pc
else:
    HOST = '192.168.217.41'
PORT = 6821

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.sendto(cmd.encode(), 0, (HOST, PORT))
s.close()

print('Sent:', cmd)
