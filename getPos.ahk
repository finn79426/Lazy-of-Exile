;#IfWinActive, Path of Exile
#SingleInstance force
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#Persistent ; Stay open in background
#MaxThreadsPerHotkey 1


~!O::
    MouseGetPos, MouseX, MouseY
    PixelGetColor, color, %MouseX%, %MouseY%
    ToolTip, x = %MouseX% `ny = %MouseY%`nColor = %color%
    SetTimer, RemoveToolTip, 10000
    return

RemoveToolTip(){
    SetTimer, RemoveToolTip, Off
    ToolTip
    return
}



; 當移動(左鍵)超過 0.5 秒，使用水銀藥劑(5)
; 按下左鍵，開始計時 0.5 秒
/* ~a::
    if LButtonIsPressed
        return
    LButtonIsPressed := true
    SetTimer, WaitLButtonRelease, 500
    return
; 放開左鍵，重設計時器
~a Up::
    SetTimer, WaitLButtonRelease, Off
    LButtonIsPressed := false
    return
; 按住左鍵超過 0.5 秒，使用水銀藥劑(5)
WaitLButtonRelease(){
    while(LButtonIsPressed){
        Send {5}
        Sleep 1000
    }
    return
}
*/
/*
QuickSliver_CD := 4800
~a down::
    Loop{
        QuickSliver_CD := QuickSliver_CD - 100
        if(!GetKeyState("a", "P")){
            Break
        }
        if(QuickSliver_CD == 0){
            QuickSliver_CD := 4800
            Tooltip, 4800ms
            SetTimer, RemoveToolTip, 3000
        }
        Sleep 100
    }
 */

iconn := Quicksilver_Flask_status_icon.png

~a::
    KeyWait, a, T0.5
    if(ErrorLevel){
        ;if WinActive("Path of Exile"){
            ImageSearch, , , 544, 179, 756, 391, iconn
            if(ErrorLevel){
                Send {5}
                Sleep, 4800
            }
        ;}
    }
    return


TriggerTheQuickFlask(){
    ; Check if key still pressing?
    ImageSearch, , , 544, 179, 756, 391, Quicksilver_Flask_status_icon.png
    if(GetKeyState("a", "P") and (ErrorLevel == 1)){
        Send {5}
        Sleep, 4800
        Tooltip, "flask!"
        TriggerTheQuickFlask()
    }
}