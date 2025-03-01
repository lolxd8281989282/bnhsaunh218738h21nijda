local ESP = {
    Enabled = false,
    ShowNames = false,
    ShowBoxes = false,
    ShowDistance = false,
    ShowHealthBars = false,
    BoxColor = Color3.fromRGB(255, 255, 255),
    NameColor = Color3.fromRGB(255, 255, 255),
    DistanceColor = Color3.fromRGB(255, 255, 255),
    TextSize = 13,
    Distance = 1000,
    Drawings = {},
    new = function(self, options)
        local esp = setmetatable({}, { __index = self })
        esp.Enabled = options.Enabled or false
        esp.ShowNames = options.ShowNames or false
        esp.ShowBoxes = options.ShowBoxes or false
        esp.ShowDistance = options.ShowDistance or false
        esp.ShowHealthBars = options.ShowHealthBars or false
        esp.BoxColor = options.BoxColor or Color3.fromRGB(255, 255, 255)
        esp.NameColor = options.NameColor or Color3.fromRGB(255, 255, 255)
        esp.DistanceColor = options.DistanceColor or Color3.fromRGB(255, 255, 255)
        esp.TextSize = options.TextSize or 13
        esp.Distance = options.Distance or 1000
        esp.Drawings = {}
        return esp
    end
}

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

function ESP:CreateDrawings(player)
    if self.Drawings[player] then return end
    
    self.Drawings[player] = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        HealthBar = Drawing.new("Square")
    }
    
    local drawings = self.Drawings[player]
    
    -- Box
    drawings.Box.Visible = false
    drawings.Box.Thickness = 1
    drawings.Box.Filled = false
    drawings.Box.Color = self.BoxColor
    drawings.Box.ZIndex = 1
    
    -- Name
    drawings.Name.Visible = false
    drawings.Name.Center = true
    drawings.Name.Outline = true
    drawings.Name.Size = self.TextSize
    drawings.Name.Color = self.NameColor
    drawings.Name.ZIndex = 2
    
    -- Distance
    drawings.Distance.Visible = false
    drawings.Distance.Center = true
    drawings.Distance.Outline = true
    drawings.Distance.Size = self.TextSize
    drawings.Distance.Color = self.DistanceColor
    drawings.Distance.ZIndex = 2
    
    -- Health Bar
    drawings.HealthBar.Visible = false
    drawings.HealthBar.Thickness = 1
    drawings.HealthBar.Filled = true
    drawings.HealthBar.ZIndex = 1
end

function ESP:RemoveDrawings(player)
    if self.Drawings[player] then
        for _, drawing in pairs(self.Drawings[player]) do
            drawing:Remove()
        end
        self.Drawings[player] = nil
    end
end

function ESP:UpdateESP()
    for player, drawings in pairs(self.Drawings) do
        if not self.Enabled then
            for _, drawing in pairs(drawings) do
                drawing.Visible = false
            end
            continue
        end
        
        if player == LocalPlayer then continue end
        
        local character = player.Character
        local humanoid = character and character:FindFirstChild("Humanoid")
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        
        if not character or not humanoid or not rootPart or not humanoid.Health > 0 then
            for _, drawing in pairs(drawings) do
                drawing.Visible = false
            end
            continue
        end
        
        local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
        local distance = (Camera.CFrame.Position - rootPart.Position).Magnitude
        
        if not onScreen or distance > self.Distance then
            for _, drawing in pairs(drawings) do
                drawing.Visible = false
            end
            continue
        end
        
        -- Calculate box size based on distance
        local size = Vector2.new(2000 / distance, 3000 / distance)
        
        -- Update Box
        if self.ShowBoxes then
            drawings.Box.Size = size
            drawings.Box.Position = Vector2.new(pos.X - size.X / 2, pos.Y - size.Y / 2)
            drawings.Box.Color = self.BoxColor
            drawings.Box.Visible = true
        else
            drawings.Box.Visible = false
        end
        
        -- Update Name
        if self.ShowNames then
            drawings.Name.Text = player.Name
            drawings.Name.Position = Vector2.new(pos.X, pos.Y - size.Y / 2 - 15)
            drawings.Name.Color = self.NameColor
            drawings.Name.Size = self.TextSize
            drawings.Name.Visible = true
        else
            drawings.Name.Visible = false
        end
        
        -- Update Distance
        if self.ShowDistance then
            drawings.Distance.Text = math.floor(distance) .. " studs"
            drawings.Distance.Position = Vector2.new(pos.X, pos.Y + size.Y / 2 + 5)
            drawings.Distance.Color = self.DistanceColor
            drawings.Distance.Size = self.TextSize
            drawings.Distance.Visible = true
        else
            drawings.Distance.Visible = false
        end
        
        -- Update Health Bar
        if self.ShowHealthBars and humanoid then
            local health = humanoid.Health / humanoid.MaxHealth
            drawings.HealthBar.Size = Vector2.new(3, size.Y * health)
            drawings.HealthBar.Position = Vector2.new(pos.X - size.X / 2 - 5, pos.Y - size.Y / 2 + (size.Y - drawings.HealthBar.Size.Y))
            drawings.HealthBar.Color = Color3.fromRGB(255 * (1 - health), 255 * health, 0)
            drawings.HealthBar.Visible = true
        else
            drawings.HealthBar.Visible = false
        end
    end
end

function ESP:Initialize()
    -- Create drawings for existing players
    for _, player in pairs(Players:GetPlayers()) do
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
    
    -- Update ESP
    RunService:BindToRenderStep("ESP", Enum.RenderPriority.Camera.Value, function()
        self:UpdateESP()
    end)
    
    return self
end

function ESP:UpdateSettings(settings)
    for key, value in pairs(settings) do
        if self[key] ~= nil then
            self[key] = value
        end
    end
end

return ESP
