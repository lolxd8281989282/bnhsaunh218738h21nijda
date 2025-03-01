local ESP = {}

-- Services
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local player = players.LocalPlayer
local camera = workspace.CurrentCamera

-- ESP Settings
ESP.Settings = {
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
    ThirdPerson = false,
    CameraFOV = 70,
    CameraAmount = 50,
    AntiClipping = false,
    CustomFog = false,
    FogDistance = 500,
    CustomBrightness = false,
    BrightnessStrength = 50,
    SpeedEnabled = false,
    SpeedAmount = 50,
    FlightEnabled = false,
    FlightAmount = 50,
    StreamProof = false,
}

-- Drawing Functions
local function NewLine()
    local line = Drawing.new("Line")
    line.Visible = false
    line.From = Vector2.new(0, 0)
    line.To = Vector2.new(1, 1)
    line.Color = ESP.Settings.BoxColor
    line.Thickness = ESP.Settings.BoxThickness
    line.Transparency = ESP.Settings.BoxTransparency
    return line
end

local function NewText()
    local text = Drawing.new("Text")
    text.Visible = false
    text.Center = true
    text.Outline = true
    text.Color = ESP.Settings.TextColor
    text.Size = 13
    text.Font = Drawing.Fonts.Monospace
    return text
end

local function NewCircle()
    local circle = Drawing.new("Circle")
    circle.Visible = false
    circle.Radius = 3
    circle.Color = ESP.Settings.BoxColor
    circle.Thickness = 1
    circle.Filled = true
    return circle
end

-- ESP Function
function ESP:CreateESP(plr)
    local lines = {
        box = {NewLine(), NewLine(), NewLine(), NewLine()},
        name = NewText(),
        healthBar = NewLine(),
        healthBarBackground = NewLine(),
        equippedItem = NewText(),
        distance = NewText(),
        headDot = NewCircle(),
    }

    plr.espLines = lines
end

function ESP:UpdateESP()
    for _, plr in pairs(players:GetPlayers()) do
        if plr == player and not self.Settings.SelfESP then continue end
        
        local lines = plr.espLines
        if not lines then continue end

        if not self.Settings.Enabled then
            for _, drawing in pairs(lines) do
                if type(drawing) == "table" then
                    for _, line in pairs(drawing) do
                        line.Visible = false
                    end
                else
                    drawing.Visible = false
                end
            end
            continue
        end

        if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.Humanoid.Health > 0 then
            local humanoid = plr.Character.Humanoid
            local rootPart = plr.Character.HumanoidRootPart
            local head = plr.Character:FindFirstChild("Head")

            if not head then continue end

            local screenPos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
            local distance = (camera.CFrame.Position - rootPart.Position).Magnitude

            if onScreen and distance <= self.Settings.Distance then
                local size = Vector2.new(2000 / distance, 2000 / distance)
                local boxSize = Vector2.new(size.X * 2, size.Y * 3)
                local boxPosition = Vector2.new(screenPos.X - size.X, screenPos.Y - size.Y * 1.5)

                -- Box ESP
                if self.Settings.ShowBoxes then
                    for i, line in ipairs(lines.box) do
                        line.Visible = true
                        line.Color = self.Settings.BoxColor
                        line.Thickness = self.Settings.BoxThickness
                    end

                    lines.box[1].From = boxPosition
                    lines.box[1].To = boxPosition + Vector2.new(boxSize.X, 0)
                    lines.box[2].From = boxPosition + Vector2.new(boxSize.X, 0)
                    lines.box[2].To = boxPosition + boxSize
                    lines.box[3].From = boxPosition + boxSize
                    lines.box[3].To = boxPosition + Vector2.new(0, boxSize.Y)
                    lines.box[4].From = boxPosition
                    lines.box[4].To = boxPosition + Vector2.new(0, boxSize.Y)
                else
                    for _, line in ipairs(lines.box) do
                        line.Visible = false
                    end
                end

                -- Name ESP
                if self.Settings.ShowNames then
                    lines.name.Visible = true
                    lines.name.Position = Vector2.new(screenPos.X, screenPos.Y - size.Y * 2)
                    lines.name.Text = plr.Name
                    lines.name.Color = self.Settings.NameColor
                else
                    lines.name.Visible = false
                end

                -- Health Bar
                if self.Settings.ShowHealthBars then
                    local healthPercent = humanoid.Health / humanoid.MaxHealth
                    local barPos = Vector2.new(screenPos.X - size.X - 5, screenPos.Y - size.Y * 1.5)
                    local barSize = Vector2.new(0, size.Y * 3)

                    lines.healthBarBackground.Visible = true
                    lines.healthBarBackground.From = barPos
                    lines.healthBarBackground.To = barPos + Vector2.new(0, barSize.Y)
                    lines.healthBarBackground.Color = Color3.fromRGB(25, 25, 25)
                    lines.healthBarBackground.Thickness = 4

                    lines.healthBar.Visible = true
                    lines.healthBar.From = barPos + Vector2.new(0, barSize.Y * (1 - healthPercent))
                    lines.healthBar.To = barPos + Vector2.new(0, barSize.Y)
                    lines.healthBar.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
                    lines.healthBar.Thickness = 2
                else
                    lines.healthBar.Visible = false
                    lines.healthBarBackground.Visible = false
                end

                -- Equipped Item
                if self.Settings.ShowEquippedItem then
                    local tool = plr.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        lines.equippedItem.Visible = true
                        lines.equippedItem.Position = Vector2.new(screenPos.X, screenPos.Y + size.Y * 2)
                        lines.equippedItem.Text = tool.Name
                        lines.equippedItem.Color = self.Settings.EquippedItemColor
                    else
                        lines.equippedItem.Visible = false
                    end
                else
                    lines.equippedItem.Visible = false
                end

                -- Distance
                if self.Settings.ShowDistance then
                    lines.distance.Visible = true
                    lines.distance.Position = Vector2.new(screenPos.X, screenPos.Y + size.Y * 2.5)
                    lines.distance.Text = string.format("%.0f studs", distance)
                    lines.distance.Color = self.Settings.DistanceColor
                else
                    lines.distance.Visible = false
                end

                -- Head Dot
                if self.Settings.ShowHeadDot and head then
                    local headPos = camera:WorldToViewportPoint(head.Position)
                    lines.headDot.Visible = true
                    lines.headDot.Position = Vector2.new(headPos.X, headPos.Y)
                    lines.headDot.Color = self.Settings.HeadDotColor
                else
                    lines.headDot.Visible = false
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
end

return ESP
