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

-- Cleanup function for ESP objects
local function CleanupESP(plr)
    if PlayerESP[plr] then
        for _, drawing in pairs(PlayerESP[plr]) do
            if type(drawing) == "table" then
                for _, obj in pairs(drawing) do
                    obj:Remove()
                end
            else
                drawing:Remove()
            end
        end
        PlayerESP[plr] = nil
    end
end

-- ESP Function
local function CreateESP(plr)
    if PlayerESP[plr] then return end -- Prevent duplicate ESP

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
    
    PlayerESP[plr] = lines

    local connection
    connection = runService.RenderStepped:Connect(function()
        if not plr or not plr.Parent then
            CleanupESP(plr)
            connection:Disconnect()
            return
        end

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
                -- ESP drawing code remains the same
                -- ... (rest of the ESP drawing code)
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
    end)

    -- Clean up ESP when player leaves
    plr.AncestryChanged:Connect(function(_, parent)
        if not parent then
            CleanupESP(plr)
            connection:Disconnect()
        end
    end)
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

-- Clean up ESP when players leave
players.PlayerRemoving:Connect(function(plr)
    CleanupESP(plr)
end)

-- Update ESP settings
function ESP:UpdateSettings(settings)
    for key, value in pairs(settings) do
        if self[key] ~= nil then
            self[key] = value
        end
    end
end

return ESP
