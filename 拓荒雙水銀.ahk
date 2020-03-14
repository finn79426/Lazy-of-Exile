#IfWinActive, Path of Exile
#SingleInstance force
#NoEnv          ; Recommended for performance and compatibility with future AutoHotkey releases.
#Persistent     ; Stay open in background
#MaxThreadsPerHotkey 1
#Include GeneralFunc.ahk
SetBatchLines, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1
SetControlDelay, -1
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SetWorkingDir %A_ScriptDir%

;============================== 警告 ==============================
; 使用此腳本請勿使用 一般通用.ahk
; 或是先將 一般通用.ahk 的 LButton 區塊註解掉，再使用 一般通用.ahk 與 拓荒雙水銀.ahk。
;============================== 功能 ==============================
; 當移動(左鍵)超過 0.8 秒，使用水銀藥劑(4,5)
;   優先按 5，若 5 藥水爲空則接着按 4
;   水銀增益狀態下(4秒)，不會再使用水銀藥劑
;============================== 動態設置 ==============================
; 水銀藥劑偵測設定
global BuffIconRange_P1_X := 0
global BuffIconRange_P1_Y := 0
global BuffIconRange_P2_X := 1641
global BuffIconRange_P2_Y := 90
global QuickSliver := "Quicksilver_Status_Icon.png"
;=====================================================================

~LButton::
    CheckAgain:
	KeyWait, LButton, T0.8
	if(ErrorLevel){
		if WinActive("Path of Exile"){
			ImageSearch, , , BuffIconRange_P1_X, BuffIconRange_P1_Y, BuffIconRange_P2_X, BuffIconRange_P2_Y, %QuickSliver%
			if(ErrorLevel){
                Send {5}
				RandomSleep(90, 100)

				ImageSearch, , , BuffIconRange_P1_X, BuffIconRange_P1_Y, BuffIconRange_P2_X, BuffIconRange_P2_Y, %QuickSliver%
				if(ErrorLevel){
					Send {4}
				} else if(ErrorLevel == 2){
					MsgBox, %QuickSliver% format error!!!
				}

				Sleep 3910
				goto, CheckAgain
			} else if(ErrorLevel == 2){
                MsgBox, %QuickSliver% format error!!!
            }
		}
	}
	return
