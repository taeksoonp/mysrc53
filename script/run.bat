set PATH=PATH;N:\ccc
echo off

rem symbolic link 사용가능.
rem  이름이 /home/tsp/ccc/7550.bat, 6205.bat인지 검사해본다.
rem  https://stackoverflow.com/questions/7005951/batch-file-find-if-substring-is-in-string-not-in-a-file
rem 머냐?-> @setlocal enableextensions enabledelayedexpansion
set Network=192.168.217
set myname=%0
set Console=console
if not x%myname:7550=%==x%myname% (set Console=console7550)
if not x%myname:6205=%==x%myname% (set Console=console6205)
rem endlocal

echo "내이름은 %0, console은 '%Console%'임"
set Port=80
rem 152 hdc442fpd, 153 uhn6400h8, 154 hdc422fd, 155 uhd1604fu
if "%1"=="152" (set Target_id=hs16a)
if "%1"=="153" (set Target_id=hs64e)
rem vvr
if "%1"=="13" (set Target_id=hs64e
	set Port=8080)
if "%1"=="154" (set Target_id=hs4c)
if "%1"=="155" (set Target_id=hs16d)

if "%1"=="022" (set Target_id=hs4c
	set Network=192.168.110)

if not defined Target_id (echo '%1'가 어디냐?) else (
	echo 한다
	N:\prj\%Console%\console\project_window\%Target_id%\release\config.exe %network%.%1 %Port% admin 12345 .
)
