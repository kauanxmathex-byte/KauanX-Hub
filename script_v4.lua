if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local settings = {
    esp = false,
    aimbot = false,
    teamCheck = true,
    fov = 120
}

local targetPartNames = {"Head", "UpperTorso", "HumanoidRootPart", "LeftFoot", "RightFoot"}
local targetIndex = 1
local currentTargetPart = targetPartNames[targetIndex]

local gui = Instance.new("ScreenGui")
gui.Name = "KauanXHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = game:GetService("CoreGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 320, 0, 350)
main.Position = UDim2.new(0.5, -160, 0.5, -175)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
main.BorderSizePixel = 0
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(90, 200, 255)
mainStroke.Thickness = 2
mainStroke.Parent = main

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
header.BorderSizePixel = 0
header.Parent = main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 14)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "KauanX Hub"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 24, 0, 24)
closeButton.Position = UDim2.new(1, -30, 0.5, -12)
closeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 58)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 100, 100)
closeButton.TextSize = 15
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = header

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 24, 0, 24)
minimizeButton.Position = UDim2.new(1, -60, 0.5, -12)
minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 58)
minimizeButton.BorderSizePixel = 0
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255,255,255)
minimizeButton.TextSize = 16
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = header

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local minimized = false
local contentVisible = true

minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        main.Size = UDim2.new(0, 320, 0, 38)
        minimizeButton.Text = "+"
        contentVisible = false
    else
        main.Size = UDim2.new(0, 320, 0, 350)
        minimizeButton.Text = "-"
        contentVisible = true
    end
end)

local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -20, 1, -55)
content.Position = UDim2.new(0, 10, 0, 40)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 4
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.Visible = contentVisible
content.Parent = main

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 8)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = content

local function createToggle(labelText, defaultValue, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -2, 0, 42)
    button.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    button.BorderSizePixel = 0
    button.Text = labelText .. " [OFF]"
    button.TextColor3 = Color3.fromRGB(255, 100, 100)
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.Parent = content

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button

    local state = defaultValue or false

    local function updateVisual()
        if state then
            button.Text = labelText .. " [ON]"
            button.TextColor3 = Color3.fromRGB(100, 255, 100)
        else
            button.Text = labelText .. " [OFF]"
            button.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end

    updateVisual()

    button.MouseButton1Click:Connect(function()
        state = not state
        updateVisual()
        if callback then
            callback(state)
        end
    end)

    return {
        get = function()
            return state
        end,
        set = function(v)
            state = v
            updateVisual()
            if callback then
                callback(v)
            end
        end
    }
end

local espToggle = createToggle("ESP", false, function(v)
    settings.esp = v
end)

local aimToggle = createToggle("Aimbot", false, function(v)
    settings.aimbot = v
end)

local teamToggle = createToggle("TeamCheck", true, function(v)
    settings.teamCheck = v
end)

local targetButton = Instance.new("TextButton")
targetButton.Size = UDim2.new(1, -2, 0, 42)
targetButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
targetButton.BorderSizePixel = 0
targetButton.Text = "Alvo: Head"
targetButton.TextColor3 = Color3.fromRGB(120, 200, 255)
targetButton.TextSize = 14
targetButton.Font = Enum.Font.GothamBold
targetButton.Parent = content

local targetCorner = Instance.new("UICorner")
targetCorner.CornerRadius = UDim.new(0, 8)
targetCorner.Parent = targetButton

local function updateTargetButtonText()
    targetButton.Text = "Alvo: " .. targetPartNames[targetIndex]
end

updateTargetButtonText()

targetButton.MouseButton1Click:Connect(function()
    targetIndex = targetIndex + 1
    if targetIndex > #targetPartNames then
        targetIndex = 1
    end
    currentTargetPart = targetPartNames[targetIndex]
    updateTargetButtonText()
end)

local espBoxes = {}

local function isEnemy(player)
    if player == LocalPlayer then
        return false
    end

    if settings.teamCheck and LocalPlayer.Team and player.Team then
        if LocalPlayer.Team == player.Team then
            return false
        end
    end

    return true
end

local function getTargetPart(player)
    if not player or not player.Character then
        return nil
    end

    local character = player.Character
    local chosenPart = character:FindFirstChild(currentTargetPart)
    if chosenPart then
        return chosenPart
    end

    local fallback = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
    return fallback
end

local function updateEsp()
    for _, player in ipairs(Players:GetPlayers()) do
        if isEnemy(player) and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            if not espBoxes[player] then
                local box = Instance.new("BoxHandleAdornment")
                box.Name = "EnemyESP"
                box.Adornee = player.Character
                box.Size = Vector3.new(2, 3, 1)
                box.Color3 = Color3.fromRGB(255, 75, 110)
                box.Transparency = 0.35
                box.AlwaysOnTop = true
                box.ZIndex = 5
                box.Parent = workspace
                espBoxes[player] = box
            end

            espBoxes[player].Visible = settings.esp
            espBoxes[player].Adornee = player.Character
            espBoxes[player].Size = Vector3.new(2, 3, 1)
        else
            if espBoxes[player] then
                espBoxes[player].Visible = false
            end
        end
    end
end

local function findClosestTarget()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local bestPart = nil
    local bestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if isEnemy(player) then
            local part = getTargetPart(player)
            if part then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist < settings.fov and dist < bestDistance then
                        bestDistance = dist
                        bestPart = part
                    end
                end
            end
        end
    end

    return bestPart
end

RunService.RenderStepped:Connect(function()
    pcall(function()
        updateEsp()

        if settings.aimbot then
            local targetPart = findClosestTarget()
            if targetPart then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
            end
        end
    end)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end

    if input.KeyCode == Enum.KeyCode.RightShift then
        minimized = not minimized
        if minimized then
            main.Size = UDim2.new(0, 320, 0, 38)
            minimizeButton.Text = "+"
            content.Visible = false
        else
            main.Size = UDim2.new(0, 320, 0, 350)
            minimizeButton.Text = "-"
            content.Visible = true
        end
    end

    if input.KeyCode == Enum.KeyCode.RightControl then
        espToggle.set(not espToggle.get())
    end

    if input.KeyCode == Enum.KeyCode.RightAlt then
        aimToggle.set(not aimToggle.get())
    end

    if input.KeyCode == Enum.KeyCode.Q then
        targetIndex = targetIndex + 1
        if targetIndex > #targetPartNames then
            targetIndex = 1
        end
        currentTargetPart = targetPartNames[targetIndex]
        updateTargetButtonText()
    end

    if input.KeyCode == Enum.KeyCode.X then
        gui:Destroy()
    end
end)