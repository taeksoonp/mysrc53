; kill `cat /tmp/console.pid` {enter} ./w& {enter}
;����:
;������ ��ġ ���Ϸ� ����
; "C:\Program Files\AutoHotkey\AutoHotkey.exe" rundvr.ahk
;ctrl-f11�� ����

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
	msgbox, Where is it? 'run-' �����?
}
