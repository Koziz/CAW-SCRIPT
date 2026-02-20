-- [[ KZOYZ HUB - INDEX LOADER V.0.52 (AUTO-LOADSTRING) ]] --

getgenv().HubVersion = "v0.52" 

local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- Bersihin UI Index lama kalau ada
pcall(function() if getgenv().KzoyzIndexUI then getgenv().KzoyzIndexUI:Destroy() end end)

-- [[ SETUP UI UTAMA ]] --
local ScreenGui = Instance.new("ScreenGui"); ScreenGui.Name = "KzoyzHubIndex"; pcall(function() ScreenGui.Parent = CoreGui end); if not ScreenGui.Parent then ScreenGui.Parent = LP.PlayerGui end; ScreenGui.ResetOnSpawn = false; getgenv().KzoyzIndexUI = ScreenGui 
local Theme = { Bg = Color3.fromRGB(20, 20, 20), Header = Color3.fromRGB(15, 15, 15), Item = Color3.fromRGB(40, 40, 40), Text = Color3.fromRGB(255, 255, 255), Purple = Color3.fromRGB(140, 80, 255), TabBg = Color3.fromRGB(25, 25, 25) }

-- Tombol Minimize (KZ)
local KZBtn = Instance.new("TextButton", ScreenGui); KZBtn.BackgroundColor3 = Theme.Purple; KZBtn.Position = UDim2.new(0.1, 0, 0.1, 0); KZBtn.Size = UDim2.new(0, 50, 0, 50); KZBtn.Text = "KZ"; KZBtn.TextColor3 = Color3.new(1,1,1); KZBtn.Font = Enum.Font.GothamBlack; KZBtn.TextSize = 22; KZBtn.Visible = false; Instance.new("UICorner", KZBtn).CornerRadius = UDim.new(1, 0)

-- Main Frame
local Main = Instance.new("Frame", ScreenGui); Main.BackgroundColor3 = Theme.Bg; Main.Position = UDim2.new(0.5, -225, 0.5, -150); Main.Size = UDim2.new(0, 450, 0, 300); Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8); local MS = Instance.new("UIStroke", Main); MS.Color = Theme.Purple; MS.Thickness = 1.5; MS.Transparency = 0.5

-- Dragging Logic
local function MakeDraggable(frame, trigger) local dragging, dragInput, dragStart, startPos; trigger.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = frame.Position; input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end); trigger.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end); UIS.InputChanged:Connect(function(input) if input == dragInput and dragging then local delta = input.Position - dragStart; frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end) end; MakeDraggable(Main, Main); MakeDraggable(KZBtn, KZBtn)

-- Header
local Header = Instance.new("Frame", Main); Header.BackgroundColor3 = Theme.Header; Header.Size = UDim2.new(1, 0, 0, 40); Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)
local HeaderHide = Instance.new("Frame", Header); HeaderHide.BackgroundColor3 = Theme.Header; HeaderHide.Size = UDim2.new(1, 0, 0.5, 0); HeaderHide.Position = UDim2.new(0, 0, 0.5, 0); HeaderHide.BorderSizePixel = 0
local Title = Instance.new("TextLabel", Header); Title.Text = " Kzoyz HUB " .. getgenv().HubVersion; Title.TextColor3 = Theme.Purple; Title.Font = Enum.Font.GothamBlack; Title.TextSize = 16; Title.Size = UDim2.new(0.5, 0, 1, 0); Title.BackgroundTransparency = 1; Title.TextXAlignment = Enum.TextXAlignment.Left

-- Tombol Discord & Minimize
local DiscordBtn = Instance.new("TextButton", Header); DiscordBtn.Size = UDim2.new(0, 90, 0, 26); DiscordBtn.Position = UDim2.new(1, -135, 0, 7); DiscordBtn.Text = "Join Discord"; DiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242); DiscordBtn.TextColor3 = Color3.new(1,1,1); DiscordBtn.Font = Enum.Font.GothamBold; DiscordBtn.TextSize = 12; Instance.new("UICorner", DiscordBtn).CornerRadius = UDim.new(0, 6)
DiscordBtn.MouseButton1Click:Connect(function() pcall(function() setclipboard("https://discord.gg/kzoyzhub") end) end)

local MinBtn = Instance.new("TextButton", Header); MinBtn.Size = UDim2.new(0, 30, 0, 26); MinBtn.Position = UDim2.new(1, -38, 0, 7); MinBtn.Text = "-"; MinBtn.BackgroundColor3 = Theme.Item; MinBtn.TextColor3 = Color3.new(1,1,1); MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 18; Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)
local function ToggleUI() Main.Visible = not Main.Visible; KZBtn.Visible = not Main.Visible; if KZBtn.Visible then KZBtn.Position = Main.Position else Main.Position = KZBtn.Position end end; MinBtn.MouseButton1Click:Connect(ToggleUI); KZBtn.MouseButton1Click:Connect(ToggleUI)

-- [[ SISTEM TAB MENU DENGAN AUTO-LOAD ]] --
local TabContainer = Instance.new("Frame", Main); TabContainer.Size = UDim2.new(0, 120, 1, -40); TabContainer.Position = UDim2.new(0, 0, 0, 40); TabContainer.BackgroundColor3 = Theme.TabBg; TabContainer.BorderSizePixel = 0
local TabListLayout = Instance.new("UIListLayout", TabContainer); TabListLayout.Padding = UDim.new(0, 5); TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local PageContainer = Instance.new("Frame", Main); PageContainer.Size = UDim2.new(1, -130, 1, -50); PageContainer.Position = UDim2.new(0, 125, 0, 45); PageContainer.BackgroundTransparency = 1

local Tabs = {}; local Pages = {}

local function CreateAutoLoadTab(TabName, DescText, LoadLink)
    -- Bikin Tombol Tab di kiri
    local TBtn = Instance.new("TextButton", TabContainer); TBtn.Size = UDim2.new(0.9, 0, 0, 35); TBtn.BackgroundColor3 = Theme.Item; TBtn.Text = TabName; TBtn.TextColor3 = Theme.Text; TBtn.Font = Enum.Font.GothamBold; TBtn.TextSize = 12; Instance.new("UICorner", TBtn).CornerRadius = UDim.new(0, 6)
    
    -- Bikin Halaman di kanan
    local Page = Instance.new("Frame", PageContainer); Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false
    
    local LTitle = Instance.new("TextLabel", Page); LTitle.Size = UDim2.new(1,0,0,30); LTitle.Position = UDim2.new(0,0,0,10); LTitle.BackgroundTransparency = 1; LTitle.Text = TabName .. " Module"; LTitle.TextColor3 = Theme.Purple; LTitle.Font = Enum.Font.GothamBlack; LTitle.TextSize = 16
    local LDesc = Instance.new("TextLabel", Page); LDesc.Size = UDim2.new(0.9,0,0,50); LDesc.Position = UDim2.new(0.05,0,0,45); LDesc.BackgroundTransparency = 1; LDesc.Text = DescText; LDesc.TextColor3 = Color3.fromRGB(180,180,180); LDesc.Font = Enum.Font.GothamSemibold; LDesc.TextSize = 12; LDesc.TextWrapped = true; LDesc.TextYAlignment = Enum.TextYAlignment.Top
    
    local StatusLabel = Instance.new("TextLabel", Page); StatusLabel.Size = UDim2.new(1,0,0,30); StatusLabel.Position = UDim2.new(0,0,0,120); StatusLabel.BackgroundTransparency = 1; StatusLabel.Text = "Menunggu diklik..."; StatusLabel.TextColor3 = Theme.Text; StatusLabel.Font = Enum.Font.GothamBold; StatusLabel.TextSize = 14
    
    local isLoaded = false -- Penjaga biar nggak nge-load berkali-kali
    
    TBtn.MouseButton1Click:Connect(function()
        -- Ganti Tampilan Tab (Warna)
        for _, p in pairs(Pages) do p.Visible = false end
        for _, t in pairs(Tabs) do t.BackgroundColor3 = Theme.Item; t.TextColor3 = Theme.Text end
        Page.Visible = true; TBtn.BackgroundColor3 = Theme.Purple; TBtn.TextColor3 = Color3.new(1,1,1)
        
        -- Logic Eksekusi Loadstring Otomatis
        if not isLoaded and LoadLink ~= "" then
            StatusLabel.Text = "⏳ Sedang mengambil script..."
            StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
            isLoaded = true 
            
            task.spawn(function()
                local success, err = pcall(function()
                    loadstring(game:HttpGet(LoadLink))()
                end)
                
                if success then
                    StatusLabel.Text = "✅ Script Berhasil Di-load!"
                    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
                else
                    StatusLabel.Text = "❌ Gagal Load! Cek Link Raw."
                    StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
                    isLoaded = false -- Kasih kesempatan klik lagi kalau gagal
                end
            end)
        end
    end)
    
    table.insert(Tabs, TBtn); table.insert(Pages, Page); return Page, TBtn
end

-- ========================================================== --
-- [[ DAFTAR TAB & LINK LOADSTRING ]] 
-- Ganti link "https://raw.github..." dengan link asli kamu!
-- ========================================================== --

CreateAutoLoadTab(
    "Pabrik", 
    "Memuat otomatis sistem Pabrik (Balanced Turbo, Auto Collect, Smart Drop).", 
    "https://raw.githubusercontent.com/NamaKamu/KzoyzHub/main/Pabrik.lua"
)

CreateAutoLoadTab(
    "Auto Farm", 
    "Memuat otomatis sistem farming resource (Kayu, Batu, dll).", 
    "https://raw.githubusercontent.com/NamaKamu/KzoyzHub/main/Autofarm.lua"
)

CreateAutoLoadTab(
    "Manager", 
    "Memuat otomatis sistem Inventory & Sortir Barang.", 
    "https://raw.githubusercontent.com/NamaKamu/KzoyzHub/main/Manager.lua"
)

-- Note: Kita nggak otomatis buka tab pertama di sini, biar user milih dulu mau nge-load yang mana.
