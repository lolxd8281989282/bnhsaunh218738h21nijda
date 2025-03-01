local ESP = {
    PlayerData = {}, -- Store ESP data here instead of on Player instances
    Settings = {
        Enabled = false,
        TeamCheck = false,
        ShowNames = true,
        ShowBoxes = true,
        ShowHealthBars = true,
        BoxColor = Color3.fromRGB(255, 255, 255),
        NameColor = Color3.fromRGB(255, 255, 255),
        HealthBarColor = Color3.fromRGB(0, 255, 0),
        TextSize = 14,
        Distance = 1000
    }
}

-- Services
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local workspace = game:GetService("Workspace")

-- Create new drawing object
local function newDrawing(type, properties)
    local obj = Drawing.new(type)
    for prop, value in pairs(properties) do
        obj[prop] = value
    end
    return obj
end

-- Create ESP components for a player
function ESP:CreateESP(player)
    if self.PlayerData[player.Name] then return end
    
    -- Create drawings for this player
    local data = {
        box = {
            newDrawing("Line", {Visible = false, Color = self.Settings.BoxColor, Thickness = 1}),
            newDrawing("Line", {Visible = false, Color = self.Settings.BoxColor, Thickness = 1}),
            newDrawing("Line", {Visible = false, Color = self.Settings.BoxColor, Thickness = 1}),
            newDrawing("Line", {Visible = false, Color = self.Settings.BoxColor, Thickness = 1})
        },
        name = newDrawing("Text", {
            Visible = false,
            Center = true,
            Outline = true,
            Size = self.Settings.TextSize,
            Color = self.Settings.NameColor,
            Font = Drawing.Fonts.UI
        }),
        healthBar = newDrawing("Line", {
            Visible = false,
            Color = self.Settings.HealthBarColor,
            Thickness = 1
        }),
        healthBarBG = newDrawing("Line", {
            Visible = false,
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = 3
        })
    }
    
    -- Store in our PlayerData table using player's Name as key
    self.PlayerData[player.Name] = data
end

-- Remove ESP components for a player
function ESP:RemoveESP(player)
    local data = self.PlayerData[player.Name]
    if data then
        -- Remove all drawings
        for _, line in pairs(data.box) do
            line:Remove()
        end
        data.name:Remove()
        data.healthBar:Remove()
        data.healthBarBG:Remove()
        
        -- Remove data from storage
        self.PlayerData[player.Name] = nil
    end
end

-- Update ESP
function ESP:UpdateESP()
    local camera = workspace.CurrentCamera
    if not camera then return end

    for _, player in pairs(players:GetPlayers()) do
        local data = self.PlayerData[player.Name]
        if not data then
            self:CreateESP(player)
            data = self.PlayerData[player.Name]
        end

        -- Set all drawings invisible by default
        for _, line in pairs(data.box) do
            line.Visible = false
        end
        data.name.Visible = false
        data.healthBar.Visible = false
        data.healthBarBG.Visible = false

        -- Check if ESP is enabled
        if not self.Settings.Enabled then continue end
        if player == players.LocalPlayer then continue end

        -- Check if player's character exists
        local character = player.Character
        if not character then continue end

        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not rootPart then continue end

        -- Get screen position
        local vector, onScreen = camera:WorldToViewportPoint(rootPart.Position)
        if not onScreen then continue end

        local distance = (camera.CFrame.Position - rootPart.Position).Magnitude
        if distance > self.Settings.Distance then continue end

        -- Calculate ESP dimensions
        local size = Vector2.new(2000 / distance, 2000 / distance)
        local boxSize = Vector2.new(size.X * 2, size.Y * 3)
        local boxPos = Vector2.new(vector.X - size.X, vector.Y - size.Y * 1.5)

        -- Update box ESP
        if self.Settings.ShowBoxes then
            data.box[1].From = boxPos
            data.box[1].To = boxPos + Vector2.new(boxSize.X, 0)
            data.box[2].From = boxPos + Vector2.new(boxSize.X, 0)
            data.box[2].To = boxPos + boxSize
            data.box[3].From = boxPos + boxSize
            data.box[3].To = boxPos + Vector2.new(0, boxSize.Y)
            data.box[4].From = boxPos
            data.box[4].To = boxPos + Vector2.new(0, boxSize.Y)

            for _, line in pairs(data.box) do
                line.Visible = true
                line.Color = self.Settings.BoxColor
            end
        end

        -- Update name ESP
        if self.Settings.ShowNames then
            data.name.Position = Vector2.new(vector.X, vector.Y - size.Y * 2)
            data.name.Text = player.Name
            data.name.Color = self.Settings.NameColor
            data.name.Visible = true
        end

        -- Update health bar
        if self.Settings.ShowHealthBars then
            local healthPercent = humanoid.Health / humanoid.MaxHealth
            local barPos = Vector2.new(boxPos.X - 5, boxPos.Y)
            local barSize = Vector2.new(0, boxSize.Y)

            data.healthBarBG.From = barPos
            data.healthBarBG.To = barPos + barSize
            data.healthBarBG.Visible = true

            data.healthBar.From = barPos + Vector2.new(0, barSize.Y * (1 - healthPercent))
            data.healthBar.To = barPos + barSize
            data.healthBar.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
            data.healthBar.Visible = true
        end
    end
end

-- Initialize
function ESP:Init()
    -- Set up connections
    players.PlayerAdded:Connect(function(player)
        self:CreateESP(player)
    end)

    players.PlayerRemoving:Connect(function(player)
        self:RemoveESP(player)
    end)

    -- Create ESP for existing players
    for _, player in pairs(players:GetPlayers()) do
        self:CreateESP(player)
    end

    -- Update loop
    runService.RenderStepped:Connect(function()
        self:UpdateESP()
    end)
end

return ESP
