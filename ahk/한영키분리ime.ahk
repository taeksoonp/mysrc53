#Requires AutoHotkey v2.0
#SingleInstance Force
DetectHiddenWindows true

; ── IME 상태 조회/설정 (1 = 한글, 0 = 영문) ──
ImeWnd() {
    try hwnd := ControlGetFocus("A")
    catch
        hwnd := 0
    if !hwnd
        hwnd := WinExist("A")
    return DllCall("imm32\ImmGetDefaultIMEWnd", "ptr", hwnd, "ptr")
}

; 권한 높은 창(자격 증명/UAC 등)은 UIPI 때문에 SendMessage가 "액세스 거부(5)"로 실패 → -1 반환
IME_Get() {
    try return SendMessage(0x283, 0x001, 0, , "ahk_id " ImeWnd())   ; IMC_GETCONVERSIONMODE
    catch
        return -1
}
;한글 전환 안된다 IME_Set(m) => SendMessage(0x283, 0x002, m, , "ahk_id " ImeWnd())  ; IMC_SETCONVERSIONMODE
IME_Set(m) {
    w := "ahk_id " ImeWnd()
    try {
        SendMessage(0x283, 0x006, 1, , w)   ; IMC_SETOPENSTATUS → IME 열기
        SendMessage(0x283, 0x002, m, , w)   ; IMC_SETCONVERSIONMODE
    } catch
        return                              ; 접근 불가 창
    Sleep 30
    r := IME_Get()
    if (r != -1 && (r & 1) != m)        ; 적용이 안 됐으면
        Send "{vk15}"                   ; 한/영 키로 강제 토글
}

; ── 강제 지정 키 ──
CapsLock::IME_Set(0), ShowState()        ; CapsLock → 무조건 영문
;+CapsLock::IME_Set(1), ShowState()       ; Shift+CapsLock → 무조건 한글
; ^CapsLock::SetCapsLockState(!GetKeyState("CapsLock", "T"))   ; Ctrl+CapsLock → 원래 CapsLock 토글
; +CapsLock은 그냥 CapsLock으로 작동한다?
vk15::IME_Set(1), ShowState()       ;한영키 -> 한글

; ── 창 전환 시 커서 옆에 상태 표시 ──
global lastWin := 0
SetTimer(CheckWin, 150)
CheckWin() {
    global lastWin
    w := WinExist("A")
    if (w != lastWin) {
        lastWin := w
        Sleep 80
        IME_Set(0)  ;적응이 잘 안된다-_-; 창 전환 시 일단 영어로 시작
        ShowState()
    }
}
ShowState() {
    r := IME_Get()
    if (r = -1)                         ; 접근 불가 창이면 표시 안 함
        return
    s := (r & 1) ? "한" : "A"
    try {
        if !CaretGetPos(&x, &y)
            MouseGetPos(&x, &y)
    } catch
        return
    ToolTip(s, x + 12, y + 20)
    SetTimer(() => ToolTip(), -5000)
}