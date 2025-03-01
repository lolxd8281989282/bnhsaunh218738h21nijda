local ESP = {}

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Debug flag
local DEBUG = true

-- Settings
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

-- Storage
local Drawings = {}

-- Debug function
local function Debug(...)
    if DEBUG then
        print("[ESP Debug]:", ...)
    end
end

local function GetCharacterSize(character)
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return Vector3.new(5, 7, 3) end
    
    local size = hrp.Size
    return Vector3.new(size.X * 2, size.Y * 2, size.Z)
end

local function CreateDrawingsForPlayer(player)
    Debug("Creating drawings for player:", player.Name)
    
    if Drawings[player] then
        Debug("Drawings already exist for player:", player.Name)
        return
    end
    
    local success, drawings = pcall(function()
        return {
            Box = Drawing.new("Square"),
            Name = Drawing.new("Text"),
            Distance = Drawing.new("Text"),
            HealthBar = Drawing.new("Square")
        }
    end)
    
    if not success then
        Debug("Failed to create drawings:", drawings)
        return
    end
    
    -- Box
    drawings.Box.Visible = false
    drawings.Box.Thickness = 1
    drawings.Box.Filled = false
    drawings.Box.Color = ESP.BoxColor
    drawings.Box.ZIndex = 1
    
    -- Name
    drawings.Name.Visible = false
    drawings.Name.Center = true
    drawings.Name.Outline = true
    drawings.Name.Size = ESP.TextSize
    drawings.Name.Color = ESP.NameColor
    drawings.Name.ZIndex = 2
    
    -- Distance
    drawings.Distance.Visible = false
    drawings.Distance.Center = true
    drawings.Distance.Outline = true
    drawings.Distance.Size = ESP.TextSize
    drawings.Distance.Color = ESP.DistanceColor
    drawings.Distance.ZIndex = 2
    
    -- Health Bar
    drawings.HealthBar.Visible = false
    drawings.HealthBar.Thickness = 1
    drawings.HealthBar.Filled = true
    drawings.HealthBar.ZIndex = 1
    
    Drawings[player] = drawings
    Debug("Successfully created drawings for player:", player.Name)
end

local function RemoveDrawingsForPlayer(player)
    Debug("Removing drawings for player:", player.Name)
    
    if Drawings[player] then
        for _, drawing in pairs(Drawings[player]) do
            drawing:Remove()
        end
        Drawings[player] = nil
    end
end

local function UpdateESP()
    if not ESP.Enabled then
        -- Hide all drawings when ESP is disabled
        for _, drawings in pairs(Drawings) do
            for _, drawing in pairs(drawings) do
                drawing.Visible = false
            end
        end
        return
    end
    
    for player, drawings in pairs(Drawings) do
        if player == LocalPlayer then continue end
        
        local character = player.Character
        local humanoid = character and character:FindFirstChild("Humanoid")
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        
        if not character or not humanoid or not rootPart or not humanoid.Health > 0 then
            -- Hide drawings if character is not valid
            for _, drawing in pairs(drawings) do
                drawing.Visible = false
            end
            continue
        end
        
        local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
        local distance = (Camera.CFrame.Position - rootPart.Position).Magnitude
        
        if not onScreen or distance > ESP.Distance then
            -- Hide drawings if player is not on screen or too far
            for _, drawing in pairs(drawings) do
                drawing.Visible = false
            end
            continue
        end
        
        -- Get character size for box calculations
        local charSize = GetCharacterSize(character)
        local boxSize = Vector2.new(charSize.X * 1000 / distance, charSize.Y * 1000 / distance)
        
        -- Update Box
        if ESP.ShowBoxes then
            drawings.Box.Size = boxSize
            drawings.Box.Position = Vector2.new(pos.X - boxSize.X / 2, pos.Y - boxSize.Y / 2)
            drawings.Box.Color = ESP.BoxColor
            drawings.Box.Visible = true
        else
            drawings.Box.Visible = false
        end
        
        -- Update Name
        if ESP.ShowNames then
            drawings.Name.Text = player.Name
            drawings.Name.Position = Vector2.new(pos.X, pos.Y - boxSize.Y / 2 - 15)
            drawings.Name.Color = ESP.NameColor
            drawings.Name.Size = ESP.TextSize
            drawings.Name.Visible = true
        else
            drawings.Name.Visible = false
        end
        
        -- Update Distance
        if ESP.ShowDistance then
            drawings.Distance.Text = math.floor(distance) .. " studs"
            drawings.Distance.Position = Vector2.new(pos.X, pos.Y + boxSize.Y / 2 + 5)
            drawings.Distance.Color = ESP.DistanceColor
            drawings.Distance.Size = ESP.TextSize
            drawings.Distance.Visible = true
        else
            drawings.Distance.Visible = false
        end
        
        -- Update Health Bar
        if ESP.ShowHealthBars and humanoid then
            local health = humanoid.Health / humanoid.MaxHealth
            local barHeight = boxSize.Y
            drawings.HealthBar.Size = Vector2.new(3, barHeight * health)
            drawings.HealthBar.Position = Vector2.new(pos.X - boxSize.X / 2 - 5, pos.Y - boxSize.Y / 2 + (barHeight - drawings.HealthBar.Size.Y))
            drawings.HealthBar.Color = Color3.fromRGB(255 * (1 - health), 255 * health, 0)
            drawings.HealthBar.Visible = true
        else
            drawings.HealthBar.Visible = false
        end
    end
end

function ESP:Initialize()
    Debug("Initializing ESP")
    
    -- Create drawings for existing players
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreateDrawingsForPlayer(player)
        end
    end
    
    -- Handle new players
    Players.PlayerAdded:Connect(function(player)
        Debug("New player joined:", player.Name)
        CreateDrawingsForPlayer(player)
    end)
    
    -- Handle players leaving
    Players.PlayerRemoving:Connect(function(player)
        Debug("Player leaving:", player.Name)
        RemoveDrawingsForPlayer(player)
    end)
    
    -- Update ESP
    local connection = RunService.RenderStepped:Connect(function()
        local success, err = pcall(UpdateESP)
        if not success then
            Debug("Error in UpdateESP:", err)
        end
    end)
    
    Debug("ESP initialized successfully")
    return connection
end

return ESP
