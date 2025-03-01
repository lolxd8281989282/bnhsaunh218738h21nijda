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

-- Store ESP lines in a separate table instead of attaching to Player instances
ESP.PlayerESP = {}

-- ESP Function
function ESP:CreateESP(plr)
    if not self.PlayerESP[plr.Name] then
        self.PlayerESP[plr.Name] = {
            box = {NewLine(), NewLine(), NewLine(), NewLine()},
            name = NewText(),
            healthBar = NewLine(),
            healthBarBackground = NewLine(),
            equippedItem = NewText(),
            distance = NewText(),
            headDot = NewCircle(),
        }
    end
end

function ESP:RemoveESP(plr)
    if self.PlayerESP[plr.Name] then
        for _, drawing in pairs(self.PlayerESP[plr.Name]) do
            if type(drawing) == "table" then
                for _, line in pairs(drawing) do
                    line:Remove()
                end
            else
                drawing:Remove()
            end
        end
        self.PlayerESP[plr.Name] = nil
    end
end

function ESP:UpdateESP()
    for _, plr in pairs(players:GetPlayers()) do
        if plr == player and not self.Settings.SelfESP then continue end
        
        local espData = self.PlayerESP[plr.Name]
        if not espData then
            self:CreateESP(plr)
            espData = self.PlayerESP[plr.Name]
        end

        if not self.Settings.Enabled then
            for _, drawing in pairs(espData) do
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
                    for i, line in ipairs(espData.box) do
                        line.Visible = true
                        line.Color = self.Settings.BoxColor
                        line.Thickness = self.Settings.BoxThickness
                    end

                    espData.box[1].From = boxPosition
                    espData.box[1].To = boxPosition + Vector2.new(boxSize.X, 0)
                    espData.box[2].From = boxPosition + Vector2.new(boxSize.X, 0)
                    espData.box[2].To = boxPosition + boxSize
                    espData.box[3].From = boxPosition + boxSize
                    espData.box[3].To = boxPosition + Vector2.new(0, boxSize.Y)
                    espData.box[4].From = boxPosition
                    espData.box[4].To = boxPosition + Vector2.new(0, boxSize.Y)
                else
                    for _, line in ipairs(espData.box) do
                        line.Visible = false
                    end
                end

                -- Name ESP
                if self.Settings.ShowNames then
                    espData.name.Visible = true
                    espData.name.Position = Vector2.new(screenPos.X, screenPos.Y - size.Y * 2)
                    espData.name.Text = plr.Name
                    espData.name.Color = self.Settings.NameColor
                else
                    espData.name.Visible = false
                end

                -- Health Bar
                if self.Settings.ShowHealthBars then
                    local healthPercent = humanoid.Health / humanoid.MaxHealth
                    local barPos = Vector2.new(screenPos.X - size.X - 5, screenPos.Y - size.Y * 1.5)
                    local barSize = Vector2.new(0, size.Y * 3)

                    espData.healthBarBackground.Visible = true
                    espData.healthBarBackground.From = barPos
                    espData.healthBarBackground.To = barPos + Vector2.new(0, barSize.Y)
                    espData.healthBarBackground.Color = Color3.fromRGB(25, 25, 25)
                    espData.healthBarBackground.Thickness = 4

                    espData.healthBar.Visible = true
                    espData.healthBar.From = barPos + Vector2.new(0, barSize.Y * (1 - healthPercent))
                    espData.healthBar.To = barPos + Vector2.new(0, barSize.Y)
                    espData.healthBar.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
                    espData.healthBar.Thickness = 2
                else
                    espData.healthBar.Visible = false
                    espData.healthBarBackground.Visible = false
                end

                -- Equipped Item
                if self.Settings.ShowEquippedItem then
                    local tool = plr.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        espData.equippedItem.Visible = true
                        espData.equippedItem.Position = Vector2.new(screenPos.X, screenPos.Y + size.Y * 2)
                        espData.equippedItem.Text = tool.Name
                        espData.equippedItem.Color = self.Settings.EquippedItemColor
                    else
                        espData.equippedItem.Visible = false
                    end
                else
                    espData.equippedItem.Visible = false
                end

                -- Distance
                if self.Settings.ShowDistance then
                    espData.distance.Visible = true
                    espData.distance.Position = Vector2.new(screenPos.X, screenPos.Y + size.Y * 2.5)
                    espData.distance.Text = string.format("%.0f studs", distance)
                    espData.distance.Color = self.Settings.DistanceColor
                else
                    espData.distance.Visible = false
                end

                -- Head Dot
                if self.Settings.ShowHeadDot and head then
                    local headPos = camera:WorldToViewportPoint(head.Position)
                    espData.headDot.Visible = true
                    espData.headDot.Position = Vector2.new(headPos.X, headPos.Y)
                    espData.headDot.Color = self.Settings.HeadDotColor
                else
                    espData.headDot.Visible = false
                end
            else
                for _, drawing in pairs(espData) do
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
            for _, drawing in pairs(espData) do
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
