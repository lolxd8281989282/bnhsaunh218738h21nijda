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
        line.Thickness = ESP.BoxThickness or 1.4  -- Ensure default thickness
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
        circle.Thickness = ESP.BoxThickness or 1  -- Ensure default thickness
        circle.Filled = true
        circle.Transparency = 1
        circle.NumSides = 30
    end
    return circle
end

-- Cleanup function
local function CleanupESP(plr)
    if PlayerESP[plr] then
        for _, drawing in pairs(PlayerESP[plr]) do
            if drawing then
                pcall(function()
                    drawing:Remove()
                end)
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
