local ESP = {}
ESP.__index = ESP

-- Initialize core services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

function ESP.new()
    local self = setmetatable({}, ESP)
    
    -- Settings
    self.Enabled = false
    self.ShowNames = false
    self.ShowBoxes = false
    self.ShowDistance = false
    self.ShowHealthBars = false
    self.MaxDistance = 1000
    self.TextSize = 13
    
    -- Colors
    self.BoxColor = Color3.fromRGB(255, 255, 255)
    self.NameColor = Color3.fromRGB(255, 255, 255)
    self.DistanceColor = Color3.fromRGB(255, 255, 255)
    self.HealthBarColor = Color3.fromRGB(0, 255, 0)
    
    -- Storage
    self.Objects = {}
    self.Connections = {}
    
    return self
end

function ESP:Initialize()
    -- Clear existing connections
    for _, connection in pairs(self.Connections) do
        connection:Disconnect()
    end
    self.Connections = {}
    
    -- Player handling
    table.insert(self.Connections, Players.PlayerAdded:Connect(function(player)
        self:CreateESPObject(player)
    end))
    
    table.insert(self.Connections, Players.PlayerRemoving:Connect(function(player)
        self:RemoveESPObject(player)
    end))
    
    -- Add existing players
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            self:CreateESPObject(player)
        end
    end
    
    -- Update loop
    table.insert(self.Connections, RunService.RenderStepped:Connect(function()
        self:Update()
    end))
    
    return true
end

function ESP:CreateESPObject(player)
    if self.Objects[player] then return end
    
    local drawings = {
        box = Drawing.new("Square"),
        name = Drawing.new("Text"),
        distance = Drawing.new("Text"),
        healthBar = Drawing.new("Square"),
        healthBarOutline = Drawing.new("Square")
    }
    
    -- Box setup
    drawings.box.Thickness = 1
    drawings.box.Filled = false
    drawings.box.Color = self.BoxColor
    drawings.box.Visible = false
    drawings.box.Transparency = 1
    
    -- Name setup
    drawings.name.Size = self.TextSize
    drawings.name.Center = true
    drawings.name.Outline = true
    drawings.name.Color = self.NameColor
    drawings.name.Visible = false
    drawings.name.Transparency = 1
    
    -- Distance setup
    drawings.distance.Size = self.TextSize
    drawings.distance.Center = true
    drawings.distance.Outline = true
    drawings.distance.Color = self.DistanceColor
    drawings.distance.Visible = false
    drawings.distance.Transparency = 1
    
    -- Health bar setup
    drawings.healthBar.Thickness = 1
    drawings.healthBar.Filled = true
    drawings.healthBar.Color = self.HealthBarColor
    drawings.healthBar.Visible = false
    drawings.healthBar.Transparency = 1
    
    drawings.healthBarOutline.Thickness = 1
    drawings.healthBarOutline.Filled = false
    drawings.healthBarOutline.Color = Color3.new(0, 0, 0)
    drawings.healthBarOutline.Visible = false
    drawings.healthBarOutline.Transparency = 1
    
    self.Objects[player] = drawings
end

function ESP:RemoveESPObject(player)
    local drawings = self.Objects[player]
    if drawings then
        for _, drawing in pairs(drawings) do
            drawing:Remove()
        end
        self.Objects[player] = nil
    end
end

function ESP:UpdateSettings(settings)
    for setting, value in pairs(settings) do
        self[setting] = value
    end
end

function ESP:ToggleDrawing(drawing, enabled)
    if drawing and drawing.Visible ~= enabled then
        drawing.Visible = enabled
    end
end

function ESP:Update()
    for player, drawings in pairs(self.Objects) do
        if not self.Enabled then
            for _, drawing in pairs(drawings) do
                drawing.Visible = false
            end
            continue
        end
        
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            for _, drawing in pairs(drawings) do
                drawing.Visible = false
            end
            continue
        end
        
        local humanoid = player.Character:FindFirstChild("Humanoid")
        local rootPart = player.Character.HumanoidRootPart
        
        local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
        local distance = (Camera.CFrame.Position - rootPart.Position).Magnitude
        
        if not onScreen or distance > self.MaxDistance then
            for _, drawing in pairs(drawings) do
                drawing.Visible = false
            end
            continue
        end
        
        -- Update box
        if self.ShowBoxes then
            drawings.box.Size = Vector2.new(50, 70)
            drawings.box.Position = Vector2.new(pos.X - 25, pos.Y - 35)
            drawings.box.Color = self.BoxColor
            drawings.box.Visible = true
        else
            drawings.box.Visible = false
        end
        
        -- Update name
        if self.ShowNames then
            drawings.name.Text = player.Name
            drawings.name.Position = Vector2.new(pos.X, pos.Y - 45)
            drawings.name.Color = self.NameColor
            drawings.name.Visible = true
        else
            drawings.name.Visible = false
        end
        
        -- Update distance
        if self.ShowDistance then
            drawings.distance.Text = math.floor(distance) .. " studs"
            drawings.distance.Position = Vector2.new(pos.X, pos.Y + 35)
            drawings.distance.Color = self.DistanceColor
            drawings.distance.Visible = true
        else
            drawings.distance.Visible = false
        end
        
        -- Update health bar
        if self.ShowHealthBars and humanoid then
            local health = humanoid.Health
            local maxHealth = humanoid.MaxHealth
            local healthPercent = health / maxHealth
            
            local barHeight = 70
            drawings.healthBarOutline.Size = Vector2.new(4, barHeight)
            drawings.healthBarOutline.Position = Vector2.new(pos.X - 30, pos.Y - 35)
            drawings.healthBarOutline.Visible = true
            
            drawings.healthBar.Size = Vector2.new(2, barHeight * healthPercent)
            drawings.healthBar.Position = Vector2.new(pos.X - 29, pos.Y - 35 + (barHeight * (1 - healthPercent)))
            drawings.healthBar.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
            drawings.healthBar.Visible = true
        else
            drawings.healthBar.Visible = false
            drawings.healthBarOutline.Visible = false
        end
    end
end

return ESP
