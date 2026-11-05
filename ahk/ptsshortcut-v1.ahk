;Menu, Tray, Icon, %A_ScriptDir%\flask.ico
Menu, Tray, Icon, %ProgramFiles%\Microsoft OneDrive\OneDrive.exe
groupadd, explorer, ahk_class CabinetWClass

;MatchMode 1 + 'ahk_class HwndWrapper[DefaultDomain' 실패
;visual studio하고 araxis는 #숫자로 해결
;groupadd, visualstudio, Microsoft Visual Studio
groupadd, eclipse, ahk_class SWT_Window0

;안돼 groupadd, Tortoise, ahk_exe TortoiseProc.exe
groupadd, Tortoise, ahk_class #32770
groupadd, notepad, ahk_class Notepad
groupadd, Notepadxx, ahk_class Notepad++
groupadd, console, ahk_class ConsoleWindowClass
groupadd, onenote, ahk_class Framework::CFrame
groupadd, winterminal, ahk_class CASCADIA_HOSTING_WINDOW_CLASS
groupadd, winterminal, ahk_class mintty
groupadd, putty, ahk_class PuTTY
groupadd, sourcetree, Sourcetree
;얘는 안씀. win-4
groupadd, stickermemo, ahk_class ApplicationFrameWindow
groupadd, aladinev, ahk_class HwndWrapper[AladinEbookViewer.exe;;2246c64d-9128-4661-bd12-cca5827a6c26]
groupadd, naverworks, ahk_class Qt5152QWindowIcon
;윽 너무 많다 claude, obsidian, 크롬 본체 등등 엥? vscode도? groupadd, obsidian, ahk_class Chrome_WidgetWin_1
return

;
; pts map 200715
; 실패다-_-; key swap은 무한루프에 빠진다
; SharpKeys는 Pause/break 인식 못한다
;  https://stackoverflow.com/questions/38846347/what-is-the-scancode-of-pause-break-key

;pts key ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;남은 거 f,s
;s,q는 'open search'
;h는 한글 자모 분리, k blutooth
;

;마우스 가운데 버튼
;MButton::XButton1

#\::	GroupActivate, Tortoise, R
#+\::	winminimize, ahk_class 32770
#^+\::	GroupClose, Tortoise, R

#'::	GroupActivate, putty, R
#+'::
  winminimize, ahk_class PuTTY
  return

#j::	GroupActivate, onenote, R
#+j::	winminimize, ahk_class Framework::CFrame
#^+j::	GroupClose, onenote, R

#y::    GroupActivate, aladinev, R
#+y::   winminimize, ahk_class HwndWrapper[AladinEbookViewer.exe;;2246c64d-9128-4661-bd12-cca5827a6c26]
#^+y::	GroupClose, aladinev, R

#o::	GroupActivate, winterminal, R
#+o:: winminimize, ahk_class CASCADIA_HOSTING_WINDOW_CLASS
#^+o::	GroupClose, winterminal, R

#/:: GroupActivate, explorer
#^+/:: GroupClose, explorer

#[::	GroupActivate, Notepadxx, R
#^+[::	GroupClose, Notepadxx, R

#]::	GroupActivate, stickermemo, R
#^+]::	GroupClose, stickermemo, R

#s::	GroupActivate, Notepad, R
#^+s::	GroupClose, Notepad, R

;BT 리모콘 돼라
;포기. 갖다 버려라-_-

;*****************************************************************************
; 매크로
;*****************************************************************************
vk19::	;한자
Input, UserInput, T5 L4 C M, {enter}.{esc}{tab},{Space},kc,ka,kb,kd,kD,ke,kf,kg,kG,kk,kK,kl,km,ko,kO,kp,kq,kr,ks,kS,kt,kT,ky,k`,,k.,k``,k~,k$,k<,k>,k=,0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f,g,h,i,j,l,L,m,n,o,p,q,r,s,t,u,v,w,x,y,z
if ErrorLevel = Max
{
    MsgBox, You entered "%UserInput%", which is the maximum length of text.
    return
}
if ErrorLevel = Timeout
{
    MsgBox, You entered "%UserInput%" at which time the input timed out.
    return
}
if ErrorLevel = NewInput
    return
IfInString, ErrorLevel, EndKey:
{
    MsgBox, You entered "%UserInput%" and terminated the input with %ErrorLevel%.
    return
}
; Otherwise, a match was found.
SetKeyDelay, -1  ; Most editors can handle the fastest speed.

if UserInput = a
    Send, cat /proc/meminfo&&free
else if UserInput = d
    Send, qDebug(`"@`%s:`%d: `"`, __FILE__`,__LINE__
else if UserInput = e
    Send, ehla
else if UserInput = f
    Send, ƒ
else if UserInput = m
	send, mount 192.168.217.158:/home/tsp/prj /mnt/nfs -onolock -tnfs -octo
else if UserInput = n
	send, mount 192.168.217.159:/home/tsp/prj /mnt/nfs -onolock -tnfs -octo
else if UserInput = j
	send, mount 192.168.110.158:/home/tsp/prj /mnt/nfs -onolock -tnfs -octo
else if UserInput = h
	send, mount 192.168.110.159:/home/tsp/prj /mnt/nfs -onolock -tnfs -octo
else if UserInput = t
  Send, ttrace("\n");
else if UserInput = y
    Send, ttrace("~~~~~~~~ ~~~~~~~~\n");

else if UserInput = kc
    Send, kill ``cat /tmp/console.pid``
;수학 기호 ka,kb,kg,kd,ke,km,kp
else if UserInput = ka
    Send, α
else if UserInput = kb
    Send, β
else if UserInput = kd
    Send, δ
else if UserInput = kD
    Send, δ
else if UserInput = ke
    Send, ε
else if UserInput = kf
    Send, ƒ
else if UserInput = kg
    Send, γ
else if UserInput = kG
    Send, Γ
else if UserInput = kk
    Send, ∙
else if UserInput = kK
    Send, ∙∙∙
else if UserInput = kl
    Send, λ
else if UserInput = km
    Send, μ
else if UserInput = ko
    Send, ω
else if UserInput = kO
    Send, Ω
else if UserInput = kp
    Send, π
else if UserInput = kq
    Send, θ
else if UserInput = kr
    Send, ρ
else if UserInput = ks
    Send, σ
else if UserInput = kS
    Send, Σ
else if UserInput = kt
    Send, τ
;else if UserInput = kT
;    Send, θ
else if UserInput = ky
    Send, λ
else if UserInput = k$
    Send, §
else if UserInput = k``
    Send, ′
else if UserInput = k~
    Send, ※
else if UserInput = k<
    Send, ∈
else if UserInput = k>
    Send, ∋
else if UserInput = k`(
    Send, ⊂⊆
else if UserInput = k`)
    Send, ⊃⊇
else if UserInput = k=
    Send, ≈
else if UserInput = 0
    Send, ⑩
else if UserInput = 1
    Send, ①
else if UserInput = 2
    Send, ②
else if UserInput = 3
    Send, ③
else if UserInput = 4
    Send, ④
else if UserInput = 5
    Send, ⑤
else if UserInput = 6
    Send, ⑥
else if UserInput = 7
    Send, ⑦
else if UserInput = 8
    Send, ⑧
else if UserInput = 9
    Send, ⑨

else if UserInput = o
	send, alias ll='ls -alF' la='ls -A' l='ls -CF'
else if UserInput = l
	send, alias ll='ls -alF --time-style=long-iso' la='ls -A' l='ls -CF'

;되라쫌
else if UserInput = i
	send, iot-hub-kc
else if UserInput = I
    send, iot-hub-kc.azure-devices.net
;

else
	msgbox, "%UserInput%" 로 머?
return

/*
win 10 key?
#t	태스크바
*/

;auto-reloads the AHK script
;http://www.autohotkey.com/forum/viewtopic.php?t=135&highlight=auto+reload
/* 일단 빼본다.
$^s::
  Send, ^s
  SetTitleMatchMode, 2
  IfWinActive, %A_ScriptName%
    {
       TrayTip, AutoHotkey, reloading script...
       SetTimer, RemoveTrayTip, 1500
    }
return

RemoveTrayTip:
    SetTimer, RemoveTrayTip, Off
    TrayTip
    Reload
return
*/

