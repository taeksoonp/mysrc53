"""
I am listening.
Created on 2014. 12. 12.
@author: ts.p
ConEmu 설정
명령: uv run \\wsl.localhost/PengwinEnterprise9/home/tsp/GitHub/mysrc53/python/imlistening.py
"""

import os
import shlex
import shutil  # noqa: F401  eee가 쓴다.
import socket
import subprocess
import sys

# from PySide2.QtWidgets import *
# from PyQt5.QtWidgets import *
from qtpy.QtWidgets import QApplication, QPushButton

UDP_IP = ""
UDP_PORT = 6821
# todo: socket.gaierror: [Errno 11001] getaddrinfo failed
ptslinux = "0.0.0.0"  # deprecated: socket.gethostbyname('ptslinux.mshome.net')
Gigacitys = ["192.168.217.53", "192.168.217.165", "192.168.217.159", "192.168.217.158"]
cccexe_dir = "d:\\cccexe"
#
# 잊지말고 "제어판\시스템 및 보안\Windows 방화벽\고급 설정" 에 가서 풀어 줘라(고생했다)
# 인바운드 규칙 udp 6821
#
sock = socket.socket(
    socket.AF_INET,  # Internet
    socket.SOCK_DGRAM,  # UDP
)
sock.bind((UDP_IP, UDP_PORT))

# QApplication은 global로 써야 재사용 할 수 있다.
# PySide 에러 메시지가 좀 친절해서 알게됨
app = QApplication(sys.argv)

print(f'여기는  "{os.getcwd()}"\n')
# os.chdir(cccexe_dir)
# print('"%s"로  바꿈\n' % os.getcwd())
print(f"현재 python path: {sys.path}")
envpath = os.environ["path"]
print(f"env path: {envpath}")
os.environ["path"] = envpath + cccexe_dir + ";"
print(f"cccexe 추가 후 path: {os.environ['path']}")

while True:
    data, (ip, port) = sock.recvfrom(1024)  # buffer size is 1024 bytes
    print("received message:", data)
    print("from:", ip)
    if ip not in Gigacitys:
        print("Warning! Strange ip:", ip)
        continue

    if ip == ptslinux:
        ip = "ptslinux.mshome.net"
    cmd = data.decode("utf8")
    # 따옴표로 묶인 건 한 토큰. posix=False라 윈도우 경로의 \는 그대로 둔다.
    try:
        args = [t.strip('"') for t in shlex.split(cmd, posix=False)]
    except ValueError as e:  # 따옴표 짝이 안 맞을 때
        print(f"tokenize 실패: {e}")
        args = cmd.split()
    print(f"cmd??{cmd}")
#    print(f"commands: {commands}")

# nfs임
# config.exe를 samba에서 실행하면 win11 23h2에서 cpu reset된다!
    if "/home/tsp/prj/" == cmd[0:14]:
        args[0].replace("/", "\\")
        cmd = "\\\\" + ip + " ".join(args)
        print("->>", subprocess.Popen(cmd).pid)

# samba
    elif "explorer" == args[0]:
        cmd = os.path.normpath(cmd)  # netdrive는 안된다.
        cmd = cmd.replace("\\home\\", "\\\\" + ip + "\\")
        print("-1>>", subprocess.Popen(cmd).pid)

    elif ".exe" == args[0][-4:] or ".EXE" == args[0][-4:]:
        print("-->")
        cmd = cmd.replace("/home/", "\\\\" + ip + "\\")
        print("-2>>", subprocess.Popen(cmd).pid)

    elif "python " == cmd[0:7]:
        cmd = cmd.replace("/home/", "\\\\" + ip + "\\")
        try:
            exec(cmd[7:])  # noqa: S102
        except Exception as inst:  # noqa: BLE001
            print(inst)
            m1, m2 = inst.args
            msg = f"errno {m1:d}\n{m2}"

            pushbtn = QPushButton(msg, None)
            pushbtn.show()
            pushbtn.resize(200, 140)
            pushbtn.clicked.connect(app.closeAllWindows)
            app.exec()

    elif "byebye" == cmd:
        break

    else:
#vscode용: code.cmd
        print("-3>>", subprocess.Popen(cmd).pid)

    print("cmd: ", cmd, "\n\n")
