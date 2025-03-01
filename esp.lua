local ESP = {
    Enabled = false,
    TeamCheck = false,
    Outline = false,
    SelfESP = false,
    ShowNames = false,
    ShowBoxes = false,
    ShowHealthBars = false,
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
    ShowWatermark = true,
    ShowKeybindList = true,
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
        Box = CreateDrawing("Square", {Thickness = ESP.BoxThickness, Filled = false, Transparency = ESP.BoxTransparency, Color = ESP.BoxColor, Visible = false}),
        Name = CreateDrawing("Text", {Text = player.Name, Size = ESP.TextSize, Center = true, Outline = true, Color = ESP.NameColor, Visible = false}),
        HealthBar = CreateDrawing("Line", {Thickness = 2, Color = ESP.HealthBarColor, Visible = false}),
        ArmorBar = CreateDrawing("Line", {Thickness = 2, Color = ESP.ArmorBarColor, Visible = false}),
        HeadDot = CreateDrawing("Circle", {Radius = 3, Filled = true, Color = ESP.HeadDotColor, Visible = false}),
        Distance = CreateDrawing("Text", {Size = ESP.TextSize, Center = true, Outline = true, Color = ESP.DistanceColor, Visible = false}),
        EquippedItem = CreateDrawing("Text", {Size = ESP.TextSize, Center = true, Outline = true, Color = ESP.EquippedItemColor, Visible = false}),
        Skeleton = {},
    }
    
    for _, boneName in ipairs({"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}) do
        self.Drawings.Skeleton[boneName] = CreateDrawing("Line", {Thickness = 1, Color = ESP.SkeletonColor, Visible = false})
    end
    
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

    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoidRootPart or not humanoid then
        self:Hide()
        return true
    end

    local position, onScreen = CurrentCamera:WorldToViewportPoint(humanoidRootPart.Position)
    if not onScreen or GetDistanceFromCamera(humanoidRootPart.Position) > ESP.Distance then
        self:Hide()
        return true
    end

    local size = (CurrentCamera:WorldToViewportPoint(humanoidRootPart.Position - Vector3.new(0, 3, 0)).Y - CurrentCamera:WorldToViewportPoint(humanoidRootPart.Position + Vector3.new(0, 2.6, 0)).Y) / 2

    -- Update Box
    if ESP.ShowBoxes then
        self.Drawings.Box.Size = Vector2.new(size * 1.5, size * 1.8)
        self.Drawings.Box.Position = Vector2.new(position.X - size * 1.5 / 2, position.Y - size * 1.8 / 2)
        self.Drawings.Box.Color = ESP.BoxColor
        self.Drawings.Box.Transparency = ESP.BoxTransparency
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
    if ESP.ShowHealthBars then
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

    -- Update Head Dot
    if ESP.ShowHeadDot then
        local head = character:FindFirstChild("Head")
        if head then
            local headPosition = CurrentCamera:WorldToViewportPoint(head.Position)
            self.Drawings.HeadDot.Position = Vector2.new(headPosition.X, headPosition.Y)
            self.Drawings.HeadDot.Color = ESP.HeadDotColor
            self.Drawings.HeadDot.Visible = true
        else
            self.Drawings.HeadDot.Visible = false
        end
    else
        self.Drawings.HeadDot.Visible = false
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

    -- Update Equipped Item
    if ESP.ShowEquippedItem then
        local equippedItem = character:FindFirstChildOfClass("Tool")
        if equippedItem then
            self.Drawings.EquippedItem.Text = equippedItem.Name
            self.Drawings.EquippedItem.Position = Vector2.new(position.X, position.Y + size * 1.8 / 2 + 20)
            self.Drawings.EquippedItem.Color = ESP.EquippedItemColor
            self.Drawings.EquippedItem.Visible = true
        else
            self.Drawings.EquippedItem.Visible = false
        end
    else
        self.Drawings.EquippedItem.Visible = false
    end

    -- Update Skeleton
    if ESP.ShowSkeleton then
        local head = character:FindFirstChild("Head")
        local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
        local leftArm = character:FindFirstChild("LeftUpperArm")
        local rightArm = character:FindFirstChild("RightUpperArm")
        local leftLeg = character:FindFirstChild("LeftUpperLeg")
        local rightLeg = character:FindFirstChild("RightUpperLeg")

        if head and torso then
            local headPos = CurrentCamera:WorldToViewportPoint(head.Position)
            local torsoPos = CurrentCamera:WorldToViewportPoint(torso.Position)

            self.Drawings.Skeleton.Head.From = Vector2.new(headPos.X, headPos.Y)
            self.Drawings.Skeleton.Head.To = Vector2.new(torsoPos.X, torsoPos.Y)
            self.Drawings.Skeleton.Head.Color = ESP.SkeletonColor
            self.Drawings.Skeleton.Head.Visible = true

            if leftArm then
                local leftArmPos = CurrentCamera:WorldToViewportPoint(leftArm.Position)
                self.Drawings.Skeleton["Left Arm"].From = Vector2.new(torsoPos.X, torsoPos.Y)
                self.Drawings.Skeleton["Left Arm"].To = Vector2.new(leftArmPos.X, leftArmPos.Y)
                self.Drawings.Skeleton["Left Arm"].Color = ESP.SkeletonColor
                self.Drawings.Skeleton["Left Arm"].Visible = true
            else
                self.Drawings.Skeleton["Left Arm"].Visible = false
            end

            if rightArm then
                local rightArmPos = CurrentCamera:WorldToViewportPoint(rightArm.Position)
                self.Drawings.Skeleton["Right Arm"].From = Vector2.new(torsoPos.X, torsoPos.Y)
                self.Drawings.Skeleton["Right Arm"].To = Vector2.new(rightArmPos.X, rightArmPos.Y)
                self.Drawings.Skeleton["Right Arm"].Color = ESP.SkeletonColor
                self.Drawings.Skeleton["Right Arm"].Visible = true
            else
                self.Drawings.Skeleton["Right Arm"].Visible = false
            end

            if leftLeg then
                local leftLegPos = CurrentCamera:WorldToViewportPoint(leftLeg.Position)
                self.Drawings.Skeleton["Left Leg"].From = Vector2.new(torsoPos.X, torsoPos.Y)
                self.Drawings.Skeleton["Left Leg"].To = Vector2.new(leftLegPos.X, leftLegPos.Y)
                self.Drawings.Skeleton["Left Leg"].Color = ESP.SkeletonColor
                self.Drawings.Skeleton["Left Leg"].Visible = true
            else
                self.Drawings.Skeleton["Left Leg"].Visible = false
            end

            if rightLeg then
                local rightLegPos = CurrentCamera:WorldToViewportPoint(rightLeg.Position)
                self.Drawings.Skeleton["Right Leg"].From = Vector2.new(torsoPos.X, torsoPos.Y)
                self.Drawings.Skeleton["Right Leg"].To = Vector2.new(rightLegPos.X, rightLegPos.Y)
                self.Drawings.Skeleton["Right Leg"].Color = ESP.SkeletonColor
                self.Drawings.Skeleton["Right Leg"].Visible = true
            else
                self.Drawings.Skeleton["Right Leg"].Visible = false
            end
        else
            for _, bone in pairs(self.Drawings.Skeleton) do
                bone.Visible = false
            end
        end
    else
        for _, bone in pairs(self.Drawings.Skeleton) do
            bone.Visible = false
        end
    end

    return true
end

function ESPObject:Hide()
    for _, drawing in pairs(self.Drawings) do
        if type(drawing) == "table" then
            for _, subDrawing in pairs(drawing) do
                subDrawing.Visible = false
            end
        else
            drawing.Visible = false
        end
    end
end

function ESPObject:Remove()
    for _, drawing in pairs(self.Drawings) do
        if type(drawing) == "table" then
            for _, subDrawing in pairs(drawing) do
                subDrawing:Remove()
            end
        else
            drawing:Remove()
        end
    end
    ESP.Objects[self.Player] = nil
end

-- Main ESP Functions
ESP.Objects = {}

function ESP:Toggle(state)
    self.Enabled = state
    if self.Enabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not self.Objects[player] then
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

-- Connections
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer and ESP.Enabled then
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

-- Stream Proof functionality
local function setupStreamProof()
    local function updateStreamProof()
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("Frame") and obj.Name:find("ESP") then
                if ESP.StreamProof then
                    obj.ClipsDescendants = true
                    obj.BackgroundTransparency = 1
                    obj.Visible = false
                    obj:SetAttribute("StreamProof", true)
                else
                    obj.ClipsDescendants = false
                    obj.BackgroundTransparency = 0
                    obj.Visible = true
                    obj:SetAttribute("StreamProof", false)
                end
            end
        end
    end
    
    return updateStreamProof
end

-- Initialize stream proof
local updateStreamProof = setupStreamProof()

-- Update stream proof when the setting changes
function ESP:SetStreamProof(value)
    self.StreamProof = value
    updateStreamProof()
end

return ESP
