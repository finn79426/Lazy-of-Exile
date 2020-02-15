#IfWinActive, Path of Exile
#SingleInstance force
#NoEnv      ; Recommended for performance and compatibility with future AutoHotkey releases.
#Persistent ; Stay open in background
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

;========================== 技能面板配置 ============================
; 技能配置
; 滑鼠左鍵 - 移動
; 滑鼠右鍵 - 旋風斬
; Q 鍵 - 暗影迷蹤
; WE 鍵 - 死亡標記
; R 鍵 - 烈焰衝刺
; Ctrl + QWE - 光環
; Ctrl + R - 召喚物
; 滑鼠側前鍵- 號召
; 滑鼠側後鍵- 骸骨鎧甲
; 滑鼠中鍵 - 瓦爾優雅
; 1 - 恐慌的生命藥劑 (貧血即回)
; 2 - 堅岩藥劑
; 3 - 翠玉藥劑
; 4 - 迷霧藥劑
;=============================== 邏輯 ================================
; 按 End 鍵啓動此腳本，進入打怪狀態
; 當瀕血(35%)時，按 1 喝紅水
; 當血量低於 95% 時，按 23 喝堅岩藥劑(2)與翠玉藥劑(3)
;	藥劑效果持續時間內不會再次使用
; 當按下旋風斬(右鍵)時，自動施放號召(側前鍵)
; 當旋風斬(右鍵)超過 1 秒，使用迷霧藥劑(4)
;	迷霧效果持續時間內且旋風斬沒有停止施放，不會再次使用
; 當按下暗影迷蹤(Q)，自動施放骸骨鎧甲(側後鍵)與瓦爾優雅(中鍵)
; 按 Alt+E 切換靈魂奉獻技能寶石，用於召喚召喚物
;================================ 備註 ================================
; 自動喝水是檢測血量的顏色是否異常 (血量不是紅色就會喝)，所以黑暗挖礦不適用自動喝水
; 過場換圖時也會因爲血量座標顏色異常而觸發自動喝水，但影響不大
;=============================== 靜態設置 ==============================
global ACTIVATED := false
global LessensDamageBuff_Expired := true
;=============================== 動態設置 ==============================
; 瀕血喝水座標設定
global LowLife_X := 95
global LowLife_Y := 1007
global LowLife_Color := 0x120D6E
; 減傷喝水座標設定
global LessensDamage_X := 95
global LessensDamage_Y := 884
global LessensDamage_Color := 0x241E53
global LessensDamage_CD := 4800
; 技能寶石切換設定
global Gem1_X := 1560	; 裝備座標
global Gem1_Y := 189
global Gem2_X := 1876	; 背包座標
global Gem2_Y := 721
;=======================================================================


; 腳本啟用與關閉，快捷鍵: End
~End::
    ACTIVATED := !ACTIVATED
    if(ACTIVATED){
		ToolTip, 打怪模式已啟用
		SetTimer, RemoveToolTip, 5000
	}else if(!ACTIVATED){
		ToolTip, 打怪模式已關閉
		SetTimer, RemoveToolTip, 5000
	}

    ; 打怪模式啟用時，同時也開啓了自動喝水
    while(ACTIVATED){
        Flask_when_LowLife()
        Flask_when_DamgeTaken()
    }
    return

; 當瀕血(35%)時，按 1 喝紅水
Flask_when_LowLife(){
	if WinActive("Path of Exile"){
		PixelGetColor, color, LowLife_X, LowLife_Y
		if(color != LowLife_Color){
			Send, {1}

			; Won't trigger again in 2 sec
			Sleep 2000
		}
	}
    return
}

; 當血量低於 95% 時，按 23 喝堅岩藥劑(2)與翠玉藥劑(3)
Flask_when_DamgeTaken(){
	if WinActive("Path of Exile"){
		PixelGetColor, color, LessensDamage_X, LessensDamage_Y
		if(color != LessensDamage_Color) and (LessensDamageBuff_Expired){
			Send, {2}
			RandomSleep(56, 68)

			Send, {3}
			RandomSleep(56, 68)

			LessensDamageBuff_Expired := false

			; Won't trigger again in 4.8 sec
			SetTimer, WaitForFlaskCD, 4800
		}
	}
    return
}

~RButton::
	if(ACTIVATED){
		Send, {XButton2}		; 當按下旋風斬(右鍵)時，自動施放號召(側前鍵)
		KeyWait, RButton, T1	; 當旋風斬(右鍵)超過 1 秒，使用迷霧藥劑(4)
		Check_if_Still_Holding:
		if(ErrorLevel){
			Send {4}
			KeyWait, RButton, T6
			gosub, Check_if_Still_Holding
		}
	}
	return

; 當使用暗影迷蹤(Q)，自動施放骸骨鎧甲(側後鍵)與瓦爾優雅(中鍵)
~Q::
    if(ACTIVATED){
        Send, {XButton1}
        RandomSleep(56,68)

        Send, {MButton}
        RandomSleep(56,68)

		; Won't trigger again in 0.5 sec
		Sleep 500
    }
    return

; 按 Alt+E 切換靈魂奉獻技能寶石
!E::
    Keywait, Alt
  	BlockInput On
    MouseGetPos xx, yy

  	Send {i}
    RandomSleep(56,68)

    MouseMove %Gem1_X%, %Gem1_Y%
    RandomSleep(56,68)
    Click, Right
  	RandomSleep(56,68)

    MouseMove %Gem2_X%, %Gem2_Y%
  	RandomSleep(56,68)
  	Click
  	RandomSleep(56,68)

    MouseMove %Gem1_X%, %Gem1_Y%
  	RandomSleep(56,68)
  	Click
  	RandomSleep(56,68)

    Send {i}
  	MouseMove, xx, yy, 0
    BlockInput Off

;============================== Sub-Functions ==============================
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
