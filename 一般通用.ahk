#IfWinActive, Path of Exile
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
; 當移動(左鍵)超過 0.8 秒，使用水銀藥劑(5)
;   水銀增益狀態下，不會再使用水銀藥劑
; 按 Alt+Q 鍵開啓傳送門
; 按 F4 回到倉庫第一頁
; 按 F2 將物品放到倉庫
;   使用前請先按 Z 進行重設避免出問題
; 按 F3 清理背包
; 按 F5 從城鎮進入藏身處
; 按 F6 暫離模式
; 按 F7 修正錯位
; 按 F12 顯示快截鍵列表
;============================== 備註 ==============================
; 爲了避免太容易出問題，所有熱鍵都是 Single Thread
;   代表當某個功能正在執行時，沒辦法暫停，只能等它跑完 (例如背包全部清空)
;============================== 靜態設置 ==============================
global CurrentTab = 0
;============================== 動態設置 ==============================
; 傳送卷軸座標設定
global PortalScroll_X=1877
global PortalScroll_Y=824
; 倉庫頁號設定 (第一頁請設定爲 0)
global MaximumTab := 9   ; 你有多少倉庫頁？
global CurrencyTab := 1  ; 通貨頁
global MapTab := 2       ; 輿圖頁
global EssenceTab := 3   ; 精髓頁
global CardTab := 4      ; 命運卡頁
global FragmentTab := 5  ; 碎片頁
global CatalystTab := 6  ; 催化劑頁
global FossilTab := 6    ; 掘獄收藏頁
global OilTab := 6       ; 凋落油瓶頁
global MetamorphTab := 6 ; 鍊魔器官頁
global RecipesTab := 6   ; 商店配方頁
global SellTab := 8      ; 賣場頁
global OtherTab := 0     ; 不屬於上面的物品都放這一頁
; 水銀藥劑偵測設定
global BuffIconRange_P1_X := 0
global BuffIconRange_P1_Y := 0
global BuffIconRange_P2_X := 1641
global BuffIconRange_P2_Y := 276
global QuickSliver := "Quicksilver_Status_Icon.jpg"
;============================== 物品辨識 ==============================
global Currencies := ["磨刀石", "知識卷軸", "混沌石", "護甲片", "卡蘭德的魔鏡", "點金石", "機會石", "後悔石", "蛻變石", "改造石", "重鑄石", "崇高石", "富豪石", "增幅石", "傳送卷軸", "玻璃彈珠", "寶石匠的稜鏡", "幻色石", "鏈結石", "工匠石", "神聖石", "祝福石", "製圖釘", "卷軸碎片", "瓦爾寶珠", "普蘭德斯金幣", "銀幣", "遺忘的污染器皿", "製圖六分儀", "無效石", "束縛石", "地平石", "神諭石", "工程石", "古變石", "魔鏡碎片"]

global Maps := ["地圖階級", "輿圖地區"]

global Essences := ["之低語精髓", "之呢喃精髓", "之啼泣精髓", "之哀嚎精髓", "之咆哮精髓", "之尖嘯精髓", "之破空精髓"]

global Cards := ["稀有度: 命運卡"]

global Fragments := ["索伏裂片", "托沃裂片", "艾許裂片", "烏爾尼多裂片", "夏烏拉裂片", "永恆卡魯裂片", "永恆馬拉克斯裂片", "永恆不朽帝國裂片", "永恆聖宗裂片", "永恆瓦爾裂片", "女神祭品", "午夜的奉獻", "黎明的奉獻", "正午的奉獻", "黃昏的奉獻", "凡人的憤怒", "凡人的希望", "凡人的無知", "凡人的哀傷", "希伯之鑰", "伊瑞之鑰", "茵雅之鑰", "福庫爾之鑰", "鳳凰斷片", "牛頭斷片", "奇美拉斷片", "九頭蛇斷片", "奴役斷片", "根除斷片", "干擾斷片", "淨化斷片", "恐懼斷片", "空虛斷片", "雕塑斷片", "智慧斷片", "聖甲蟲：", "眾神聖器", "索伏的祝福", "托沃的祝福", "艾許的祝福", "烏爾尼多的祝福", "夏烏拉的祝福"]

global Catalysts := ["洶湧的催化劑", "充能的催化劑", "研磨的催化劑", "冶鍊的催化劑", "富饒的催化劑", "多稜的催化劑", "本質的催化劑"]

global Fossils := ["化石", "鑄新儀"]

global Oils := ["油瓶"]

global Metamorphoses := ["的 腦髓", "的 眼睛", "的 肝臟", "的 肺臟", "的 心臟"]

global Recipes := ["稀有度: 寶石", "石錘", "破岩錘", "堅錘", "生命藥劑", "魔力藥劑", "複合藥劑", "紅玉藥劑", "藍玉藥劑", "黃玉藥劑", "堅岩藥劑", "水銀藥劑", "紫晶藥劑", "石英藥劑", "翠玉藥劑", "石化藥劑", "海藍藥劑", "迷霧藥劑", "硫磺藥劑", "真銀藥劑", "灰岩藥劑", "寶鑽藥劑"]

global Sell := ["豐裕牌組"]
;=====================================================================


; 當移動(左鍵)超過 0.8 秒，使用水銀藥劑(5)
/*
    當按下左鍵

    0. 開始計時
    1. 左鍵有按壓超過 0.8 秒？
    1-1. 沒有 -> 結束
    1-2. 有 -> 進入 2
    2. 有 buff icon 存在嗎？
    2-1. 有 -> 返回 0
    2-2. 沒有 -> 喝水! 休息 4.8 秒後進入 3
    3. 回到 0
*/
~LButton::
    CheckAgain:
	KeyWait, LButton, T0.8
	if(ErrorLevel){
		if WinActive("Path of Exile"){
			ImageSearch, , , BuffIconRange_P1_X, BuffIconRange_P1_Y, BuffIconRange_P2_X, BuffIconRange_P2_Y, %QuickSliver%
			if(ErrorLevel){
                Send {5}
				Sleep 4800
				gosub, CheckAgain
			} else if(ErrorLevel == 2){
                MsgBox, %QuickSliver% format error!!!
            }
		}
	}
	return

; 按 Alt+Q 鍵開啓傳送門
!Q::
    Keywait, Alt
	BlockInput On
	MouseGetPos xx, yy

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

; 當前物品自動歸倉
F2::
    Keywait, F2
    ToolTip, 歸倉中...

    oldClip := clipboard
    StashItem()
    clipboard := oldClip

    ToolTip, 歸倉完成!!!
    SetTimer, RemoveToolTip, 1000
    return


; 回到倉庫第一頁
~F4::
ResetToTab0:
    Keywait, F4
    Loop %MaximumTab%{
        Send {Left}
        Sleep 1
    }
    CurrentTab := 0
    return

; 按 F5 從城鎮進入藏身處
F5::
    BlockInput On
    oldClip := clipboard
    clipboard := "/hideout"
    Send {Enter}
    Sleep 2
    SendInput ^v
    Sleep 2
    Send {Enter}
    clipboard := oldClip
    BlockInput Off
    return
    return

; 按 F6 暫離模式
F6::
    BlockInput On
    oldClip := clipboard
    clipboard := "/afk"
    Send {Enter}
    Sleep 2
    SendInput ^v
    Sleep 2
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
    SendInput ^v
    Sleep 2
    Send {Enter}
    clipboard := oldClip
    BlockInput Off
    return

F12::
    ToolTip, 按 Alt+Q 鍵開啓傳送門`n按 F4 回到倉庫第一頁`n按 F2 將物品放到倉庫`n使用前請先按 Z 進行重設避免出問題`n按 F3 清理背包`n按 F5 從城鎮進入藏身處`n按 F6 暫離模式`n按 F7 修正錯位`n按 F12 顯示快截鍵列表
    SetTimer, RemoveToolTip, 5000


;============================== Sub-Functions ==============================
; 自動歸倉主程式
StashItem(){
    clipboard := ""
    Send ^c
    ClipWait, 0.5

    ; Preliminary Parse the Clipboard to Reduce CPU Performance Costs
    item := StrSplit(clipboard, "--------")[1]

    ; 我就懶! 語法就醜! 能快速看懂最重要~
    if InStash(item, Currencies){
        locate := CurrencyTab
    } else if InStash(item, Maps){
        locate := MapTab
    } else if InStash(item, Essences){
        locate := EssenceTab
    } else if InStash(item, Cards){
        locate := CardTab
    } else if InStash(item, Fragments){
        locate := FragmentTab
    } else if InStash(item, Catalysts){
        locate := CatalystTab
    } else if InStash(item, Fossils){
        locate := FossilTab
    } else if InStash(item, Oils){
        locate := OilTab
    } else if InStash(item, Metamorphoses){
        locate := MetamorphTab
    } else if InStash(item, Recipes){
        locate := RecipesTab
    } else if InStash(item, Sell){
        locate := SellTab
    } else {
        ; 直接抓輿圖名稱可能會發生誤判，需要特別處理
        item := StrSplit(clipboard, "--------")[2]
        if InStash(item, Maps){
            locate := MapTab
        } else {
            locate := OtherTab
        }
    }

    offset := locate - CurrentTab

    if(offset > 0){
        SwitchTab(offset, "R")
    } else if (offset < 0){
        offset := Abs(offset)
        SwitchTab(offset, "L")
    }

    Send {Ctrl Down}
    Sleep 1
    Send {Click}
    Sleep 1
    Send {Ctrl Up}
    Sleep 1
}

; 字典判斷，適用於清包功能
HasVal(haystack, needle) {
	if !(IsObject(haystack)) || (haystack.Length() = 0)
		return 0
	for index, value in haystack
		if (value = needle)
			return index
	return 0
}

; 字串判斷，適用於智能歸倉
InStash(item, dict){
    for k, c in dict
        If Instr(item, c)
            return true
    return false
}

; 切換到指定的倉庫頁
SwitchTab(step, direction){
    switch direction{
        Case "R":
            Loop %step% {
                Send {Right}
                CurrentTab++
                Sleep 1
            }
        Case "L":
            Loop %step% {
                Send {Left}
                CurrentTab--
                Sleep 1
            }
    }
    return
}


RandomSleep(min,max) {
    Random, rand, %min%, %max%
    Sleep %rand%
    return
}

RemoveToolTip(){
    SetTimer, RemoveToolTip, Off
    ToolTip
    return
}