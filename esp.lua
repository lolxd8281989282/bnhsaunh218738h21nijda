local ESP = {}
ESP.__index = ESP

-- Initialize core services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

function ESP.new(settings)
    local self = setmetatable({}, ESP)
    
    -- Default settings
    self.Enabled = false
    self.TeamCheck = false
    self.ShowBoxes = false
    self.ShowNames = false
    self.ShowDistance = false
    self.ShowHealthBars = false
    self.BoxColor = Color3.fromRGB(255, 255, 255)
    self.NameColor = Color3.fromRGB(255, 255, 255)
    self.DistanceColor = Color3.fromRGB(255, 255, 255)
    self.TextSize = 13
    self.Distance = 1000
    
    -- Apply provided settings
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
    
    -- Create drawings
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
        if player ~= LocalPlayer then
            self:AddPlayer(player)
        end
    end
    
    return true
end

function ESP:CreateDrawings()
    -- Create drawing objects for ESP elements
    self.Drawings = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        HealthBar = Drawing.new("Square")
    }
    
    -- Set up Box
    self.Drawings.Box.Thickness = 1
    self.Drawings.Box.Filled = false
    self.Drawings.Box.Color = self.BoxColor
    self.Drawings.Box.Visible = false
    
    -- Set up Name
    self.Drawings.Name.Size = self.TextSize
    self.Drawings.Name.Center = true
    self.Drawings.Name.Outline = true
    self.Drawings.Name.Color = self.NameColor
    self.Drawings.Name.Visible = false
    
    -- Set up Distance
    self.Drawings.Distance.Size = self.TextSize
    self.Drawings.Distance.Center = true
    self.Drawings.Distance.Outline = true
    self.Drawings.Distance.Color = self.DistanceColor
    self.Drawings.Distance.Visible = false
    
    -- Set up HealthBar
    self.Drawings.HealthBar.Thickness = 1
    self.Drawings.HealthBar.Filled = true
    self.Drawings.HealthBar.Color = Color3.fromRGB(0, 255, 0)
    self.Drawings.HealthBar.Visible = false
end

function ESP:AddPlayer(player)
    if not self.Players[player] then
        self.Players[player] = {
            Drawings = {
                Box = Drawing.new("Square"),
                Name = Drawing.new("Text"),
                Distance = Drawing.new("Text"),
                HealthBar = Drawing.new("Square")
            }
        }
        
        -- Initialize drawings for this player
        local drawings = self.Players[player].Drawings
        
        -- Box
        drawings.Box.Thickness = 1
        drawings.Box.Filled = false
        drawings.Box.Color = self.BoxColor
        drawings.Box.Visible = false
        
        -- Name
        drawings.Name.Size = self.TextSize
        drawings.Name.Center = true
        drawings.Name.Outline = true
        drawings.Name.Color = self.NameColor
        drawings.Name.Visible = false
        
        -- Distance
        drawings.Distance.Size = self.TextSize
        drawings.Distance.Center = true
        drawings.Distance.Outline = true
        drawings.Distance.Color = self.DistanceColor
        drawings.Distance.Visible = false
        
        -- HealthBar
        drawings.HealthBar.Thickness = 1
        drawings.HealthBar.Filled = true
        drawings.HealthBar.Color = Color3.fromRGB(0, 255, 0)
        drawings.HealthBar.Visible = false
    end
end

function ESP:RemovePlayer(player)
    if self.Players[player] then
        -- Clean up drawings
        for _, drawing in pairs(self.Players[player].Drawings) do
            drawing:Remove()
        end
        self.Players[player] = nil
    end
end

function ESP:UpdateSettings(settings)
    -- Update ESP settings
    for setting, value in pairs(settings) do
        self[setting] = value
    end
    
    -- Update all player drawings with new settings
    for _, playerData in pairs(self.Players) do
        if playerData.Drawings then
            if self.ShowBoxes then
                playerData.Drawings.Box.Color = self.BoxColor
            end
            if self.ShowNames then
                playerData.Drawings.Name.Color = self.NameColor
                playerData.Drawings.Name.Size = self.TextSize
            end
            if self.ShowDistance then
                playerData.Drawings.Distance.Color = self.DistanceColor
                playerData.Drawings.Distance.Size = self.TextSize
            end
        end
    end
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
        for _, playerData in pairs(self.Players) do
            for _, drawing in pairs(playerData.Drawings) do
                drawing.Visible = false
            end
        end
        return
    end
    
    -- Update ESP for each player
    for player, playerData in pairs(self.Players) do
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            
            if rootPart and humanoid and humanoid.Health > 0 then
                local position = rootPart.Position
                local distance = self:GetDistance(position)
                
                -- Check distance
                if distance > self.Distance then
                    for _, drawing in pairs(playerData.Drawings) do
                        drawing.Visible = false
                    end
                    continue
                end
                
                local screenPosition, onScreen = Camera:WorldToViewportPoint(position)
                
                if onScreen then
                    -- Update Box ESP
                    if self.ShowBoxes then
                        playerData.Drawings.Box.Size = Vector2.new(50, 70)
                        playerData.Drawings.Box.Position = Vector2.new(screenPosition.X - 25, screenPosition.Y - 35)
                        playerData.Drawings.Box.Visible = true
                    else
                        playerData.Drawings.Box.Visible = false
                    end
                    
                    -- Update Name ESP
                    if self.ShowNames then
                        playerData.Drawings.Name.Text = player.Name
                        playerData.Drawings.Name.Position = Vector2.new(screenPosition.X, screenPosition.Y - 40)
                        playerData.Drawings.Name.Visible = true
                    else
                        playerData.Drawings.Name.Visible = false
                    end
                    
                    -- Update Distance ESP
                    if self.ShowDistance then
                        playerData.Drawings.Distance.Text = string.format("%.0f studs", distance)
                        playerData.Drawings.Distance.Position = Vector2.new(screenPosition.X, screenPosition.Y + 40)
                        playerData.Drawings.Distance.Visible = true
                    else
                        playerData.Drawings.Distance.Visible = false
                    end
                    
                    -- Update Health Bar ESP
                    if self.ShowHealthBars then
                        local healthPercent = humanoid.Health / humanoid.MaxHealth
                        playerData.Drawings.HealthBar.Size = Vector2.new(2, 70 * healthPercent)
                        playerData.Drawings.HealthBar.Position = Vector2.new(screenPosition.X - 30, screenPosition.Y - 35)
                        playerData.Drawings.HealthBar.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
                        playerData.Drawings.HealthBar.Visible = true
                    else
                        playerData.Drawings.HealthBar.Visible = false
                    end
                else
                    -- Hide drawings when player is off screen
                    for _, drawing in pairs(playerData.Drawings) do
                        drawing.Visible = false
                    end
                end
            else
                -- Hide drawings when character is not valid
                for _, drawing in pairs(playerData.Drawings) do
                    drawing.Visible = false
                end
            end
        end
    end
end

return ESP
