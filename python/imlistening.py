'''
I am listening.
Created on 2014. 12. 12.

@author: ts.p
'''

import socket
import os
import subprocess
import shutil

UDP_IP = ""
UDP_PORT = 6821
Gigacity = '192.168.217.53'
Home_path = '/home/ts.p'
sock = socket.socket(socket.AF_INET,  # Internet
                     socket.SOCK_DGRAM)  # UDP

sock.bind((UDP_IP, UDP_PORT))

while True:
    data, (ip, port) = sock.recvfrom(1024)  # buffer size is 1024 bytes
    print("received message:", data)
    print("from:", ip)
    if ip != Gigacity:
        print('Warning! Strange ip:', ip)
        continue

    cmd = data.decode('utf8')
    cmd = cmd.replace(Home_path, 'n:')
    if 'explorer' in cmd:
        cmd = os.path.normpath(cmd)
        print("->", subprocess.Popen(cmd).pid)

    elif 'python ' == cmd[0:7]:
        exec(cmd[7:])

    else:
        print("->", subprocess.Popen(cmd).pid)

    print('cmd: ', cmd)
