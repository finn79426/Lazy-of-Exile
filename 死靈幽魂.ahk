;#IfWinActive, Path of Exile
#SingleInstance force
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#Persistent ; Stay open in background
#MaxThreadsPerHotkey 1

;========================== 技能面板配置 ============================
; 技能配置
; 滑鼠左鍵 - 移動
; 滑鼠右鍵 - 旋風斬
; Q 鍵 - 暗影迷蹤
; WE 鍵 - 死亡標記
; R 鍵 - 烈焰衝刺
; Ctrl + QW(E) - 光環
; Ctrl + (E)R - 召喚物
; 滑鼠側前鍵- 號召
; 滑鼠側後鍵- 骸骨鎧甲
; 滑鼠中鍵 - 瓦爾優雅
;============================== 邏輯 ==============================
; 按 End 鍵啓動此腳本，進入打怪狀態
; 按 Alt+Q 鍵開啓傳送門
; 按 F5 從城鎮進入傳送處
; 按 F6 暫離模式
; 按 F7 修正錯位
; 當瀕血(35%)時，按 1 喝紅水
; 當血量低於 95% 時，按 23 喝堅岩藥劑(2)與翠玉藥劑(3)
; 當移動(左鍵)超過 0.5 秒，使用水銀藥劑(5)
; 當按下旋風斬(右鍵)時，自動施放號召(側前鍵)
; 當旋風斬(右鍵)超過 1 秒，使用迷霧藥劑(4)
; 當使用暗影迷蹤(Q)，自動施放骸骨鎧甲(側後鍵)與瓦爾優雅(中鍵)
;============================== 備註 ==============================
; 自動喝水是檢測血量的顏色是否異常 (血量不是紅色)，所以黑暗挖礦不適用自動喝水
;============================== To-Do ==============================
; 把第一行註解拿到才能只在 POE 裡運行腳本
; 給定偵測 Buff icon 的矩形座標
; 測試水銀藥劑的 icon 能不能成功在遊戲內抓到
; 添加自動清背包，把東西丟到倉庫的功能
;   測試不判斷物品名稱的清包
;   開發清包暫停鍵
;   開發半自動清包，適用於只需要快速找到單一物品所需要放置的倉庫頁位置
; 分離角色打怪專用與通用腳本，通用腳本功能包含: 自動喝水銀、快速開傳送門、快速指令(藏身處)
;============================== 靜態設置 ==============================
global ACTIVATED := false
global LessensDamageBuff_Expired := true
;============================== 動態設置 ==============================
; 瀕血喝水座標設定
global LowLife_X := 95
global LowLife_Y := 1007
global LowLife_Color := 0x120D6E
; 減傷喝水座標設定
global LessensDamage_X := 95
global LessensDamage_Y := 884
global LessensDamage_Color := 0x241E53
global LessensDamage_CD := 4800

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
			RandomSleep(10,50)
			Send, {3}

			LessensDamageBuff_Expired := false
			SetTimer, WaitForFlaskCD, 4850
		}
	}
    return
}

; 當使用暗影迷蹤(Q)，自動施放骸骨鎧甲(側後鍵)與瓦爾優雅(中鍵)
~Q::
    if(ACTIVATED){
        Send, {XButton1}
        Random, rand, 10, 50
        Sleep rand
        Send, {MButton}
        Sleep 500
    }
    return


;============================== Sub-Functions ==============================
RemoveToolTip(){
    SetTimer, RemoveToolTip, Off
    ToolTip
    return
}

RandomSleep(min,max){
	Random, r, %min%, %max%
	r:=floor(r/Speed)
	Sleep %r%
	return
}

; 避免減傷水在有效時間內重複喝，且異步執行不會卡其他更重要的 Threads (例如瀕血喝水)
WaitForFlaskCD(){
    LessensDamage_Expire := true
    return
}

;==================================================================

; 通貨關鍵字：
; 精髓關鍵字:
; 碎片關鍵字: