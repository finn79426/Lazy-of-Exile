RemoveToolTip(){
    SetTimer, RemoveToolTip, Off
    ToolTip
    return
}

RandomSleep(min,max) {
    Random, rand, %min%, %max%
    Sleep %rand%
    return
}