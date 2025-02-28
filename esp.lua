-- Services
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local player = players.LocalPlayer
local camera = workspace.CurrentCamera

-- ESP Settings
local ESP = {
    Enabled = false,
    TeamCheck = false,
    Outline = false,
    SelfESP = false,
    ShowNames = false,
    ShowBoxes = false,
    ShowHealthBars = false,
    ShowEquippedItem = false,
    ShowSkeleton = false,
    ShowArmorBar = false,
    ShowHeadDot = false,
    FillBox = false,
    ShowDistance = false,
    OutlineColor = Color3.new(1, 1, 1),
    OutlineThickness = 3,
    BoxColor = Color3.fromRGB(255, 255, 255),
    BoxThickness = 1.4,
    BoxTransparency = 1,
    TextColor = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    Distance = 1000,
    BoxType = "Corners",
    ArmorBarColor = Color3.fromRGB(0, 150, 255),
    NameColor = Color3.fromRGB(255, 255, 255),
    EquippedItemColor = Color3.fromRGB(255, 255, 255),
    SkeletonColor = Color3.fromRGB(255, 255, 255),
    HeadDotColor = Color3.fromRGB(255, 255, 255),
    DistanceColor = Color3.fromRGB(255, 255, 255),
}

-- Optimization: Cache frequently used functions
local Vector2new = Vector2.new
local Color3fromRGB = Color3.fromRGB
local WorldToViewportPoint = camera.WorldToViewportPoint
local FindFirstChild = game.FindFirstChild
local floor = math.floor

-- Drawing Functions
local function NewDrawing(type)
    local drawing = Drawing.new(type)
    drawing.Visible = false
    return drawing
end

-- ESP Function
local function CreateESP(plr)
    local lines = {
        box = {NewDrawing("Line"), NewDrawing("Line"), NewDrawing("Line"), NewDrawing("Line"),
               NewDrawing("Line"), NewDrawing("Line"), NewDrawing("Line"), NewDrawing("Line")},
        healthBarBackground = NewDrawing("Line"),
        healthBar = NewDrawing("Line"),
        text = NewDrawing("Text"),
        headDot = NewDrawing("Circle"),
        itemText = NewDrawing("Text"),
        armorBar = NewDrawing("Line"),
        armorBarBackground = NewDrawing("Line"),
        skeleton = {
            NewDrawing("Line"), NewDrawing("Line"), NewDrawing("Line"), NewDrawing("Line"),
            NewDrawing("Line"), NewDrawing("Line"), NewDrawing("Line"), NewDrawing("Line"),
            NewDrawing("Line"), NewDrawing("Line"), NewDrawing("Line"), NewDrawing("Line"),
            NewDrawing("Line"), NewDrawing("Line"), NewDrawing("Line"), NewDrawing("Line"),
            NewDrawing("Line")
        }
    }

    local highlight = Instance.new("Highlight")
    highlight.FillColor = ESP.OutlineColor
    highlight.OutlineColor = ESP.OutlineColor
    highlight.FillTransparency = 1
    highlight.OutlineTransparency = 0
    highlight.Enabled = false

    local function UpdateESP()
        local connection
        connection = runService.Heartbeat:Connect(function()
            if not ESP.Enabled then
                for _, obj in pairs(lines) do
                    if type(obj) == "table" then
                        for _, drawing in pairs(obj) do
                            drawing.Visible = false
                        end
                    else
                        obj.Visible = false
                    end
                end
                highlight.Enabled = false
                return
            end

            local character = plr.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")

            if not character or not humanoid or not rootPart or humanoid.Health <= 0 then
                for _, obj in pairs(lines) do
                    if type(obj) == "table" then
                        for _, drawing in pairs(obj) do
                            drawing.Visible = false
                        end
                    else
                        obj.Visible = false
                    end
                end
                highlight.Enabled = false
                return
            end

            local screenPos, onScreen = WorldToViewportPoint(camera, rootPart.Position)
            local distance = (camera.CFrame.Position - rootPart.Position).Magnitude

            if not onScreen or distance > ESP.Distance then
                for _, obj in pairs(lines) do
                    if type(obj) == "table" then
                        for _, drawing in pairs(obj) do
                            drawing.Visible = false
                        end
                    else
                        obj.Visible = false
                    end
                end
                highlight.Enabled = false
                return
            end

            local size = Vector2new(2000 / distance, 2000 / distance)

            -- Team Check
            if ESP.TeamCheck and plr.Team == player.Team then
                for _, obj in pairs(lines) do
                    if type(obj) == "table" then
                        for _, drawing in pairs(obj) do
                            drawing.Visible = false
                        end
                    else
                        obj.Visible = false
                    end
                end
                highlight.Enabled = false
                return
            end

            -- Self ESP Check
            if not ESP.SelfESP and plr == player then
                for _, obj in pairs(lines) do
                    if type(obj) == "table" then
                        for _, drawing in pairs(obj) do
                            drawing.Visible = false
                        end
                    else
                        obj.Visible = false
                    end
                end
                highlight.Enabled = false
                return
            end

            -- Box ESP
            if ESP.ShowBoxes then
                local boxSize = Vector2new(size.X * 2, size.Y * 3)
                local boxPosition = Vector2new(screenPos.X - size.X, screenPos.Y - size.Y * 1.5)

                if ESP.BoxType == "Corners" then
                    local cornerSize = boxSize.X * 0.2

                    -- Top left
                    lines.box[1].From = boxPosition
                    lines.box[1].To = boxPosition + Vector2new(cornerSize, 0)
                    lines.box[2].From = boxPosition
                    lines.box[2].To = boxPosition + Vector2new(0, cornerSize)

                    -- Top right
                    lines.box[3].From = boxPosition + Vector2new(boxSize.X, 0)
                    lines.box[3].To = boxPosition + Vector2new(boxSize.X - cornerSize, 0)
                    lines.box[4].From = boxPosition + Vector2new(boxSize.X, 0)
                    lines.box[4].To = boxPosition + Vector2new(boxSize.X, cornerSize)

                    -- Bottom left
                    lines.box[5].From = boxPosition + Vector2new(0, boxSize.Y)
                    lines.box[5].To = boxPosition + Vector2new(cornerSize, boxSize.Y)
                    lines.box[6].From = boxPosition + Vector2new(0, boxSize.Y)
                    lines.box[6].To = boxPosition + Vector2new(0, boxSize.Y - cornerSize)

                    -- Bottom right
                    lines.box[7].From = boxPosition + Vector2new(boxSize.X, boxSize.Y)
                    lines.box[7].To = boxPosition + Vector2new(boxSize.X - cornerSize, boxSize.Y)
                    lines.box[8].From = boxPosition + Vector2new(boxSize.X, boxSize.Y)
                    lines.box[8].To = boxPosition + Vector2new(boxSize.X, boxSize.Y - cornerSize)

                    for i = 1, 8 do
                        lines.box[i].Visible = true
                        lines.box[i].Color = ESP.BoxColor
                        lines.box[i].Thickness = ESP.BoxThickness
                    end
                else
                    -- Draw full box
                    lines.box[1].From = boxPosition
                    lines.box[1].To = boxPosition + Vector2new(boxSize.X, 0)
                    lines.box[2].From = boxPosition + Vector2new(boxSize.X, 0)
                    lines.box[2].To = boxPosition + boxSize
                    lines.box[3].From = boxPosition + boxSize
                    lines.box[3].To = boxPosition + Vector2new(0, boxSize.Y)
                    lines.box[4].From = boxPosition
                    lines.box[4].To = boxPosition + Vector2new(0, boxSize.Y)

                    for i = 1, 4 do
                        lines.box[i].Visible = true
                        lines.box[i].Color = ESP.BoxColor
                        lines.box[i].Thickness = ESP.BoxThickness
                    end
                    for i = 5, 8 do
                        lines.box[i].Visible = false
                    end
                end
            else
                for i = 1, 8 do
                    lines.box[i].Visible = false
                end
            end

            -- Health Bar
            if ESP.ShowHealthBars then
                local healthPercent = humanoid.Health / humanoid.MaxHealth
                local barPos = Vector2new(screenPos.X - size.X - 5, screenPos.Y - size.Y * 1.5)
                local barSize = Vector2new(3, size.Y * 3)

                lines.healthBarBackground.From = barPos
                lines.healthBarBackground.To = barPos + Vector2new(0, barSize.Y)
                lines.healthBarBackground.Color = Color3fromRGB(25, 25, 25)
                lines.healthBarBackground.Thickness = 5
                lines.healthBarBackground.Visible = true
                lines.healthBarBackground.ZIndex = 1

                local healthBarHeight = barSize.Y * healthPercent
                local healthBarStart = barPos + Vector2new(0, barSize.Y - healthBarHeight)
                local healthBarEnd = barPos + Vector2new(0, barSize.Y)

                lines.healthBar.From = healthBarStart
                lines.healthBar.To = healthBarEnd
                lines.healthBar.Thickness = 3
                lines.healthBar.ZIndex = 2
                
                if healthPercent > 0.75 then
                    lines.healthBar.Color = Color3fromRGB(0, 255, 0)
                elseif healthPercent > 0.5 then
                    lines.healthBar.Color = Color3fromRGB(255, 255, 0)
                else
                    lines.healthBar.Color = Color3fromRGB(255, 0, 0)
                end
                
                lines.healthBar.Visible = true
            else
                lines.healthBar.Visible = false
                lines.healthBarBackground.Visible = false
            end

            -- Name ESP
            if ESP.ShowNames then
                lines.text.Position = Vector2new(screenPos.X, screenPos.Y - size.Y * 2)
                lines.text.Text = plr.Name
                lines.text.Color = ESP.NameColor
                lines.text.Visible = true
                lines.text.Size = ESP.TextSize
            else
                lines.text.Visible = false
            end

            -- Head Dot
            if ESP.ShowHeadDot then
                local head = character:FindFirstChild("Head")
                if head then
                    local headPos = WorldToViewportPoint(camera, head.Position)
                    lines.headDot.Position = Vector2new(headPos.X, headPos.Y)
                    lines.headDot.Color = ESP.HeadDotColor
                    lines.headDot.Visible = true
                else
                    lines.headDot.Visible = false
                end
            else
                lines.headDot.Visible = false
            end

            -- Distance
            if ESP.ShowDistance then
                lines.itemText.Position = Vector2new(screenPos.X, screenPos.Y + size.Y * 1.5)
                lines.itemText.Text = floor(distance) .. "m"
                lines.itemText.Color = ESP.DistanceColor
                lines.itemText.Visible = true
                lines.itemText.Size = ESP.TextSize
            else
                lines.itemText.Visible = false
            end

            -- Skeleton ESP
            if ESP.ShowSkeleton then
                local function getJointPosition(part)
                    if part and part:IsA("BasePart") then
                        local pos = WorldToViewportPoint(camera, part.Position)
                        return Vector2new(pos.X, pos.Y)
                    end
                    return nil
                end

                local head = getJointPosition(character:FindFirstChild("Head"))
                local torso = getJointPosition(character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso"))
                local leftArm = getJointPosition(character:FindFirstChild("LeftUpperArm") or character:FindFirstChild("Left Arm"))
                local rightArm = getJointPosition(character:FindFirstChild("RightUpperArm") or character:FindFirstChild("Right Arm"))
                local leftLeg = getJointPosition(character:FindFirstChild("LeftUpperLeg") or character:FindFirstChild("Left Leg"))
                local rightLeg = getJointPosition(character:FindFirstChild("RightUpperLeg") or character:FindFirstChild("Right Leg"))

                local function updateSkeletonLine(index, from, to)
                    if from and to then
                        lines.skeleton[index].From = from
                        lines.skeleton[index].To = to
                        lines.skeleton[index].Color = ESP.SkeletonColor
                        lines.skeleton[index].Thickness = 1
                        lines.skeleton[index].Visible = true
                    else
                        lines.skeleton[index].Visible = false
                    end
                end

                updateSkeletonLine(1, head, torso)
                updateSkeletonLine(2, torso, leftArm)
                updateSkeletonLine(3, torso, rightArm)
                updateSkeletonLine(4, torso, leftLeg)
                updateSkeletonLine(5, torso, rightLeg)
            else
                for i = 1, #lines.skeleton do
                    lines.skeleton[i].Visible = false
                end
            end

            -- Outline ESP
            if ESP.Outline then
                highlight.Parent = character
                highlight.Enabled = true
                highlight.FillColor = ESP.OutlineColor
                highlight.OutlineColor = ESP.OutlineColor
            else
                highlight.Enabled = false
                highlight.Parent = nil
            end
        end)
    end

    UpdateESP()
end

-- Initialize ESP for all players
for _, plr in ipairs(players:GetPlayers()) do
    if plr ~= player then
        CreateESP(plr)
    end
end

-- Connect player added event
players.PlayerAdded:Connect(function(plr)
    CreateESP(plr)
end)

function ESP:UpdateSettings(newSettings)
    for k, v in pairs(newSettings) do
        self[k] = v
    end
end

return ESP
