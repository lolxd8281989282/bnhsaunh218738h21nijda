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
    box.Color = Color3.fromRGB(255, 255, 255)  -- Set box color to white
    box.Thickness = 2
    box.Transparency = 1
    box.Filled = false
    ESP.Boxes[player] = box
end

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
                -- Get the screen position of the head and the humanoid root part
                local headPos, onScreenHead = Camera:WorldToViewportPoint(head.Position)
                local footPos, onScreenFoot = Camera:WorldToViewportPoint(humanoidRootPart.Position - Vector3.new(0, humanoid.HipWidth, 0))  -- Position of feet

                if onScreenHead and onScreenFoot then
                    -- Calculate the size of the box based on the player's height and width
                    local height = (head.Position - humanoidRootPart.Position).Magnitude
                    local width = humanoid.HipWidth * 2

                    -- Create box size and position on the screen
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

-- Initialize ESP for players already in the game
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
        CreateBox(player)
    end
end

-- Create boxes for players who join the game
Players.PlayerAdded:Connect(function(player)
    if player ~= Players.LocalPlayer then
        CreateBox(player)
    end
end)

-- Clean up when a player leaves
Players.PlayerRemoving:Connect(function(player)
    if ESP.Boxes[player] then
        ESP.Boxes[player]:Remove()
        ESP.Boxes[player] = nil
    end
end)

-- Call the UpdateESP function every frame to keep the ESP up-to-date
RunService.RenderStepped:Connect(UpdateESP)

return ESP
