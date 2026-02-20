-- [[ KZOYZ HUB - HOW TO USE MODULE (INJECTED) ]] --
local TargetPage = ...
if not TargetPage then warn("Module harus di-load dari Kzoyz Index!") return end

-- [[ FIX SCROLL MENTOK ]] --
TargetPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
TargetPage.CanvasSize = UDim2.new(0, 0, 0, 0)
local listLayout = TargetPage:FindFirstChildWhichIsA("UIListLayout")
if listLayout then
    TargetPage.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 30)
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TargetPage.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 30)
    end)
end
------------------------------

getgenv().ScriptVersion = "Guide v1.0" 

local Theme = { 
    Item = Color3.fromRGB(45, 45, 45), 
    Text = Color3.fromRGB(255, 255, 255), 
    Purple = Color3.fromRGB(140, 80, 255),
    DarkBg = Color3.fromRGB(30, 30, 30)
}

-- [[ DATABASE TEKS (INDO & ENG) ]] --
local TextIndo = [[
<font size="16"><b>📖 PANDUAN PENGGUNAAN KZOYZ HUB</b></font>

<font size="14"><b>🏭 TAB: PABRIK (Balanced Auto-Farm)</b></font>
Modul ini adalah sistem auto-farming pintar (tanam, panen, hancurin block, dan auto-drop sisa seed) agar tas tidak penuh dan loop berjalan tanpa henti.

<b>Cara Penggunaan:</b>
<b>1. Pilih Item:</b> Klik 🔄 Refresh Tas, lalu pilih item di dropdown Pilih Seed dan Pilih Block.
<b>2. Set Area Kebun:</b> Isi Start X (awal), End X (akhir), dan Y Pos (ketinggian).
<b>3. Set Posisi:</b> Jalan ke tempat hancurin block lalu klik 📍 Set Break Pos. Jalan ke tempat buang seed lalu klik 📍 Set Drop Pos.
<b>4. Atur Angka:</b> 
  - Waktu Tumbuh: Sesuaikan waktu panen (detik).
  - Block Threshold: Sisa minimal block di tas agar tidak habis.
  - Keep Seed Amt: Batas maksimal seed di tas sebelum auto-drop.
<b>5. Mulai:</b> Nyalakan toggle START BALANCED PABRIK.

---

<font size="14"><b>🎒 TAB: MANAGER (Auto Collect & Drop)</b></font>
Modul asisten untuk urusan inventory, berbagi barang, atau mungutin hasil panen.

<b>Auto Collect:</b> Berdiri di lokasi target, klik 📍 Save Pos, lalu nyalakan Enable Auto Collect. Karakter akan otomatis mengambil barang di titik tersebut.
<b>Auto Drop:</b> Pegang item di hotbar, atur Drop Amount, lalu nyalakan Auto Drop. Matikan toggle untuk membersihkan sisa UI prompt secara otomatis.

<i>💡 Info: Anti-AFK sudah tertanam otomatis di semua fitur. Aman ditinggal 24 jam!</i>
]]

local TextEng = [[
<font size="16"><b>📖 KZOYZ HUB USER GUIDE</b></font>

<font size="14"><b>🏭 TAB: PABRIK (Balanced Auto-Farm)</b></font>
This module is a smart auto-farming system (plant, harvest, break blocks, and auto-drop leftover seeds) to prevent full inventory and ensure endless looping.

<b>How to Use:</b>
<b>1. Select Items:</b> Click 🔄 Refresh Tas (Bag), then choose your items in the Pilih Seed & Pilih Block dropdowns.
<b>2. Set Farm Area:</b> Fill in Start X (start point), End X (end point), and Y Pos (height).
<b>3. Set Positions:</b> Walk to your breaking spot and click 📍 Set Break Pos. Walk to your drop spot and click 📍 Set Drop Pos.
<b>4. Configure Values:</b>
  - Waktu Tumbuh: Harvest time (seconds).
  - Block Threshold: Minimum blocks to keep in inventory.
  - Keep Seed Amt: Maximum seeds to keep before auto-dropping.
<b>5. Start:</b> Turn on the START BALANCED PABRIK toggle.

---

<font size="14"><b>🎒 TAB: MANAGER (Auto Collect & Drop)</b></font>
Assistant module for inventory management, sharing items, or collecting drops.

<b>Auto Collect:</b> Stand at your target location, click 📍 Save Pos, then enable Auto Collect. Your character will automatically pick up items at that spot.
<b>Auto Drop:</b> Hold an item in your hotbar, adjust Drop Amount, then enable Auto Drop. Turn off the toggle to automatically clean up leftover UI prompts.

<i>💡 Note: Anti-AFK is automatically embedded in all features. Safe to leave for 24 hours!</i>
]]

-- [[ BIKIN UI ELEMEN UNTUK GUIDE ]] --

-- 1. Container buat tombol Sub-Tab
local TabContainer = Instance.new("Frame", TargetPage)
TabContainer.Size = UDim2.new(1, -10, 0, 35)
TabContainer.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout", TabContainer)
Layout.FillDirection = Enum.FillDirection.Horizontal
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Padding = UDim.new(0, 10)

-- Fungsi bikin tombol sub-tab
local function CreateSubTab(Text, LayoutOrder)
    local Btn = Instance.new("TextButton", TabContainer)
    Btn.Size = UDim2.new(0.5, -5, 1, 0)
    Btn.BackgroundColor3 = Theme.Item
    Btn.Text = Text
    Btn.TextColor3 = Theme.Text
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 12
    Btn.LayoutOrder = LayoutOrder
    local C = Instance.new("UICorner", Btn)
    C.CornerRadius = UDim.new(0, 6)
    return Btn
end

local BtnIndo = CreateSubTab("🇮🇩 Indonesian", 1)
local BtnEng = CreateSubTab("🇬🇧 English", 2)

-- 2. Container buat Teks
local TextFrame = Instance.new("Frame", TargetPage)
TextFrame.Size = UDim2.new(1, -10, 0, 0)
TextFrame.AutomaticSize = Enum.AutomaticSize.Y
TextFrame.BackgroundColor3 = Theme.DarkBg
local TC = Instance.new("UICorner", TextFrame)
TC.CornerRadius = UDim.new(0, 6)
local UIPadding = Instance.new("UIPadding", TextFrame)
UIPadding.PaddingTop = UDim.new(0, 10); UIPadding.PaddingBottom = UDim.new(0, 10)
UIPadding.PaddingLeft = UDim.new(0, 10); UIPadding.PaddingRight = UDim.new(0, 10)

local GuideLabel = Instance.new("TextLabel", TextFrame)
GuideLabel.Size = UDim2.new(1, 0, 0, 0)
GuideLabel.AutomaticSize = Enum.AutomaticSize.Y
GuideLabel.BackgroundTransparency = 1
GuideLabel.Text = TextIndo -- Default Bahasa
GuideLabel.TextColor3 = Theme.Text
GuideLabel.TextSize = 12
GuideLabel.Font = Enum.Font.Gotham
GuideLabel.TextXAlignment = Enum.TextXAlignment.Left
GuideLabel.TextYAlignment = Enum.TextYAlignment.Top
GuideLabel.TextWrapped = true
GuideLabel.RichText = true

-- 3. Logika Tombol Sub-Tab
local function SwitchLanguage(Lang)
    if Lang == "Indo" then
        BtnIndo.BackgroundColor3 = Theme.Purple
        BtnEng.BackgroundColor3 = Theme.Item
        GuideLabel.Text = TextIndo
    else
        BtnEng.BackgroundColor3 = Theme.Purple
        BtnIndo.BackgroundColor3 = Theme.Item
        GuideLabel.Text = TextEng
    end
end

BtnIndo.MouseButton1Click:Connect(function() SwitchLanguage("Indo") end)
BtnEng.MouseButton1Click:Connect(function() SwitchLanguage("Eng") end)

-- Set default ke Indo saat pertama dibuka
SwitchLanguage("Indo")
