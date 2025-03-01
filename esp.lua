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
    OutlineColor = Color3.new(1, 1, 1),
    OutlineThickness = 3,
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

-- Drawing Functions
local function NewLine()
    local line = Drawing.new("Line")
    line.Visible = false
    line.From = Vector2.new(0, 0)
    line.To = Vector2.new(1, 1)
    line.Color = ESP.BoxColor
    line.Thickness = ESP.BoxThickness
    line.Transparency = ESP.BoxTransparency
    return line
end

local function NewText()
    local text = Drawing.new("Text")
    text.Visible = false
    text.Center = true
    text.Outline = true
    text.Color = ESP.TextColor
    text.Size = 13
    text.Font = Drawing.Fonts.Monospace
    return text
end

local function NewCircle()
    local circle = Drawing.new("Circle")
    circle.Visible = false
    circle.Radius = 3
    circle.Color = ESP.BoxColor
    circle.Thickness = 1
    circle.Filled = true
    return circle
end

-- ESP Function
local function CreateESP(plr)
    local lines = {
        box = {NewLine(), NewLine(), NewLine(), NewLine(), NewLine(), NewLine(), NewLine(), NewLine()},
        name = NewText(),
        healthBar = NewLine(),
        healthBarBG = NewLine(),
        armorBar = NewLine(),
        armorBarBG = NewLine(),
        itemText = NewText(),
        headDot = NewCircle(),
    }

    local function UpdateESP()
        if not ESP.Enabled then
            for _, drawing in pairs(lines) do
                if type(drawing) == "table" then
                    for _, line in pairs(drawing) do
                        line.Visible = false
                    end
                else
                    drawing.Visible = false
                end
            end
            return
        end

        if plr.Character and plr.Character:FindFirstChild("Humanoid") and 
           plr.Character:FindFirstChild("HumanoidRootPart") and 
           plr.Character.Humanoid.Health > 0 then
            
            local humanoid = plr.Character.Humanoid
            local rootPart = plr.Character.HumanoidRootPart
            local head = plr.Character:FindFirstChild("Head")

            if not head then return end

            local pos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
            local distance = (camera.CFrame.Position - rootPart.Position).Magnitude

            if onScreen and distance <= ESP.Distance then
                local size = Vector2.new(2000 / distance, 2000 / distance)
                local boxSize = Vector2.new(size.X * 2, size.Y * 3)
                local boxPos = Vector2.new(pos.X - size.X, pos.Y - size.Y * 1.5)

                -- Team Check
                if ESP.TeamCheck and plr.Team == player.Team then return end

                -- Self ESP Check
                if not ESP.SelfESP and plr == player then return end

                -- Box ESP
                if ESP.ShowBoxes then
                    if ESP.BoxType == "Corners" then
                        local cornerSize = boxSize.X * 0.2

                        -- Top left
                        lines.box[1].From = boxPos
                        lines.box[1].To = boxPos + Vector2.new(cornerSize, 0)
                        lines.box[2].From = boxPos
                        lines.box[2].To = boxPos + Vector2.new(0, cornerSize)

                        -- Top right
                        lines.box[3].From = boxPos + Vector2.new(boxSize.X, 0)
                        lines.box[3].To = boxPos + Vector2.new(boxSize.X - cornerSize, 0)
                        lines.box[4].From = boxPos + Vector2.new(boxSize.X, 0)
                        lines.box[4].To = boxPos + Vector2.new(boxSize.X, cornerSize)

                        -- Bottom left
                        lines.box[5].From = boxPos + Vector2.new(0, boxSize.Y)
                        lines.box[5].To = boxPos + Vector2.new(cornerSize, boxSize.Y)
                        lines.box[6].From = boxPos + Vector2.new(0, boxSize.Y)
                        lines.box[6].To = boxPos + Vector2.new(0, boxSize.Y - cornerSize)

                        -- Bottom right
                        lines.box[7].From = boxPos + Vector2.new(boxSize.X, boxSize.Y)
                        lines.box[7].To = boxPos + Vector2.new(boxSize.X - cornerSize, boxSize.Y)
                        lines.box[8].From = boxPos + Vector2.new(boxSize.X, boxSize.Y)
                        lines.box[8].To = boxPos + Vector2.new(boxSize.X, boxSize.Y - cornerSize)

                        for i = 1, 8 do
                            lines.box[i].Visible = true
                            lines.box[i].Color = ESP.BoxColor
                            lines.box[i].Thickness = ESP.BoxThickness
                        end
                    else
                        -- Full box
                        lines.box[1].From = boxPos
                        lines.box[1].To = boxPos + Vector2.new(boxSize.X, 0)
                        lines.box[2].From = boxPos + Vector2.new(boxSize.X, 0)
                        lines.box[2].To = boxPos + boxSize
                        lines.box[3].From = boxPos + boxSize
                        lines.box[3].To = boxPos + Vector2.new(0, boxSize.Y)
                        lines.box[4].From = boxPos
                        lines.box[4].To = boxPos + Vector2.new(0, boxSize.Y)

                        for i = 1, 4 do
                            lines.box[i].Visible = true
                            lines.box[i].Color = ESP.BoxColor
                            lines.box[i].Thickness = ESP.BoxThickness
                        end
                        for i = 5, 8 do
                            lines.box[i].Visible = false
                        end
                    end
                else
                    for i = 1, 8 do
                        lines.box[i].Visible = false
                    end
                end

                -- Name ESP
                if ESP.ShowNames then
                    lines.name.Position = Vector2.new(pos.X, pos.Y - size.Y * 2)
                    lines.name.Text = plr.Name
                    lines.name.Color = ESP.NameColor
                    lines.name.Visible = true
                else
                    lines.name.Visible = false
                end

                -- Health Bar
                if ESP.ShowHealthBars then
                    local healthPercent = humanoid.Health / humanoid.MaxHealth
                    local barPos = Vector2.new(boxPos.X - 5, boxPos.Y)
                    local barSize = Vector2.new(0, boxSize.Y)
                
                    lines.healthBarBG.From = barPos
                    lines.healthBarBG.To = barPos + barSize
                    lines.healthBarBG.Color = Color3.fromRGB(0, 0, 0)
                    lines.healthBarBG.Thickness = 3
                    lines.healthBarBG.Visible = true
                
                    lines.healthBar.From = barPos + Vector2.new(0, barSize.Y * (1 - healthPercent))
                    lines.healthBar.To = barPos + barSize
                    lines.healthBar.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
                    lines.healthBar.Thickness = 1
                    lines.healthBar.Visible = true
                else
                    lines.healthBar.Visible = false
                    lines.healthBarBG.Visible = false
                end

                -- Other features (Head Dot, Equipped Item, etc.) can be implemented similarly
            else
                for _, drawing in pairs(lines) do
                    if type(drawing) == "table" then
                        for _, line in pairs(drawing) do
                            line.Visible = false
                        end
                    else
                        drawing.Visible = false
                    end
                end
            end
        else
            for _, drawing in pairs(lines) do
                if type(drawing) == "table" then
                    for _, line in pairs(drawing) do
                        line.Visible = false
                    end
                else
                    drawing.Visible = false
                end
            end
        end
    end

    runService.RenderStepped:Connect(UpdateESP)
end

-- Initialize ESP for existing players
for _, v in pairs(players:GetChildren()) do
    if v ~= player then
        CreateESP(v)
    end
end

-- Initialize ESP for new players
players.PlayerAdded:Connect(function(plr)
    if plr ~= player then
        CreateESP(plr)
    end
end)

return ESP
