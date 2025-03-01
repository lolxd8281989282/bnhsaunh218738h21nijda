local ESP = {
    Enabled = false,
    TeamCheck = false,
    ShowBoxes = false,
    ShowNames = false,
    ShowDistance = false,
    ShowHealthBars = false,
    BoxColor = Color3.fromRGB(255, 255, 255),
    NameColor = Color3.fromRGB(255, 255, 255),
    DistanceColor = Color3.fromRGB(255, 255, 255),
    TextSize = 13,
    Distance = 1000,
    Players = {},
    Objects = {},
    Drawings = {},
}

-- Initialize core services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

function ESP.new(settings)
    -- Create new ESP instance with provided settings
    local self = setmetatable({}, {__index = ESP})
    
    -- Apply settings
    for setting, value in pairs(settings or {}) do
        self[setting] = value
    end
    
    self.Drawings = {}
    self.Players = {}
    self.Objects = {}
    
    return self
end

function ESP:Initialize()
    -- Clear existing connections
    if self.RenderConnection then
        self.RenderConnection:Disconnect()
    end

    -- Initialize ESP drawings
    self:CreateDrawings()
    
    -- Set up render loop
    self.RenderConnection = RunService.RenderStepped:Connect(function()
        self:Update()
    end)
    
    -- Set up player handling
    Players.PlayerAdded:Connect(function(player)
        self:AddPlayer(player)
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        self:RemovePlayer(player)
    end)
    
    -- Add existing players
    for _, player in ipairs(Players:GetPlayers()) do
        self:AddPlayer(player)
    end
    
    return true
end

function ESP:CreateDrawings()
    -- Create drawing objects for ESP elements
    local function createDrawing(type, properties)
        local drawing = Drawing.new(type)
        for prop, value in pairs(properties) do
            drawing[prop] = value
        end
        return drawing
    end
    
    self.Drawings.Box = createDrawing("Square", {
        Thickness = 1,
        Filled = false,
        Transparency = 1,
        Color = self.BoxColor,
        Visible = false
    })
    
    self.Drawings.Name = createDrawing("Text", {
        Size = self.TextSize,
        Center = true,
        Outline = true,
        Color = self.NameColor,
        Visible = false
    })
    
    self.Drawings.Distance = createDrawing("Text", {
        Size = self.TextSize,
        Center = true,
        Outline = true,
        Color = self.DistanceColor,
        Visible = false
    })
    
    self.Drawings.HealthBar = createDrawing("Square", {
        Thickness = 1,
        Filled = true,
        Transparency = 1,
        Color = Color3.fromRGB(0, 255, 0),
        Visible = false
    })
end

function ESP:AddPlayer(player)
    if player == LocalPlayer then return end
    self.Players[player] = true
end

function ESP:RemovePlayer(player)
    self.Players[player] = nil
end

function ESP:UpdateSettings(settings)
    -- Update ESP settings
    for setting, value in pairs(settings) do
        self[setting] = value
    end
    
    -- Update drawing properties
    if self.Drawings.Box then
        self.Drawings.Box.Color = self.BoxColor
    end
    if self.Drawings.Name then
        self.Drawings.Name.Color = self.NameColor
        self.Drawings.Name.Size = self.TextSize
    end
    if self.Drawings.Distance then
        self.Drawings.Distance.Color = self.DistanceColor
        self.Drawings.Distance.Size = self.TextSize
    end
end

function ESP:GetCharacter(player)
    if not player then return nil end
    return player.Character
end

function ESP:IsOnScreen(position)
    local _, onScreen = Camera:WorldToViewportPoint(position)
    return onScreen
end

function ESP:GetDistance(position)
    return (Camera.CFrame.Position - position).Magnitude
end

function ESP:Update()
    if not self.Enabled then
        -- Hide all drawings when disabled
        for _, drawing in pairs(self.Drawings) do
            drawing.Visible = false
        end
        return
    end
    
    -- Update ESP for each player
    for player, _ in pairs(self.Players) do
        local character = self:GetCharacter(player)
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            
            if rootPart and humanoid and humanoid.Health > 0 then
                local position = rootPart.Position
                local distance = self:GetDistance(position)
                
                -- Check distance
                if distance > self.Distance then
                    continue
                end
                
                -- Update box ESP
                if self.ShowBoxes and self.Drawings.Box then
                    local boxPosition, onScreen = Camera:WorldToViewportPoint(position)
                    if onScreen then
                        self.Drawings.Box.Size = Vector2.new(50, 70)
                        self.Drawings.Box.Position = Vector2.new(boxPosition.X - 25, boxPosition.Y - 35)
                        self.Drawings.Box.Visible = true
                    else
                        self.Drawings.Box.Visible = false
                    end
                end
                
                -- Update name ESP
                if self.ShowNames and self.Drawings.Name then
                    local namePosition, onScreen = Camera:WorldToViewportPoint(position + Vector3.new(0, 3, 0))
                    if onScreen then
                        self.Drawings.Name.Text = player.Name
                        self.Drawings.Name.Position = Vector2.new(namePosition.X, namePosition.Y)
                        self.Drawings.Name.Visible = true
                    else
                        self.Drawings.Name.Visible = false
                    end
                end
                
                -- Update distance ESP
                if self.ShowDistance and self.Drawings.Distance then
                    local distancePosition, onScreen = Camera:WorldToViewportPoint(position - Vector3.new(0, 3, 0))
                    if onScreen then
                        self.Drawings.Distance.Text = string.format("%.0f studs", distance)
                        self.Drawings.Distance.Position = Vector2.new(distancePosition.X, distancePosition.Y)
                        self.Drawings.Distance.Visible = true
                    else
                        self.Drawings.Distance.Visible = false
                    end
                end
                
                -- Update health bar ESP
                if self.ShowHealthBars and self.Drawings.HealthBar then
                    local healthPosition, onScreen = Camera:WorldToViewportPoint(position + Vector3.new(-3, 0, 0))
                    if onScreen then
                        local healthPercent = humanoid.Health / humanoid.MaxHealth
                        self.Drawings.HealthBar.Size = Vector2.new(2, 70 * healthPercent)
                        self.Drawings.HealthBar.Position = Vector2.new(healthPosition.X, healthPosition.Y - 35)
                        self.Drawings.HealthBar.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
                        self.Drawings.HealthBar.Visible = true
                    else
                        self.Drawings.HealthBar.Visible = false
                    end
                end
            end
        end
    end
end

return ESP
