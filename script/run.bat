set PATH=PATH;N:\ttccc
echo off

rem symbolic link ��밡��.
rem  �̸��� /home/tsp/ttccc/7550.bat, 6205.bat���� �˻��غ���.
rem  https://stackoverflow.com/questions/7005951/batch-file-find-if-substring-is-in-string-not-in-a-file
rem �ӳ�?-> @setlocal enableextensions enabledelayedexpansion
set myname=%0
set Console=console
if not x%myname:7550=%==x%myname% (set Console=console7550)
if not x%myname:6205=%==x%myname% (set Console=console6205)
rem endlocal

echo "���̸��� %0, console�� <%Console%>��"

rem 152 hdc442fpd, 153 uhn6400h8, 154 hdc422fd, 155 uhd1604fu
if "%1"=="152" (set Target_id=hs4c)
if "%1"=="153" (set Target_id=hs64e)
if "%1"=="154" (set Target_id=hs4b)
if "%1"=="155" (set Target_id=hs16d)

echo on
if not defined Target_id (echo %1? ���?) else (
	N:\prj\%Console%\console\project_window\%Target_id%\release\config.exe 192.168.217.%1 80 admin 12345 .
)
@echo "��"
