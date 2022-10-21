#!/bin/env python3
# explorer & notepad client

import socket, sys, os, subprocess

def usage():
    print('explorer & notepad client. v1.0')
    print("usage: e [filename]")
    print('HOST:', HOST)
    exit(0)

print('argv: %s' % sys.argv)
HOST = os.environ.get('SSH_CLIENT', 'Not set')
PORT = 6821
office16 = '"C:/Program Files/Microsoft Office/root/Office16/'
acrobatexe = '"C:/Program Files/Adobe/Acrobat DC/Acrobat/Acrobat.exe"'

if len(sys.argv) > 1:
    if sys.argv[1] in ['--help', '-h', '?']:
        usage()

    request = os.path.basename(sys.argv[0])
    filename = os.path.basename(sys.argv[1])
    if request == 'e':
        if filename[-3:] == '.ui':
            cmd = '"D:/Qt/4.8.7/bin/designer.exe" '
        elif filename[-3:] == '.ts':
            cmd = '"D:/Qt/4.8.7/bin/linguist.exe" '
        elif filename[-5:] == '.docx' or filename[-4:] == '.doc':
            cmd = office16 + 'WINWORD.EXE"'
        elif filename[-5:] == '.xlsx' or filename[-4:] == '.xls':
            cmd = office16 + 'EXCEL.exe"'
        elif filename[-4:] == '.pdf':
            cmd = acrobatexe
        else:
            cmd = '"C:/Program Files/Notepad++/Notepad++.exe"'
        cmd += ' '

# d: default
    else:
        cmd = 'notepad '

    if sys.argv[1][0] == '/' or HOST == 'Not set':  # 절대 패스 or mys2
        cmd += sys.argv[1]
    else:
        cmd += os.getcwd() + '/' + sys.argv[1]

else:
    cmd = 'explorer ' + os.getcwd()

if HOST == 'Not set':
    print('cmd: ', cmd)
    print("->>", subprocess.Popen(cmd).pid)
else:
    ipaddr = HOST.split()[0]
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.sendto(cmd.encode(), 0, (ipaddr, PORT))
    s.close()
    print('cmd:', cmd)
