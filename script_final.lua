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
    fov = 150,
    smoothness = 0.35,
    hologram = false
}

local targetPartNames = {"Head", "UpperTorso", "HumanoidRootPart", "LeftFoot", "RightFoot"}
local targetIndex = 1
local currentTargetPart = targetPartNames[targetIndex]

local rainbowColors = {
    Color3.fromRGB(255, 0, 127),
    Color3.fromRGB(255, 0, 255),
    Color3.fromRGB(127, 0, 255),
    Color3.fromRGB(0, 0, 255),
    Color3.fromRGB(0, 127, 255),
    Color3.fromRGB(0, 255, 255),
    Color3.fromRGB(0, 255, 127),
    Color3.fromRGB(0, 255, 0),
    Color3.fromRGB(127, 255, 0),
    Color3.fromRGB(255, 255, 0),
    Color3.fromRGB(255, 127, 0),
    Color3.fromRGB(255, 0, 0)
}

local rainbowIndex = 1

local gui = Instance.new("ScreenGui")
gui.Name = "KauanXHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = game:GetService("CoreGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 320, 0, 430)
main.Position = UDim2.new(0.5, -160, 0.5, -215)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
main.BorderSizePixel = 0
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = rainbowColors[1]
mainStroke.Thickness = 3
mainStroke.Parent = main

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
header.BorderSizePixel = 0
header.Parent = main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 16)
headerCorner.Parent = header

local headerStroke = Instance.new("UIStroke")
headerStroke.Color = rainbowColors[1]
headerStroke.Thickness = 2
headerStroke.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "✨ KauanX Hub ✨"
title.TextColor3 = rainbowColors[1]
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 28, 0, 28)
closeButton.Position = UDim2.new(1, -32, 0.5, -14)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 28, 0, 28)
minimizeButton.Position = UDim2.new(1, -65, 0.5, -14)
minimizeButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
minimizeButton.BorderSizePixel = 0
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 18
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = header

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 6)
minimizeCorner.Parent = minimizeButton

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local minimized = false
local contentVisible = true

minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        main.Size = UDim2.new(0, 320, 0, 45)
        minimizeButton.Text = "+"
        contentVisible = false
    else
        main.Size = UDim2.new(0, 320, 0, 430)
        minimizeButton.Text = "-"
        contentVisible = true
    end

    if content then
        content.Visible = contentVisible
    end
end)

local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -20, 1, -60)
content.Position = UDim2.new(0, 10, 0, 45)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 4
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.Visible = contentVisible
content.Parent = main

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 10)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = content

local function createToggle(labelText, defaultValue, callback, colorIndex)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -2, 0, 45)
    button.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    button.BorderSizePixel = 0
    button.Text = labelText .. " [OFF]"
    button.TextColor3 = Color3.fromRGB(255, 100, 100)
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.Parent = content

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = button

    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Thickness = 2
    buttonStroke.Color = Color3.fromRGB(100, 100, 150)
    buttonStroke.Parent = button

    local state = defaultValue or false

    local function updateVisual()
        if state then
            button.Text = labelText .. " [ON]"
            button.TextColor3 = rainbowColors[colorIndex or 3]
            buttonStroke.Color = rainbowColors[colorIndex or 3]
        else
            button.Text = labelText .. " [OFF]"
            button.TextColor3 = Color3.fromRGB(200, 100, 100)
            buttonStroke.Color = Color3.fromRGB(100, 100, 150)
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

local espToggle = createToggle("🎯 ESP", false, function(v)
    settings.esp = v
end, 5)

local hologramToggle = createToggle("🌀 Hologram", false, function(v)
    settings.hologram = v
end, 4)

local aimToggle = createToggle("🔫 Aimbot", false, function(v)
    settings.aimbot = v
end, 3)

local teamToggle = createToggle("👥 TeamCheck", true, function(v)
    settings.teamCheck = v
end, 7)

local targetButton = Instance.new("TextButton")
targetButton.Size = UDim2.new(1, -2, 0, 45)
targetButton.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
targetButton.BorderSizePixel = 0
targetButton.Text = "🎪 Alvo: Head"
targetButton.TextColor3 = rainbowColors[4]
targetButton.TextSize = 14
targetButton.Font = Enum.Font.GothamBold
targetButton.Parent = content

local targetCorner = Instance.new("UICorner")
targetCorner.CornerRadius = UDim.new(0, 10)
targetCorner.Parent = targetButton

local targetStroke = Instance.new("UIStroke")
targetStroke.Color = rainbowColors[4]
targetStroke.Thickness = 2
targetStroke.Parent = targetButton

local function updateTargetButtonText()
    targetButton.Text = "🎪 Alvo: " .. targetPartNames[targetIndex]
    targetStroke.Color = rainbowColors[(targetIndex % #rainbowColors) + 1]
    targetButton.TextColor3 = rainbowColors[(targetIndex % #rainbowColors) + 1]
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
local hologramBoxes = {}

local function isEnemy(player)
    if player == LocalPlayer then
        return false
    end

    if player and player.Character and LocalPlayer and LocalPlayer.Character then
        if player.Character == LocalPlayer.Character then
            return false
        end
    end

    if settings.teamCheck then
        local ok, sameTeam = pcall(function()
            if LocalPlayer.Team and player.Team then
                return LocalPlayer.Team == player.Team
            end
            return false
        end)

        if ok and sameTeam then
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

local function createHologramBox(player)
    if hologramBoxes[player] then
        return hologramBoxes[player]
    end

    local hologramGroup = Instance.new("Model")
    hologramGroup.Name = "HologramESP"
    hologramGroup.Parent = workspace

    local parts = {}
    for i = 1, 8 do
        local part = Instance.new("Part")
        part.Shape = Enum.PartType.Block
        part.Material = Enum.Material.Neon
        part.CanCollide = false
        part.CFrame = CFrame.new(0, 0, 0)
        part.Transparency = 0.4
        part.TopSurface = Enum.SurfaceType.Smooth
        part.BottomSurface = Enum.SurfaceType.Smooth
        part.Size = Vector3.new(0.1, 0.1, 0.1)
        part.Parent = hologramGroup
        table.insert(parts, part)
    end

    hologramBoxes[player] = {
        model = hologramGroup,
        parts = parts
    }

    return hologramBoxes[player]
end

local function updateHologramESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if settings.hologram and isEnemy(player) and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local hologram = createHologramBox(player)
                local pos = hrp.Position
                local size = Vector3.new(2, 3, 1)

                local corners = {
                    pos + Vector3.new(-size.X/2, -size.Y/2, -size.Z/2),
                    pos + Vector3.new(size.X/2, -size.Y/2, -size.Z/2),
                    pos + Vector3.new(size.X/2, size.Y/2, -size.Z/2),
                    pos + Vector3.new(-size.X/2, size.Y/2, -size.Z/2),
                    pos + Vector3.new(-size.X/2, -size.Y/2, size.Z/2),
                    pos + Vector3.new(size.X/2, -size.Y/2, size.Z/2),
                    pos + Vector3.new(size.X/2, size.Y/2, size.Z/2),
                    pos + Vector3.new(-size.X/2, size.Y/2, size.Z/2),
                }

                for i, corner in ipairs(corners) do
                    if hologram.parts[i] then
                        hologram.parts[i].Position = corner
                        hologram.parts[i].Color = rainbowColors[rainbowIndex]
                    end
                end

                hologram.model.Parent = workspace
            end
        elseif hologramBoxes[player] then
            hologramBoxes[player].model:Destroy()
            hologramBoxes[player] = nil
        end
    end
end

local function updateEsp()
    for _, player in ipairs(Players:GetPlayers()) do
        if isEnemy(player) and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            if not espBoxes[player] then
                local box = Instance.new("BoxHandleAdornment")
                box.Name = "EnemyESP"
                box.Adornee = player.Character
                box.Size = Vector3.new(2, 3, 1)
                box.Color3 = rainbowColors[5]
                box.Transparency = 0.35
                box.AlwaysOnTop = true
                box.ZIndex = 5
                box.Parent = workspace
                espBoxes[player] = box
            end

            espBoxes[player].Visible = settings.esp
            espBoxes[player].Adornee = player.Character
            espBoxes[player].Size = Vector3.new(2, 3, 1)
            espBoxes[player].Color3 = rainbowColors[rainbowIndex]
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
        rainbowIndex = rainbowIndex + 1
        if rainbowIndex > #rainbowColors then
            rainbowIndex = 1
        end

        mainStroke.Color = rainbowColors[rainbowIndex]
        headerStroke.Color = rainbowColors[rainbowIndex]
        title.TextColor3 = rainbowColors[rainbowIndex]

        updateEsp()
        updateHologramESP()

        if settings.aimbot then
            local targetPart = findClosestTarget()
            if targetPart then
                local currentCFrame = Camera.CFrame
                local targetPosition = targetPart.Position
                local smooth = settings.smoothness

                local smoothedCFrame = CFrame.new(
                    currentCFrame.Position,
                    Vector3.new(targetPosition.X, targetPosition.Y, targetPosition.Z)
                )

                Camera.CFrame = currentCFrame:Lerp(smoothedCFrame, smooth)
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
            main.Size = UDim2.new(0, 320, 0, 45)
            minimizeButton.Text = "+"
            content.Visible = false
        else
            main.Size = UDim2.new(0, 320, 0, 430)
            minimizeButton.Text = "-"
            content.Visible = true
        end
    end

    if input.KeyCode == Enum.KeyCode.RightControl then
        espToggle.set(not espToggle.get())
    end

    if input.KeyCode == Enum.KeyCode.H then
        hologramToggle.set(not hologramToggle.get())
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