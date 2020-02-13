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

;============================== 功能 ==============================
; 按 Alt+Q 鍵開啓傳送門
; 按 F3 清理背包
; 按 F5 從城鎮進入傳送處
; 按 F6 暫離模式
; 按 F7 修正錯位
;============================== To-Do ==============================
; 把第一行註解拿到才能只在 POE 裡運行腳本
; 給定偵測 Buff icon 的矩形座標
; 需要測試 Alt+Q 開啓傳送門是否正常運作
; 需要測試自動喝水銀是否正常運作
; 添加自動清背包，把東西丟到倉庫的功能
;   添加智能丟倉功能
;   開發清包暫停鍵
;   開發半自動清包，適用於只需要快速找到單一物品所需要放置的倉庫頁位置
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
; 水銀藥劑偵測設定
global BuffIconRange_P1_X := 212
global BuffIconRange_P1_Y := 197
global BuffIconRange_P2_X := 301
global BuffIconRange_P2_Y := 271
global QuickSliver := "Quicksilver_Flask_status_icon.png"

; 當移動(左鍵)超過 0.8 秒，使用水銀藥劑(5)
/*
    1. 有按超過 0.8 秒？
    1-1. 沒有 -> 返回 1
    1-2. 有 -> 進入 2
    2. 有 buff icon 存在嗎？
    2-1. 有 -> 返回 1
    2-2. 沒有 -> 喝水!

    開發備註: "返回 1" 是先 return 再觸發 LButton，而不是 goto!!!
*/
~LButton::
    KeyWait, LButton, T0.8
    ; Check if still holding
    if(ErrorLevel){
        if WinActive("Path of Exile"){
            ImageSearch, , , BuffIconRange_P1_X, BuffIconRange_P1_Y, BuffIconRange_P2_X, BuffIconRange_P2_Y, %QuickSliver%
            ; Check if still in buff time
            if(ErrorLevel){
                ToolTip, %ErrorLevel%
                Send {5}
            }else if(ErrorLevel == 2){
                ToolTip, Image format error!!!
            }
        }
    }
    return

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
	MouseMove, xx, yy
	BlockInput Off
	return

; 全部自動歸倉
F3::
    BlockInput On
    MouseGetPos MouseX, MouseY
    Grid_X := Inventory_Grid1_X
    Grid_Y := Inventory_Grid1_Y
    CurrentGrid := 0
    Loop 12{
        Loop 5{
            MouseMove %Grid_X%, %Grid_Y%
            CurrentGrid++

            if(HasVal(IgnoreGrids, CurrentGrid)){
                continue
            }

            ;Send ^c
            ; Parse the item name....
            ; Send {NumN} to switch Stash Tab...
            Send {Ctrl Down}{Click}{Ctrl Up}
            RandomSleep(10, 20)
            Grid_Y := Inventory_Grid1_Y + (Offset_Y * A_Index)
        }
        Grid_X := Inventory_Grid1_X + (Offset_X * A_Index)
        Grid_Y := Inventory_Grid1_Y
    }
    MouseMove %MouseX%, %MouseY%
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