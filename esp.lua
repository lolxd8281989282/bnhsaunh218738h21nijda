local Workspace, RunService, Players, CoreGui, Lighting = cloneref(game:GetService("Workspace")), cloneref(game:GetService("RunService")), cloneref(game:GetService("Players")), game:GetService("CoreGui"), cloneref(game:GetService("Lighting"))

local ESP = {
    Enabled = true,
    TeamCheck = true,
    MaxDistance = 200,
    FontSize = 11,
    FadeOut = {
        OnDistance = true,
        OnDeath = false,
        OnLeave = false,
    },
    Options = { 
        Teamcheck = false, TeamcheckRGB = Color3.fromRGB(0, 255, 0),
        Friendcheck = true, FriendcheckRGB = Color3.fromRGB(0, 255, 0),
        Highlight = false, HighlightRGB = Color3.fromRGB(255, 0, 0),
    },
    Drawing = {
        Chams = {
            Enabled  = true,
            Thermal = true,
            FillRGB = Color3.fromRGB(119, 120, 255),
            Fill_Transparency = 100,
            OutlineRGB = Color3.fromRGB(119, 120, 255),
            Outline_Transparency = 100,
            VisibleCheck = true,
        },
        Names = {
            Enabled = true,
            RGB = Color3.fromRGB(255, 255, 255),
        },
        Flags = {
            Enabled = true,
        },
        Distances = {
            Enabled = true, 
            Position = "Text",
            RGB = Color3.fromRGB(255, 255, 255),
        },
        Weapons = {
            Enabled = true, WeaponTextRGB = Color3.fromRGB(119, 120, 255),
            Outlined = false,
            Gradient = false,
            GradientRGB1 = Color3.fromRGB(255, 255, 255), GradientRGB2 = Color3.fromRGB(119, 120, 255),
        },
        Healthbar = {
            Enabled = true,  
            HealthText = true, Lerp = false, HealthTextRGB = Color3.fromRGB(119, 120, 255),
            Width = 2.5,
            Gradient = true, GradientRGB1 = Color3.fromRGB(200, 0, 0), GradientRGB2 = Color3.fromRGB(60, 60, 125), GradientRGB3 = Color3.fromRGB(119, 120, 255), 
        },
        Boxes = {
            Animate = true,
            RotationSpeed = 300,
            Gradient = false, GradientRGB1 = Color3.fromRGB(119, 120, 255), GradientRGB2 = Color3.fromRGB(0, 0, 0), 
            GradientFill = true, GradientFillRGB1 = Color3.fromRGB(119, 120, 255), GradientFillRGB2 = Color3.fromRGB(0, 0, 0), 
            Filled = {
                Enabled = true,
                Transparency = 0.75,
                RGB = Color3.fromRGB(0, 0, 0),
            },
            Full = {
                Enabled = true,
                RGB = Color3.fromRGB(255, 255, 255),
            },
            Corner = {
                Enabled = true,
                RGB = Color3.fromRGB(255, 255, 255),
            },
        };
    };
    Connections = {
        RunService = RunService;
    };
    Fonts = {};
}

-- Services
--local Players = game:GetService("Players")
--local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
--local Workspace = game:GetService("Workspace")

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
        Box = CreateDrawing("Square", {Thickness = 1, Filled = false, Transparency = 1, Color = ESP.Drawing.Boxes.Full.RGB, Visible = false}),
        Name = CreateDrawing("Text", {Text = player.Name, Size = ESP.FontSize, Font = Drawing.Fonts.UI, Center = true, Outline = true, Color = ESP.Drawing.Names.RGB, Visible = false}),
        HealthBar = CreateDrawing("Line", {Thickness = 2, Color = ESP.Drawing.Healthbar.GradientRGB1, Transparency = 1, Visible = false}),
        ArmorBar = CreateDrawing("Line", {Thickness = 2, Color = Color3.fromRGB(0, 255, 255), Transparency = 1, Visible = false}),
        Distance = CreateDrawing("Text", {Size = ESP.FontSize, Font = Drawing.Fonts.UI, Center = true, Outline = true, Color = ESP.Drawing.Distances.RGB, Visible = false}),
        Weapon = CreateDrawing("Text", {Size = ESP.FontSize, Font = Drawing.Fonts.UI, Center = true, Outline = true, Color = ESP.Drawing.Weapons.WeaponTextRGB, Visible = false}),
        Flags = CreateDrawing("Text", {Size = ESP.FontSize, Font = Drawing.Fonts.UI, Center = true, Outline = true, Color = Color3.fromRGB(255, 255, 255), Visible = false}),
        Bone = CreateDrawing("Line", {Thickness = 1, Color = Color3.fromRGB(255, 255, 255), Visible = false}),
        HeadCircle = CreateDrawing("Circle", {Thickness = 1, Color = Color3.fromRGB(255, 255, 255), Visible = false, NumSides = 30}),
        BulletTracer = CreateDrawing("Line", {Thickness = 1, Color = Color3.fromRGB(139, 0, 0), Visible = false})
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
    if ESP.Drawing.Boxes.Full.Enabled then
        self.Drawings.Box.Size = Vector2.new(size * 1.5, size * 1.8)
        self.Drawings.Box.Position = Vector2.new(position.X - size * 1.5 / 2, position.Y - size * 1.8 / 2)
        self.Drawings.Box.Color = ESP.Drawing.Boxes.Full.RGB
        self.Drawings.Box.Visible = true
    else
        self.Drawings.Box.Visible = false
    end

    -- Update Head Circle
    if false and head then
        local headPos = CurrentCamera:WorldToViewportPoint(head.Position)
        if headPos.Z > 0 then
            self.Drawings.HeadCircle.Position = Vector2.new(headPos.X, headPos.Y)
            self.Drawings.HeadCircle.Radius = size * 0.5
            self.Drawings.HeadCircle.Color = Color3.fromRGB(255, 255, 255)
            self.Drawings.HeadCircle.Visible = true
        else
            self.Drawings.HeadCircle.Visible = false
        end
    else
        self.Drawings.HeadCircle.Visible = false
    end

    -- Update Name
    if ESP.Drawing.Names.Enabled then
        self.Drawings.Name.Position = Vector2.new(position.X, position.Y - size * 1.8 / 2 - 15)
        self.Drawings.Name.Color = ESP.Drawing.Names.RGB
        self.Drawings.Name.Visible = true
    else
        self.Drawings.Name.Visible = false
    end

    -- Update Health Bar
    if ESP.Drawing.Healthbar.Enabled and humanoid then
        local health = humanoid.Health / humanoid.MaxHealth
        self.Drawings.HealthBar.From = Vector2.new(position.X - size * 1.5 / 2 - 5, position.Y + size * 1.8 / 2)
        self.Drawings.HealthBar.To = Vector2.new(position.X - size * 1.5 / 2 - 5, position.Y - size * 1.8 / 2)
        
        -- Yellow health bar
        self.Drawings.HealthBar.Color = ESP.Drawing.Healthbar.GradientRGB1 -- Yellow color
        self.Drawings.HealthBar.Visible = true
        
        -- Adjust the height based on health percentage
        local barHeight = size * 1.8
        self.Drawings.HealthBar.To = Vector2.new(
            position.X - size * 1.5 / 2 - 5,
            position.Y + size * 1.8 / 2 - (barHeight * health)
        )
    else
        self.Drawings.HealthBar.Visible = false
    end

    -- Update Armor Bar
    if false then
        local armor = humanoid:GetAttribute("Armor")
        local maxArmor = humanoid:GetAttribute("MaxArmor")
        
        if armor and maxArmor and maxArmor > 0 then
            local armorPercentage = armor / maxArmor
            self.Drawings.ArmorBar.From = Vector2.new(position.X - size * 1.5 / 2 - 3, position.Y + size * 1.8 / 2)
            self.Drawings.ArmorBar.To = Vector2.new(position.X - size * 1.5 / 2 - 3, position.Y - size * 1.8 / 2)
        
            -- Cyan armor bar
            self.Drawings.ArmorBar.Color = Color3.fromRGB(0, 255, 255) -- Cyan color
            self.Drawings.ArmorBar.Visible = true
        
            -- Adjust the height based on armor percentage
            local barHeight = size * 1.8
            self.Drawings.ArmorBar.To = Vector2.new(
                position.X - size * 1.5 / 2 - 3,
                position.Y + size * 1.8 / 2 - (barHeight * armorPercentage)
            )
        else
            self.Drawings.ArmorBar.Visible = false
        end
    else
        self.Drawings.ArmorBar.Visible = false
    end

    -- Update Distance
    if ESP.Drawing.Distances.Enabled then
        local distance = math.floor(GetDistanceFromCamera(humanoidRootPart.Position))
        self.Drawings.Distance.Text = tostring(distance) .. "m"
        self.Drawings.Distance.Position = Vector2.new(position.X, position.Y + size * 1.8 / 2 + 5)
        self.Drawings.Distance.Color = ESP.Drawing.Distances.RGB
        self.Drawings.Distance.Visible = true
    else
        self.Drawings.Distance.Visible = false
    end

    -- Update Weapon
    if ESP.Drawing.Weapons.Enabled then
        local weapon = character:FindFirstChildOfClass("Tool")
        if weapon then
            self.Drawings.Weapon.Text = weapon.Name
            self.Drawings.Weapon.Position = Vector2.new(position.X, position.Y + size * 1.8 / 2 + 20)
            self.Drawings.Weapon.Color = ESP.Drawing.Weapons.WeaponTextRGB
            self.Drawings.Weapon.Visible = true
        else
            self.Drawings.Weapon.Visible = false
        end
    else
        self.Drawings.Weapon.Visible = false
    end

    -- Update Flags
    if ESP.Drawing.Flags.Enabled then
        local flags = {}
        if humanoid.Jump then
            table.insert(flags, "Jumping")
        end
        if #flags > 0 then
            self.Drawings.Flags.Text = table.concat(flags, ", ")
            self.Drawings.Flags.Position = Vector2.new(position.X, position.Y + size * 1.8 / 2 + 35)
            self.Drawings.Flags.Color = Color3.fromRGB(255, 255, 255)
            self.Drawings.Flags.Visible = true
        else
            self.Drawings.Flags.Visible = false
        end
    else
        self.Drawings.Flags.Visible = false
    end

    -- Update Bone ESP
    if false then
        local head = character:FindFirstChild("Head")
        if head then
            local headPosition = CurrentCamera:WorldToViewportPoint(head.Position)
            self.Drawings.Bone.From = Vector2.new(position.X, position.Y)
            self.Drawings.Bone.To = Vector2.new(headPosition.X, headPosition.Y)
            self.Drawings.Bone.Color = Color3.fromRGB(255, 255, 255)
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
            -- Create highlight for the whole character
            local highlight = Instance.new("Highlight")
            highlight.FillColor = self.Drawing.Chams.FillRGB
            highlight.OutlineColor = self.Drawing.Chams.OutlineRGB
            highlight.FillTransparency = self.Drawing.Chams.Fill_Transparency / 100
            highlight.OutlineTransparency = self.Drawing.Chams.Outline_Transparency / 100
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Parent = character

            -- Function to apply transparency to character parts
            local function updatePartTransparency(part)
                if part:IsA("BasePart") then
                    -- Check if the part belongs to a tool
                    local tool = part:FindFirstAncestorWhichIsA("Tool")
                    if not tool then
                        -- If not part of a tool, apply transparency
                        part.Transparency = 0.8
                    end
                end
            end

            -- Apply initial transparency to all parts except tools
            for _, part in pairs(character:GetDescendants()) do
                updatePartTransparency(part)
            end

            -- Handle new parts being added
            local connections = {}
            
            connections[1] = character.DescendantAdded:Connect(function(child)
                updatePartTransparency(child)
            end)

            -- Store in cache
            self.ChamsCache[player] = {
                Highlight = highlight,
                Connections = connections
            }

            -- Handle character changes
            player.CharacterAdded:Connect(function(char)
                if self.ChamsCache[player] then
                    self:RemoveChams(player)
                    if self.Drawing.Chams.Enabled and self.Enabled then
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
        if cache.Connections then
            for _, connection in pairs(cache.Connections) do
                connection:Disconnect()
            end
        end
        if cache.Highlight then
            cache.Highlight:Destroy()
        end
        
        -- Reset transparency for all parts
        local character = player.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
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
            if self.Drawing.Chams.Enabled and self.Enabled then
                if not self.ChamsCache[player] then
                    self:CreateChams(player)
                else
                    -- Update existing chams
                    local cache = self.ChamsCache[player]
                    if cache.Highlight then
                        cache.Highlight.FillColor = self.Drawing.Chams.FillRGB
                        cache.Highlight.OutlineColor = self.Drawing.Chams.OutlineRGB
                        cache.Highlight.FillTransparency = self.Drawing.Chams.Fill_Transparency / 100
                        cache.Highlight.OutlineTransparency = self.Drawing.Chams.Outline_Transparency / 100
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
    tracer.Color = Color3.fromRGB(139, 0, 0)
    tracer.Thickness = 1
    tracer.Transparency = 1
    
    local startPos = CurrentCamera:WorldToViewportPoint(origin)
    local endPos = CurrentCamera:WorldToViewportPoint(destination)
    
    tracer.From = Vector2.new(startPos.X, startPos.Y)
    tracer.To = Vector2.new(endPos.X, endPos.Y)
    
    -- Remove tracer after duration
    spawn(function()
        wait(1.5)
        tracer:Remove()
    end)
end

-- Main ESP Functions
ESP.Objects = {}

function ESP:Toggle(state)
    self.Enabled = state
    if self.Enabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer or false then
                self.Objects[player] = ESPObject.new(player)
                if self.Drawing.Chams.Enabled then
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
        if player ~= LocalPlayer or false then
            ESP.Objects[player] = ESPObject.new(player)
            if ESP.Drawing.Chams.Enabled and ESP.Enabled then
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
        self.Drawing.Chams.FillRGB = color
        self.Drawing.Chams.OutlineRGB = color
        for _, cache in pairs(self.ChamsCache) do
            if cache.Highlight then
                cache.Highlight.FillColor = color
                cache.Highlight.OutlineColor = color
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
        self.Drawing.Chams.Enabled = state
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
