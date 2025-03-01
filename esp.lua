local ESP = {}
ESP.__index = ESP

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

function ESP.new()
    local self = setmetatable({}, ESP)
    
    self.Enabled = false
    self.ShowNames = false
    self.ShowBoxes = false
    self.ShowDistance = false
    self.ShowHealthBars = false
    self.BoxColor = Color3.fromRGB(255, 255, 255)
    self.NameColor = Color3.fromRGB(255, 255, 255)
    self.DistanceColor = Color3.fromRGB(255, 255, 255)
    self.TextSize = 13
    self.MaxDistance = 1000
    
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
    
    -- Add existing players
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            self:CreateObject(player)
        end
    end
    
    -- Handle players joining and leaving
    table.insert(self.Connections, Players.PlayerAdded:Connect(function(player)
        self:CreateObject(player)
    end))
    
    table.insert(self.Connections, Players.PlayerRemoving:Connect(function(player)
        self:RemoveObject(player)
    end))
    
    -- Update loop
    table.insert(self.Connections, RunService.RenderStepped:Connect(function()
        self:Update()
    end))
end

function ESP:CreateObject(player)
    if self.Objects[player] then return end
    
    self.Objects[player] = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        HealthBar = Drawing.new("Square"),
        HealthBarOutline = Drawing.new("Square")
    }
    
    local obj = self.Objects[player]
    
    -- Box
    obj.Box.Thickness = 1
    obj.Box.Filled = false
    obj.Box.Color = self.BoxColor
    obj.Box.Visible = false
    
    -- Name
    obj.Name.Center = true
    obj.Name.Outline = true
    obj.Name.Color = self.NameColor
    obj.Name.Size = self.TextSize
    obj.Name.Visible = false
    
    -- Distance
    obj.Distance.Center = true
    obj.Distance.Outline = true
    obj.Distance.Color = self.DistanceColor
    obj.Distance.Size = self.TextSize
    obj.Distance.Visible = false
    
    -- Health Bar
    obj.HealthBar.Thickness = 1
    obj.HealthBar.Filled = true
    obj.HealthBar.Color = Color3.fromRGB(0, 255, 0)
    obj.HealthBar.Visible = false
    
    obj.HealthBarOutline.Thickness = 1
    obj.HealthBarOutline.Filled = false
    obj.HealthBarOutline.Color = Color3.new(0, 0, 0)
    obj.HealthBarOutline.Visible = false
end

function ESP:RemoveObject(player)
    local obj = self.Objects[player]
    if obj then
        for _, drawing in pairs(obj) do
            drawing:Remove()
        end
        self.Objects[player] = nil
    end
end

function ESP:Update()
    for player, obj in pairs(self.Objects) do
        if not self.Enabled then
            for _, drawing in pairs(obj) do
                drawing.Visible = false
            end
            continue
        end
        
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            for _, drawing in pairs(obj) do
                drawing.Visible = false
            end
            continue
        end
        
        local humanoid = player.Character:FindFirstChild("Humanoid")
        local rootPart = player.Character.HumanoidRootPart
        local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
        local distance = (Camera.CFrame.Position - rootPart.Position).Magnitude
        
        if not onScreen or distance > self.MaxDistance then
            for _, drawing in pairs(obj) do
                drawing.Visible = false
            end
            continue
        end
        
        -- Update Box
        if self.ShowBoxes then
            obj.Box.Size = Vector2.new(50, 70)
            obj.Box.Position = Vector2.new(pos.X - 25, pos.Y - 35)
            obj.Box.Color = self.BoxColor
            obj.Box.Visible = true
        else
            obj.Box.Visible = false
        end
        
        -- Update Name
        if self.ShowNames then
            obj.Name.Text = player.Name
            obj.Name.Position = Vector2.new(pos.X, pos.Y - 45)
            obj.Name.Color = self.NameColor
            obj.Name.Visible = true
        else
            obj.Name.Visible = false
        end
        
        -- Update Distance
        if self.ShowDistance then
            obj.Distance.Text = math.floor(distance) .. " studs"
            obj.Distance.Position = Vector2.new(pos.X, pos.Y + 35)
            obj.Distance.Color = self.DistanceColor
            obj.Distance.Visible = true
        else
            obj.Distance.Visible = false
        end
        
        -- Update Health Bar
        if self.ShowHealthBars and humanoid then
            local health = humanoid.Health
            local maxHealth = humanoid.MaxHealth
            local healthPercent = health / maxHealth
            
            obj.HealthBarOutline.Size = Vector2.new(4, 70)
            obj.HealthBarOutline.Position = Vector2.new(pos.X - 30, pos.Y - 35)
            obj.HealthBarOutline.Visible = true
            
            obj.HealthBar.Size = Vector2.new(2, 70 * healthPercent)
            obj.HealthBar.Position = Vector2.new(pos.X - 29, pos.Y - 35 + (70 * (1 - healthPercent)))
            obj.HealthBar.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
            obj.HealthBar.Visible = true
        else
            obj.HealthBar.Visible = false
            obj.HealthBarOutline.Visible = false
        end
    end
end

function ESP:UpdateSettings(settings)
    for setting, value in pairs(settings) do
        self[setting] = value
    end
end

return ESP

