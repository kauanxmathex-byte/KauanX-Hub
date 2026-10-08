if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local playerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
local parentGui = game:GetService("CoreGui") or playerGui

local antigo = parentGui:FindFirstChild("KauanX_Hub")
if antigo then antigo:Destroy() end

local AimbotEnabled = false
local EspEnabled = false
local FovSize = 100

local gui = Instance.new("ScreenGui")
gui.Name = "KauanX_Hub"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999
gui.IgnoreGuiInset = true
gui.Parent = parentGui

local fovCircleGui = Instance.new("Frame")
fovCircleGui.Name = "FOVCircle"
fovCircleGui.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircleGui.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
fovCircleGui.BackgroundTransparency = 1
fovCircleGui.Size = UDim2.fromOffset(FovSize * 2, FovSize * 2)
fovCircleGui.Position = UDim2.new(0.5, 0, 0.5, 0)
fovCircleGui.Visible = false
fovCircleGui.Parent = gui

local fovStroke = Instance.new("UIStroke")
fovStroke.Thickness = 1.5
fovStroke.Color = Color3.fromRGB(0, 170, 255)
fovStroke.Parent = fovCircleGui

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = fovCircleGui

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(300, 290)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
frame.BorderSizePixel = 0
frame.Visible = true
frame.ClipsDescendants = true
frame.Active = true
frame.Parent = gui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = frame

local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(0, 170, 255)
uiStroke.Parent = frame

local draggingMenu = false
local dragInput, dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingMenu = true
        dragStart = input.Position
        startPos = frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingMenu = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and draggingMenu then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, -70, 0, 35)
label.Position = UDim2.new(0, 15, 0, 0)
label.BackgroundTransparency = 1
label.Text = "KauanX Hub"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextSize = 16
label.Font = Enum.Font.GothamBold
label.TextXAlignment = Enum.TextXAlignment.Left
label.Parent = frame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.fromOffset(25, 25)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.BackgroundTransparency = 1
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 75, 75)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = frame

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local minimizado = false
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.fromOffset(25, 25)
minimizeButton.Position = UDim2.new(1, -55, 0, 5)
minimizeButton.BackgroundTransparency = 1
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 20
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = frame

local container = Instance.new("Frame")
container.Size = UDim2.new(1, 0, 1, -35)
container.Position = UDim2.new(0, 0, 0, 35)
container.BackgroundTransparency = 1
container.Parent = frame

minimizeButton.MouseButton1Click:Connect(function()
    minimizado = not minimizado
    if minimizado then
        container.Visible = false
        frame.Size = UDim2.fromOffset(300, 35)
        minimizeButton.Text = "+"
    else
        container.Visible = true
        frame.Size = UDim2.fromOffset(300, 290)
        minimizeButton.Text = "-"
    end
end)

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = container

local function createToggle(name, order, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    btn.Text = name .. ": DESLIGADO"
    btn.TextColor3 = Color3.fromRGB(255, 75, 75)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.LayoutOrder = order
    btn.Parent = container

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    
    local tStroke = Instance.new("UIStroke")
    tStroke.Thickness = 1
    tStroke.Color = Color3.fromRGB(50, 50, 65)
    tStroke.Parent = btn

    local estado = false
    btn.MouseButton1Click:Connect(function()
        estado = not estado
        if estado then
            btn.Text = name .. ": LIGADO"
            btn.TextColor3 = Color3.fromRGB(75, 255, 75)
            tStroke.Color = Color3.fromRGB(0, 170, 255)
        else
            btn.Text = name .. ": DESLIGADO"
            btn.TextColor3 = Color3.fromRGB(255, 75, 75)
            tStroke.Color = Color3.fromRGB(50, 50, 65)
        end
        callback(estado)
    end)
end

createToggle("Aimbot", 1, function(valor)
    AimbotEnabled = valor
    fovCircleGui.Visible = valor
end)

createToggle("Visual ESP", 2, function(valor)
    EspEnabled = valor
end)

local function isPlayerVisible(targetPart)
    local character = LocalPlayer.Character
    if not character then return false end
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {character, Camera}
    raycastParams.IgnoreWater = true
    
    local origin = Camera.CFrame.Position
    local direction = targetPart.Position - origin
    local raycastResult = workspace:Raycast(origin, direction, raycastParams)
    
    if raycastResult then
        if raycastResult.Instance:IsDescendantOf(targetPart.Parent) then
            return true
        end
        return false
    end
    return true
end

local function getClosestPlayerToCenter()
    local target = nil
    local maxDistance = FovSize
    local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, pl in pairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") and pl.Character:FindFirstChild("Head") and pl.Character:FindFirstChild("Humanoid") and pl.Character.Humanoid.Health > 0 then
            local screenPos, onScreen = Camera:WorldToViewportPoint(pl.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - centerScreen).Magnitude
                if distance < maxDistance then
                    if isPlayerVisible(pl.Character.Head) then
                        target = pl
                        maxDistance = distance
                    end
                end
            end
        end
    end
    return target
end

local function addEsp(player)
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "ESP_Box"
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Color3 = Color3.fromRGB(255, 0, 85)
    box.Transparency = 0.5
    
    local function updateBox()
        if EspEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            box.Adornee = player.Character
            box.Size = player.Character:GetExtentsSize()
            box.Parent = player.Character.HumanoidRootPart
        else
            box.Adornee = nil
            box.Parent = nil
        end
    end

    RunService.RenderStepped:Connect(updateBox)
end

for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then addEsp(p) end
end
Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer then addEsp(p) end
end)

RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local target = getClosestPlayerToCenter()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)