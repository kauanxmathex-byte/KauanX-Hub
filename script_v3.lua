if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "KauanX"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 300, 0, 350)
main.Position = UDim2.new(0.5, -150, 0.5, -175)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(100, 200, 255)
stroke.Thickness = 2
stroke.Parent = main

local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
header.BorderSizePixel = 0
header.Text = "KauanX Hub"
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.TextSize = 18
header.Font = Enum.Font.GothamBold
header.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0.5, -15)
close.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
close.BorderSizePixel = 0
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 100, 100)
close.TextSize = 16
close.Font = Enum.Font.GothamBold
close.Parent = header

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 30, 0, 30)
minimize.Position = UDim2.new(1, -70, 0.5, -15)
minimize.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
minimize.BorderSizePixel = 0
minimize.Text = "-"
minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
minimize.TextSize = 18
minimize.Font = Enum.Font.GothamBold
minimize.Parent = header

local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, 0, 1, -40)
content.Position = UDim2.new(0, 0, 0, 40)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 3
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = content

local settings = {
    esp = false,
    aimbot = false,
    names = false,
    distance = false,
    health = true,
    teamCheck = true,
    fov = 120
}

local espBoxes = {}

local function createToggle(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -16, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    btn.BorderSizePixel = 0
    btn.Text = name .. " [OFF]"
    btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.Parent = content
    btn.Visible = true

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn

    local state = false

    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.Text = name .. " [ON]"
            btn.TextColor3 = Color3.fromRGB(100, 255, 100)
        else
            btn.Text = name .. " [OFF]"
            btn.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        return state
    end)

    return {
        button = btn,
        isEnabled = function() return state end,
        setValue = function(v) state = v end
    }
end

local toggles = {
    esp = createToggle("ESP"),
    aimbot = createToggle("Aimbot"),
    names = createToggle("Nomes"),
    distance = createToggle("Distância"),
    health = createToggle("Health"),
    teamCheck = createToggle("Team Check")
}

local minimized = false
minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        content.Visible = false
        main.Size = UDim2.new(0, 300, 0, 40)
        minimize.Text = "+"
    else
        content.Visible = true
        main.Size = UDim2.new(0, 300, 0, 350)
        minimize.Text = "-"
    end
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local function getEnemy(plr)
    if plr == LocalPlayer then return false end
    if not settings.teamCheck then return true end
    return LocalPlayer.Team ~= plr.Team
end

local function updateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if getEnemy(player) and player.Character then
            local head = player.Character:FindFirstChild("Head")
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")

            if head and humanoid and humanoid.Health > 0 and hrp then
                if not espBoxes[player] then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Name = "ESP"
                    box.Adornee = player.Character
                    box.AlwaysOnTop = true
                    box.Color3 = Color3.fromRGB(255, 50, 100)
                    box.Transparency = 0.3
                    box.Size = Vector3.new(2, 3, 1)
                    box.ZIndex = 5
                    box.Parent = workspace
                    espBoxes[player] = box
                end

                if toggles.esp.isEnabled() then
                    espBoxes[player].Adornee = player.Character
                else
                    espBoxes[player].Adornee = nil
                end
            end
        elseif espBoxes[player] then
            pcall(function() espBoxes[player]:Destroy() end)
            espBoxes[player] = nil
        end
    end
end

local function getClosestTarget()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local closest = nil
    local dist = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if getEnemy(player) and player.Character then
            local head = player.Character:FindFirstChild("Head")
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if head and humanoid and humanoid.Health > 0 then
                local pos = Camera:WorldToViewportPoint(head.Position)
                local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if d < settings.fov and d < dist then
                    dist = d
                    closest = player
                end
            end
        end
    end

    return closest
end

RunService.RenderStepped:Connect(function()
    pcall(function()
        updateESP()

        if toggles.aimbot.isEnabled() then
            local target = getClosestTarget()
            if target and target.Character then
                local head = target.Character:FindFirstChild("Head")
                if head then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
                end
            end
        end
    end)
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    if input.KeyCode == Enum.KeyCode.RightShift then
        minimized = not minimized
        if minimized then
            content.Visible = false
            main.Size = UDim2.new(0, 300, 0, 40)
        else
            content.Visible = true
            main.Size = UDim2.new(0, 300, 0, 350)
        end
    end
end)