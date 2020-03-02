#!/bin/env python3

import socket, sys, os
import fcntl, struct #to get eth0pc

print('argv: %s' % sys.argv)
HOST = os.environ['SSH_CLIENT'].split()[0]
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
