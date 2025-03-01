local ESP = {}
ESP.__index = ESP

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

ESP.Enabled = false
ESP.ShowNames = false
ESP.ShowBoxes = false
ESP.ShowDistance = false
ESP.ShowHealthBars = false
ESP.BoxColor = Color3.fromRGB(255, 255, 255)
ESP.NameColor = Color3.fromRGB(255, 255, 255)
ESP.DistanceColor = Color3.fromRGB(255, 255, 255)
ESP.TextSize = 13
ESP.Distance = 1000

local Drawings = {}

local function CreateDrawing(player)
    if Drawings[player] then return end
    
    Drawings[player] = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        HealthBar = Drawing.new("Square")
    }
    
    local drawings = Drawings[player]
    
    drawings.Box.Visible = false
    drawings.Box.Thickness = 1
    drawings.Box.Filled = false
    drawings.Box.Color = ESP.BoxColor
    
    drawings.Name.Visible = false
    drawings.Name.Center = true
    drawings.Name.Outline = true
    drawings.Name.Size = ESP.TextSize
    drawings.Name.Color = ESP.NameColor
    
    drawings.Distance.Visible = false
    drawings.Distance.Center = true
    drawings.Distance.Outline = true
    drawings.Distance.Size = ESP.TextSize
    drawings.Distance.Color = ESP.DistanceColor
    
    drawings.HealthBar.Visible = false
    drawings.HealthBar.Thickness = 1
    drawings.HealthBar.Filled = true
end

local function RemoveDrawing(player)
    if Drawings[player] then
        for _, drawing in pairs(Drawings[player]) do
            drawing:Remove()
        end
        Drawings[player] = nil
    end
end

local function UpdateESP()
    for player, drawings in pairs(Drawings) do
        if not ESP.Enabled then
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
        
        if not onScreen or distance > ESP.Distance then
            for _, drawing in pairs(drawings) do
                drawing.Visible = false
            end
            continue
        end
        
        -- Box ESP
        if ESP.ShowBoxes then
            drawings.Box.Size = Vector2.new(50, 70)
            drawings.Box.Position = Vector2.new(pos.X - 25, pos.Y - 35)
            drawings.Box.Color = ESP.BoxColor
            drawings.Box.Visible = true
        else
            drawings.Box.Visible = false
        end
        
        -- Name ESP
        if ESP.ShowNames then
            drawings.Name.Text = player.Name
            drawings.Name.Position = Vector2.new(pos.X, pos.Y - 45)
            drawings.Name.Color = ESP.NameColor
            drawings.Name.Size = ESP.TextSize
            drawings.Name.Visible = true
        else
            drawings.Name.Visible = false
        end
        
        -- Distance ESP
        if ESP.ShowDistance then
            drawings.Distance.Text = math.floor(distance) .. " studs"
            drawings.Distance.Position = Vector2.new(pos.X, pos.Y + 35)
            drawings.Distance.Color = ESP.DistanceColor
            drawings.Distance.Size = ESP.TextSize
            drawings.Distance.Visible = true
        else
            drawings.Distance.Visible = false
        end
        
        -- Health Bar
        if ESP.ShowHealthBars and humanoid then
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
            CreateDrawing(player)
        end
    end
    
    -- Handle new players
    Players.PlayerAdded:Connect(function(player)
        CreateDrawing(player)
    end)
    
    -- Handle removing players
    Players.PlayerRemoving:Connect(function(player)
        RemoveDrawing(player)
    end)
    
    -- Update ESP
    RunService.RenderStepped:Connect(UpdateESP)
end

return ESP

