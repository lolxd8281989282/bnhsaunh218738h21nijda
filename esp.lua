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
    Distance = 1000
}

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local DrawingObjects = {}

function ESP:CreateDrawings(player)
    if DrawingObjects[player] then return end
    
    DrawingObjects[player] = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        HealthBar = Drawing.new("Square")
    }
    
    local drawings = DrawingObjects[player]
    
    drawings.Box.Visible = false
    drawings.Box.Thickness = 1
    drawings.Box.Filled = false
    
    drawings.Name.Visible = false
    drawings.Name.Center = true
    drawings.Name.Outline = true
    drawings.Name.Size = 13
    
    drawings.Distance.Visible = false
    drawings.Distance.Center = true
    drawings.Distance.Outline = true
    drawings.Distance.Size = 13
    
    drawings.HealthBar.Visible = false
    drawings.HealthBar.Thickness = 1
    drawings.HealthBar.Filled = true
end

function ESP:RemoveDrawings(player)
    if DrawingObjects[player] then
        for _, drawing in pairs(DrawingObjects[player]) do
            drawing:Remove()
        end
        DrawingObjects[player] = nil
    end
end

function ESP:UpdateESP()
    for player, drawings in pairs(DrawingObjects) do
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
        
        if not onScreen or distance > self.Distance then
            for _, drawing in pairs(drawings) do
                drawing.Visible = false
            end
            continue
        end
        
        -- Box ESP
        if self.ShowBoxes then
            drawings.Box.Size = Vector2.new(50, 70)
            drawings.Box.Position = Vector2.new(pos.X - 25, pos.Y - 35)
            drawings.Box.Color = self.BoxColor
            drawings.Box.Visible = true
        else
            drawings.Box.Visible = false
        end
        
        -- Name ESP
        if self.ShowNames then
            drawings.Name.Text = player.Name
            drawings.Name.Position = Vector2.new(pos.X, pos.Y - 45)
            drawings.Name.Color = self.NameColor
            drawings.Name.Size = self.TextSize
            drawings.Name.Visible = true
        else
            drawings.Name.Visible = false
        end
        
        -- Distance ESP
        if self.ShowDistance then
            drawings.Distance.Text = math.floor(distance) .. " studs"
            drawings.Distance.Position = Vector2.new(pos.X, pos.Y + 35)
            drawings.Distance.Color = self.DistanceColor
            drawings.Distance.Size = self.TextSize
            drawings.Distance.Visible = true
        else
            drawings.Distance.Visible = false
        end
        
        -- Health Bar
        if self.ShowHealthBars and humanoid then
            local health = humanoid.Health / humanoid.MaxHealth
            drawings.HealthBar.Size = Vector2.new(2, 70 * health)
            drawings.HealthBar.Position = Vector2.new(pos.X - 30, pos.Y - 35)
            drawings.HealthBar.Color = Color3.fromRGB(255 * (1 - health), 255 * health, 0)
            drawings.HealthBar.Visible = true
        else
            drawings.HealthBar.Visible = false
        end
    end
end

function ESP:Initialize()
    -- Add existing players
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            self:CreateDrawings(player)
        end
    end
    
    -- Handle new players
    Players.PlayerAdded:Connect(function(player)
        self:CreateDrawings(player)
    end)
    
    -- Handle removing players
    Players.PlayerRemoving:Connect(function(player)
        self:RemoveDrawings(player)
    end)
    
    -- Update ESP
    RunService.RenderStepped:Connect(function()
        self:UpdateESP()
    end)
end

function ESP:UpdateSettings(settings)
    for setting, value in pairs(settings) do
        self[setting] = value
    end
end

return ESP
