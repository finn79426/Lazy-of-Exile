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
; 按 Z 回到倉庫第一頁 (作爲重設使用)
; 按 F3 清理背包
; 按 F5 從城鎮進入傳送處
; 按 F6 暫離模式
; 按 F7 修正錯位
;============================== 備註 ==============================
; 爲了避免太容易出 Bug 或誤判，所有熱鍵都是 Single Thread
;   代表當某個功能正在執行時，沒辦法暫停，只能等它跑完 (例如背包全部清空)
;============================== To-Do ==============================
; 把第一行註解拿到才能只在 POE 裡運行腳本
; 給定偵測 Buff icon 的矩形座標
; 需要測試 Alt+Q 開啓傳送門是否正常運作
; 需要測試自動喝水銀是否正常運作
; 添加自動清背包，把東西丟到倉庫的功能
;   添加智能丟倉功能
;   開發清包暫停鍵
;   開發半自動清包，適用於只需要快速找到單一物品所需要放置的倉庫頁位置
;============================== 靜態設置 ==============================
global CurrentTab = 0
;============================== 動態設置 ==============================
; 傳送卷軸座標設定
global PortalScroll_X=1877
global PortalScroll_Y=824
; 自動清包設定
global IgnoreGrids := [59, 60]  ; 略過的背包欄位
global Inventory_Grid1_X := 22  ; 1296
global Inventory_Grid1_Y := 166 ; 613
global Offset_X := 53
global Offset_Y := 54
; 倉庫頁號設定 (第一頁請設定爲 0)
global MaximumTab := 9   ; 你有多少倉庫頁？
global CurrencyTab := 1  ; 通貨頁
global MapTab := 2       ; 輿圖頁
global EssenceTab := 3   ; 精髓頁
global CardTab := 4      ; 命運卡頁
global FragmentTab := 5  ; 碎片頁
global CatalystTab := 6  ; 催化劑頁
global FossilTab := 6    ; 掘獄化石頁
global OilTab := 6       ; 凋落油瓶頁
global MetamorphTab := 6 ; 鍊魔器官頁
global RecipesTab := 6   ; 商店配方頁
global SellTab := 8      ; 賣場頁
global OtherTab := 0     ; 不屬於上面的物品都放這一頁
; 水銀藥劑偵測設定
global BuffIconRange_P1_X := 212
global BuffIconRange_P1_Y := 197
global BuffIconRange_P2_X := 301
global BuffIconRange_P2_Y := 271
global QuickSliver := "Quicksilver_Flask_status_icon.png"
;============================== 物品辨識 ==============================
Currencies := ["磨刀石", "知識卷軸", "混沌石", "護甲片", "卡蘭德的魔鏡", "點金石", "機會石", "後悔石", "蛻變石", "改造石", "重鑄石", "崇高石", "富豪石", "增幅石", "傳送卷軸", "玻璃彈珠", "寶石匠的稜鏡", "幻色石", "鏈結石", "工匠石", "神聖石", "祝福石", "製圖釘", "卷軸碎片", "蛻變石碎片", "改造石碎片", "點金石碎片", "瓦爾寶珠", "普蘭德斯金幣", "銀幣", "遺忘的污染器皿", "製圖六分儀．簡易", "製圖六分儀．精華", "製圖六分儀．覺醒", "無效石", "束縛石", "地平石", "神諭石", "工程石", "古變石", "無效石碎片", "束縛石碎片", "地平石碎片", "神諭石碎片", "工程石碎片", "古變石碎片", "混沌石碎片", "魔鏡碎片", "崇高石碎片", "富豪石碎片"]

Maps := ["如履危牆", "白沙灘頭", "墮影墓場", "禁魂炎獄", "危城巷弄", "穢陰獄牢", "貧瘠之地", "乾枯湖岸", "洪災礦坑", "惡臭沼地", "極原冰帽", "羈破牢籠", "毒菌魔域", "挖掘場", "荒涼牧野", "乾潮林地", "失落城塢", "旱地墓室", "幽魂監牢", "崩壞長廊", "危城廣場", "古典密室", "失序教院", "致命岩灘", "古堡", "幽暗地穴", "冰川山丘", "火山炎域", "絕望燈塔", "炙陽峽谷", "寧逸溫房", "硫磺蝕岸", "幽魂宅邸", "冥神之域", "秘密通道", "腐敗下水道", "遠古危城", "象牙神殿", "巨蛛巢穴", "熱林塚墓", "靜縊陵墓"]

Essences := ["之低語精髓", "之呢喃精髓", "之啼泣精髓", "之哀嚎精髓", "之咆哮精髓", "之尖嘯精髓", "之破空精髓"]

Cards := ["稀有度: 命運卡"]

Fragments := ["索伏裂片", "托沃裂片", "艾許裂片", "烏爾尼多裂片", "夏烏拉裂片", "索伏的祝福", "托沃的祝福", "艾許的祝福", "烏爾尼多的祝福", "夏烏拉的祝福", "永恆卡魯裂片", "永恆馬拉克斯裂片", "永恆不朽帝國裂片", "永恆聖宗裂片", "永恆瓦爾裂片", "女神祭品", "	午夜的奉獻", "黎明的奉獻", "正午的奉獻", "黃昏的奉獻", "凡人的憤怒", "凡人的希望", "凡人的無知", "凡人的哀傷", "希伯之鑰", "伊瑞之鑰", "茵雅之鑰", "福庫爾之鑰", "鳳凰斷片", "牛頭斷片", "奇美拉斷片", "九頭蛇斷片", "奴役斷片", "根除斷片", "干擾斷片", "淨化斷片", "恐懼斷片", "空虛斷片", "雕塑斷片", "智慧斷片", "聖甲蟲："]

Catalysts := ["洶湧的催化劑", "充能的催化劑", "研磨的催化劑", "冶鍊的催化劑", "富饒的催化劑", "多稜的催化劑", "本質的催化劑"]

Fossils := ["暴炎化石", "寒風化石", "金鋼化石", "鋸齒化石", "特異化石", "原始化石", "稠密化石", "斑駁化石", "三相化石", "神幻化石", "利齒化石", "明透化石", "顫慄化石", "畛域化石", "無瑕化石", "附魔化石", "鑲飾化石", "雕琢化石", "血漬化石", "鏤空化石", "破裂化石", "雕紋化石", "紊亂化石", "神聖化石", "鑲金化石"]
Oils := ["清透油瓶", "深褐油瓶", "琥珀油瓶", "翠綠油瓶", "清綠油瓶", "碧藍油瓶", "奼紫油瓶", "緋紅油瓶", "漆黑油瓶", "乳白油瓶", "純銀油瓶", "金黃油瓶"]

Metamorphoses := []

Recipes := ["石錘", "破岩錘", "堅錘", "永恆生命藥劑", "不朽生命藥劑", "聖化生命藥劑", "永恆魔力藥劑", "不朽魔力藥劑", "聖化魔力藥劑", "祝福複合藥劑", "紅玉藥劑", "藍玉藥劑", "黃玉藥劑", "堅岩藥劑", "水銀藥劑", "紫晶藥劑", "石英藥劑", "翠玉藥劑", "石化藥劑", "海藍藥劑", "迷霧藥劑", "硫磺藥劑", "真銀藥劑", "灰岩藥劑", "寶鑽藥劑"]

Sell := ["豐裕牌組"]
;=====================================================================


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
                MsgBox, Image format error!!!
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

; 當前物品自動歸倉
F2::
    Keywait, F2
    BlockInput On
    ; Backup clipboard
    ; Send ^c
    ; Parse the item name....
    ; Send {NumN} to switch Stash Tab...
    ; Send {Click}
    Send {Ctrl Down}{Click}{Ctrl Up}
    RandomSleep(10, 20)
    ; Recovery clipboard
    BlockInput Off
    return

; 背包全部自動歸倉
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
            ; Backup clipboard
            ; Send ^c
            ; Parse the item name....
            ; Send {NumN} to switch Stash Tab...
            ; Send {Click}
            Send {Ctrl Down}{Click}{Ctrl Up}
            RandomSleep(10, 20)
            ; Recovery clipboard

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