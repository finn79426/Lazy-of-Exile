#IfWinActive, Path of Exile
#SingleInstance force
#NoEnv      ; Recommended for performance and compatibility with future AutoHotkey releases.
#Persistent ; Stay open in background
#MaxThreadsPerHotkey 2	; 爲了開關 Hotkey，必須要有第 2 個 Thread
#Include %A_WorkingDir%\..\GeneralFunc.ahk
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
; 滑鼠中鍵 - 熔岩護盾
; 滑鼠右鍵 - 旋風斬
; Q 鍵 - 鮮血狂怒
; W 鍵 - 瓦爾．熔岩護盾
; E 鍵 - 瓦爾．先祖戰士長
; R 鍵 - 重盾衝鋒4
; T 鍵 - 血腥沙戮
; Ctrl + Q - 血肉骸骨
; Ctrl + W - 純淨之捷
; Ctrl + E - 恐懼之旗
; 滑鼠側前鍵 - 烈焰衝刺
; 1 - 禁果
; 2 - 獅吼精華
; 3 - 化學家的加速之真銀藥劑
; 4 - 耐久的守護之永恆魔力藥劑
;=============================== 邏輯 ================================
; 按 End 鍵啓動此腳本，進入打怪狀態
; 當瀕血(35%)時，按 1 喝禁果補血
; 當按下旋風斬(右鍵)時：
;   按鮮血狂怒(Q)
;		若已在鮮血狂怒持續時間內，則略過不按
;   按熔岩護盾(滑鼠中鍵)
;		若已在熔岩護盾持續時間內(包含瓦爾)，則略過不按
; 當按下旋風斬(右鍵)超過 1 秒時：
;   喝獅吼精華(2)
;       若已在獅吼藥水持續時間內，則略過不喝
;       藥劑持續時間 4 秒 => 每 4.1 秒重新檢測一次
;   喝真銀藥劑(3)
;       若已在真銀藥劑持續時間內，則略過不喝
;       藥劑持續時間 6 秒 => 每 6.1 秒重新檢測一次
;   喝魔力藥劑(4)
;       若已在魔力藥劑持續時間內，則略過不喝
;       藥劑持續時間 4.9 秒 => 每 5.0 秒重新檢測一次
;   按鮮血狂怒(Q) (需要實際測試效果，有沒有硬直影響、使用效率、狂怒球持續時間等等)
; 按 Alt+E 切換 增大範圍 / 集中效應 輔助
;================================ 備註 ================================
; 自動喝水是檢測血量的顏色是否異常 (血量不是紅色就會喝)，所以黑暗挖礦不適用自動喝水
; 過場換圖時也會因爲血量座標顏色異常而觸發自動喝水，但影響不大
;=============================== 靜態設置 ==============================
global ACTIVATED := false
global LionsRoar_Expired := true
global SilverFlask_Expired := true
global ManaFlask_Expired := true
;=============================== 動態設置 ==============================
; 瀕血喝水座標設定
global LowLife_X := 95
global LowLife_Y := 1007
global LowLife_Color := 0x120D6E
; 技能寶石切換設定
global Gem1_X := 0		; 裝備座標
global Gem1_Y := 0
global Gem2_X := 1876	; 背包座標
global Gem2_Y := 721
; 藥劑偵測設定
global BuffIconRange_P1_X := 0		; Buff Icon 範圍
global BuffIconRange_P1_Y := 0
global BuffIconRange_P2_X := 1641
global BuffIconRange_P2_Y := 90
global LionsRoar := "獅吼精華_狀態.png"
global SilverFlask := "猛攻水_狀態.png"
global ManaFlask := "免疫詛咒_狀態.png"		; 耐久的守護之永恆魔力藥劑
; 增益技能偵測設定
global BloodRage := "鮮血狂怒_狀態.png"
global MoltenShell := "熔岩護盾_狀態.png"
;=======================================================================

; 腳本啟用與關閉，快捷鍵: End
~End::
	KeyWait, End
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
    }
    return

#MaxThreadsPerHotkey 1
~RButton::
	if(ACTIVATED){
		; 當按下旋風斬(右鍵)時，且沒有在鮮血狂怒的持續時間內，自動施放鮮血狂怒(Q)
		ImageSearch, , , BuffIconRange_P1_X, BuffIconRange_P1_Y, BuffIconRange_P2_X, BuffIconRange_P2_Y, %BloodRage%
		if(ErrorLevel){
			Send, {Q}
			RandomSleep(56,68)
		}


		; 當按下旋風斬(右鍵)時，且沒有在熔岩護盾的持續時間內，自動施放熔岩護盾(滑鼠中鍵)
		ImageSearch, , , BuffIconRange_P1_X, BuffIconRange_P1_Y, BuffIconRange_P2_X, BuffIconRange_P2_Y, %MoltenShell%
		if(ErrorLevel){
			Send, {MButton}
			RandomSleep(56,68)
		}

		Checkif_RButton_Still_Holding:
		KeyWait, RButton, T1	; 當旋風斬(右鍵)超過 1 秒，喝各種藥劑
		if(ErrorLevel){
			gosub, Use_LionsRoar
			gosub, Use_SilverFlask
			gosub, Use_ManaFlask
			goto, Checkif_RButton_Still_Holding
		}
		return
	}
	return

Use_LionsRoar:
	if LionsRoar_Expired{
		ImageSearch, , , BuffIconRange_P1_X, BuffIconRange_P1_Y, BuffIconRange_P2_X, BuffIconRange_P2_Y, %LionsRoar%
		if(ErrorLevel){
			Send {2}
			LionsRoar_Expired := false
			SetTimer, WaitForLionsRoarCD, 4100
		}
	}
	return

WaitForLionsRoarCD:
	LionsRoar_Expired := true
    return


Use_SilverFlask:
	if SilverFlask_Expired{
		ImageSearch, , , BuffIconRange_P1_X, BuffIconRange_P1_Y, BuffIconRange_P2_X, BuffIconRange_P2_Y, %SilverFlask%
		if(ErrorLevel){
			Send {3}
			SilverFlask_Expired := false
			SetTimer, WaitForSilverFlaskCD, 6100
		}
	}
	return

WaitForSilverFlaskCD:
	SilverFlask_Expired := true
    return


Use_ManaFlask:
	if ManaFlask_Expired{
		ImageSearch, , , BuffIconRange_P1_X, BuffIconRange_P1_Y, BuffIconRange_P2_X, BuffIconRange_P2_Y, %ManaFlask%
		if(ErrorLevel){
			Send {4}
			ManaFlask_Expired := false
			SetTimer, WaitForManaFlaskCD, 5000
		}
	}
	return

WaitForManaFlaskCD:
	ManaFlask_Expired := true
    return


; 當瀕血(35%)時，按 1 喝紅水
Flask_when_LowLife(){
	if WinActive("Path of Exile"){
		PixelGetColor, color, LowLife_X, LowLife_Y
		if(color != LowLife_Color){
			Send, {1}

			; Won't trigger again in 4 sec
			Sleep 4000
		}
	}
    return
}



#MaxThreadsPerHotkey 1
; 按 Alt+E 切換 增大範圍 / 集中效應 輔助
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