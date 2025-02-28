-- Services
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
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
local Vector3new = Vector3.new
local Color3new = Color3.new
local Color3fromRGB = Color3.fromRGB
local WorldToViewportPoint = camera.WorldToViewportPoint
local FindFirstChild = game.FindFirstChild
local floor = math.floor

-- Drawing Functions
local function NewLine()
    local line = Drawing.new("Line")
    line.Visible = false
    line.From = Vector2new(0, 0)
    line.To = Vector2new(1, 1)
    line.Color = ESP.BoxColor
    line.Thickness = ESP.BoxThickness
    line.Transparency = ESP.BoxTransparency
    return line
end

local function NewText()
    local text = Drawing.new("Text")
    text.Visible = false
    text.Center = true
    text.Outline = true
    text.Color = ESP.TextColor
    text.Size = 13
    text.Font = Drawing.Fonts.Monospace
    return text
end

local function NewCircle()
    local circle = Drawing.new("Circle")
    circle.Visible = false
    circle.Radius = 3
    circle.Color = ESP.BoxColor
    circle.Thickness = 1
    circle.Filled = true
    return circle
end

local function NewSkeletonLine()
    local line = Drawing.new("Line")
    line.Visible = false
    line.From = Vector2new(0, 0)
    line.To = Vector2new(1, 1)
    line.Color = ESP.BoxColor
    line.Thickness = 1.5
    line.Transparency = 1
    return line
end

-- ESP Function
local function CreateESP(plr)
    local highlight = Instance.new("Highlight")
    highlight.FillColor = ESP.OutlineColor
    highlight.OutlineColor = ESP.OutlineColor
    highlight.FillTransparency = 1
    highlight.OutlineTransparency = 0
    highlight.Enabled = false

    local lines = {
        line1 = NewLine(),
        line2 = NewLine(),
        line3 = NewLine(),
        line4 = NewLine(),
        line5 = NewLine(),
        line6 = NewLine(),
        line7 = NewLine(),
        line8 = NewLine(),
        text = NewText(),
        headDot = NewCircle(),
        healthBar = NewLine(),
        armorBar = NewLine(),
        itemText = NewText(),
        healthBarBackground = NewLine(),
        armorBarBackground = NewLine(),
        skeletonNeck = NewSkeletonLine(),
        skeletonSpineUpper = NewSkeletonLine(),
        skeletonSpineLower = NewSkeletonLine(),
        skeletonLeftUpperArm = NewSkeletonLine(),
        skeletonLeftLowerArm = NewSkeletonLine(),
        skeletonRightUpperArm = NewSkeletonLine(),
        skeletonRightLowerArm = NewSkeletonLine(),
        skeletonLeftUpperLeg = NewSkeletonLine(),
        skeletonLeftLowerLeg = NewSkeletonLine(),
        skeletonRightUpperLeg = NewSkeletonLine(),
        skeletonRightLowerLeg = NewSkeletonLine(),
        skeletonHead = NewSkeletonLine(),
        skeletonLeftShoulder = NewSkeletonLine(),
        skeletonRightShoulder = NewSkeletonLine(),
        skeletonLeftHip = NewSkeletonLine(),
        skeletonRightHip = NewSkeletonLine(),
    }

    local function UpdateSkeleton(character, onScreen)
        local function getJointPosition(part)
            if part and part:IsA("BasePart") then
                local pos = part.Position
                local screenPos, isOnScreen = WorldToViewportPoint(camera, pos)
                if isOnScreen then
                    return Vector2new(screenPos.X, screenPos.Y)
                end
            end
            return nil
        end

        local function updateLine(line, from, to)
            if from and to then
                line.From = from
                line.To = to
                line.Color = ESP.SkeletonColor
                line.Thickness = 1.5
                line.Transparency = 1
                line.Visible = onScreen
            else
                line.Visible = false
            end
        end

        -- Get all joint positions
        local head = getJointPosition(FindFirstChild(character, "Head"))
        local upperTorso = getJointPosition(FindFirstChild(character, "UpperTorso"))
        local lowerTorso = getJointPosition(FindFirstChild(character, "LowerTorso"))
        local torso = getJointPosition(FindFirstChild(character, "Torso"))

        -- Arms
        local leftUpperArm = getJointPosition(FindFirstChild(character, "LeftUpperArm") or FindFirstChild(character, "Left Arm"))
        local leftLowerArm = getJointPosition(FindFirstChild(character, "LeftLowerArm"))
        local leftHand = getJointPosition(FindFirstChild(character, "LeftHand"))
        
        local rightUpperArm = getJointPosition(FindFirstChild(character, "RightUpperArm") or FindFirstChild(character, "Right Arm"))
        local rightLowerArm = getJointPosition(FindFirstChild(character, "RightLowerArm"))
        local rightHand = getJointPosition(FindFirstChild(character, "RightHand"))

        -- Legs
        local leftUpperLeg = getJointPosition(FindFirstChild(character, "LeftUpperLeg") or FindFirstChild(character, "Left Leg"))
        local leftLowerLeg = getJointPosition(FindFirstChild(character, "LeftLowerLeg"))
        local leftFoot = getJointPosition(FindFirstChild(character, "LeftFoot"))
        
        local rightUpperLeg = getJointPosition(FindFirstChild(character, "RightUpperLeg") or FindFirstChild(character, "Right Leg"))
        local rightLowerLeg = getJointPosition(FindFirstChild(character, "RightLowerLeg"))
        local rightFoot = getJointPosition(FindFirstChild(character, "RightFoot"))

        -- Reference points
        local mainTorso = upperTorso or torso
        local bottomTorso = lowerTorso or torso

        -- Draw complete skeleton
        updateLine(lines.skeletonHead, head, mainTorso)
        updateLine(lines.skeletonSpineUpper, upperTorso, lowerTorso)
        updateLine(lines.skeletonLeftShoulder, mainTorso, leftUpperArm)
        updateLine(lines.skeletonLeftUpperArm, leftUpperArm, leftLowerArm)
        updateLine(lines.skeletonLeftLowerArm, leftLowerArm, leftHand)
        updateLine(lines.skeletonRightShoulder, mainTorso, rightUpperArm)
        updateLine(lines.skeletonRightUpperArm, rightUpperArm, rightLowerArm)
        updateLine(lines.skeletonRightLowerArm, rightLowerArm, rightHand)
        updateLine(lines.skeletonLeftHip, bottomTorso, leftUpperLeg)
        updateLine(lines.skeletonLeftUpperLeg, leftUpperLeg, leftLowerLeg)
        updateLine(lines.skeletonLeftLowerLeg, leftLowerLeg, leftFoot)
        updateLine(lines.skeletonRightHip, bottomTorso, rightUpperLeg)
        updateLine(lines.skeletonRightUpperLeg, rightUpperLeg, rightLowerLeg)
        updateLine(lines.skeletonRightLowerLeg, rightLowerLeg, rightFoot)
    end

    local lastUpdate = 0
    local updateInterval = 1/60  -- Limit updates to 60fps

    local function UpdateESP()
        local connection
        connection = runService.RenderStepped:Connect(function()
            local currentTime = tick()
            if currentTime - lastUpdate < updateInterval then return end
            lastUpdate = currentTime

            if not ESP.Enabled then
                for _, drawing in pairs(lines) do
                    drawing.Visible = false
                end
                return
            end

            if not plr.Character or not plr.Character:FindFirstChild("Humanoid") or not plr.Character:FindFirstChild("HumanoidRootPart") then
                for _, drawing in pairs(lines) do
                    drawing.Visible = false
                end
                return
            end

            local humanoid = plr.Character.Humanoid
            if humanoid.Health <= 0 then
                for _, drawing in pairs(lines) do
                    drawing.Visible = false
                end
                return
            end

            local rootPart = plr.Character.HumanoidRootPart
            local head = plr.Character:FindFirstChild("Head")
            if not head then return end

            local screenPos, onScreen = WorldToViewportPoint(camera, rootPart.Position)
            local distance = (camera.CFrame.Position - rootPart.Position).Magnitude

            if not onScreen or distance > ESP.Distance then
                for _, drawing in pairs(lines) do
                    drawing.Visible = false
                end
                return
            end

            local size = Vector2new(2000 / distance, 2000 / distance)

            -- Team Check
            if ESP.TeamCheck and plr.Team == player.Team then
                for _, drawing in pairs(lines) do
                    drawing.Visible = false
                end
                return
            end

            -- Self ESP Check
            if not ESP.SelfESP and plr == player then
                for _, drawing in pairs(lines) do
                    drawing.Visible = false
                end
                return
            end

            -- Box ESP
            if ESP.ShowBoxes then
                local boxSize = Vector2new(size.X * 2, size.Y * 3)
                local boxPosition = Vector2new(screenPos.X - size.X, screenPos.Y - size.Y * 1.5)

                if ESP.BoxType == "Corners" then
                    local cornerSize = boxSize.X * 0.2

                    -- Top left
                    lines.line1.From = boxPosition
                    lines.line1.To = boxPosition + Vector2new(cornerSize, 0)
                    lines.line2.From = boxPosition
                    lines.line2.To = boxPosition + Vector2new(0, cornerSize)

                    -- Top right
                    lines.line3.From = boxPosition + Vector2new(boxSize.X, 0)
                    lines.line3.To = boxPosition + Vector2new(boxSize.X - cornerSize, 0)
                    lines.line4.From = boxPosition + Vector2new(boxSize.X, 0)
                    lines.line4.To = boxPosition + Vector2new(boxSize.X, cornerSize)

                    -- Bottom left
                    lines.line5.From = boxPosition + Vector2new(0, boxSize.Y)
                    lines.line5.To = boxPosition + Vector2new(cornerSize, boxSize.Y)
                    lines.line6.From = boxPosition + Vector2new(0, boxSize.Y)
                    lines.line6.To = boxPosition + Vector2new(0, boxSize.Y - cornerSize)

                    -- Bottom right
                    lines.line7.From = boxPosition + Vector2new(boxSize.X, boxSize.Y)
                    lines.line7.To = boxPosition + Vector2new(boxSize.X - cornerSize, boxSize.Y)
                    lines.line8.From = boxPosition + Vector2new(boxSize.X, boxSize.Y)
                    lines.line8.To = boxPosition + Vector2new(boxSize.X, boxSize.Y - cornerSize)

                    for i = 1, 8 do
                        lines["line"..i].Visible = true
                        lines["line"..i].Color = ESP.BoxColor
                        lines["line"..i].Thickness = ESP.BoxThickness
                    end
                else
                    -- Draw full box
                    lines.line1.From = boxPosition
                    lines.line1.To = boxPosition + Vector2new(boxSize.X, 0)
                    lines.line2.From = boxPosition + Vector2new(boxSize.X, 0)
                    lines.line2.To = boxPosition + boxSize
                    lines.line3.From = boxPosition + boxSize
                    lines.line3.To = boxPosition + Vector2new(0, boxSize.Y)
                    lines.line4.From = boxPosition
                    lines.line4.To = boxPosition + Vector2new(0, boxSize.Y)

                    for i = 1, 4 do
                        lines["line"..i].Visible = true
                        lines["line"..i].Color = ESP.BoxColor
                        lines["line"..i].Thickness = ESP.BoxThickness
                    end
                    for i = 5, 8 do
                        lines["line"..i].Visible = false
                    end
                end
            else
                for i = 1, 8 do
                    lines["line"..i].Visible = false
                end
            end

            -- Health Bar
            if ESP.ShowHealthBars then
                local healthPercent = humanoid.Health / humanoid.MaxHealth
                local barPos = Vector2new(screenPos.X - size.X - 5, screenPos.Y - size.Y * 1.5)
                local barSize = Vector2new(3, size.Y * 3)

                -- Background bar
                lines.healthBarBackground.From = barPos
                lines.healthBarBackground.To = barPos + Vector2new(0, barSize.Y)
                lines.healthBarBackground.Color = Color3fromRGB(25, 25, 25)
                lines.healthBarBackground.Thickness = 5
                lines.healthBarBackground.Visible = true
                lines.healthBarBackground.ZIndex = 1

                -- Calculate health bar size
                local healthBarHeight = barSize.Y * healthPercent
                local healthBarStart = barPos + Vector2new(0, barSize.Y - healthBarHeight)
                local healthBarEnd = barPos + Vector2new(0, barSize.Y)

                -- Health bar
                lines.healthBar.From = healthBarStart
                lines.healthBar.To = healthBarEnd
                lines.healthBar.Thickness = 3
                lines.healthBar.ZIndex = 2
                
                -- Health bar color
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
            else
                lines.text.Visible = false
            end

            -- Head Dot
            if ESP.ShowHeadDot and head then
                local headPos = WorldToViewportPoint(camera, head.Position)
                lines.headDot.Position = Vector2new(headPos.X, headPos.Y)
                lines.headDot.Color = ESP.HeadDotColor
                lines.headDot.Visible = true
            else
                lines.headDot.Visible = false
            end

            -- Distance
            if ESP.ShowDistance then
                lines.itemText.Position = Vector2new(screenPos.X, screenPos.Y + size.Y * 1.5)
                lines.itemText.Text = floor(distance) .. "m"
                lines.itemText.Color = ESP.DistanceColor
                lines.itemText.Visible = true
            else
                lines.itemText.Visible = false
            end

            -- Skeleton ESP
            if ESP.ShowSkeleton then
                UpdateSkeleton(plr.Character, true)
            else
                for _, line in pairs({
                    lines.skeletonHead, lines.skeletonSpineUpper, lines.skeletonSpineLower,
                    lines.skeletonLeftUpperArm, lines.skeletonLeftLowerArm,
                    lines.skeletonRightUpperArm, lines.skeletonRightLowerArm,
                    lines.skeletonLeftUpperLeg, lines.skeletonLeftLowerLeg,
                    lines.skeletonRightUpperLeg, lines.skeletonRightLowerLeg,
                    lines.skeletonLeftShoulder, lines.skeletonRightShoulder,
                    lines.skeletonLeftHip, lines.skeletonRightHip
                }) do
                    line.Visible = false
                end
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
