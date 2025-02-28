local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local ESP = {
    Enabled = false,
    Boxes = {},
}

-- Utility function to get character size
local function GetCharacterSize(character)
    local size = Vector3.new()
    local hrp = character:FindFirstChild("HumanoidRootPart")
    
    if hrp then
        -- Get all parts of the character
        local parts = {}
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                table.insert(parts, part)
            end
        end
        
        -- Calculate bounds
        local minX, minY, minZ = math.huge, math.huge, math.huge
        local maxX, maxY, maxZ = -math.huge, -math.huge, -math.huge
        
        for _, part in pairs(parts) do
            local cf = part.CFrame
            local size = part.Size
            local corners = {
                cf * CFrame.new(size.X/2, size.Y/2, size.Z/2),
                cf * CFrame.new(size.X/2, size.Y/2, -size.Z/2),
                cf * CFrame.new(size.X/2, -size.Y/2, size.Z/2),
                cf * CFrame.new(size.X/2, -size.Y/2, -size.Z/2),
                cf * CFrame.new(-size.X/2, size.Y/2, size.Z/2),
                cf * CFrame.new(-size.X/2, size.Y/2, -size.Z/2),
                cf * CFrame.new(-size.X/2, -size.Y/2, size.Z/2),
                cf * CFrame.new(-size.X/2, -size.Y/2, -size.Z/2)
            }
            
            for _, corner in pairs(corners) do
                local pos = corner.Position
                minX = math.min(minX, pos.X)
                minY = math.min(minY, pos.Y)
                minZ = math.min(minZ, pos.Z)
                maxX = math.max(maxX, pos.X)
                maxY = math.max(maxY, pos.Y)
                maxZ = math.max(maxZ, pos.Z)
            end
        end
        
        size = Vector3.new(maxX - minX, maxY - minY, maxZ - minZ)
    end
    
    return size
end

local function CreateBox(player)
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(255, 255, 255) -- White color
    box.Thickness = 1 -- Thinner lines
    box.Transparency = 1
    box.Filled = false
    ESP.Boxes[player] = box
end

local function UpdateESP()
    for player, box in pairs(ESP.Boxes) do
        if player.Character and player ~= LocalPlayer then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and humanoid.Health > 0 and hrp then
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                
                if onScreen and ESP.Enabled then
                    local size = GetCharacterSize(player.Character)
                    local depth = (Camera.CFrame.Position - hrp.Position).Magnitude
                    
                    -- Calculate box dimensions
                    local scaleFactorX = 1 / (depth * math.tan(math.rad(Camera.FieldOfView / 2)) * 2) * 1000
                    local scaleFactorY = scaleFactorX * (Camera.ViewportSize.Y / Camera.ViewportSize.X)
                    
                    local width = size.X * scaleFactorX
                    local height = size.Y * scaleFactorY
                    
                    -- Update box properties
                    box.Size = Vector2.new(width, height)
                    box.Position = Vector2.new(pos.X - width/2, pos.Y - height/2)
                    box.Visible = true
                    
                    -- Optional: Add distance-based transparency
                    local maxDistance = 100 -- Adjust this value as needed
                    box.Transparency = math.clamp(1 - (depth / maxDistance), 0.3, 1)
                else
                    box.Visible = false
                end
            else
                box.Visible = false
            end
        else
            box.Visible = false
        end
    end
end

function ESP:Toggle(state)
    self.Enabled = state
    if not state then
        for _, box in pairs(self.Boxes) do
            box.Visible = false
        end
    end
end

-- Initialize boxes for existing players
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateBox(player)
    end
end

-- Create boxes for new players
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        CreateBox(player)
    end
end)

-- Remove boxes for players who leave
Players.PlayerRemoving:Connect(function(player)
    if ESP.Boxes[player] then
        ESP.Boxes[player]:Remove()
        ESP.Boxes[player] = nil
    end
end)

-- Update ESP
RunService.RenderStepped:Connect(UpdateESP)

return ESP
