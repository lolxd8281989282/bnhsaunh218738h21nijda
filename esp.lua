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

-- ESP Creation
function ESP:CreateESP(plr)
    local PlayerDrawings = {
        Box = {
            NewLine(), NewLine(), NewLine(), NewLine(),
            NewLine(), NewLine(), NewLine(), NewLine()
        },
        Name = NewText(),
        HealthBar = NewLine(),
        HealthBarBG = NewLine(),
        ArmorBar = NewLine(),
        ArmorBarBG = NewLine(),
        HeadDot = NewCircle(),
        Distance = NewText(),
        EquippedItem = NewText()
    }

    -- Update ESP
    local function UpdateESP()
        if not ESP.Enabled then
            for _, drawing in pairs(PlayerDrawings.Box) do
                drawing.Visible = false
            end
            PlayerDrawings.Name.Visible = false
            PlayerDrawings.HealthBar.Visible = false
            PlayerDrawings.HealthBarBG.Visible = false
            PlayerDrawings.ArmorBar.Visible = false
            PlayerDrawings.ArmorBarBG.Visible = false
            PlayerDrawings.HeadDot.Visible = false
            PlayerDrawings.Distance.Visible = false
            PlayerDrawings.EquippedItem.Visible = false
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
                if ESP.TeamCheck and plr.Team == player.Team then
                    return
                end

                -- Self ESP Check
                if not ESP.SelfESP and plr == player then
                    return
                end

                -- Box ESP
                if ESP.ShowBoxes then
                    if ESP.BoxType == "Corners" then
                        local cornerSize = boxSize.X * 0.2

                        -- Top left
                        PlayerDrawings.Box[1].From = boxPos
                        PlayerDrawings.Box[1].To = boxPos + Vector2.new(cornerSize, 0)
                        PlayerDrawings.Box[2].From = boxPos
                        PlayerDrawings.Box[2].To = boxPos + Vector2.new(0, cornerSize)

                        -- Top right
                        PlayerDrawings.Box[3].From = boxPos + Vector2.new(boxSize.X, 0)
                        PlayerDrawings.Box[3].To = boxPos + Vector2.new(boxSize.X - cornerSize, 0)
                        PlayerDrawings.Box[4].From = boxPos + Vector2.new(boxSize.X, 0)
                        PlayerDrawings.Box[4].To = boxPos + Vector2.new(boxSize.X, cornerSize)

                        -- Bottom left
                        PlayerDrawings.Box[5].From = boxPos + Vector2.new(0, boxSize.Y)
                        PlayerDrawings.Box[5].To = boxPos + Vector2.new(cornerSize, boxSize.Y)
                        PlayerDrawings.Box[6].From = boxPos + Vector2.new(0, boxSize.Y)
                        PlayerDrawings.Box[6].To = boxPos + Vector2.new(0, boxSize.Y - cornerSize)

                        -- Bottom right
                        PlayerDrawings.Box[7].From = boxPos + Vector2.new(boxSize.X, boxSize.Y)
                        PlayerDrawings.Box[7].To = boxPos + Vector2.new(boxSize.X - cornerSize, boxSize.Y)
                        PlayerDrawings.Box[8].From = boxPos + Vector2.new(boxSize.X, boxSize.Y)
                        PlayerDrawings.Box[8].To = boxPos + Vector2.new(boxSize.X, boxSize.Y - cornerSize)

                        for i = 1, 8 do
                            PlayerDrawings.Box[i].Visible = true
                            PlayerDrawings.Box[i].Color = ESP.BoxColor
                            PlayerDrawings.Box[i].Thickness = ESP.BoxThickness
                        end
                    else
                        -- Full box
                        PlayerDrawings.Box[1].From = boxPos
                        PlayerDrawings.Box[1].To = boxPos + Vector2.new(boxSize.X, 0)
                        PlayerDrawings.Box[2].From = boxPos + Vector2.new(boxSize.X, 0)
                        PlayerDrawings.Box[2].To = boxPos + boxSize
                        PlayerDrawings.Box[3].From = boxPos + boxSize
                        PlayerDrawings.Box[3].To = boxPos + Vector2.new(0, boxSize.Y)
                        PlayerDrawings.Box[4].From = boxPos
                        PlayerDrawings.Box[4].To = boxPos + Vector2.new(0, boxSize.Y)

                        for i = 1, 4 do
                            PlayerDrawings.Box[i].Visible = true
                            PlayerDrawings.Box[i].Color = ESP.BoxColor
                            PlayerDrawings.Box[i].Thickness = ESP.BoxThickness
                        end
                        for i = 5, 8 do
                            PlayerDrawings.Box[i].Visible = false
                        end
                    end
                else
                    for _, drawing in pairs(PlayerDrawings.Box) do
                        drawing.Visible = false
                    end
                end

                -- Name ESP
                if ESP.ShowNames then
                    PlayerDrawings.Name.Position = Vector2.new(pos.X, pos.Y - size.Y * 2)
                    PlayerDrawings.Name.Text = plr.Name
                    PlayerDrawings.Name.Color = ESP.NameColor
                    PlayerDrawings.Name.Visible = true
                else
                    PlayerDrawings.Name.Visible = false
                end

                -- Health Bar
                if ESP.ShowHealthBars then
                    local healthPercent = humanoid.Health / humanoid.MaxHealth
                    local barPos = Vector2.new(boxPos.X - 5, boxPos.Y)
                    local barSize = Vector2.new(0, boxSize.Y)

                    PlayerDrawings.HealthBarBG.From = barPos
                    PlayerDrawings.HealthBarBG.To = barPos + barSize
                    PlayerDrawings.HealthBarBG.Color = Color3.fromRGB(0, 0, 0)
                    PlayerDrawings.HealthBarBG.Thickness = 3
                    PlayerDrawings.HealthBarBG.Visible = true

                    PlayerDrawings.HealthBar.From = barPos + Vector2.new(0, barSize.Y * (1 - healthPercent))
                    PlayerDrawings.HealthBar.To = barPos + barSize
                    PlayerDrawings.HealthBar.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
                    PlayerDrawings.HealthBar.Thickness = 1
                    PlayerDrawings.HealthBar.Visible = true
                else
                    PlayerDrawings.HealthBar.Visible = false
                    PlayerDrawings.HealthBarBG.Visible = false
                end

                -- Head Dot
                if ESP.ShowHeadDot and head then
                    local headPos = camera:WorldToViewportPoint(head.Position)
                    PlayerDrawings.HeadDot.Position = Vector2.new(headPos.X, headPos.Y)
                    PlayerDrawings.HeadDot.Color = ESP.HeadDotColor
                    PlayerDrawings.HeadDot.Visible = true
                else
                    PlayerDrawings.HeadDot.Visible = false
                end

                -- Distance
                if ESP.ShowDistance then
                    PlayerDrawings.Distance.Position = Vector2.new(pos.X, pos.Y + size.Y * 2)
                    PlayerDrawings.Distance.Text = string.format("[%d]", math.floor(distance))
                    PlayerDrawings.Distance.Color = ESP.DistanceColor
                    PlayerDrawings.Distance.Visible = true
                else
                    PlayerDrawings.Distance.Visible = false
                end

                -- Equipped Item
                if ESP.ShowEquippedItem then
                    local tool = plr.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        PlayerDrawings.EquippedItem.Position = Vector2.new(pos.X, pos.Y + size.Y * 2.5)
                        PlayerDrawings.EquippedItem.Text = tool.Name
                        PlayerDrawings.EquippedItem.Color = ESP.EquippedItemColor
                        PlayerDrawings.EquippedItem.Visible = true
                    else
                        PlayerDrawings.EquippedItem.Visible = false
                    end
                else
                    PlayerDrawings.EquippedItem.Visible = false
                end
            else
                for _, drawing in pairs(PlayerDrawings.Box) do
                    drawing.Visible = false
                end
                PlayerDrawings.Name.Visible = false
                PlayerDrawings.HealthBar.Visible = false
                PlayerDrawings.HealthBarBG.Visible = false
                PlayerDrawings.ArmorBar.Visible = false
                PlayerDrawings.ArmorBarBG.Visible = false
                PlayerDrawings.HeadDot.Visible = false
                PlayerDrawings.Distance.Visible = false
                PlayerDrawings.EquippedItem.Visible = false
            end
        end
    end

    -- Connect update function
    runService.RenderStepped:Connect(UpdateESP)
end

-- Initialize ESP
function ESP:Init()
    for _, plr in pairs(players:GetPlayers()) do
        if plr ~= player then
            ESP:CreateESP(plr)
        end
    end

    players.PlayerAdded:Connect(function(plr)
        ESP:CreateESP(plr)
    end)
end

return ESP
