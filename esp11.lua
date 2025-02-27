local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local ESP = {
    Enabled = false,
    Boxes = {},
}

-- Function to create a box for each player
local function CreateBox(player)
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(255, 255, 255) -- Modern white box color
    box.Thickness = 2
    box.Transparency = 1
    box.Filled = false
    ESP.Boxes[player] = box
end

-- Function to update ESP (create box sizes and positions)
local function UpdateESP()
    if not ESP.Enabled then
        -- If ESP is disabled, hide all boxes
        for _, box in pairs(ESP.Boxes) do
            box.Visible = false
        end
        return
    end

    for player, box in pairs(ESP.Boxes) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= Players.LocalPlayer then
            local character = player.Character
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            local head = character:FindFirstChild("Head")
            local humanoid = character:FindFirstChild("Humanoid")

            if head and humanoidRootPart then
                -- Get the screen positions of the head and humanoid root part
                local headPos, onScreenHead = Camera:WorldToViewportPoint(head.Position)
                local footPos, onScreenFoot = Camera:WorldToViewportPoint(humanoidRootPart.Position - Vector3.new(0, humanoid.HipWidth, 0)) -- Foot position

                if onScreenHead and onScreenFoot then
                    -- Calculate the size of the box to fit the player, based on their height and width
                    local height = (head.Position - humanoidRootPart.Position).Magnitude
                    local width = humanoid.HipWidth * 2

                    -- Adjust size and position to create the box around the player
                    local boxPos = Vector2.new((headPos.X + footPos.X) / 2, (headPos.Y + footPos.Y) / 2)
                    local boxSize = Vector2.new(width * 1000 / footPos.Z, height * 1500 / footPos.Z)
                    box.Position = Vector2.new(boxPos.X - boxSize.X / 2, boxPos.Y - boxSize.Y / 2)
                    box.Size = boxSize
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

-- Toggle function to enable/disable ESP
function ESP:Toggle(state)
    self.Enabled = state
    print("ESP Toggled:", state) -- Debugging
    if not state then
        -- Hide all boxes if ESP is disabled
        for _, box in pairs(ESP.Boxes) do
            box.Visible = false
        end
    end
end

-- Initialize ESP for existing players
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
        CreateBox(player)
    end
end

-- Add boxes for new players joining
Players.PlayerAdded:Connect(function(player)
    if player ~= Players.LocalPlayer then
        CreateBox(player)
    end
end)

-- Clean up boxes for players leaving
Players.PlayerRemoving:Connect(function(player)
    if ESP.Boxes[player] then
        ESP.Boxes[player]:Remove()
        ESP.Boxes[player] = nil
    end
end)

-- Update ESP each frame
RunService.RenderStepped:Connect(UpdateESP)

return ESP
