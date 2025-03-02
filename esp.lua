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
    BulletTracersColor = Color3.fromRGB(139, 0, 0),
    TextSize = 14,
    TextFont = Drawing.Fonts.UI,
    MaxDistance = 1000,
    OutlineTransparency = 1,
    TracerDuration = 1.5,
    ChamsCache = {}
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
        Bone = CreateDrawing("Line", {Thickness = 1, Color = ESP.BoneColor, Visible = false}),
        HeadCircle = CreateDrawing("Circle", {Thickness = 1, Color = ESP.HeadCircleColor, Visible = false, NumSides = 30}),
        BulletTracer = CreateDrawing("Line", {Thickness = 1, Color = ESP.BulletTracersColor, Visible = false})
    }
    
    -- Handle character changes
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

    -- Update Head Circle
    if ESP.ShowHeadCircle and head then
        local headPos = CurrentCamera:WorldToViewportPoint(head.Position)
        if headPos.Z > 0 then
            self.Drawings.HeadCircle.Position = Vector2.new(headPos.X, headPos.Y)
            self.Drawings.HeadCircle.Radius = size * 0.5
            self.Drawings.HeadCircle.Color = ESP.HeadCircleColor
            self.Drawings.HeadCircle.Visible = true
        else
            self.Drawings.HeadCircle.Visible = false
        end
    else
        self.Drawings.HeadCircle.Visible = false
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

-- Chams Functions
function ESP:CreateChams(player)
    if not self.ChamsCache[player] then
        local character = player.Character
        if character then
            -- Create a folder to hold individual part highlights
            local chamsFolder = Instance.new("Folder")
            chamsFolder.Name = "ChamsFolder"
            chamsFolder.Parent = character

            -- Function to create highlight for a body part
            local function createPartHighlight(part)
                if part:IsA("BasePart") and part.Parent == character and 
                   part.Name ~= "Head" and not part:IsA("Accessory") and 
                   not part.Parent:IsA("Accessory") and not part.Parent:IsA("Tool") then
                    local highlight = Instance.new("Highlight")
                    highlight.FillColor = self.ChamsColor
                    highlight.OutlineColor = self.ChamsColor
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 1
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Adornee = part
                    highlight.Parent = chamsFolder
                    part.Transparency = 0.8
                end
            end
            
            -- Apply highlights to existing body parts
            for _, part in pairs(character:GetChildren()) do
                createPartHighlight(part)
            end
            
            -- Handle new parts being added
            local descendantConnection = character.ChildAdded:Connect(function(part)
                createPartHighlight(part)
            end)
            
            -- Store in cache
            self.ChamsCache[player] = {
                ChamsFolder = chamsFolder,
                Connection = descendantConnection
            }

            -- Handle character changes
            player.CharacterAdded:Connect(function(char)
                if self.ChamsCache[player] then
                    self:RemoveChams(player)
                    if self.ShowChams and self.Enabled then
                        self:CreateChams(player)
                    end
                end
            end)
        end
    end
end

function ESP:RemoveChams(player)
    local cache = self.ChamsCache[player]
    if cache then
        if cache.Connection then
            cache.Connection:Disconnect()
        end
        if cache.ChamsFolder then
            cache.ChamsFolder:Destroy()
        end
        
        -- Reset transparency for body parts
        local character = player.Character
        if character then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "Head" and 
                   not part:IsA("Accessory") and not part.Parent:IsA("Tool") then
                    part.Transparency = 0
                end
            end
        end
        
        self.ChamsCache[player] = nil
    end
end

function ESP:UpdateChams()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if self.ShowChams and self.Enabled then
                if not self.ChamsCache[player] then
                    self:CreateChams(player)
                else
                    -- Update existing chams
                    local cache = self.ChamsCache[player]
                    if cache.ChamsFolder then
                        for _, highlight in pairs(cache.ChamsFolder:GetChildren()) do
                            if highlight:IsA("Highlight") then
                                highlight.FillColor = self.ChamsColor
                                highlight.OutlineColor = self.ChamsColor
                                highlight.FillTransparency = 0.3 + math.sin(tick() * 2) * 0.2
                            end
                        end
                    end
                end
            else
                self:RemoveChams(player)
            end
        end
    end
end

-- Bullet Tracer Implementation
function ESP:CreateBulletTracer(origin, destination)
    if not ESP.BulletTracers then return end
    
    local tracer = Drawing.new("Line")
    tracer.Visible = true
    tracer.Color = ESP.BulletTracersColor
    tracer.Thickness = 1
    tracer.Transparency = 1
    
    local startPos = CurrentCamera:WorldToViewportPoint(origin)
    local endPos = CurrentCamera:WorldToViewportPoint(destination)
    
    tracer.From = Vector2.new(startPos.X, startPos.Y)
    tracer.To = Vector2.new(endPos.X, endPos.Y)
    
    -- Remove tracer after duration
    spawn(function()
        wait(ESP.TracerDuration)
        tracer:Remove()
    end)
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
            end
        end
    else
        for _, object in pairs(self.Objects) do
            object:Hide()
        end
        for player, _ in pairs(self.ChamsCache) do
            self:RemoveChams(player)
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
end

function ESP:Init()
    -- Connections
    Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer or ESP.SelfESP then
            ESP.Objects[player] = ESPObject.new(player)
            if ESP.ShowChams and ESP.Enabled then
                ESP:CreateChams(player)
            end
        end
    end)

    Players.PlayerRemoving:Connect(function(player)
        if ESP.Objects[player] then
            ESP.Objects[player]:Remove()
        end
        ESP:RemoveChams(player)
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
        for _, cache in pairs(self.ChamsCache) do
            if cache.ChamsFolder then
                for _, highlight in pairs(cache.ChamsFolder:GetChildren()) do
                    if highlight:IsA("Highlight") then
                        highlight.FillColor = color
                        highlight.OutlineColor = color
                    end
                end
            end
        end
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
        if state then
            -- Create chams for all players immediately when enabled
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    self:CreateChams(player)
                end
            end
        else
            -- Remove chams when disabled
            for player, _ in pairs(self.ChamsCache) do
                self:RemoveChams(player)
            end
        end
    else
        if self["Show"..feature] ~= nil then
            self["Show"..feature] = state
        end
    end
end

return ESP
