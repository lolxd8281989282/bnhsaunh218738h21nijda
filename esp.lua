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
    BulletTracers = false,
    BoxColor = Color3.fromRGB(255, 255, 255),
    NameColor = Color3.fromRGB(255, 255, 255),
    HealthBarColor = Color3.fromRGB(0, 255, 0),
    ArmorBarColor = Color3.fromRGB(0, 255, 255,255),
    HealthBarColor = Color3.fromRGB(0, 255, 0),
    ArmorBarColor = Color3.fromRGB(0, 255, 255),
    DistanceColor = Color3.fromRGB(255, 255, 255),
    WeaponColor = Color3.fromRGB(255, 255, 255),
    FlagsColor = Color3.fromRGB(255, 255, 255),
    BoneColor = Color3.fromRGB(255, 255, 255),
    BulletTracersColor = Color3.fromRGB(139, 0, 0),
    TextSize = 14,
    TextFont = Drawing.Fonts.UI,
    MaxDistance = 1000,
    OutlineTransparency = 1,
    TracerDuration = 1.5
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
        Name = CreateDrawing("Text", {Text = player.Name, Size = ESP.TextSize, Font = ESP.TextFont, Center = true, Outline = true, Color = ESP.NameColor, Visible = false}),
        HealthBar = CreateDrawing("Line", {Thickness = 2, Color = ESP.HealthBarColor, Visible = false}),
        ArmorBar = CreateDrawing("Line", {Thickness = 2, Color = ESP.ArmorBarColor, Visible = false}),
        Distance = CreateDrawing("Text", {Size = ESP.TextSize, Font = ESP.TextFont, Center = true, Outline = true, Color = ESP.DistanceColor, Visible = false}),
        Weapon = CreateDrawing("Text", {Size = ESP.TextSize, Font = ESP.TextFont, Center = true, Outline = true, Color = ESP.WeaponColor, Visible = false}),
        Flags = CreateDrawing("Text", {Size = ESP.TextSize, Font = ESP.TextFont, Center = true, Outline = true, Color = ESP.FlagsColor, Visible = false}),
        Bone = CreateDrawing("Line", {Thickness = 1, Color = ESP.BoneColor, Visible = false})
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
    if not humanoidRootPart or not humanoid then
        self:Hide()
        return true
    end

    local position, onScreen = CurrentCamera:WorldToViewportPoint(humanoidRootPart.Position)
    if not onScreen or GetDistanceFromCamera(humanoidRootPart.Position) > ESP.MaxDistance then
        self:Hide()
        return true
    end

    local size = (CurrentCamera:WorldToViewportPoint(humanoidRootPart.Position - Vector3.new(0, 3, 0)).Y - CurrentCamera:WorldToViewportPoint(humanoidRootPart.Position + Vector3.new(0, 2.6, 0)).Y) / 2

    -- Update Box
    if ESP.ShowBoxes then
        self.Drawings.Box.Size = Vector2.new(size * 1.5, size * 1.8)
        self.Drawings.Box.Position = Vector2.new(position.X - size * 1.5 / 2, position.Y - size * 1.8 / 2)
        self.Drawings.Box.Color = ESP.BoxColor
        self.Drawings.Box.Visible = true
    else
        self.Drawings.Box.Visible = false
    end

    -- Update Name
    if ESP.ShowNames then
        self.Drawings.Name.Position = Vector2.new(position.X, position.Y - size * 1.8 / 2 - 15)
        self.Drawings.Name.Color = ESP.NameColor
        self.Drawings.Name.Visible = true
    else
        self.Drawings.Name.Visible = false
    end

    -- Update Health Bar
    if ESP.ShowHealthBars and humanoid then
        local health = humanoid.Health / humanoid.MaxHealth
        self.Drawings.HealthBar.From = Vector2.new(position.X - size * 1.5 / 2 - 5, position.Y + size * 1.8 / 2)
        self.Drawings.HealthBar.To = Vector2.new(position.X - size * 1.5 / 2 - 5, position.Y - size * 1.8 / 2 * health)
        self.Drawings.HealthBar.Color = ESP.HealthBarColor
        self.Drawings.HealthBar.Visible = true
    else
        self.Drawings.HealthBar.Visible = false
    end

    -- Update Armor Bar
    if ESP.ShowArmorBar then
        local armor = humanoid:GetAttribute("Armor") or 0
        local maxArmor = humanoid:GetAttribute("MaxArmor") or 100
        local armorPercentage = armor / maxArmor
        self.Drawings.ArmorBar.From = Vector2.new(position.X + size * 1.5 / 2 + 5, position.Y + size * 1.8 / 2)
        self.Drawings.ArmorBar.To = Vector2.new(position.X + size * 1.5 / 2 + 5, position.Y - size * 1.8 / 2 * armorPercentage)
        self.Drawings.ArmorBar.Color = ESP.ArmorBarColor
        self.Drawings.ArmorBar.Visible = true
    else
        self.Drawings.ArmorBar.Visible = false
    end

    -- Update Distance
    if ESP.ShowDistance then
        local distance = math.floor(GetDistanceFromCamera(humanoidRootPart.Position))
        self.Drawings.Distance.Text = tostring(distance) .. "m"
        self.Drawings.Distance.Position = Vector2.new(position.X, position.Y + size * 1.8 / 2 + 5)
        self.Drawings.Distance.Color = ESP.DistanceColor
        self.Drawings.Distance.Visible = true
    else
        self.Drawings.Distance.Visible = false
    end

    -- Update Weapon
    if ESP.ShowWeapon then
        local weapon = character:FindFirstChildOfClass("Tool")
        if weapon then
            self.Drawings.Weapon.Text = weapon.Name
            self.Drawings.Weapon.Position = Vector2.new(position.X, position.Y + size * 1.8 / 2 + 20)
            self.Drawings.Weapon.Color = ESP.WeaponColor
            self.Drawings.Weapon.Visible = true
        else
            self.Drawings.Weapon.Visible = false
        end
    else
        self.Drawings.Weapon.Visible = false
    end

    -- Update Flags
    if ESP.ShowFlags then
        local flags = {}
        if humanoid.Jump then
            table.insert(flags, "Jumping")
        end
        if #flags > 0 then
            self.Drawings.Flags.Text = table.concat(flags, ", ")
            self.Drawings.Flags.Position = Vector2.new(position.X, position.Y + size * 1.8 / 2 + 35)
            self.Drawings.Flags.Color = ESP.FlagsColor
            self.Drawings.Flags.Visible = true
        else
            self.Drawings.Flags.Visible = false
        end
    else
        self.Drawings.Flags.Visible = false
    end

    -- Update Bone ESP
    if ESP.ShowBone then
        local head = character:FindFirstChild("Head")
        if head then
            local headPosition = CurrentCamera:WorldToViewportPoint(head.Position)
            self.Drawings.Bone.From = Vector2.new(position.X, position.Y)
            self.Drawings.Bone.To = Vector2.new(headPosition.X, headPosition.Y)
            self.Drawings.Bone.Color = ESP.BoneColor
            self.Drawings.Bone.Visible = true
        else
            self.Drawings.Bone.Visible = false
        end
    else
        self.Drawings.Bone.Visible = false
    end

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

-- Main ESP Functions
ESP.Objects = {}

function ESP:Toggle(state)
    self.Enabled = state
    if self.Enabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer or self.SelfESP then
                self.Objects[player] = ESPObject.new(player)
            end
        end
    else
        for _, object in pairs(self.Objects) do
            object:Hide()
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
end

function ESP:Init()
    -- Connections
    Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer or ESP.SelfESP then
            ESP.Objects[player] = ESPObject.new(player)
        end
    end)

    Players.PlayerRemoving:Connect(function(player)
        if ESP.Objects[player] then
            ESP.Objects[player]:Remove()
        end
    end)

    RunService.RenderStepped:Connect(function()
        if ESP.Enabled then
            ESP:Update()
        end
    end)

    return self
end

return ESP
