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
    ShowBone = false,
    ShowHeadCircle = false,
    BoxType = "full", -- "full", "corners", "3d"
    BoxColor = Color3.fromRGB(255, 192, 203), -- Pink color from image
    NameColor = Color3.fromRGB(255, 255, 255),
    HealthBarColor = Color3.fromRGB(0, 255, 0), -- Will be used as the gradient top color
    ArmorBarColor = Color3.fromRGB(0, 255, 255),
    DistanceColor = Color3.fromRGB(0, 255, 255), -- Light blue from image
    WeaponColor = Color3.fromRGB(0, 255, 255),
    BoneColor = Color3.fromRGB(255, 255, 0), -- Yellow from image
    HeadCircleColor = Color3.fromRGB(255, 255, 255),
    TextSize = 13, -- Smaller text size for names
    TextFont = Drawing.Fonts.UI,
    MaxDistance = 1000,
    BarThickness = 1, -- Thin but visible bars
}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
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

local function GetDistanceFromCamera(position)
    return (CurrentCamera.CFrame.Position - position).Magnitude
end

local function GetBonePositions(character)
    local bones = {}
    local function addBone(part1Name, part2Name)
        local part1 = character:FindFirstChild(part1Name)
        local part2 = character:FindFirstChild(part2Name)
        if part1 and part2 then
            local pos1 = CurrentCamera:WorldToViewportPoint(part1.Position)
            local pos2 = CurrentCamera:WorldToViewportPoint(part2.Position)
            if pos1.Z > 0 and pos2.Z > 0 then
                table.insert(bones, {
                    From = Vector2.new(pos1.X, pos1.Y),
                    To = Vector2.new(pos2.X, pos2.Y)
                })
            end
        end
    end

    -- Define all bone connections
    addBone("Head", "UpperTorso")
    addBone("UpperTorso", "LowerTorso")
    addBone("UpperTorso", "LeftUpperArm")
    addBone("LeftUpperArm", "LeftLowerArm")
    addBone("LeftLowerArm", "LeftHand")
    addBone("UpperTorso", "RightUpperArm")
    addBone("RightUpperArm", "RightLowerArm")
    addBone("RightLowerArm", "RightHand")
    addBone("LowerTorso", "LeftUpperLeg")
    addBone("LeftUpperLeg", "LeftLowerLeg")
    addBone("LeftLowerLeg", "LeftFoot")
    addBone("LowerTorso", "RightUpperLeg")
    addBone("RightUpperLeg", "RightLowerLeg")
    addBone("RightLowerLeg", "RightFoot")

    return bones
end

-- ESP Object
local ESPObject = {}
ESPObject.__index = ESPObject

function ESPObject.new(player)
    local self = setmetatable({}, ESPObject)
    self.Player = player
    self.Character = player.Character or player.CharacterAdded:Wait()
    self.Drawings = {
        Box = CreateDrawing("Square", {
            Thickness = 1,
            Filled = false,
            Transparency = 1,
            Color = ESP.BoxColor,
            Visible = false
        }),
        BoxCorners = {}, -- Will be populated for corner box type
        Name = CreateDrawing("Text", {
            Text = player.Name,
            Size = ESP.TextSize,
            Font = ESP.TextFont,
            Center = true,
            Outline = true,
            Color = ESP.NameColor,
            Visible = false
        }),
        HealthBar = CreateDrawing("Square", {
            Thickness = ESP.BarThickness,
            Filled = true,
            Transparency = 1,
            Color = ESP.HealthBarColor,
            Visible = false
        }),
        ArmorBar = CreateDrawing("Square", {
            Thickness = ESP.BarThickness,
            Filled = true,
            Transparency = 1,
            Color = ESP.ArmorBarColor,
            Visible = false
        }),
        HealthText = CreateDrawing("Text", {
            Size = ESP.TextSize,
            Font = ESP.TextFont,
            Center = false,
            Outline = true,
            Color = ESP.NameColor,
            Visible = false
        }),
        Distance = CreateDrawing("Text", {
            Size = ESP.TextSize,
            Font = ESP.TextFont,
            Center = true,
            Outline = true,
            Color = ESP.DistanceColor,
            Visible = false
        }),
        Weapon = CreateDrawing("Text", {
            Size = ESP.TextSize,
            Font = ESP.TextFont,
            Center = true,
            Outline = true,
            Color = ESP.WeaponColor,
            Visible = false
        }),
        Bones = {}, -- Will be populated with bone lines
        HeadCircle = CreateDrawing("Circle", {
            Thickness = 1,
            NumSides = 30,
            Color = ESP.HeadCircleColor,
            Filled = false,
            Visible = false
        })
    }

    -- Create corner lines if using corner box type
    if ESP.BoxType == "corners" then
        for i = 1, 8 do
            self.Drawings.BoxCorners[i] = CreateDrawing("Line", {
                Thickness = 1,
                Color = ESP.BoxColor,
                Visible = false
            })
        end
    end

    -- Create bone lines
    for i = 1, 12 do -- Adjust number based on bone connections
        self.Drawings.Bones[i] = CreateDrawing("Line", {
            Thickness = 1,
            Color = ESP.BoneColor,
            Visible = false
        })
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

    -- Update Box based on type
    if ESP.ShowBoxes then
        if ESP.BoxType == "full" then
            self.Drawings.Box.Size = Vector2.new(size * 1.5, size * 1.8)
            self.Drawings.Box.Position = Vector2.new(position.X - size * 1.5 / 2, position.Y - size * 1.8 / 2)
            self.Drawings.Box.Color = ESP.BoxColor
            self.Drawings.Box.Visible = true
        elseif ESP.BoxType == "corners" then
            local boxSize = Vector2.new(size * 1.5, size * 1.8)
            local boxPosition = Vector2.new(position.X - size * 1.5 / 2, position.Y - size * 1.8 / 2)
            local cornerSize = size * 0.3

            -- Top Left
            self.Drawings.BoxCorners[1].From = boxPosition
            self.Drawings.BoxCorners[1].To = boxPosition + Vector2.new(cornerSize, 0)
            self.Drawings.BoxCorners[2].From = boxPosition
            self.Drawings.BoxCorners[2].To = boxPosition + Vector2.new(0, cornerSize)

            -- Top Right
            self.Drawings.BoxCorners[3].From = Vector2.new(boxPosition.X + boxSize.X, boxPosition.Y)
            self.Drawings.BoxCorners[3].To = Vector2.new(boxPosition.X + boxSize.X - cornerSize, boxPosition.Y)
            self.Drawings.BoxCorners[4].From = Vector2.new(boxPosition.X + boxSize.X, boxPosition.Y)
            self.Drawings.BoxCorners[4].To = Vector2.new(boxPosition.X + boxSize.X, boxPosition.Y + cornerSize)

            -- Bottom Left
            self.Drawings.BoxCorners[5].From = Vector2.new(boxPosition.X, boxPosition.Y + boxSize.Y)
            self.Drawings.BoxCorners[5].To = Vector2.new(boxPosition.X + cornerSize, boxPosition.Y + boxSize.Y)
            self.Drawings.BoxCorners[6].From = Vector2.new(boxPosition.X, boxPosition.Y + boxSize.Y)
            self.Drawings.BoxCorners[6].To = Vector2.new(boxPosition.X, boxPosition.Y + boxSize.Y - cornerSize)

            -- Bottom Right
            self.Drawings.BoxCorners[7].From = Vector2.new(boxPosition.X + boxSize.X, boxPosition.Y + boxSize.Y)
            self.Drawings.BoxCorners[7].To = Vector2.new(boxPosition.X + boxSize.X - cornerSize, boxPosition.Y + boxSize.Y)
            self.Drawings.BoxCorners[8].From = Vector2.new(boxPosition.X + boxSize.X, boxPosition.Y + boxSize.Y)
            self.Drawings.BoxCorners[8].To = Vector2.new(boxPosition.X + boxSize.X, boxPosition.Y + boxSize.Y - cornerSize)

            for _, corner in ipairs(self.Drawings.BoxCorners) do
                corner.Color = ESP.BoxColor
                corner.Visible = true
            end
            self.Drawings.Box.Visible = false
        end
        -- Note: 3D box type would be implemented here if supported
    else
        self.Drawings.Box.Visible = false
        if ESP.BoxType == "corners" then
            for _, corner in ipairs(self.Drawings.BoxCorners) do
                corner.Visible = false
            end
        end
    end

    -- Update Name and Health Text
    if ESP.ShowNames then
        local nameText = self.Player.Name
        if humanoid then
            local health = math.floor(humanoid.Health)
            local maxHealth = math.floor(humanoid.MaxHealth)
            self.Drawings.HealthText.Text = string.format("[%d/%d]", health, maxHealth)
            self.Drawings.HealthText.Position = Vector2.new(position.X + self.Drawings.Name.TextBounds.X / 2 + 5, position.Y - size * 1.8 / 2 - 15)
            self.Drawings.HealthText.Visible = true
        end
        
        self.Drawings.Name.Position = Vector2.new(position.X, position.Y - size * 1.8 / 2 - 15)
        self.Drawings.Name.Visible = true
    else
        self.Drawings.Name.Visible = false
        self.Drawings.HealthText.Visible = false
    end

    -- Update Health Bar with gradient
    if ESP.ShowHealthBars and humanoid then
        local health = humanoid.Health / humanoid.MaxHealth
        local barHeight = size * 1.8
        local barWidth = 2 -- Thin bar
        local barPosition = Vector2.new(position.X - size * 1.5 / 2 - 5, position.Y - size * 1.8 / 2)
        
        self.Drawings.HealthBar.Size = Vector2.new(barWidth, barHeight * health)
        self.Drawings.HealthBar.Position = Vector2.new(barPosition.X, barPosition.Y + barHeight * (1 - health))
        
        -- Calculate gradient color based on health
        local r = health < 0.5 and 1 or (1 - health) * 2
        local g = health > 0.5 and 1 or health * 2
        self.Drawings.HealthBar.Color = Color3.new(r, g, 0)
        self.Drawings.HealthBar.Visible = true
    else
        self.Drawings.HealthBar.Visible = false
    end

    -- Update Armor Bar
    if ESP.ShowArmorBar then
        local armor = humanoid:GetAttribute("Armor") or 0
        local maxArmor = humanoid:GetAttribute("MaxArmor") or 100
        local armorPercentage = armor / maxArmor
        local barHeight = size * 1.8
        local barWidth = 2 -- Thin bar
        local barPosition = Vector2.new(position.X + size * 1.5 / 2 + 3, position.Y - size * 1.8 / 2)
        
        self.Drawings.ArmorBar.Size = Vector2.new(barWidth, barHeight * armorPercentage)
        self.Drawings.ArmorBar.Position = Vector2.new(barPosition.X, barPosition.Y + barHeight * (1 - armorPercentage))
        self.Drawings.ArmorBar.Visible = true
    else
        self.Drawings.ArmorBar.Visible = false
    end

    -- Update Distance and Weapon Text (stacked)
    if ESP.ShowDistance or ESP.ShowWeapon then
        local baseY = position.Y + size * 1.8 / 2 + 5
        
        if ESP.ShowDistance then
            local distance = math.floor(GetDistanceFromCamera(humanoidRootPart.Position))
            self.Drawings.Distance.Text = string.format("[%dm]", distance)
            self.Drawings.Distance.Position = Vector2.new(position.X, baseY)
            self.Drawings.Distance.Visible = true
            baseY = baseY + self.Drawings.Distance.TextBounds.Y + 2
        else
            self.Drawings.Distance.Visible = false
        end
        
        if ESP.ShowWeapon then
            local weapon = character:FindFirstChildOfClass("Tool")
            if weapon then
                self.Drawings.Weapon.Text = string.format("[%s]", weapon.Name)
                self.Drawings.Weapon.Position = Vector2.new(position.X, baseY)
                self.Drawings.Weapon.Visible = true
            else
                self.Drawings.Weapon.Visible = false
            end
        else
            self.Drawings.Weapon.Visible = false
        end
    else
        self.Drawings.Distance.Visible = false
        self.Drawings.Weapon.Visible = false
    end

    -- Update Skeleton ESP
    if ESP.ShowBone then
        local bones = GetBonePositions(character)
        for i, bone in ipairs(bones) do
            if self.Drawings.Bones[i] then
                self.Drawings.Bones[i].From = bone.From
                self.Drawings.Bones[i].To = bone.To
                self.Drawings.Bones[i].Color = ESP.BoneColor
                self.Drawings.Bones[i].Visible = true
            end
        end
        -- Hide unused bone drawings
        for i = #bones + 1, #self.Drawings.Bones do
            self.Drawings.Bones[i].Visible = false
        end
    else
        for _, bone in ipairs(self.Drawings.Bones) do
            bone.Visible = false
        end
    end

    -- Update Head Circle
    if ESP.ShowHeadCircle and head then
        local headPos = CurrentCamera:WorldToViewportPoint(head.Position)
        if headPos.Z > 0 then
            -- Calculate head size in viewport space
            local headSize = head.Size.Y
            local headTop = CurrentCamera:WorldToViewportPoint(head.Position + Vector3.new(0, headSize/2, 0))
            local headBottom = CurrentCamera:WorldToViewportPoint(head.Position - Vector3.new(0, headSize/2, 0))
            local radius = math.abs(headTop.Y - headBottom.Y) / 2
            
            self.Drawings.HeadCircle.Position = Vector2.new(headPos.X, headPos.Y)
            self.Drawings.HeadCircle.Radius = radius
            self.Drawings.HeadCircle.Visible = true
        else
            self.Drawings.HeadCircle.Visible = false
        end
    else
        self.Drawings.HeadCircle.Visible = false
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

function ESP:UpdateColor(feature, color)
    local propertyName = feature.."Color"
    if self[propertyName] then
        self[propertyName] = color
    end
end

function ESP:ToggleFeature(feature, state)
    if self["Show"..feature] ~= nil then
        self["Show"..feature] = state
    end
end

return ESP
