'''
I am listening.
Created on 2014. 12. 12.
@author: ts.p

'''

import socket
import os
import subprocess
import shutil  # eee가 쓴다.
import sys
from PyQt5.QtWidgets import *
#from PyQt4.QtGui import *

UDP_IP = ''
UDP_PORT = 6821
ptslinux = socket.gethostbyname('ptslinux.mshome.net')
Gigacitys = [ptslinux, '192.168.217.53', '192.168.217.165']

#
# 잊지말고 "제어판\시스템 및 보안\Windows 방화벽" 에 가서 풀어 줘라(고생했다)
#
sock = socket.socket(socket.AF_INET,  # Internet
                     socket.SOCK_DGRAM)  # UDP
sock.bind((UDP_IP, UDP_PORT))

# QApplication은 global로 써야 재사용 할 수 있다.
# PySide 에러 메시지가 좀 친절해서 알게됨
app =  QApplication(sys.argv)

print('되라\n')
while True:
    data, (ip, port) = sock.recvfrom(1024)  # buffer size is 1024 bytes
    print("received message:", data)
    print("from:", ip)
    if ip not in Gigacitys:
        print('Warning! Strange ip:', ip)
        continue
    
    if ip == Gigacitys[0]:
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
    else:
        cmd = cmd.replace('/home/', '\\\\' + ip + '\\')
        print("->>", subprocess.Popen(cmd).pid)

    print('cmd: ', cmd)
