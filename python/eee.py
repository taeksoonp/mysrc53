#!/bin/env python3

import socket, sys, os, subprocess

print('argv: %s' % sys.argv)
HOST = os.environ.get('SSH_CLIENT', 'Not set')
PORT = 6821

def usage():
    print("usage(있는 그대로 원격 명령): eee <cmd args...>")
    exit(1)

#arg1 cmd, arg2 args
if len(sys.argv) == 1:
    usage()
else:
    cmd = ' '.join(sys.argv[1:]);

if HOST == 'Not set':
    print("->>", subprocess.Popen(cmd).pid)
else:
    ipaddr = HOST.split()[0]
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.sendto(cmd.encode(), 0, (ipaddr, PORT))
    s.close()
    print('Sent:', cmd)
