;#IfWinActive, Path of Exile
#SingleInstance force
#NoEnv          ; Recommended for performance and compatibility with future AutoHotkey releases.
#Persistent     ; Stay open in background
#MaxThreadsPerHotkey 1
SetBatchLines, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1
SetControlDelay, -1
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SetWorkingDir %A_ScriptDir%


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

