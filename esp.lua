local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local ESP = {}

function ESP.Init(config)
    -- ESP settings
    local settings = {
        Enabled = false,
        TeamCheck = false,
        ShowBoxes = false,
        ShowNames = false,
        ShowDistance = false,
        ShowHealthBars = false,
        ShowHeadDot = false,
        ShowSkeleton = false,
        Outline = false,
        BoxType = "Full",
        BoxColor = Color3.fromRGB(255, 255, 255),
        NameColor = Color3.fromRGB(255, 255, 255),
        DistanceColor = Color3.fromRGB(255, 255, 255),
        HeadDotColor = Color3.fromRGB(255, 255, 255),
        SkeletonColor = Color3.fromRGB(255, 255, 255),
        BoxThickness = 1,
        BoxTransparency = 1,
        OutlineColor = Color3.fromRGB(255, 255, 255),
        TextSize = 13,
        Distance = 1000,
        SelfESP = false
    }

    -- Merge provided config with default settings
    for k, v in pairs(config or {}) do
        settings[k] = v
    end

    -- Drawing Functions
    local function NewDrawing(type, properties)
        local drawing = Drawing.new(type)
        for prop, value in pairs(properties) do
            drawing[prop] = value
        end
        return drawing
    end

    local function NewLine()
        return NewDrawing("Line", {
            Visible = false,
            From = Vector2.new(0, 0),
            To = Vector2.new(1, 1),
            Color = settings.BoxColor,
            Thickness = settings.BoxThickness,
            Transparency = settings.BoxTransparency
        })
    end

    local function NewText()
        return NewDrawing("Text", {
            Visible = false,
            Center = true,
            Outline = true,
            Color = settings.NameColor,
            Size = settings.TextSize,
            Font = Drawing.Fonts.Monospace
        })
    end

    local function NewCircle()
        return NewDrawing("Circle", {
            Visible = false,
            Radius = 3,
            Color = settings.HeadDotColor,
            Thickness = 1,
            Filled = true
        })
    end

    -- ESP Function
    local function CreateESP(plr)
        local esp = {
            box = {
                line1 = NewLine(),
                line2 = NewLine(),
                line3 = NewLine(),
                line4 = NewLine(),
                line5 = NewLine(),
                line6 = NewLine(),
                line7 = NewLine(),
                line8 = NewLine(),
            },
            name = NewText(),
            distance = NewText(),
            healthBar = NewLine(),
            healthBarBackground = NewLine(),
            headDot = NewCircle(),
            skeleton = {
                head = NewLine(),
                torso = NewLine(),
                leftArm = NewLine(),
                rightArm = NewLine(),
                leftLeg = NewLine(),
                rightLeg = NewLine(),
            }
        }

        local function UpdateESP()
            local character = plr.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local head = character and character:FindFirstChild("Head")
            local hrp = character and character:FindFirstChild("HumanoidRootPart")

            if not character or not humanoid or not head or not hrp or humanoid.Health <= 0 then
                for _, drawing in pairs(esp.box) do drawing.Visible = false end
                esp.name.Visible = false
                esp.distance.Visible = false
                esp.healthBar.Visible = false
                esp.healthBarBackground.Visible = false
                esp.headDot.Visible = false
                for _, drawing in pairs(esp.skeleton) do drawing.Visible = false end
                return
            end

            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            local distance = (Camera.CFrame.Position - hrp.Position).Magnitude

            if onScreen and distance <= settings.Distance and settings.Enabled then
                -- Team Check
                if settings.TeamCheck and plr.Team == LocalPlayer.Team then
                    for _, drawing in pairs(esp.box) do drawing.Visible = false end
                    esp.name.Visible = false
                    esp.distance.Visible = false
                    esp.healthBar.Visible = false
                    esp.healthBarBackground.Visible = false
                    esp.headDot.Visible = false
                    for _, drawing in pairs(esp.skeleton) do drawing.Visible = false end
                    return
                end

                -- Self ESP Check
                if not settings.SelfESP and plr == LocalPlayer then
                    for _, drawing in pairs(esp.box) do drawing.Visible = false end
                    esp.name.Visible = false
                    esp.distance.Visible = false
                    esp.healthBar.Visible = false
                    esp.healthBarBackground.Visible = false
                    esp.headDot.Visible = false
                    for _, drawing in pairs(esp.skeleton) do drawing.Visible = false end
                    return
                end

                local size = (Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) - Vector2.new(pos.X, pos.Y)).Magnitude / 100
                local boxSize = Vector2.new(size * 2, size * 3)
                local boxPos = Vector2.new(pos.X - size, pos.Y - size * 1.5)

                -- Box ESP
                if settings.ShowBoxes then
                    if settings.BoxType == "Corners" then
                        local cornerSize = boxSize.X * 0.2

                        -- Top left
                        esp.box.line1.From = boxPos
                        esp.box.line1.To = boxPos + Vector2.new(cornerSize, 0)
                        esp.box.line2.From = boxPos
                        esp.box.line2.To = boxPos + Vector2.new(0, cornerSize)

                        -- Top right
                        esp.box.line3.From = boxPos + Vector2.new(boxSize.X, 0)
                        esp.box.line3.To = esp.box.line3.From - Vector2.new(cornerSize, 0)
                        esp.box.line4.From = boxPos + Vector2.new(boxSize.X, 0)
                        esp.box.line4.To = esp.box.line4.From + Vector2.new(0, cornerSize)

                        -- Bottom left
                        esp.box.line5.From = boxPos + Vector2.new(0, boxSize.Y)
                        esp.box.line5.To = esp.box.line5.From + Vector2.new(cornerSize, 0)
                        esp.box.line6.From = boxPos + Vector2.new(0, boxSize.Y)
                        esp.box.line6.To = esp.box.line6.From - Vector2.new(0, cornerSize)

                        -- Bottom right
                        esp.box.line7.From = boxPos + boxSize
                        esp.box.line7.To = esp.box.line7.From - Vector2.new(cornerSize, 0)
                        esp.box.line8.From = boxPos + boxSize
                        esp.box.line8.To = esp.box.line8.From - Vector2.new(0, cornerSize)

                        for _, line in pairs(esp.box) do
                            line.Visible = true
                            line.Color = settings.BoxColor
                            line.Thickness = settings.BoxThickness
                            line.Transparency = settings.BoxTransparency
                        end
                    else
                        esp.box.line1.From = boxPos
                        esp.box.line1.To = boxPos + Vector2.new(boxSize.X, 0)
                        esp.box.line2.From = boxPos + Vector2.new(boxSize.X, 0)
                        esp.box.line2.To = boxPos + boxSize
                        esp.box.line3.From = boxPos + boxSize
                        esp.box.line3.To = boxPos + Vector2.new(0, boxSize.Y)
                        esp.box.line4.From = boxPos
                        esp.box.line4.To = boxPos + Vector2.new(0, boxSize.Y)

                        for i = 1, 4 do
                            esp.box["line"..i].Visible = true
                            esp.box["line"..i].Color = settings.BoxColor
                            esp.box["line"..i].Thickness = settings.BoxThickness
                            esp.box["line"..i].Transparency = settings.BoxTransparency
                        end
                        for i = 5, 8 do
                            esp.box["line"..i].Visible = false
                        end
                    end
                else
                    for _, line in pairs(esp.box) do
                        line.Visible = false
                    end
                end

                -- Name ESP
                if settings.ShowNames then
                    esp.name.Position = Vector2.new(pos.X, boxPos.Y - esp.name.TextBounds.Y - 2)
                    esp.name.Text = plr.Name
                    esp.name.Color = settings.NameColor
                    esp.name.Visible = true
                else
                    esp.name.Visible = false
                end

                -- Distance ESP
                if settings.ShowDistance then
                    esp.distance.Position = Vector2.new(pos.X, boxPos.Y + boxSize.Y + 2)
                    esp.distance.Text = string.format("%.1f m", distance)
                    esp.distance.Color = settings.DistanceColor
                    esp.distance.Visible = true
                else
                    esp.distance.Visible = false
                end

                -- Health Bar
                if settings.ShowHealthBars then
                    local healthPercent = humanoid.Health / humanoid.MaxHealth
                    local barPos = Vector2.new(boxPos.X - 5, boxPos.Y)
                    local barSize = Vector2.new(2, boxSize.Y)

                    esp.healthBarBackground.From = barPos
                    esp.healthBarBackground.To = barPos + Vector2.new(0, barSize.Y)
                    esp.healthBarBackground.Color = Color3.fromRGB(0, 0, 0)
                    esp.healthBarBackground.Thickness = 4
                    esp.healthBarBackground.Visible = true

                    esp.healthBar.From = barPos + Vector2.new(0, barSize.Y * (1 - healthPercent))
                    esp.healthBar.To = barPos + Vector2.new(0, barSize.Y)
                    esp.healthBar.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
                    esp.healthBar.Thickness = 2
                    esp.healthBar.Visible = true
                else
                    esp.healthBar.Visible = false
                    esp.healthBarBackground.Visible = false
                end

                -- Head Dot
                if settings.ShowHeadDot then
                    local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        esp.headDot.Position = Vector2.new(headPos.X, headPos.Y)
                        esp.headDot.Visible = true
                        esp.headDot.Color = settings.HeadDotColor
                    else
                        esp.headDot.Visible = false
                    end
                else
                    esp.headDot.Visible = false
                end

                -- Skeleton ESP
                if settings.ShowSkeleton then
                    local function drawBone(bone1, bone2, skeletonPart)
                        local pos1, vis1 = Camera:WorldToViewportPoint(bone1.Position)
                        local pos2, vis2 = Camera:WorldToViewportPoint(bone2.Position)
                        if vis1 and vis2 then
                            esp.skeleton[skeletonPart].From = Vector2.new(pos1.X, pos1.Y)
                            esp.skeleton[skeletonPart].To = Vector2.new(pos2.X, pos2.Y)
                            esp.skeleton[skeletonPart].Visible = true
                            esp.skeleton[skeletonPart].Color = settings.SkeletonColor
                        else
                            esp.skeleton[skeletonPart].Visible = false
                        end
                    end

                    local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
                    local leftArm = character:FindFirstChild("LeftUpperArm") or character:FindFirstChild("Left Arm")
                    local rightArm = character:FindFirstChild("RightUpperArm") or character:FindFirstChild("Right Arm")
                    local leftLeg = character:FindFirstChild("LeftUpperLeg") or character:FindFirstChild("Left Leg")
                    local rightLeg = character:FindFirstChild("RightUpperLeg") or character:FindFirstChild("Right Leg")

                    if torso and head and leftArm and rightArm and leftLeg and rightLeg then
                        drawBone(head, torso, "head")
                        drawBone(torso, leftArm, "leftArm")
                        drawBone(torso, rightArm, "rightArm")
                        drawBone(torso, leftLeg, "leftLeg")
                        drawBone(torso, rightLeg, "rightLeg")
                    else
                        for _, part in pairs(esp.skeleton) do
                            part.Visible = false
                        end
                    end
                else
                    for _, part in pairs(esp.skeleton) do
                        part.Visible = false
                    end
                end
            else
                for _, drawing in pairs(esp.box) do drawing.Visible = false end
                esp.name.Visible = false
                esp.distance.Visible = false
                esp.healthBar.Visible = false
                esp.healthBarBackground.Visible = false
                esp.headDot.Visible = false
                for _, drawing in pairs(esp.skeleton) do drawing.Visible = false end
            end
        end

        RunService:BindToRenderStep(plr.Name.."_ESP", 1, UpdateESP)
    end

    -- Initialize ESP for all players
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            CreateESP(plr)
        end
    end

    -- Connect player added event
    Players.PlayerAdded:Connect(function(plr)
        CreateESP(plr)
    end)

    -- Update settings function
    function ESP:UpdateSettings(newSettings)
        for k, v in pairs(newSettings) do
            settings[k] = v
        end
    end

    return ESP
end

return ESP
