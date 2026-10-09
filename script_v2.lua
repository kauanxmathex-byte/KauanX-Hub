if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local guiFolder = Instance.new("ScreenGui")
guiFolder.Name = "KauanX_Menu"
guiFolder.ResetOnSpawn = false
guiFolder.IgnoreGuiInset = true
guiFolder.DisplayOrder = 999
guiFolder.Parent = game:GetService("CoreGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 320, 0, 360)
main.Position = UDim2.new(0.5, -160, 0.5, -180)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
main.BorderSizePixel = 0
main.Parent = guiFolder

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(50, 200, 255)
stroke.Thickness = 2
stroke.Transparency = 0
stroke.Parent = main

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 34)
topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
topBar.BorderSizePixel = 0
topBar.Parent = main

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 14)
topCorner.Parent = topBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -90, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "KauanX Hub"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -30, 0.5, -10)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = topBar

local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0, 20, 0, 20)
hideBtn.Position = UDim2.new(1, -55, 0.5, -10)
hideBtn.BackgroundTransparency = 1
hideBtn.Text = "_"
hideBtn.TextColor3 = Color3.fromRGB(255,255,255)
hideBtn.TextSize = 18
hideBtn.Font = Enum.Font.GothamBold
hideBtn.Parent = topBar

closeBtn.MouseButton1Click:Connect(function()
    guiFolder:Destroy()
end)

local menuOpen = true

hideBtn.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    main.Visible = menuOpen
end)

local list = Instance.new("ScrollingFrame")
list.Size = UDim2.new(1, -20, 1, -60)
list.Position = UDim2.new(0, 10, 0, 42)
list.BackgroundTransparency = 1
list.BorderSizePixel = 0
list.ScrollBarThickness = 4
list.CanvasSize = UDim2.new(0,0,0,600)
list.AutomaticCanvasSize = Enum.AutomaticSize.Y
list.Parent = main

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 10)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = list

local toggles = {}

local function makeToggle(text, default, callback)
    local state = default or false

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 42)
    btn.BackgroundColor3 = Color3.fromRGB(29, 29, 35)
    btn.BorderSizePixel = 0
    btn.Text = text .. "  |  OFF"
    btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    btn.TextSize = 15
    btn.Font = Enum.Font.GothamBold
    btn.Parent = list

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn

    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(58, 58, 68)
    s.Thickness = 1
    s.Parent = btn

    local function updateVisual()
        if state then
            btn.Text = text .. "  |  ON"
            btn.TextColor3 = Color3.fromRGB(120,255,120)
            s.Color = Color3.fromRGB(80,210,255)
        else
            btn.Text = text .. "  |  OFF"
            btn.TextColor3 = Color3.fromRGB(255,100,100)
            s.Color = Color3.fromRGB(58,58,68)
        end
    end

    updateVisual()

    btn.MouseButton1Click:Connect(function()
        state = not state
        updateVisual()
        callback(state)
    end)

    toggles[text] = function()
        return state
    end
end

local settings = {
    esp = false,
    aimbot = false,
    tracers = false,
    names = false,
    distance = false,
    teamCheck = true,
    visibleCheck = true,
    fov = 100
}

local function isEnemy(plr)
    if not settings.teamCheck then
        return true
    end
    return LocalPlayer.Team ~= plr.Team
end

local function getCharacter(plr)
    if plr and plr.Character then
        return plr.Character
    end
    return nil
end

local function getHumanoidRootPart(plr)
    local char = getCharacter(plr)
    if char then
        return char:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

local function getHead(plr)
    local char = getCharacter(plr)
    if char then
        return char:FindFirstChild("Head")
    end
    return nil
end

local function getHumanoid(plr)
    local char = getCharacter(plr)
    if char then
        return char:FindFirstChild("Humanoid")
    end
    return nil
end

local function worldToScreen(worldPos)
    local screenPos, onScreen = Camera:WorldToViewportPoint(worldPos)
    return Vector2.new(screenPos.X, screenPos.Y), onScreen
end

local espCache = {}

local function createESPForPlayer(player)
    if espCache[player] then
        return espCache[player]
    end

    local data = {
        box = Instance.new("BoxHandleAdornment"),
        name = Instance.new("BillboardGui"),
        distance = Instance.new("BillboardGui"),
        tracer = Drawing.new("Line"),
        health = Instance.new("BillboardGui"),
    }

    data.box.Name = "ESPBox"
    data.box.Adornee = nil
    data.box.AlwaysOnTop = true
    data.box.ZIndex = 5
    data.box.Transparency = 0.45
    data.box.Color3 = Color3.fromRGB(255, 80, 120)
    data.box.Size = Vector3.new(2, 4, 1)
    data.box.Visible = false
    data.box.Parent = workspace

    for _, v in ipairs({
        data.name,
        data.distance,
        data.health
    }) do
        v.ResetOnSpawn = false
        v.Adornee = nil
        v.AlwaysOnTop = true
        v.Size = UDim2.new(0, 120, 0, 30)
        v.StudsOffset = Vector3.new(0, 2.8, 0)
        v.Parent = nil
    end

    local nameLabel = Instance.new("TextLabel")
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255,255,255)
    nameLabel.TextSize = 16
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextScaled = false
    nameLabel.Parent = data.name

    local distLabel = Instance.new("TextLabel")
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "0m"
    distLabel.TextColor3 = Color3.fromRGB(200,220,255)
    distLabel.TextSize = 12
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextScaled = false
    distLabel.Parent = data.distance

    local healthLabel = Instance.new("TextLabel")
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = "100"
    healthLabel.TextColor3 = Color3.fromRGB(120,255,120)
    healthLabel.TextSize = 12
    healthLabel.Font = Enum.Font.GothamBold
    healthLabel.Parent = data.health

    data.name.Adornee = nil
    data.distance.Adornee = nil
    data.health.Adornee = nil

    espCache[player] = data
    return data
end

local function removeESPForPlayer(player)
    local data = espCache[player]
    if data then
        if data.box then data.box:Destroy() end
        if data.name then data.name:Destroy() end
        if data.distance then data.distance:Destroy() end
        if data.health then data.health:Destroy() end
        if data.tracer then data.tracer:Remove() end
        espCache[player] = nil
    end
end

local function updateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and isEnemy(player) then
            local data = createESPForPlayer(player)
            local humanoidRoot = getHumanoidRootPart(player)
            local head = getHead(player)
            local humanoid = getHumanoid(player)

            if humanoidRoot and head and humanoid and humanoid.Health > 0 then
                local pos = humanoidRoot.Position
                local size = Vector3.new(2, 3, 1)

                data.box.Adornee = getCharacter(player)
                data.box.Size = size
                data.box.Visible = settings.esp
                data.box.Color3 = Color3.fromRGB(255, 80, 120)

                local dist = math.floor((Camera.CFrame.Position - pos).Magnitude)

                data.name.Parent = getCharacter(player)
                data.name.Adornee = getCharacter(player)
                data.name.StudsOffset = Vector3.new(0, 3.2, 0)
                data.name.AlwaysOnTop = true
                data.name.Enabled = settings.esp and settings.names

                if data.name:FindFirstChild("TextLabel") then
                    local label = data.name.TextLabel
                    if label then
                        label.Text = player.Name
                        label.TextColor3 = Color3.fromRGB(255,255,255)
                    end
                end

                data.distance.Parent = getCharacter(player)
                data.distance.Adornee = getCharacter(player)
                data.distance.StudsOffset = Vector3.new(0, 1.6, 0)
                data.distance.AlwaysOnTop = true
                data.distance.Enabled = settings.esp and settings.distance

                if data.distance:FindFirstChild("TextLabel") then
                    local label = data.distance.TextLabel
                    if label then
                        label.Text = tostring(dist) .. "m"
                        label.TextColor3 = Color3.fromRGB(180,220,255)
                    end
                end

                data.health.Parent = getCharacter(player)
                data.health.Adornee = getCharacter(player)
                data.health.StudsOffset = Vector3.new(0, 0.5, 0)
                data.health.AlwaysOnTop = true
                data.health.Enabled = settings.esp and settings.health

                if data.health:FindFirstChild("TextLabel") then
                    local txt = data.health.TextLabel
                    if txt then
                        txt.Text = tostring(math.floor(humanoid.Health))
                        txt.TextColor3 = Color3.fromRGB(120,255,120)
                    end
                end

                local tracerVisible = settings.tracers and settings.esp
                if tracerVisible then
                    local from = Camera.CFrame.Position
                    local to = head.Position
                    local color = Color3.fromRGB(255, 80, 120)

                    local line = data.tracer
                    line.Visible = true
                    line.Color = color
                    line.Thickness = 2
                    line.Transparency = 0.2

                    local p1, ok1 = worldToScreen(from)
                    local p2, ok2 = worldToScreen(to)

                    if ok1 and ok2 then
                        line.From = p1
                        line.To = p2
                    end
                else
                    data.tracer.Visible = false
                end
            else
                data.box.Visible = false
                data.tracer.Visible = false
                if data.name then data.name.Enabled = false end
                if data.distance then data.distance.Enabled = false end
                if data.health then data.health.Enabled = false end
            end
        else
            removeESPForPlayer(player)
        end
    end

    for player, data in pairs(espCache) do
        if not Players:GetPlayers():find(function(p)
            return p == player
        end) then
            removeESPForPlayer(player)
        end
    end
end

local FOVCircle = Instance.new("Frame")
FOVCircle.Size = UDim2.fromOffset(settings.fov * 2, settings.fov * 2)
FOVCircle.BackgroundTransparency = 1
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVCircle.Parent = guiFolder

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color = Color3.fromRGB(80,200,255)
FOVStroke.Thickness = 1.5
FOVStroke.Parent = FOVCircle

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVCircle

FOVCircle.Visible = false

local function updateFOVVisual()
    FOVCircle.Size = UDim2.fromOffset(settings.fov * 2, settings.fov * 2)
end

local function getClosestTarget()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local bestTarget = nil
    local bestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and isEnemy(player) then
            local head = getHead(player)
            if head then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist < settings.fov and dist < bestDistance and (not settings.visibleCheck or (head and head.Parent and head.Parent:FindFirstChildOfClass("Humanoid") and head.Parent.Humanoid.Health > 0)) then
                        bestDistance = dist
                        bestTarget = player
                    end
                end
            end
        end
    end

    return bestTarget
end

RunService.RenderStepped:Connect(function()
    updateESP()

    if settings.aimbot then
        local target = getClosestTarget()
        if target then
            local head = getHead(target)
            if head then
                local lookAt = CFrame.new(Camera.CFrame.Position, head.Position)
                Camera.CFrame = lookAt
            end
        end
    end
end)

makeToggle("ESP", false, function(v)
    settings.esp = v
end)

makeToggle("Aimbot", false, function(v)
    settings.aimbot = v
end)

makeToggle("Tracers", false, function(v)
    settings.tracers = v
end)

makeToggle("Nomes", false, function(v)
    settings.names = v
end)

makeToggle("Distância", false, function(v)
    settings.distance = v
end)

makeToggle("Team Check", true, function(v)
    settings.teamCheck = v
end)

makeToggle("Visible Check", true, function(v)
    settings.visibleCheck = v
end)

local keybinds = {
    [Enum.KeyCode.RightShift] = function()
        main.Visible = not main.Visible
    end,
    [Enum.KeyCode.RightControl] = function()
        settings.esp = not settings.esp
    end,
    [Enum.KeyCode.RightAlt] = function()
        settings.aimbot = not settings.aimbot
    end,
    [Enum.KeyCode.Z] = function()
        settings.fov = settings.fov == 100 and 160 or 100
        updateFOVVisual()
        FOVCircle.Visible = settings.aimbot
    end,
    [Enum.KeyCode.X] = function()
        guiFolder:Destroy()
    end
}

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end

    if keybinds[input.KeyCode] then
        keybinds[input.KeyCode]()
    end

    if input.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
    end

    if input.KeyCode == Enum.KeyCode.RightControl then
        settings.esp = not settings.esp
    end

    if input.KeyCode == Enum.KeyCode.RightAlt then
        settings.aimbot = not settings.aimbot
    end
end)

settings.esp = false
settings.aimbot = false
settings.tracers = false
settings.names = false
settings.distance = false
settings.teamCheck = true
settings.visibleCheck = true
settings.fov = 100

FOVCircle.Visible = false

updateFOVVisual()