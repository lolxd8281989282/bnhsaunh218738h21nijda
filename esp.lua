-- Services
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local player = players.LocalPlayer
local camera = workspace.CurrentCamera

-- ESP Settings
local ESP = {
    Enabled = false,
    TeamCheck = false,
    Outline = false,
    SelfESP = false,
    ShowNames = true,
    ShowBoxes = true,
    ShowHealthBars = true,
    ShowEquippedItem = false,
    ShowSkeleton = false,
    ShowArmorBar = false,
    ShowHeadDot = false,
    FillBox = false,
    ShowDistance = false,
    BoxColor = Color3.fromRGB(255, 255, 255),
    BoxThickness = 1.4,
    BoxTransparency = 1,
    TextColor = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    Distance = 1000,
    BoxType = "Corners",
    ArmorBarColor = Color3.fromRGB(0, 150, 255),
    NameColor = Color3.fromRGB(255, 255, 255),
    EquippedItemColor = Color3.fromRGB(255, 255, 255),
    SkeletonColor = Color3.fromRGB(255, 255, 255),
    HeadDotColor = Color3.fromRGB(255, 255, 255),
    DistanceColor = Color3.fromRGB(255, 255, 255),
}

-- Store ESP objects for each player
local PlayerESP = {}

-- Safe Drawing Creation
local function SafeNewDrawing(drawingType)
    local success, drawing = pcall(function()
        return Drawing.new(drawingType)
    end)
    
    if success and drawing then
        return drawing
    else
        warn("Failed to create drawing of type:", drawingType)
        return nil
    end
end

-- Drawing Functions
local function NewLine()
    local line = SafeNewDrawing("Line")
    if line then
        line.Visible = false
        line.From = Vector2.new(0, 0)
        line.To = Vector2.new(1, 1)
        line.Color = ESP.BoxColor
        line.Thickness = ESP.BoxThickness
        line.Transparency = 1
    end
    return line
end

local function NewText()
    local text = SafeNewDrawing("Text")
    if text then
        text.Visible = false
        text.Center = true
        text.Outline = true
        text.Color = ESP.TextColor
        text.Size = ESP.TextSize
        text.Font = 3 -- Monospace
        text.Transparency = 1
    end
    return text
end

local function NewCircle()
    local circle = SafeNewDrawing("Circle")
    if circle then
        circle.Visible = false
        circle.Position = Vector2.new(0, 0)
        circle.Radius = 3
        circle.Color = ESP.BoxColor
        circle.Thickness = 1
        circle.Filled = true
        circle.Transparency = 1
        circle.NumSides = 30
    end
    return circle
end

-- Safe Drawing Removal
local function SafeRemoveDrawing(drawing)
    if drawing then
        pcall(function()
            drawing:Remove()
        end)
    end
end

-- Cleanup function
local function CleanupESP(plr)
    if PlayerESP[plr] then
        for _, drawing in pairs(PlayerESP[plr]) do
            if type(drawing) == "table" then
                for _, obj in pairs(drawing) do
                    SafeRemoveDrawing(obj)
                end
            else
                SafeRemoveDrawing(drawing)
            end
        end
        PlayerESP[plr] = nil
    end
end

-- ESP Function
local function CreateESP(plr)
    if PlayerESP[plr] then return end

    -- Create ESP objects with error checking
    local box = {NewLine(), NewLine(), NewLine(), NewLine()}
    local name = NewText()
    local healthBar = NewLine()
    local healthBarBG = NewLine()
    local distance = NewText()
    local headDot = NewCircle()

    -- Verify all drawings were created successfully
    for _, line in pairs(box) do
        if not line then return end
    end
    if not (name and healthBar and healthBarBG and distance and headDot) then
        -- Cleanup any successfully created drawings
        for _, line in pairs(box) do
            SafeRemoveDrawing(line)
        end
        SafeRemoveDrawing(name)
        SafeRemoveDrawing(healthBar)
        SafeRemoveDrawing(healthBarBG)
        SafeRemoveDrawing(distance)
        SafeRemoveDrawing(headDot)
        return
    end

    local esp = {
        box = box,
        name = name,
        healthBar = healthBar,
        healthBarBG = healthBarBG,
        distance = distance,
        headDot = headDot
    }
    
    PlayerESP[plr] = esp

    local function UpdateESP()
        if not plr or not plr.Parent then
            CleanupESP(plr)
            return
        end

        if not ESP.Enabled then
            for _, drawing in pairs(esp) do
                if type(drawing) == "table" then
                    for _, obj in pairs(drawing) do
                        if obj then obj.Visible = false end
                    end
                else
                    if drawing then drawing.Visible = false end
                end
            end
            return
        end

        local character = plr.Character
        local humanoid = character and character:FindFirstChild("Humanoid")
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local head = character and character:FindFirstChild("Head")

        if not (character and humanoid and rootPart and head and humanoid.Health > 0) then
            for _, drawing in pairs(esp) do
                if type(drawing) == "table" then
                    for _, obj in pairs(drawing) do
                        if obj then obj.Visible = false end
                    end
                else
                    if drawing then drawing.Visible = false end
                end
            end
            return
        end

        local pos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
        local distance = (camera.CFrame.Position - rootPart.Position).Magnitude

        if onScreen and distance <= ESP.Distance then
            local size = Vector2.new(2000 / distance, 2000 / distance)
            local boxSize = Vector2.new(size.X * 1.5, size.Y * 3)
            local boxPos = Vector2.new(pos.X - boxSize.X / 2, pos.Y - boxSize.Y / 2)

            -- Box ESP
            if ESP.ShowBoxes then
                local boxPoints = {
                    {boxPos.X, boxPos.Y},
                    {boxPos.X + boxSize.X, boxPos.Y},
                    {boxPos.X + boxSize.X, boxPos.Y + boxSize.Y},
                    {boxPos.X, boxPos.Y + boxSize.Y}
                }

                for i = 1, 4 do
                    local line = esp.box[i]
                    if line then
                        line.From = Vector2.new(boxPoints[i][1], boxPoints[i][2])
                        line.To = Vector2.new(boxPoints[i % 4 + 1][1], boxPoints[i % 4 + 1][2])
                        line.Color = ESP.BoxColor
                        line.Thickness = ESP.BoxThickness
                        line.Visible = true
                    end
                end
            else
                for _, line in pairs(esp.box) do
                    if line then line.Visible = false end
                end
            end

            -- Name ESP
            if ESP.ShowNames and esp.name then
                esp.name.Position = Vector2.new(pos.X, boxPos.Y - 16)
                esp.name.Text = plr.Name
                esp.name.Color = ESP.NameColor
                esp.name.Size = ESP.TextSize
                esp.name.Visible = true
            elseif esp.name then
                esp.name.Visible = false
            end

            -- Health Bar
            if ESP.ShowHealthBars and esp.healthBar and esp.healthBarBG then
                local healthPercent = humanoid.Health / humanoid.MaxHealth
                local barHeight = boxSize.Y
                local barPos = Vector2.new(boxPos.X - 5, boxPos.Y)

                esp.healthBarBG.From = barPos
                esp.healthBarBG.To = barPos + Vector2.new(0, barHeight)
                esp.healthBarBG.Color = Color3.fromRGB(0, 0, 0)
                esp.healthBarBG.Thickness = 3
                esp.healthBarBG.Visible = true

                esp.healthBar.From = barPos + Vector2.new(0, barHeight * (1 - healthPercent))
                esp.healthBar.To = barPos + Vector2.new(0, barHeight)
                esp.healthBar.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
                esp.healthBar.Thickness = 1
                esp.healthBar.Visible = true
            else
                if esp.healthBar then esp.healthBar.Visible = false end
                if esp.healthBarBG then esp.healthBarBG.Visible = false end
            end

            -- Distance ESP
            if ESP.ShowDistance and esp.distance then
                esp.distance.Position = Vector2.new(pos.X, boxPos.Y + boxSize.Y + 2)
                esp.distance.Text = string.format("[%d]", math.floor(distance))
                esp.distance.Color = ESP.DistanceColor
                esp.distance.Size = ESP.TextSize
                esp.distance.Visible = true
            elseif esp.distance then
                esp.distance.Visible = false
            end

            -- Head Dot
            if ESP.ShowHeadDot and esp.headDot then
                local headPos = camera:WorldToViewportPoint(head.Position)
                esp.headDot.Position = Vector2.new(headPos.X, headPos.Y)
                esp.headDot.Color = ESP.HeadDotColor
                esp.headDot.Visible = true
            elseif esp.headDot then
                esp.headDot.Visible = false
            end
        else
            for _, drawing in pairs(esp) do
                if type(drawing) == "table" then
                    for _, obj in pairs(drawing) do
                        if obj then obj.Visible = false end
                    end
                else
                    if drawing then drawing.Visible = false end
                end
            end
        end
    end

    local connection = runService.RenderStepped:Connect(UpdateESP)
    
    plr.AncestryChanged:Connect(function(_, parent)
        if not parent then
            CleanupESP(plr)
            connection:Disconnect()
        end
    end)
end

-- Initialize ESP
for _, v in pairs(players:GetPlayers()) do
    if v ~= player then
        CreateESP(v)
    end
end

players.PlayerAdded:Connect(function(plr)
    if plr ~= player then
        CreateESP(plr)
    end
end)

players.PlayerRemoving:Connect(CleanupESP)

function ESP:UpdateSettings(settings)
    for key, value in pairs(settings) do
        if self[key] ~= nil then
            self[key] = value
        end
    end
end

return ESP
