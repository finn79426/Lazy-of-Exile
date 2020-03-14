# Lazy of Exile

![](https://img.shields.io/badge/%E7%9B%AE%E5%89%8D%E6%94%AF%E6%8F%B4%E5%8F%B0%E6%9C%8D-3.9-greensvg)
![](https://img.shields.io/badge/license-GPL-black.svg)

致新手：

外掛用 AutoHotKey 寫的，原理就是**模擬鍵盤滑鼠的動作**，程式碼幫你解放雙手。

低調自己用不會被鎖，官方不會花太多成本抓 "非人類可以執行的操作速度" 的外掛上，畢竟沒有修改客戶端記憶體。

從國外抓的腳本部分功能不能用在台服，台服的腳本的某些功能還需要花台幣買 (而且還有可能暗藏病毒...)。

不要浪費錢了，自己寫腳本也是一種樂趣不是嗎？

這邊開源我自己寫的腳本，給想要自己寫的人當參考，Code 都蠻醜的哈哈，不想花太多時間在這上面優化，能動就好。

不會提供公版，後續更新也隨緣，設定得自己慢慢摸索。我也不想擋外掛商的財路，懶得搞就去買商業版吧~

# Feature

腳本分爲一般通用與角色專用。

一般通用只要設定好，可以適用任何角色。

一般通用的功能包含：

1. 當移動(左鍵)超過 0.8 秒，使用水銀藥劑(5)
    - 藥劑防呆 - 在增益效果持續時間內不會重複喝水
2. 按 Alt+Q 鍵開啓傳送門
3. 按 Z 回到倉庫第一頁
4. 按 F2 將物品放到倉庫
5. 按 F4 切回倉庫第一頁
6. 按 F5 從城鎮進入藏身處
7. 按 F6 暫離模式
8. 按 F7 修正錯位
9. 按 F12 顯示快截鍵列表

角色專用需要根據不同 Build、不同的技能面板配置組合成適合自己的腳本。

目前角色專用版已實現的功能有：

1. 當瀕血(35%)時自動喝紅水
2. 當血量低於 95% 時自動喝減傷藥水
3. 使用技能時自動施放 Buff
4. 引導時喝水
    - 讀秒循環 - 時間到了就會喝水
5. 快速切換技能寶石

# Usage

## 通用版

通用版簡單設定座標與倉庫頁就能用，大部分設置在腳本裡面都有說明，這裡是額外說明。

**使用前請將遊戲設定爲全螢幕視窗模式**，目前的設定值都是在 1920x1080 解析度下進行設定。

你需要設定的項目：

- 放在背包裡的傳送卷軸座標
- 倉庫頁號設定
  - 頁號可以重複
  - 例：油瓶跟器官我都設定爲 6，代表這兩個類型的物品都會被放到同一頁倉庫
- 水銀藥劑 Buff 圖示偵測範圍
- 水銀藥劑 Buff 圖片

上面設定都可以在 `一般通用.ahk` 裡的 `動態設定` 找到。靜態設定一律不要動到，除非你真的瞭解自己在做什麼。

設定好後，雙擊 ahk 腳本就運行囉。

---

執行 `獲取座標與顏色.ahk` 後按 `Alt+O` 可以獲取當前游標所在位置的座標與色碼。

---

倉庫頁號設定，有幾頁倉庫頁就 `MaximumTab` 就是多少，然後接著標示每個倉庫是放什麼類型的物品。

目前支援的物品分類：

1. 通貨倉
2. 輿圖倉
3. 精髓倉
4. 命運卡
5. 碎片
6. 催化劑
7. 掘獄收藏
8. 凋落油瓶
9. 鍊魔器官
10. 商店配方 (技能寶石、製圖白錘、藥水)
11. 賣場 (自行設定哪些物品要放到賣場)

最左邊第一頁會被程式認爲 `0`，若物品沒有被歸納在任意一類，則會丟到 `OtherTab` (例如裝備)。

---

水銀藥劑智能防呆的原理是檢測光環 Buff 區有沒有水銀藥劑的 Buff 圖示，要給定 Buff 區的範圍。

給定 P1 與 P2 的座標，程式會自動依照這兩點畫一個矩形，此矩形就是偵測範圍

矩形範圍不要給太大，會影響電腦效能，矩形越小對效能越高。建議大概抓 P1 是 `0, 0`，P2 是小地圖的左下角即可。

`Quicksilver_Status_Icon.jpeg` 是程式尋找的目標，建議自己截圖抓圖示 (預設是 1920x1080 解析度下截的圖)，然後把旁邊的黃色框框去掉。

> 註: 當滑鼠指向怪物，螢幕上方會出現怪物的血條；血條擋到 Buff 圖示，程式可能會判定沒有 Buff 而重複喝水，這個無法避免 Orz

---

## 進階版

請有程式編程基礎的人自行參考。

---

# 拓荒雙水銀

給拓荒前期會拿兩隻水銀跑主線的人用的，程式會優先喝設定好的主力那隻水銀藥劑，當主力藥劑喝完時才喝備用藥劑。

預設主力藥劑放在 5，備用藥劑放在 4。

如果要搭配 `一般通用.ahk` 一起用，請先把 `一般通用.ahk` 的 `~LButton` 代碼塊註解掉，否則你會重複喝水銀。

# To-Do

1. 快速查價
2. 殘血自動退出角色 (防止扣經驗)