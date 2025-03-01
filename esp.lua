-- Previous ESP code remains the same until the CreateESP function...

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
        return
    end

    PlayerESP[plr] = {
        box = box,
        name = name,
        healthBar = healthBar,
        healthBarBG = healthBarBG,
        distance = distance,
        headDot = headDot
    }
end

-- Add UpdatePlayer function
function ESP:UpdatePlayer(plr)
    if not PlayerESP[plr] then
        CreateESP(plr)
        return
    end

    local esp = PlayerESP[plr]
    if not esp then return end

    local character = plr.Character
    local humanoid = character and character:FindFirstChild("Humanoid")
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    local head = character and character:FindFirstChild("Head")

    if not (character and humanoid and rootPart and head and humanoid.Health > 0) then
        -- Hide ESP if character is not valid
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

        -- Update Box ESP
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

        -- Update Name ESP
        if ESP.ShowNames and esp.name then
            esp.name.Position = Vector2.new(pos.X, boxPos.Y - 16)
            esp.name.Text = plr.Name
            esp.name.Color = ESP.NameColor
            esp.name.Size = ESP.TextSize
            esp.name.Visible = true
        elseif esp.name then
            esp.name.Visible = false
        end

        -- Update Health Bar
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

        -- Update Distance ESP
        if ESP.ShowDistance and esp.distance then
            esp.distance.Position = Vector2.new(pos.X, boxPos.Y + boxSize.Y + 2)
            esp.distance.Text = string.format("[%d]", math.floor(distance))
            esp.distance.Color = ESP.DistanceColor
            esp.distance.Size = ESP.TextSize
            esp.distance.Visible = true
        elseif esp.distance then
            esp.distance.Visible = false
        end

        -- Update Head Dot
        if ESP.ShowHeadDot and esp.headDot then
            local headPos = camera:WorldToViewportPoint(head.Position)
            esp.headDot.Position = Vector2.new(headPos.X, headPos.Y)
            esp.headDot.Color = ESP.HeadDotColor
            esp.headDot.Visible = true
        elseif esp.headDot then
            esp.headDot.Visible = false
        end
    else
        -- Hide ESP if player is not on screen or too far
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

-- Add Init function
function ESP:Init()
    -- Initialize ESP for existing players
    for _, v in pairs(players:GetPlayers()) do
        if v ~= player then
            CreateESP(v)
        end
    end

    -- Set up player connections
    players.PlayerAdded:Connect(function(plr)
        if plr ~= player then
            CreateESP(plr)
        end
    end)

    players.PlayerRemoving:Connect(CleanupESP)
end

-- Add player management functions
function ESP:AddPlayer(plr)
    if plr ~= player then
        CreateESP(plr)
    end
end

function ESP:RemovePlayer(plr)
    CleanupESP(plr)
end

function ESP:UpdateSettings(settings)
    for key, value in pairs(settings) do
        if self[key] ~= nil then
            self[key] = value
        end
    end
end

return ESP
