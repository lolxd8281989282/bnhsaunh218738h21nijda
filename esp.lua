local ESP = {}
ESP.__index = ESP

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

function ESP.new()
    local self = setmetatable({}, ESP)
    
    -- Core Settings
    self.Enabled = false
    self.ShowNames = false
    self.ShowBoxes = false
    self.ShowDistance = false
    self.ShowHealthBars = false
    
    -- Colors and Style
    self.BoxColor = Color3.fromRGB(255, 255, 255)
    self.NameColor = Color3.fromRGB(255, 255, 255)
    self.DistanceColor = Color3.fromRGB(255, 255, 255)
    self.TextSize = 13
    self.MaxDistance = 1000
    
    -- Storage
    self.Drawings = {}
    
    return self
end

function ESP:CreateDrawings(player)
    if self.Drawings[player] then return end
    
    self.Drawings[player] = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        HealthBar = Drawing.new("Square"),
        HealthBarOutline = Drawing.new("Square")
    }
    
    local drawings = self.Drawings[player]
    
    -- Box Setup
    drawings.Box.Thickness = 1
    drawings.Box.Filled = false
    drawings.Box.Color = self.BoxColor
    drawings.Box.Visible = false
    
    -- Name Setup
    drawings.Name.Center = true
    drawings.Name.Outline = true
    drawings.Name.Size = self.TextSize
    drawings.Name.Color = self.NameColor
    drawings.Name.Visible = false
    
    -- Distance Setup
    drawings.Distance.Center = true
    drawings.Distance.Outline = true
    drawings.Distance.Size = self.TextSize
    drawings.Distance.Color = self.DistanceColor
    drawings.Distance.Visible = false
    
    -- Health Bar Setup
    drawings.HealthBar.Thickness = 1
    drawings.HealthBar.Filled = true
    drawings.HealthBar.Color = Color3.fromRGB(0, 255, 0)
    drawings.HealthBar.Visible = false
    
    drawings.HealthBarOutline.Thickness = 1
    drawings.HealthBarOutline.Filled = false
    drawings.HealthBarOutline.Color = Color3.new(0, 0, 0)
    drawings.HealthBarOutline.Visible = false
end

function ESP:RemoveDrawings(player)
    if self.Drawings[player] then
        for _, drawing in pairs(self.Drawings[player]) do
            drawing:Remove()
        end
        self.Drawings[player] = nil
    end
end

function ESP:Initialize()
    -- Add existing players
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            self:CreateDrawings(player)
        end
    end
    
    -- Handle new players
    Players.PlayerAdded:Connect(function(player)
        self:CreateDrawings(player)
    end)
    
    -- Handle players leaving
    Players.PlayerRemoving:Connect(function(player)
        self:RemoveDrawings(player)
    end)
    
    -- Update loop
    RunService.RenderStepped:Connect(function()
        self:Update()
    end)
end

function ESP:Update()
    for player, drawings in pairs(self.Drawings) do
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
        local head = player.Character:FindFirstChild("Head")
        
        if not humanoid or not rootPart or not head then
            for _, drawing in pairs(drawings) do
                drawing.Visible = false
            end
            continue
        end
        
        local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
        local distance = (Camera.CFrame.Position - rootPart.Position).Magnitude
        
        if not onScreen or distance > self.MaxDistance then
            for _, drawing in pairs(drawings) do
                drawing.Visible = false
            end
            continue
        end
        
        -- Update Box ESP
        if self.ShowBoxes then
            drawings.Box.Size = Vector2.new(50, 70)
            drawings.Box.Position = Vector2.new(pos.X - 25, pos.Y - 35)
            drawings.Box.Color = self.BoxColor
            drawings.Box.Visible = true
        else
            drawings.Box.Visible = false
        end
        
        -- Update Name ESP
        if self.ShowNames then
            drawings.Name.Text = player.Name
            drawings.Name.Position = Vector2.new(pos.X, pos.Y - 45)
            drawings.Name.Color = self.NameColor
            drawings.Name.Visible = true
        else
            drawings.Name.Visible = false
        end
        
        -- Update Distance ESP
        if self.ShowDistance then
            drawings.Distance.Text = math.floor(distance) .. " studs"
            drawings.Distance.Position = Vector2.new(pos.X, pos.Y + 35)
            drawings.Distance.Color = self.DistanceColor
            drawings.Distance.Visible = true
        else
            drawings.Distance.Visible = false
        end
        
        -- Update Health Bar
        if self.ShowHealthBars then
            local health = humanoid.Health
            local maxHealth = humanoid.MaxHealth
            local healthPercent = health / maxHealth
            
            drawings.HealthBarOutline.Size = Vector2.new(4, 70)
            drawings.HealthBarOutline.Position = Vector2.new(pos.X - 30, pos.Y - 35)
            drawings.HealthBarOutline.Visible = true
            
            drawings.HealthBar.Size = Vector2.new(2, 70 * healthPercent)
            drawings.HealthBar.Position = Vector2.new(pos.X - 29, pos.Y - 35 + (70 * (1 - healthPercent)))
            drawings.HealthBar.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
            drawings.HealthBar.Visible = true
        else
            drawings.HealthBar.Visible = false
            drawings.HealthBarOutline.Visible = false
        end
    end
end

function ESP:UpdateSettings(settings)
    for setting, value in pairs(settings) do
        self[setting] = value
    end
end

return ESP
