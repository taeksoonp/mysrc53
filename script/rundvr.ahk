; kill `cat /tmp/console.pid` {enter} ./w& {enter}
;사용법:
;다음을 배치 파일로 만들어서
; "C:\Program Files\AutoHotkey\AutoHotkey.exe" rundvr.ahk
;ctrl-f11로 실행

;ahk_class SWT_Window0
;154hac430f - SecureCRT
;ahk_class VanDyke Software - SecureCRT
;ahk_class Notepad2
;

IfWinExist, run-
{
	WinActivate
	send, {enter} kill ``cat /tmp/console.pid`` {enter} ./w& {enter}
	WinActivate, ahk_class SWT_Window0
}
else
{
	msgbox, Where is it? 'run-' 어딨냐?
}
