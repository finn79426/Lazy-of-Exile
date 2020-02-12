#IfWinActive, Path of Exile
#SingleInstance force
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#Persistent ; Stay open in background
#MaxThreadsPerHotkey 1

;============================== To-Do ==============================
; 需要測試 Alt+Q 開啓傳送門是否正常運作
;============================== 開發者筆記 ===========================
; 背包欄位 = 12x5
; 背包左上角的框框: 1266, 587
; 背包右下角的框框: 1910, 854
; => 框框 x 軸相差: 644
; => 框框 y 軸相處: 267
; => 框框 x 軸每格平均間距: 53.6
; => 框框 y 軸每格平均間距: 53.4
;
; 背包 A1: 1296, 613
; 背包 A2: 1296, 667
; 背包 B1: 1349, 613
; A1:A2 的 y 軸差: 54
; A1:B1 的 x 軸差: 53
;
; 知識卷軸: 1876, 774
; 傳送卷軸: 1876, 827
;
; 靈魂奉獻位置: 1560, 189
; 背包替換技能石位置: 1876, 721
;============================== 動態設置 ==============================
; 傳送卷軸座標設定
global PortalScroll_X=1877
global PortalScroll_Y=824
; 自動清包設定
global IgnoreGrids := [59, 60]
global Inventory_Grid1_X := 22 ; 1296
global Inventory_Grid1_Y := 166 ; 613
global Offset_X := 53
global Offset_Y := 54


; 按 F5 從城鎮進入藏身處
F5::
    BlockInput On
    oldClip := clipboard
    clipboard := "/hideout"
    Send {Enter}
    Sleep 2
    Send ^v
    Send {Enter}
    clipboard := oldClip
    BlockInput Off
    return

; 按 F6 暫離模式
F6::
    BlockInput On
    oldClip := clipboard
    clipboard := "/afk"
    Send {Enter}
    Sleep 2
    Send ^v
    Send {Enter}
    clipboard := oldClip
    BlockInput Off
    return

; 按 F7 修正錯位
F7::
    BlockInput On
    oldClip := clipboard
    clipboard := "/oos"
    Send {Enter}
    Sleep 2
    Send ^v
    Send {Enter}
    clipboard := oldClip
    BlockInput Off
    return

; 按 Alt+Q 鍵開啓傳送門
!Q::
    Keywait, Alt
	BlockInput On
	MouseGetPos xx, yy
	RandomSleep(53,87)

	Send {i}
	RandomSleep(56,68)

	MouseMove, PortalScroll_X, PortalScroll_Y, 0
	RandomSleep(56,68)

	Click Right
	RandomSleep(56,68)

	Send {i}
	MouseMove, xx, yy, 0
	BlockInput Off
	return

; 全部自動歸倉
F3::
    BlockInput On
    MouseGetPos MouseX, MouseY, 0
    Grid_X := Inventory_Grid1_X
    Grid_Y := Inventory_Grid1_Y
    CurrentGrid := 0
    Loop 12{
        Loop 5{
            MouseMove %Grid_X%, %Grid_Y%, 0
            CurrentGrid++

            if(HasVal(IgnoreGrids, CurrentGrid)){
                continue
            }

            ;Send ^c
            ; Parse the item name....
            ; Send {NumN} to switch Stash Tab...
            ;Send {Ctrl Down}{Click}{Ctrl Up}
            ;Send {Click}
            RandomSleep(10, 20)
            Grid_Y := Inventory_Grid1_Y + (Offset_Y * A_Index)
        }
        Grid_X := Inventory_Grid1_X + (Offset_X * A_Index)
        Grid_Y := Inventory_Grid1_Y
    }
    MouseMove %MouseX%, %MouseY%, 0
    BlockInput Off
    return


;============================== Sub-Functions ==============================
; 字典判斷，適用於清包功能
HasVal(haystack, needle) {
	if !(IsObject(haystack)) || (haystack.Length() = 0)
		return 0
	for index, value in haystack
		if (value = needle)
			return index
	return 0
}