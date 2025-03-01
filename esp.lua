local ESP = {
    PlayerData = {}, -- Store ESP data here
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
local camera = workspace.CurrentCamera
local player = players.LocalPlayer

-- Drawing Functions
local function NewDrawing(type, properties)
    local obj = Drawing.new(type)
    for prop, value in pairs(properties) do
        obj[prop] = value
    end
    return obj
end

function ESP:CreateESP(plr)
    if self.PlayerData[plr.Name] then return end
    
    -- Create drawings for this player
    self.PlayerData[plr.Name] = {
        box = {
            NewDrawing("Line", {Visible = false, Color = self.Settings.BoxColor, Thickness = 1}),
            NewDrawing("Line", {Visible = false, Color = self.Settings.BoxColor, Thickness = 1}),
            NewDrawing("Line", {Visible = false, Color = self.Settings.BoxColor, Thickness = 1}),
            NewDrawing("Line", {Visible = false, Color = self.Settings.BoxColor, Thickness = 1})
        },
        name = NewDrawing("Text", {
            Visible = false,
            Center = true,
            Outline = true,
            Size = self.Settings.TextSize,
            Color = self.Settings.NameColor,
            Font = Drawing.Fonts.UI
        }),
        healthBar = NewDrawing("Line", {
            Visible = false,
            Color = self.Settings.HealthBarColor,
            Thickness = 1
        }),
        healthBarBG = NewDrawing("Line", {
            Visible = false,
            Color = Color3.fromRGB(0, 0, 0),
            Thickness = 3
        })
    }
end

function ESP:RemoveESP(plr)
    local data = self.PlayerData[plr.Name]
    if data then
        -- Remove all drawings
        for _, line in pairs(data.box) do
            line:Remove()
        end
        data.name:Remove()
        data.healthBar:Remove()
        data.healthBarBG:Remove()
        
        -- Remove data from storage
        self.PlayerData[plr.Name] = nil
    end
end

function ESP:UpdateESP()
    for _, plr in pairs(players:GetPlayers()) do
        if plr == player then continue end
        
        local data = self.PlayerData[plr.Name]
        if not data then
            self:CreateESP(plr)
            data = self.PlayerData[plr.Name]
        end

        -- Hide everything by default
        for _, line in pairs(data.box) do
            line.Visible = false
        end
        data.name.Visible = false
        data.healthBar.Visible = false
        data.healthBarBG.Visible = false

        if not self.Settings.Enabled then continue end

        if plr.Character and plr.Character:FindFirstChild("Humanoid") and 
           plr.Character:FindFirstChild("HumanoidRootPart") and 
           plr.Character.Humanoid.Health > 0 then
            
            local humanoid = plr.Character.Humanoid
            local rootPart = plr.Character.HumanoidRootPart
            
            local pos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
            if not onScreen then continue end
            
            local distance = (camera.CFrame.Position - rootPart.Position).Magnitude
            if distance > self.Settings.Distance then continue end

            -- Calculate box dimensions
            local size = Vector2.new(2000 / distance, 2000 / distance)
            local boxSize = Vector2.new(size.X * 2, size.Y * 3)
            local boxPos = Vector2.new(pos.X - size.X, pos.Y - size.Y * 1.5)

            -- Draw box
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

            -- Draw name
            if self.Settings.ShowNames then
                data.name.Position = Vector2.new(pos.X, pos.Y - size.Y * 2)
                data.name.Text = plr.Name
                data.name.Color = self.Settings.NameColor
                data.name.Visible = true
            end

            -- Draw health bar
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
end

function ESP:Init()
    -- Set up connections
    players.PlayerAdded:Connect(function(plr)
        self:CreateESP(plr)
    end)

    players.PlayerRemoving:Connect(function(plr)
        self:RemoveESP(plr)
    end)

    -- Create ESP for existing players
    for _, plr in pairs(players:GetPlayers()) do
        self:CreateESP(plr)
    end

    -- Update loop
    runService.RenderStepped:Connect(function()
        self:UpdateESP()
    end)
end

return ESP
