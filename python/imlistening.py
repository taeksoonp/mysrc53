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
from PyQt4.QtGui import *

UDP_IP = ''
UDP_PORT = 6821
Gigacitys = ['192.168.56.101', '192.168.217.53', '192.168.217.165']
Network_drive = ['n:', '~Network~192.168.217.53/ts.p', '~Network~192.168.217.165/ts.p']
Home_path = '/home/tsp'
Home_path2 = '/home/ts.p'
Share_foler = 'd:/Backup'
Shared_foler = '/media/sf_Backup'
Eclipse_home = os.environ['Eclipse_home']

sock = socket.socket(socket.AF_INET,  # Internet
                     socket.SOCK_DGRAM)  # UDP
sock.bind((UDP_IP, UDP_PORT))

# QApplication은 global로 써야 재사용 할 수 있다.
# PySide 에러 메시지가 좀 친절해서 알게됨
app = QApplication(sys.argv)

print('한다.\n')
while True:
    data, (ip, port) = sock.recvfrom(1024)  # buffer size is 1024 bytes
    print("received message:", data)
    print("from:", ip)
    if ip not in Gigacitys:
        print('Warning! Strange ip:', ip)
        continue

    cmd = data.decode('utf8')
    netdrv = Network_drive[Gigacitys.index(ip)]
    cmd = cmd.replace(Home_path, netdrv)
    cmd = cmd.replace(Home_path2, netdrv)
    cmd = cmd.replace(Shared_foler, Share_foler)
    cmd = cmd.replace('`~Eclipse_home`~', Eclipse_home)
    
    print('cmd는 %s' % cmd)
    if 'explorer' in cmd:
        cmd = os.path.normpath(cmd)
        cmd = cmd.replace('~Network~', '\\\\')
        print("->", subprocess.Popen(cmd).pid)

    elif 'python ' == cmd[0:7]:
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
        print("->", subprocess.Popen(cmd).pid)

    print('cmd: ', cmd)
