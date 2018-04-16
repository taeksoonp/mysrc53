set PATH=PATH;N:\ttccc
echo off

rem symbolic link 사용가능.
rem  이름이 /home/tsp/ttccc/7550.bat, 6205.bat인지 검사해본다.
rem  https://stackoverflow.com/questions/7005951/batch-file-find-if-substring-is-in-string-not-in-a-file
rem 머냐?-> @setlocal enableextensions enabledelayedexpansion
set myname=%0
set Console=console
if not x%myname:7550=%==x%myname% (set Console=console7550)
if not x%myname:6205=%==x%myname% (set Console=console6205)
rem endlocal

echo "내이름은 %0, console은 <%Console%>임"

rem 152 hdc442fpd, 153 uhn6400h8, 154 hdc422fd, 155 uhd1604fu
if "%1"=="152" (set Target_id=hs4c)
if "%1"=="153" (set Target_id=hs64e)
if "%1"=="154" (set Target_id=hs4b)
if "%1"=="155" (set Target_id=hs16d)

echo on
if not defined Target_id (echo %1? 어디?) else (
	N:\prj\%Console%\console\project_window\%Target_id%\release\config.exe 192.168.217.%1 80 admin 12345 .
)
@echo "끝"
