;#IfWinActive, Path of Exile
#SingleInstance force
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#Persistent ; Stay open in background
#MaxThreadsPerHotkey 2


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


