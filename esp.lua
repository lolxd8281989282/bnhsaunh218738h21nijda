local ESP = {
    Enabled = false,
    TeamCheck = false,
    SelfESP = false,
    ShowNames = false,
    ShowBoxes = false,
    ShowHealthBars = false,
    ShowArmorBar = false,
    ShowDistance = false,
    ShowWeapon = false,
    ShowFlags = false,
    ShowBone = false,
    ShowHeadCircle = false,
    ShowChams = false,
    ShowHighlight = false,
    BulletTracers = false,
    BoxColor = Color3.fromRGB(255, 255, 255),
    NameColor = Color3.fromRGB(255, 255, 255),
    HealthBarColor = Color3.fromRGB(0, 255, 0),
    ArmorBarColor = Color3.fromRGB(0, 255, 255),
    DistanceColor = Color3.fromRGB(255, 255, 255),
    WeaponColor = Color3.fromRGB(255, 255, 255),
    FlagsColor = Color3.fromRGB(255, 255, 255),
    BoneColor = Color3.fromRGB(255, 255, 255),
    HeadCircleColor = Color3.fromRGB(255, 255, 255),
    ChamsColor = Color3.fromRGB(147, 112, 219),
    HighlightColor = Color3.fromRGB(255, 255, 255),
    BulletTracersColor = Color3.fromRGB(139, 0, 0),
    TextSize = 11,
    TextFont = Drawing.Fonts.Code,
    MaxDistance = 1000,
    OutlineTransparency = 1,
    TracerDuration = 1.5,
    BoxType = "2D",
    ChamsCache = {},
    HighlightCache = {}
}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local CurrentCamera = Workspace.CurrentCamera

-- Helper Functions
local function CreateDrawing(type, properties)
    local drawing = Drawing.new(type)
    for property, value in pairs(properties) do
        drawing[property] = value
    end
    return drawing
end

local function IsOnScreen(position)
    local _, onScreen = CurrentCamera:WorldToViewportPoint(position)
    return onScreen
end

local function GetDistanceFromCamera(position)
    return (CurrentCamera.CFrame.Position - position).Magnitude
end

-- ESP Object
local ESPObject = {}
ESPObject.__index = ESPObject

function ESPObject.new(player)
    local self = setmetatable({}, ESPObject)
    self.Player = player
    self.Character = player.Character or player.CharacterAdded:Wait()
    
    self.Drawings = {
        Box = CreateDrawing("Square", {Thickness = 1, Filled = false, Transparency = 1, Color = ESP.BoxColor, Visible = false}),
        BoxOutline = CreateDrawing("Square", {Thickness = 3, Filled = false, Transparency = 1, Color = Color3.new(0, 0, 0), Visible = false}),
        Name = CreateDrawing("Text", {Text = player.Name, Size = ESP.TextSize, Font = ESP.TextFont, Center = true, Outline = true, Color = ESP.NameColor, Visible = false}),
        HealthBar = CreateDrawing("Line", {Thickness = 1, Color = ESP.HealthBarColor, Transparency = 1, Visible = false}),
        HealthBarOutline = CreateDrawing("Line", {Thickness = 3, Color = Color3.new(0, 0, 0), Transparency = 1, Visible = false}),
        ArmorBar = CreateDrawing("Line", {Thickness = 1, Color = ESP.ArmorBarColor, Transparency = 1, Visible = false}),
        ArmorBarOutline = CreateDrawing("Line", {Thickness = 3, Color = Color3.new(0, 0, 0), Transparency = 1, Visible = false}),
        Distance = CreateDrawing("Text", {Size = ESP.TextSize, Font = ESP.TextFont, Center = true, Outline = true, Color = ESP.DistanceColor, Visible = false}),
        Weapon = CreateDrawing("Text", {Size = ESP.TextSize, Font = ESP.TextFont, Center = true, Outline = true, Color = ESP.WeaponColor, Visible = false}),
        Flags = CreateDrawing("Text", {Size = ESP.TextSize, Font = ESP.TextFont, Center = true, Outline = true, Color = ESP.FlagsColor, Visible = false}),
        Bone = CreateDrawing("Line", {Thickness = 1, Color = ESP.BoneColor, Visible = false}),
        HeadCircle = CreateDrawing("Circle", {Thickness = 1, Color = ESP.HeadCircleColor, Visible = false, NumSides = 30}),
        BulletTracer = CreateDrawing("Line", {Thickness = 1, Color = ESP.BulletTracersColor, Visible = false}),
        HealthText = CreateDrawing("Text", {Text = "100", Size = ESP.TextSize, Font = ESP.TextFont, Center = true, Outline = true, Color = Color3.new(1, 1, 1), Visible = false})
    }
    
    player.CharacterAdded:Connect(function(char)
        self.Character = char
    end)
    
    return self
end

function ESPObject:Update()
    if not self.Player or not self.Player.Parent then
        self:Remove()
        return false
    end

    local character = self.Character
    if not character or not ESP.Enabled then
        self:Hide()
        return true
    end

    if self.Player == LocalPlayer and not ESP.SelfESP then
        self:Hide()
        return true
    end

    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local head = character:FindFirstChild("Head")
    
    if not humanoidRootPart or not humanoid or not head then
        self:Hide()
        return true
    end

    local position, onScreen = CurrentCamera:WorldToViewportPoint(humanoidRootPart.Position)
    if not onScreen or GetDistanceFromCamera(humanoidRootPart.Position) > ESP.MaxDistance then
        self:Hide()
        return true
    end

    local topPosition = CurrentCamera:WorldToViewportPoint((humanoidRootPart.CFrame * CFrame.new(0, 3, 0)).Position)
    local bottomPosition = CurrentCamera:WorldToViewportPoint((humanoidRootPart.CFrame * CFrame.new(0, -3.5, 0)).Position)
    local size = bottomPosition.Y - topPosition.Y

    -- Update Box
    if ESP.ShowBoxes then
        local boxSize = Vector2.new(size * 0.6, size)
        local boxPosition = Vector2.new(position.X - size * 0.3, position.Y - size * 0.5)
        
        if ESP.BoxType == "2D" then
            self.Drawings.Box.Size = boxSize
            self.Drawings.Box.Position = boxPosition
            self.Drawings.BoxOutline.Size = boxSize
            self.Drawings.BoxOutline.Position = boxPosition
            self.Drawings.Box.Visible = true
            self.Drawings.BoxOutline.Visible = true
        elseif ESP.BoxType == "3D" then
            -- Implement 3D box drawing here
        elseif ESP.BoxType == "corner" then
            -- Implement corner box drawing here
        end
        
        self.Drawings.Box.Color = ESP.BoxColor
    else
        self.Drawings.Box.Visible = false
        self.Drawings.BoxOutline.Visible = false
    end

    -- Update Health Bar
    if ESP.ShowHealthBars then
        local health = humanoid.Health / humanoid.MaxHealth
        local barHeight = size
        self.Drawings.HealthBarOutline.From = Vector2.new(position.X - size * 0.3 - 5, position.Y + size * 0.5)
        self.Drawings.HealthBarOutline.To = Vector2.new(position.X - size * 0.3 - 5, position.Y - size * 0.5)
        self.Drawings.HealthBar.From = Vector2.new(position.X - size * 0.3 - 5, position.Y + size * 0.5)
        self.Drawings.HealthBar.To = Vector2.new(position.X - size * 0.3 - 5, position.Y + size * 0.5 - barHeight * health)
        self.Drawings.HealthBar.Color = ESP.HealthBarColor
        self.Drawings.HealthBar.Visible = true
        self.Drawings.HealthBarOutline.Visible = true
    else
        self.Drawings.HealthBar.Visible = false
        self.Drawings.HealthBarOutline.Visible = false
    end

    -- Update Health Text
    if ESP.ShowHealthText then
        self.Drawings.HealthText.Text = tostring(math.floor(humanoid.Health))
        self.Drawings.HealthText.Position = Vector2.new(position.X, position.Y - size * 0.5 - 15)
        self.Drawings.HealthText.Visible = true
    else
        self.Drawings.HealthText.Visible = false
    end

    -- Update Armor Bar
    if ESP.ShowArmorBar then
        local armor = humanoid:GetAttribute("Armor") or 0
        local maxArmor = humanoid:GetAttribute("MaxArmor") or 100
        if armor > 0 then
            local armorPercentage = armor / maxArmor
            local barHeight = size
            self.Drawings.ArmorBarOutline.From = Vector2.new(position.X - size * 0.3 - 10, position.Y + size * 0.5)
            self.Drawings.ArmorBarOutline.To = Vector2.new(position.X - size * 0.3 - 10, position.Y - size * 0.5)
            self.Drawings.ArmorBar.From = Vector2.new(position.X - size * 0.3 - 10, position.Y + size * 0.5)
            self.Drawings.ArmorBar.To = Vector2.new(position.X - size * 0.3 - 10, position.Y + size * 0.5 - barHeight * armorPercentage)
            self.Drawings.ArmorBar.Color = ESP.ArmorBarColor
            self.Drawings.ArmorBar.Visible = true
            self.Drawings.ArmorBarOutline.Visible = true
        else
            self.Drawings.ArmorBar.Visible = false
            self.Drawings.ArmorBarOutline.Visible = false
        end
    else
        self.Drawings.ArmorBar.Visible = false
        self.Drawings.ArmorBarOutline.Visible = false
    end

    -- Update other ESP features (names, distances, etc.) here...

    return true
end

function ESPObject:Hide()
    for _, drawing in pairs(self.Drawings) do
        drawing.Visible = false
    end
end

function ESPObject:Remove()
    for _, drawing in pairs(self.Drawings) do
        drawing:Remove()
    end
    ESP.Objects[self.Player] = nil
end

-- Chams Functions
function ESP:CreateChams(player)
    if not self.ChamsCache[player] then
        local character = player.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    local surfaceGui = Instance.new("SurfaceGui")
                    surfaceGui.AlwaysOnTop = true
                    surfaceGui.CanvasSize = Vector2.new(100, 100)
                    surfaceGui.LightInfluence = 0
                    surfaceGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                    surfaceGui.Face = Enum.NormalId.Front
                    surfaceGui.Parent = part

                    local frame = Instance.new("Frame")
                    frame.Size = UDim2.new(1, 0, 1, 0)
                    frame.BackgroundColor3 = self.ChamsColor
                    frame.BackgroundTransparency = 0.5
                    frame.Parent = surfaceGui

                    if not self.ChamsCache[player] then
                        self.ChamsCache[player] = {}
                    end
                    table.insert(self.ChamsCache[player], surfaceGui)
                end
            end
        end
    end
end

function ESP:RemoveChams(player)
    if self.ChamsCache[player] then
        for _, surfaceGui in pairs(self.ChamsCache[player]) do
            surfaceGui:Destroy()
        end
        self.ChamsCache[player] = nil
    end
end

function ESP:UpdateChams()
    for player, chams in pairs(self.ChamsCache) do
        if self.ShowChams and self.Enabled then
            for _, surfaceGui in pairs(chams) do
                surfaceGui.Enabled = true
                surfaceGui.Frame.BackgroundColor3 = self.ChamsColor
            end
        else
            for _, surfaceGui in pairs(chams) do
                surfaceGui.Enabled = false
            end
        end
    end
end

-- Highlight Functions
function ESP:CreateHighlight(player)
    if not self.HighlightCache[player] then
        local character = player.Character
        if character then
            local highlight = Instance.new("Highlight")
            highlight.FillColor = self.HighlightColor
            highlight.OutlineColor = self.HighlightColor
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Adornee = character
            highlight.Parent = character

            self.HighlightCache[player] = highlight
        end
    end
end

function ESP:RemoveHighlight(player)
    if self.HighlightCache[player] then
        self.HighlightCache[player]:Destroy()
        self.HighlightCache[player] = nil
    end
end

function ESP:UpdateHighlight()
    for player, highlight in pairs(self.HighlightCache) do
        if self.ShowHighlight and self.Enabled then
            highlight.Enabled = true
            highlight.FillColor = self.HighlightColor
            highlight.OutlineColor = self.HighlightColor
        else
            highlight.Enabled = false
        end
    end
end

-- Main ESP Functions
ESP.Objects = {}

function ESP:Toggle(state)
    self.Enabled = state
    if self.Enabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer or self.SelfESP then
                self.Objects[player] = ESPObject.new(player)
                if self.ShowChams then
                    self:CreateChams(player)
                end
                if self.ShowHighlight then
                    self:CreateHighlight(player)
                end
            end
        end
    else
        for _, object in pairs(self.Objects) do
            object:Hide()
        end
        for player, _ in pairs(self.ChamsCache) do
            self:RemoveChams(player)
        end
        for player, _ in pairs(self.HighlightCache) do
            self:RemoveHighlight(player)
        end
    end
end

function ESP:Update()
    for player, object in pairs(self.Objects) do
        if not object:Update() then
            object:Remove()
            self.Objects[player] = nil
        end
    end
    self:UpdateChams()
    self:UpdateHighlight()
end

function ESP:Init()
    Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer or ESP.SelfESP then
            ESP.Objects[player] = ESPObject.new(player)
            if ESP.ShowChams and ESP.Enabled then
                ESP:CreateChams(player)
            end
            if ESP.ShowHighlight and ESP.Enabled then
                ESP:CreateHighlight(player)
            end
        end
    end)

    Players.PlayerRemoving:Connect(function(player)
        if ESP.Objects[player] then
            ESP.Objects[player]:Remove()
        end
        ESP:RemoveChams(player)
        ESP:RemoveHighlight(player)
    end)

    RunService.RenderStepped:Connect(function()
        if ESP.Enabled then
            ESP:Update()
        end
    end)

    return self
end

function ESP:UpdateColor(feature, color)
    if feature == "Chams" then
        self.ChamsColor = color
        self:UpdateChams()
    elseif feature == "Highlight" then
        self.HighlightColor = color
        self:UpdateHighlight()
    else
        local propertyName = feature.."Color"
        if self[propertyName] then
            self[propertyName] = color
        end
    end
end

function ESP:ToggleFeature(feature, state)
    if feature == "Chams" then
        self.ShowChams = state
        self:UpdateChams()
    elseif feature == "Highlight" then
        self.ShowHighlight = state
        self:UpdateHighlight()
    else
        if self["Show"..feature] ~= nil then
            self["Show"..feature] = state
        end
    end
end

function ESP:UpdateBoxType(boxType)
    self.BoxType = boxType
end

return ESP
