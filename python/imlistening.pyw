'''
I am listening.
Created on 2014. 12. 12.
@author: ts.p
ConEmu 설정
 인자: /dir d:\runccc
 명령: D:\python\WPy-3670\python-3.6.7.amd64\python.exe \\ptslinux.mshome.net\tsp\mysrc53\python\imlistening.py
'''

import socket
import os
import subprocess
import shutil  # eee가 쓴다.
import sys
#from PySide2.QtWidgets import *
#from PyQt5.QtWidgets import *
from qtpy.QtWidgets import QApplication, QPushButton

UDP_IP = ''
UDP_PORT = 6821
#todo: socket.gaierror: [Errno 11001] getaddrinfo failed
ptslinux = '0.0.0.0'    #deprecated: socket.gethostbyname('ptslinux.mshome.net')
Gigacitys = ['192.168.217.53', '192.168.217.165', '192.168.217.159', '192.168.217.158']
cccexe_dir = 'd:\\cccexe'
#
# 잊지말고 "제어판\시스템 및 보안\Windows 방화벽\고급 설정" 에 가서 풀어 줘라(고생했다)
# 인바운드 규칙 udp 6821
#
sock = socket.socket(socket.AF_INET,  # Internet
                     socket.SOCK_DGRAM)  # UDP
sock.bind((UDP_IP, UDP_PORT))

# QApplication은 global로 써야 재사용 할 수 있다.
# PySide 에러 메시지가 좀 친절해서 알게됨
app =  QApplication(sys.argv)

print('여기는  "%s"\n' % os.getcwd())
#os.chdir(cccexe_dir)
#print('"%s"로  바꿈\n' % os.getcwd())
print ('현재 python path: %s' % sys.path)
envpath = os.environ["path"]
print ('env path: %s' % envpath)
os.environ["path"] = envpath + cccexe_dir + ';';
print ('cccexe 추가 후 path: %s' % os.environ["path"])

while True:
    data, (ip, port) = sock.recvfrom(1024)  # buffer size is 1024 bytes
    print("received message:", data)
    print("from:", ip)
    if ip not in Gigacitys:
        print('Warning! Strange ip:', ip)
        continue

    if ip == ptslinux:
        ip = 'ptslinux.mshome.net'
    cmd = data.decode('utf8')

    print('cmd??%s' % cmd)
    if 'explorer' in cmd:
        cmd = os.path.normpath(cmd) #netdrive는 안된다.
        cmd = cmd.replace('\\home\\', '\\\\' + ip + '\\')
        print("->", subprocess.Popen(cmd).pid)

    elif 'python ' == cmd[0:7]:
        cmd = cmd.replace('/home/', '\\\\' + ip + '\\')
        try:
            exec(cmd[7:])
        except Exception as inst:
            print(inst)
            m1, m2 = inst.args
            msg = 'errno %d' % m1 + '\n' + m2

            pushbtn = QPushButton(msg, None)
            pushbtn.show()
            pushbtn.resize(200, 140)
            pushbtn.clicked.connect(app.closeAllWindows)
            app.exec_()

    elif 'byebye' == cmd:
        break
    
    #nfs
    #config.exe를 samba에서 실행하면 win11 23h2에서 cpu reset된다!
    elif '/home/tsp/prj/' == cmd[0:14]:
        cmd = '\\\\' + ip + '\\' + cmd
        print('-->')
        print(cmd)
        print("->>", subprocess.Popen(cmd).pid)
    elif '.exe' == cmd[-4:]:
        print('-->')
        print(cmd)
        print("sorry. I can't. use it on NFS")
    #samba
    else:
        cmd = cmd.replace('/home/', '\\\\' + ip + '\\')
        print("->>", subprocess.Popen(cmd).pid)

    print('cmd: ', cmd, '\n\n')
