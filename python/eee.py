#!/bin/env python3

import socket, sys, os
import fcntl, struct #to get eth0pc

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

if Hostnm.startswith('ptslinux'):
    HOST = eth0pc
else:
    HOST = '192.168.217.41'
PORT = 6821

def usage():
    print("usage(있는 그대로 원격 명령): eee <cmd args...>")
    exit(1)

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

#arg1 cmd, arg2 args
if len(sys.argv) == 1:
    usage()
else:
    cmd = ' '.join(sys.argv[1:]);

print(cmd)
s.sendto(cmd.encode(), 0, (HOST, PORT))
s.close()
