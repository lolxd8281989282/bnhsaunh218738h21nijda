local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local ESP = {
    Enabled = false,
    Boxes = {},
}

local function CreateBox(player)
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Thickness = 2
    box.Transparency = 1
    box.Filled = false
    ESP.Boxes[player] = box
end

local function UpdateESP()
    for player, box in pairs(ESP.Boxes) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= Players.LocalPlayer then
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen and ESP.Enabled then
                local rootPart = player.Character.HumanoidRootPart
                local head = player.Character.Head
                local rootPos = rootPart.Position
                local headPos = head.Position
                
                local boxSize = (headPos - rootPos).Magnitude
                local boxCenter = rootPos + Vector3.new(0, boxSize / 2, 0)
                
                local boxPos, onScreen = Camera:WorldToViewportPoint(boxCenter)
                if onScreen then
                    box.Size = Vector2.new(boxSize * 1000 / pos.Z, boxSize * 1500 / pos.Z)
                    box.Position = Vector2.new(boxPos.X - box.Size.X / 2, boxPos.Y - box.Size.Y / 2)
                    box.Visible = true
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
        -- Hide all boxes if ESP is disabled
        for _, box in pairs(ESP.Boxes) do
            box.Visible = false
        end
    end
end

-- Initialize boxes for existing players
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
        CreateBox(player)
    end
end

-- Create boxes for new players
Players.PlayerAdded:Connect(function(player)
    CreateBox(player)
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
