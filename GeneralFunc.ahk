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

; 避免減傷水在有效時間內重複喝，且異步執行不會卡其他更重要的 Threads (例如瀕血喝水)
WaitForFlaskCD(){
    LessensDamage_Expire := true
    return
}