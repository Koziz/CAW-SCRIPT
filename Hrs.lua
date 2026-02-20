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

getgenv().ScriptVersion = "Guide v2.0-Technical" 

local Theme = { 
    Item = Color3.fromRGB(45, 45, 45), 
    Text = Color3.fromRGB(255, 255, 255), 
    Purple = Color3.fromRGB(140, 80, 255),
    DarkBg = Color3.fromRGB(30, 30, 30)
}

-- [[ DATABASE TEKS (INDO & ENG) ]] --
local TextIndo = [[
<font size="16"><b>INFORMASI & PANDUAN PENGGUNAAN</b></font>

<font size="14"><b>⚙️ TAB: AUTO FARM</b></font>
Script untuk menghancurkan (Break) dan meletakkan (Place) block berdasarkan posisi Grid karakter Anda saat ini.
<b>Parameter Konfigurasi:</b>
• <b>Break/Place Offset X & Y:</b> Menentukan pergeseran titik target dari posisi karakter. (Contoh: Offset X = 1 berarti target berada 1 Grid di sebelah kanan karakter).
• <b>Farm Amount:</b> Jumlah block yang dieksekusi dalam satu siklus garis lurus. Jika diset ke 3, script akan mengeksekusi 3 Grid berurutan ke arah samping.
• <b>Hit Count:</b> Jumlah pukulan (hit) yang dikirimkan ke server untuk menghancurkan satu block. Sesuaikan angka ini dengan tingkat kekerasan block

---

<font size="14"><b>🏭 TAB: PABRIK</b></font>
Sistem otomasi penuh yang mencakup penanaman, pemanenan, penumpukan (stacking), dan manajemen batas inventory untuk mencegah kapasitas penuh.
<b>Parameter Konfigurasi:</b>
• <b>Pemilihan Item:</b> Gunakan tombol <i>Refresh Tas</i> lalu pilih Seed dan Block yang sesuai dari menu Dropdown.
• <b>Start X, End X, Y Pos:</b> Menentukan garis Grid area penanaman dan pemanenan utama.
• <b>Set Break Pos:</b> Menentukan titik Grid tempat karakter akan berdiri untuk melakukan proses <i>Break & Place (Stacking)</i> secara berulang.
• <b>Set Drop Pos:</b> Menentukan titik Grid tempat karakter akan membuang (drop) kelebihan Seed.
• <b>Waktu Tumbuh (Detik):</b> Jeda waktu tunggu antara proses penanaman dan pemanenan.
• <b>Block Threshold:</b> Batas minimal jumlah Block di inventory. Jika Block menyentuh angka ini, script akan menahan proses Place dan memprioritaskan Break Block untuk memulihkan stok.
• <b>Keep Seed Amt:</b> Batas maksimal Seed yang dipertahankan di inventory. Kelebihan Seed dari angka ini akan otomatis dibuang di lokasi <i>Drop Pos</i>.

---

<font size="14"><b>🎒 TAB: MANAGER</b></font>
pengumpulan barang (Looting) dan pembuangan barang (Dropping).
<b>Fitur Utama:</b>
• <b>Auto Collect:</b> Berdiri di Grid target tempat barang terkumpul, klik <b>Save Pos</b> (menyimpan koordinat Grid X/Y), lalu aktifkan toggle. Karakter akan berjalan secara Grid-by-Grid menuju titik tersebut dan kembali ke posisi asal secara otomatis.
• <b>Auto Drop:</b> Pilih item di Hotbar Anda, atur jumlah pembuangan per eksekusi menggunakan <b>Drop Amount</b>, dan aktifkan toggle. 
<i>Penting: Mematikan toggle Auto Drop akan memicu fungsi Force Restore, yang otomatis membersihkan sisa UI Prompt drop pada layar dan mengembalikan UI standar.</i>
]]

local TextEng = [[
<font size="16"><b>INFORMATION & USER GUIDE</b></font>

<font size="14"><b>⚙️ TAB: AUTO FARM</b></font>
A core execution module for breaking and placing blocks based on your character's current Grid position.
<b>Configuration Parameters:</b>
• <b>Break/Place Offset X & Y:</b> Determines the target grid offset relative to the character. (e.g., Offset X = 1 targets the grid immediately to the right).
• <b>Farm Amount:</b> The number of blocks executed in a single linear cycle. If set to 3, the script processes 3 consecutive grids horizontally.
• <b>Hit Count:</b> The number of hits transmitted to the server to break a single block. Adjust this based on the block's durability.

---

<font size="14"><b>🏭 TAB: PABRIK (Balanced Automation)</b></font>
A fully automated system encompassing planting, harvesting, stacking, and inventory limit management to prevent overflow.
<b>Configuration Parameters:</b>
• <b>Item Selection:</b> Click <i>Refresh Tas</i> and select the specific Seed and Block from the Dropdown menu.
• <b>Start X, End X, Y Pos:</b> Defines the main Grid line for the planting and harvesting sequence.
• <b>Set Break Pos:</b> Sets the specific Grid where the character will stand to execute the continuous <i>Break & Place (Stacking)</i> process.
• <b>Set Drop Pos:</b> Sets the specific Grid where the character will discard excess Seeds.
• <b>Waktu Tumbuh (Seconds):</b> The delay interval between planting and harvesting phases.
• <b>Block Threshold:</b> The minimum allowable Block count in your inventory. Reaching this triggers a priority override, halting placement to focus entirely on breaking and restocking blocks.
• <b>Keep Seed Amt:</b> The maximum number of Seeds retained in the inventory. Any excess is automatically dropped at the <i>Drop Pos</i>.

---

<font size="14"><b>🎒 TAB: MANAGER</b></font>
A utility module for automated looting and item dropping mechanics.
<b>Main Features:</b>
• <b>Auto Collect:</b> Stand on the target loot Grid, click <b>Save Pos</b> (to log the X/Y Grid coordinates), and enable the toggle. The character will navigate grid-by-grid to the target and return automatically.
• <b>Auto Drop:</b> Select an item in your Hotbar, configure the drop quantity per execution via <b>Drop Amount</b>, and activate the toggle.
<i>Important: Disabling the Auto Drop toggle triggers a Force Restore sequence, which clears residual UI Drop Prompts from the screen and restores the default UI.</i>
]]

-- [[ BIKIN UI ELEMEN UNTUK GUIDE ]] --

local TabContainer = Instance.new("Frame", TargetPage)
TabContainer.Size = UDim2.new(1, -10, 0, 35)
TabContainer.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout", TabContainer)
Layout.FillDirection = Enum.FillDirection.Horizontal
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Padding = UDim.new(0, 10)

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

local TextFrame = Instance.new("Frame", TargetPage)
TextFrame.Size = UDim2.new(1, -10, 0, 0)
TextFrame.AutomaticSize = Enum.AutomaticSize.Y
TextFrame.BackgroundColor3 = Theme.DarkBg
local TC = Instance.new("UICorner", TextFrame)
TC.CornerRadius = UDim.new(0, 6)
local UIPadding = Instance.new("UIPadding", TextFrame)
UIPadding.PaddingTop = UDim.new(0, 15); UIPadding.PaddingBottom = UDim.new(0, 15)
UIPadding.PaddingLeft = UDim.new(0, 15); UIPadding.PaddingRight = UDim.new(0, 15)

local GuideLabel = Instance.new("TextLabel", TextFrame)
GuideLabel.Size = UDim2.new(1, 0, 0, 0)
GuideLabel.AutomaticSize = Enum.AutomaticSize.Y
GuideLabel.BackgroundTransparency = 1
GuideLabel.Text = TextIndo 
GuideLabel.TextColor3 = Theme.Text
GuideLabel.TextSize = 12
GuideLabel.Font = Enum.Font.Gotham
GuideLabel.TextXAlignment = Enum.TextXAlignment.Left
GuideLabel.TextYAlignment = Enum.TextYAlignment.Top
GuideLabel.TextWrapped = true
GuideLabel.RichText = true
GuideLabel.LineHeight = 1.3 

local function SwitchLanguage(Lang)
    if Lang == "Indo" then
        BtnIndo.BackgroundColor3 = Theme.Purple
        BtnIndo.TextColor3 = Color3.new(1,1,1)
        BtnEng.BackgroundColor3 = Theme.Item
        BtnEng.TextColor3 = Color3.fromRGB(150,150,150)
        GuideLabel.Text = TextIndo
    else
        BtnEng.BackgroundColor3 = Theme.Purple
        BtnEng.TextColor3 = Color3.new(1,1,1)
        BtnIndo.BackgroundColor3 = Theme.Item
        BtnIndo.TextColor3 = Color3.fromRGB(150,150,150)
        GuideLabel.Text = TextEng
    end
end

BtnIndo.MouseButton1Click:Connect(function() SwitchLanguage("Indo") end)
BtnEng.MouseButton1Click:Connect(function() SwitchLanguage("Eng") end)

SwitchLanguage("Indo")
