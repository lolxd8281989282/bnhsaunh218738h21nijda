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

-- Drawing Functions
local function CreateDrawing(type, properties)
    local drawing = Drawing.new(type)
    for property, value in pairs(properties) do
        drawing[property] = value
    end
    return drawing
end

local function NewLine()
    return CreateDrawing("Line", {
        Visible = false,
        From = Vector2.new(0, 0),
        To = Vector2.new(1, 1),
        Color = ESP.BoxColor,
        Thickness = ESP.BoxThickness,
        Transparency = 1
    })
end

local function NewText()
    return CreateDrawing("Text", {
        Visible = false,
        Center = true,
        Outline = true,
        Color = ESP.TextColor,
        Size = ESP.TextSize,
        Font = Drawing.Fonts.Monospace,
        Transparency = 1
    })
end

local function NewCircle()
    return CreateDrawing("Circle", {
        Visible = false,
        Radius = 3,
        Color = ESP.BoxColor,
        Thickness = 1,
        Filled = true,
        Transparency = 1
    })
end

-- Cleanup function
local function CleanupESP(plr)
    if PlayerESP[plr] then
        for _, drawing in pairs(PlayerESP[plr]) do
            if type(drawing) == "table" then
                for _, obj in pairs(drawing) do
                    pcall(function() obj:Remove() end)
                end
            else
                pcall(function() drawing:Remove() end)
            end
        end
        PlayerESP[plr] = nil
    end
end

-- ESP Function
local function CreateESP(plr)
    if PlayerESP[plr] then return end

    local esp = {
        box = {NewLine(), NewLine(), NewLine(), NewLine()},
        name = NewText(),
        healthBar = NewLine(),
        healthBarBG = NewLine(),
        distance = NewText(),
        headDot = NewCircle()
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
                        obj.Visible = false
                    end
                else
                    drawing.Visible = false
                end
            end
            return
        end

        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and 
           plr.Character:FindFirstChild("Humanoid") and 
           plr.Character.Humanoid.Health > 0 then
            
            local humanoid = plr.Character.Humanoid
            local rootPart = plr.Character.HumanoidRootPart
            local head = plr.Character:FindFirstChild("Head")
            
            if not head then return end

            local pos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
            local distance = (camera.CFrame.Position - rootPart.Position).Magnitude

            if onScreen and distance <= ESP.Distance then
                local size = Vector2.new(2000 / distance, 2000 / distance)
                local boxSize = Vector2.new(size.X * 1.5, size.Y * 3)
                local boxPos = Vector2.new(pos.X - boxSize.X / 2, pos.Y - boxSize.Y / 2)

                -- Box ESP
                if ESP.ShowBoxes then
                    esp.box[1].From = Vector2.new(boxPos.X, boxPos.Y)
                    esp.box[1].To = Vector2.new(boxPos.X + boxSize.X, boxPos.Y)
                    esp.box[2].From = Vector2.new(boxPos.X + boxSize.X, boxPos.Y)
                    esp.box[2].To = Vector2.new(boxPos.X + boxSize.X, boxPos.Y + boxSize.Y)
                    esp.box[3].From = Vector2.new(boxPos.X, boxPos.Y + boxSize.Y)
                    esp.box[3].To = Vector2.new(boxPos.X + boxSize.X, boxPos.Y + boxSize.Y)
                    esp.box[4].From = Vector2.new(boxPos.X, boxPos.Y)
                    esp.box[4].To = Vector2.new(boxPos.X, boxPos.Y + boxSize.Y)

                    for _, line in pairs(esp.box) do
                        line.Color = ESP.BoxColor
                        line.Thickness = ESP.BoxThickness
                        line.Visible = true
                    end
                else
                    for _, line in pairs(esp.box) do
                        line.Visible = false
                    end
                end

                -- Name ESP
                if ESP.ShowNames then
                    esp.name.Position = Vector2.new(pos.X, boxPos.Y - esp.name.TextBounds.Y - 2)
                    esp.name.Text = plr.Name
                    esp.name.Color = ESP.NameColor
                    esp.name.Size = ESP.TextSize
                    esp.name.Visible = true
                else
                    esp.name.Visible = false
                end

                -- Health Bar
                if ESP.ShowHealthBars then
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
                    esp.healthBar.Visible = false
                    esp.healthBarBG.Visible = false
                end

                -- Distance ESP
                if ESP.ShowDistance then
                    esp.distance.Position = Vector2.new(pos.X, boxPos.Y + boxSize.Y + 2)
                    esp.distance.Text = string.format("[%d]", math.floor(distance))
                    esp.distance.Color = ESP.DistanceColor
                    esp.distance.Size = ESP.TextSize
                    esp.distance.Visible = true
                else
                    esp.distance.Visible = false
                end

                -- Head Dot
                if ESP.ShowHeadDot and head then
                    local headPos = camera:WorldToViewportPoint(head.Position)
                    esp.headDot.Position = Vector2.new(headPos.X, headPos.Y)
                    esp.headDot.Color = ESP.HeadDotColor
                    esp.headDot.Visible = true
                else
                    esp.headDot.Visible = false
                end
            else
                for _, drawing in pairs(esp) do
                    if type(drawing) == "table" then
                        for _, obj in pairs(drawing) do
                            obj.Visible = false
                        end
                    else
                        drawing.Visible = false
                    end
                end
            end
        else
            for _, drawing in pairs(esp) do
                if type(drawing) == "table" then
                    for _, obj in pairs(drawing) do
                        obj.Visible = false
                    end
                else
                    drawing.Visible = false
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
