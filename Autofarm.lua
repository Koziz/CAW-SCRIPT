-- [[ KZOYZ HUB - AUTO FARM MODULE ]] --

getgenv().ScriptVersion = "Auto Farm v1.0" 

-- ========================================== --
getgenv().PlaceDelay = 0.05 
getgenv().BreakDelay = 0.05 
getgenv().GridSize = 4.5 
-- ========================================== --

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser") 

-- Anti-AFK
LP.Idled:Connect(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)

-- Variabel Global
getgenv().AutoBreak = false
getgenv().AutoPlace = false
getgenv().OffsetX = 0
getgenv().OffsetY = 0 
getgenv().FarmAmount = 1  
getgenv().HitCount = 3    

-- Module Finder
local function FindInventoryModule()
    local Candidates = {}
    for _, v in pairs(RS:GetDescendants()) do if v:IsA("ModuleScript") and (v.Name:match("Inventory") or v.Name:match("Hotbar") or v.Name:match("Client")) then table.insert(Candidates, v) end end
    if LP:FindFirstChild("PlayerScripts") then for _, v in pairs(LP.PlayerScripts:GetDescendants()) do if v:IsA("ModuleScript") and (v.Name:match("Inventory") or v.Name:match("Hotbar")) then table.insert(Candidates, v) end end end
    for _, module in pairs(Candidates) do local success, result = pcall(require, module); if success and type(result) == "table" then if result.GetSelectedHotbarItem or result.GetSelectedItem or result.GetEquippedItem then return result end end end
    return nil
end
getgenv().GameInventoryModule = FindInventoryModule()

-- Cleanup UI Lama
pcall(function() if getgenv().KzoyzAutofarmUI then getgenv().KzoyzAutofarmUI:Destroy() end end)

-- UI Setup
local ScreenGui = Instance.new("ScreenGui"); ScreenGui.Name = "KzoyzAutofarmUI"; pcall(function() ScreenGui.Parent = CoreGui end); if not ScreenGui.Parent then ScreenGui.Parent = LP.PlayerGui end; ScreenGui.IgnoreGuiInset = true; ScreenGui.ResetOnSpawn = false; getgenv().KzoyzAutofarmUI = ScreenGui 
local Theme = { Bg = Color3.fromRGB(25, 25, 25), Item = Color3.fromRGB(45, 45, 45), Text = Color3.fromRGB(255, 255, 255), Purple = Color3.fromRGB(140, 80, 255) }

local Main = Instance.new("Frame"); Main.Parent = ScreenGui; Main.BackgroundColor3 = Theme.Bg; Main.Position = UDim2.new(0.6, 0, 0.5, -140); Main.Size = UDim2.new(0, 300, 0, 350); local MC = Instance.new("UICorner"); MC.CornerRadius = UDim.new(0, 10); MC.Parent = Main; local MS = Instance.new("UIStroke"); MS.Parent = Main; MS.Color = Theme.Purple; MS.Thickness = 1.5; MS.Transparency = 0.5
local function MakeDraggable(frame) local dragging, dragInput, dragStart, startPos; frame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = frame.Position; input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end); frame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end); UIS.InputChanged:Connect(function(input) if input == dragInput and dragging then local delta = input.Position - dragStart; frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end) end
MakeDraggable(Main)

local Header = Instance.new("Frame"); Header.Parent = Main; Header.BackgroundColor3 = Theme.Bg; Header.Size = UDim2.new(1, 0, 0, 40); Header.BackgroundTransparency = 1
local Title = Instance.new("TextLabel"); Title.Parent = Header; Title.Text = "🌾 Auto Farm"; Title.TextColor3 = Theme.Text; Title.Font = Enum.Font.GothamBold; Title.TextSize = 15; Title.Size = UDim2.new(0, 150, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0); Title.BackgroundTransparency = 1; Title.TextXAlignment = Enum.TextXAlignment.Left
local MinBtn = Instance.new("TextButton"); MinBtn.Parent = Header; MinBtn.Text = "X"; MinBtn.TextColor3 = Color3.fromRGB(255, 100, 100); MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 16; MinBtn.Size = UDim2.new(0, 40, 0, 40); MinBtn.Position = UDim2.new(1, -40, 0, 0); MinBtn.BackgroundTransparency = 1; MinBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local Page = Instance.new("ScrollingFrame"); Page.Parent = Main; Page.Position = UDim2.new(0, 10, 0, 45); Page.Size = UDim2.new(1, -20, 1, -55); Page.BackgroundTransparency = 1; Page.BorderSizePixel = 0; Page.ScrollBarThickness = 2; Page.ScrollBarImageColor3 = Theme.Purple; local L1 = Instance.new("UIListLayout"); L1.Parent = Page; L1.Padding = UDim.new(0, 6)

-- Components
function CreateToggle(Parent, Text, Var) local Btn = Instance.new("TextButton"); Btn.Parent = Parent; Btn.BackgroundColor3 = Theme.Item; Btn.Size = UDim2.new(1, 0, 0, 35); Btn.Text = ""; Btn.AutoButtonColor = false; local C = Instance.new("UICorner"); C.CornerRadius = UDim.new(0, 6); C.Parent = Btn; local T = Instance.new("TextLabel"); T.Parent = Btn; T.Text = Text; T.TextColor3 = Theme.Text; T.Font = Enum.Font.GothamSemibold; T.TextSize = 12; T.Size = UDim2.new(1, -40, 1, 0); T.Position = UDim2.new(0, 10, 0, 0); T.BackgroundTransparency = 1; T.TextXAlignment = Enum.TextXAlignment.Left; local IndBg = Instance.new("Frame"); IndBg.Parent = Btn; IndBg.Size = UDim2.new(0, 36, 0, 18); IndBg.Position = UDim2.new(1, -45, 0.5, -9); IndBg.BackgroundColor3 = Color3.fromRGB(30,30,30); local IC = Instance.new("UICorner"); IC.CornerRadius = UDim.new(1,0); IC.Parent = IndBg; local Dot = Instance.new("Frame"); Dot.Parent = IndBg; Dot.Size = UDim2.new(0, 14, 0, 14); Dot.Position = UDim2.new(0, 2, 0.5, -7); Dot.BackgroundColor3 = Color3.fromRGB(100,100,100); local DC = Instance.new("UICorner"); DC.CornerRadius = UDim.new(1,0); DC.Parent = Dot; Btn.MouseButton1Click:Connect(function() getgenv()[Var] = not getgenv()[Var]; if getgenv()[Var] then Dot:TweenPosition(UDim2.new(1, -16, 0.5, -7), "Out", "Quad", 0.2, true); Dot.BackgroundColor3 = Color3.new(1,1,1); IndBg.BackgroundColor3 = Theme.Purple else Dot:TweenPosition(UDim2.new(0, 2, 0.5, -7), "Out", "Quad", 0.2, true); Dot.BackgroundColor3 = Color3.fromRGB(100,100,100); IndBg.BackgroundColor3 = Color3.fromRGB(30,30,30) end end) end
function CreateSlider(Parent, Text, Min, Max, Default, Var) local Frame = Instance.new("Frame"); Frame.Parent = Parent; Frame.BackgroundColor3 = Theme.Item; Frame.Size = UDim2.new(1, 0, 0, 45); local C = Instance.new("UICorner"); C.CornerRadius = UDim.new(0, 6); C.Parent = Frame; local Label = Instance.new("TextLabel"); Label.Parent = Frame; Label.Text = Text .. ": " .. Default; Label.TextColor3 = Theme.Text; Label.BackgroundTransparency = 1; Label.Size = UDim2.new(1, 0, 0, 20); Label.Position = UDim2.new(0, 10, 0, 2); Label.Font = Enum.Font.GothamSemibold; Label.TextSize = 12; Label.TextXAlignment = Enum.TextXAlignment.Left; local SliderBg = Instance.new("TextButton"); SliderBg.Parent = Frame; SliderBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30); SliderBg.Position = UDim2.new(0, 10, 0, 28); SliderBg.Size = UDim2.new(1, -20, 0, 6); SliderBg.Text = ""; SliderBg.AutoButtonColor = false; local SC = Instance.new("UICorner"); SC.CornerRadius = UDim.new(1,0); SC.Parent = SliderBg; local Fill = Instance.new("Frame"); Fill.Parent = SliderBg; Fill.BackgroundColor3 = Theme.Purple; Fill.Size = UDim2.new(0.5, 0, 1, 0); local FC = Instance.new("UICorner"); FC.CornerRadius = UDim.new(1,0); FC.Parent = Fill; local Dragging = false; local function Update(input) local SizeX = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1); local Val = math.floor(Min + ((Max - Min) * SizeX)); Fill.Size = UDim2.new(SizeX, 0, 1, 0); Label.Text = Text .. ": " .. Val; getgenv()[Var] = Val end; SliderBg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Dragging = true; Update(i) end end); UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Dragging = false end end); UIS.InputChanged:Connect(function(i) if Dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then Update(i) end end) end

CreateToggle(Page, "Auto Break", "AutoBreak")
CreateToggle(Page, "Auto Place", "AutoPlace")
CreateSlider(Page, "Break/Place Offset X", -5, 5, 0, "OffsetX")
CreateSlider(Page, "Break/Place Offset Y", -5, 5, 0, "OffsetY")
CreateSlider(Page, "Farm Amount", 1, 5, 1, "FarmAmount")
CreateSlider(Page, "Hit Count", 1, 15, 3, "HitCount") 

-- Logic
local Remotes = RS:WaitForChild("Remotes")
local RemotePlace = Remotes:WaitForChild("PlayerPlaceItem")
local RemoteBreak = Remotes:WaitForChild("PlayerFist")

task.spawn(function()
    while true do
        if getgenv().AutoPlace and getgenv().GameInventoryModule then
            local HitboxFolder = workspace:FindFirstChild("Hitbox")
            local MyHitbox = HitboxFolder and HitboxFolder:FindFirstChild(LP.Name)
            local RefPart = MyHitbox or (LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"))
            if RefPart then
                local X = math.floor(RefPart.Position.X / getgenv().GridSize + 0.5)
                local Y = math.floor(RefPart.Position.Y / getgenv().GridSize + 0.5)
                local _, ItemIndex
                if getgenv().GameInventoryModule.GetSelectedHotbarItem then _, ItemIndex = getgenv().GameInventoryModule.GetSelectedHotbarItem()
                elseif getgenv().GameInventoryModule.GetSelectedItem then _, ItemIndex = getgenv().GameInventoryModule.GetSelectedItem() end
                if ItemIndex then
                    for i = 0, getgenv().FarmAmount - 1 do
                        if not getgenv().AutoPlace then break end
                        local TGrid = Vector2.new(X + getgenv().OffsetX + i, Y + getgenv().OffsetY)
                        RemotePlace:FireServer(TGrid, ItemIndex)
                        task.wait(getgenv().PlaceDelay) 
                    end
                else task.wait(0.1) end
            end
        else task.wait(0.1) end
    end
end)

task.spawn(function()
    while true do
        if getgenv().AutoBreak then
            local HitboxFolder = workspace:FindFirstChild("Hitbox")
            local MyHitbox = HitboxFolder and HitboxFolder:FindFirstChild(LP.Name)
            local RefPart = MyHitbox or (LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"))
            if RefPart then
                local X = math.floor(RefPart.Position.X / getgenv().GridSize + 0.5)
                local Y = math.floor(RefPart.Position.Y / getgenv().GridSize + 0.5)
                for i = 0, getgenv().FarmAmount - 1 do
                    if not getgenv().AutoBreak then break end
                    local TGrid = Vector2.new(X + getgenv().OffsetX + i, Y + getgenv().OffsetY)
                    for hit = 1, getgenv().HitCount do
                        if not getgenv().AutoBreak then break end
                        RemoteBreak:FireServer(TGrid)
                        task.wait(getgenv().BreakDelay) 
                    end
                end
            end
        else task.wait(0.1) end
    end
end)
