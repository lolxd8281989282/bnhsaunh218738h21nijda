-- Services
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local coreGui = game:GetService("CoreGui")
local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local player = players.LocalPlayer
local camera = workspace.CurrentCamera

-- ESP Settings
local ESP = {
  Enabled = false,
  TeamCheck = false,
  Outline = false,
  SelfESP = false,
  ShowNames = true,
  ShowBoxes = true,
  ShowHealthBars = true,
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

-- Drawing Functions
local function NewLine()
  local line = Drawing.new("Line")
  line.Visible = false
  line.From = Vector2.new(0, 0)
  line.To = Vector2.new(1, 1)
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
  line.From = Vector2.new(0, 0)
  line.To = Vector2.new(1, 1)
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
              local screenPos, isOnScreen = camera:WorldToViewportPoint(pos)
              if isOnScreen then
                  return Vector2.new(screenPos.X, screenPos.Y)
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
      local head = getJointPosition(character:FindFirstChild("Head"))
      local upperTorso = getJointPosition(character:FindFirstChild("UpperTorso"))
      local lowerTorso = getJointPosition(character:FindFirstChild("LowerTorso"))
      local torso = getJointPosition(character:FindFirstChild("Torso")) -- R6 fallback

      -- Arms
      local leftUpperArm = getJointPosition(character:FindFirstChild("LeftUpperArm") or character:FindFirstChild("Left Arm"))
      local leftLowerArm = getJointPosition(character:FindFirstChild("LeftLowerArm"))
      local leftHand = getJointPosition(character:FindFirstChild("LeftHand"))
      
      local rightUpperArm = getJointPosition(character:FindFirstChild("RightUpperArm") or character:FindFirstChild("Right Arm"))
      local rightLowerArm = getJointPosition(character:FindFirstChild("RightLowerArm"))
      local rightHand = getJointPosition(character:FindFirstChild("RightHand"))

      -- Legs
      local leftUpperLeg = getJointPosition(character:FindFirstChild("LeftUpperLeg") or character:FindFirstChild("Left Leg"))
      local leftLowerLeg = getJointPosition(character:FindFirstChild("LeftLowerLeg"))
      local leftFoot = getJointPosition(character:FindFirstChild("LeftFoot"))
      
      local rightUpperLeg = getJointPosition(character:FindFirstChild("RightUpperLeg") or character:FindFirstChild("Right Leg"))
      local rightLowerLeg = getJointPosition(character:FindFirstChild("RightLowerLeg"))
      local rightFoot = getJointPosition(character:FindFirstChild("RightFoot"))

      -- Reference points
      local mainTorso = upperTorso or torso
      local bottomTorso = lowerTorso or torso

      -- Draw complete skeleton
      -- Head and Torso
      updateLine(lines.skeletonHead, head, mainTorso)
      updateLine(lines.skeletonSpineUpper, upperTorso, lowerTorso)

      -- Left Arm
      updateLine(lines.skeletonLeftShoulder, mainTorso, leftUpperArm)
      updateLine(lines.skeletonLeftUpperArm, leftUpperArm, leftLowerArm)
      updateLine(lines.skeletonLeftLowerArm, leftLowerArm, leftHand)

      -- Right Arm
      updateLine(lines.skeletonRightShoulder, mainTorso, rightUpperArm)
      updateLine(lines.skeletonRightUpperArm, rightUpperArm, rightLowerArm)
      updateLine(lines.skeletonRightLowerArm, rightLowerArm, rightHand)

      -- Left Leg
      updateLine(lines.skeletonLeftHip, bottomTorso, leftUpperLeg)
      updateLine(lines.skeletonLeftUpperLeg, leftUpperLeg, leftLowerLeg)
      updateLine(lines.skeletonLeftLowerLeg, leftLowerLeg, leftFoot)

      -- Right Leg
      updateLine(lines.skeletonRightHip, bottomTorso, rightUpperLeg)
      updateLine(lines.skeletonRightUpperLeg, rightUpperLeg, rightLowerLeg)
      updateLine(lines.skeletonRightLowerLeg, rightLowerLeg, rightFoot)
  end

  local function UpdateESP()
      local connection
      connection = runService.RenderStepped:Connect(function()
          if not ESP.Enabled then
              for _, drawing in pairs(lines) do
                  drawing.Visible = false
              end
              return
          end

          if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.Humanoid.Health > 0 then
              local humanoid = plr.Character.Humanoid
              local rootPart = plr.Character.HumanoidRootPart
              local head = plr.Character:FindFirstChild("Head")

              if not head then return end

              local screenPos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
              local distance = (camera.CFrame.Position - rootPart.Position).Magnitude

              if onScreen and distance <= ESP.Distance then
                  local size = Vector2.new(2000 / distance, 2000 / distance)
                  local screenSize = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

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
                      local boxSize = Vector2.new(size.X * 2, size.Y * 3)
                      local boxPosition = Vector2.new(screenPos.X - size.X, screenPos.Y - size.Y * 1.5)

                      if ESP.BoxType == "Corners" then
                          -- Draw corner box
                          local cornerSize = boxSize.X * 0.2

                          -- Top left
                          lines.line1.From = boxPosition
                          lines.line1.To = boxPosition + Vector2.new(cornerSize, 0)
                          lines.line2.From = boxPosition
                          lines.line2.To = boxPosition + Vector2.new(0, cornerSize)

                          -- Top right
                          lines.line3.From = boxPosition + Vector2.new(boxSize.X, 0)
                          lines.line3.To = boxPosition + Vector2.new(boxSize.X - cornerSize, 0)
                          lines.line4.From = boxPosition + Vector2.new(boxSize.X, 0)
                          lines.line4.To = boxPosition + Vector2.new(boxSize.X, cornerSize)

                          -- Bottom left
                          lines.line5.From = boxPosition + Vector2.new(0, boxSize.Y)
                          lines.line5.To = boxPosition + Vector2.new(cornerSize, boxSize.Y)
                          lines.line6.From = boxPosition + Vector2.new(0, boxSize.Y)
                          lines.line6.To = boxPosition + Vector2.new(0, boxSize.Y - cornerSize)

                          -- Bottom right
                          lines.line7.From = boxPosition + Vector2.new(boxSize.X, boxSize.Y)
                          lines.line7.To = boxPosition + Vector2.new(boxSize.X - cornerSize, boxSize.Y)
                          lines.line8.From = boxPosition + Vector2.new(boxSize.X, boxSize.Y)
                          lines.line8.To = boxPosition + Vector2.new(boxSize.X, boxSize.Y - cornerSize)

                          for i = 1, 8 do
                              lines["line"..i].Visible = true
                              lines["line"..i].Color = ESP.BoxColor
                              lines["line"..i].Thickness = ESP.BoxThickness
                              lines["line"..i].Transparency = 1
                          end
                      else
                          -- Draw full box
                          lines.line1.From = boxPosition
                          lines.line1.To = boxPosition + Vector2.new(boxSize.X, 0)
                          lines.line2.From = boxPosition + Vector2.new(boxSize.X, 0)
                          lines.line2.To = boxPosition + boxSize
                          lines.line3.From = boxPosition + boxSize
                          lines.line3.To = boxPosition + Vector2.new(0, boxSize.Y)
                          lines.line4.From = boxPosition
                          lines.line4.To = boxPosition + Vector2.new(0, boxSize.Y)

                          for i = 1, 4 do
                              lines["line"..i].Visible = true
                              lines["line"..i].Color = ESP.BoxColor
                              lines["line"..i].Thickness = ESP.BoxThickness
                              lines["line"..i].Transparency = 1
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

                  -- Outline ESP
                  if ESP.Outline then
                      if plr.Character then
                          highlight.Parent = plr.Character
                          highlight.Enabled = true
                          highlight.FillColor = ESP.OutlineColor
                          highlight.OutlineColor = ESP.OutlineColor
                      end
                  else
                      highlight.Enabled = false
                      highlight.Parent = nil
                  end

                  -- Name ESP
                  if ESP.ShowNames then
                      lines.text.Position = Vector2.new(screenPos.X, screenPos.Y - size.Y * 2)
                      lines.text.Text = plr.Name
                      lines.text.Color = ESP.NameColor
                      lines.text.Visible = true
                  else
                      lines.text.Visible = false
                  end

                  -- Head Dot
                  if ESP.ShowHeadDot and head then
                      local headPos, onScreen = camera:WorldToViewportPoint(head.Position)
                      if onScreen then
                          local headSize = head.Size.Y
                          local distance = (camera.CFrame.Position - head.Position).Magnitude
                          local screenSize = headSize * 1000 / distance
                          
                          lines.headDot.Position = Vector2.new(headPos.X, headPos.Y)
                          lines.headDot.Radius = screenSize / 2
                          lines.headDot.Visible = true
                          lines.headDot.Color = ESP.HeadDotColor
                          lines.headDot.Filled = false
                          lines.headDot.Thickness = 1.5
                      else
                          lines.headDot.Visible = false
                      end
                  else
                      lines.headDot.Visible = false
                  end

                  -- Health Bar
                  if ESP.ShowHealthBars then
                      local healthPercent = humanoid.Health / humanoid.MaxHealth
                      local barPos = Vector2.new(screenPos.X - size.X - 5, screenPos.Y - size.Y * 1.5)
                      local barSize = Vector2.new(0, size.Y * 3)
                  
                      -- Background bar
                      lines.healthBarBackground.From = barPos
                      lines.healthBarBackground.To = barPos + Vector2.new(0, barSize.Y)
                      lines.healthBarBackground.Color = Color3.fromRGB(25, 25, 25)
                      lines.healthBarBackground.Thickness = 4
                      lines.healthBarBackground.Visible = true
                  
                      -- Health bar
                      local healthBarStart = barPos
                      local healthBarEnd = barPos + Vector2.new(0, barSize.Y)
                      local currentHeight = barSize.Y * (1 - healthPercent)
                      lines.healthBar.From = healthBarStart + Vector2.new(0, currentHeight)
                      lines.healthBar.To = healthBarEnd
                      
                      if healthPercent > 0.75 then
                          lines.healthBar.Color = Color3.fromRGB(0, 255, 0)
                      elseif healthPercent > 0.5 then
                          lines.healthBar.Color = Color3.fromRGB(255, 255, 0)
                      elseif healthPercent > 0.25 then
                          lines.healthBar.Color = Color3.fromRGB(255, 125, 0)
                      else
                          lines.healthBar.Color = Color3.fromRGB(255, 0, 0)
                      end
                      
                      lines.healthBar.Thickness = 2
                      lines.healthBar.Visible = true
                      lines.healthBar.ZIndex = 2
                  else
                      lines.healthBar.Visible = false
                      lines.healthBarBackground.Visible = false
                  end

                  -- Armor Bar
                  if ESP.ShowArmorBar then
                      local armorValue = 0
                      local maxArmor = 100
                      
                      if humanoid:GetAttribute("Armor") then
                          armorValue = humanoid:GetAttribute("Armor")
                      elseif humanoid:FindFirstChild("Armor") then
                          armorValue = humanoid.Armor.Value
                      elseif plr.Character:FindFirstChild("Armor") then
                          armorValue = plr.Character.Armor.Value
                      elseif humanoid:FindFirstChild("Shield") then
                          armorValue = humanoid.Shield.Value
                      elseif plr.Character:FindFirstChild("Shield") then
                          armorValue = plr.Character.Shield.Value
                      elseif plr:FindFirstChild("Armor") then
                          armorValue = plr.Armor.Value
                      elseif plr:FindFirstChild("Shield") then
                          armorValue = plr.Shield.Value
                      elseif plr.Character:FindFirstChild("Protection") then
                          armorValue = plr.Character.Protection.Value
                      end
                  
                      if humanoid:GetAttribute("MaxArmor") then
                          maxArmor = humanoid:GetAttribute("MaxArmor")
                      elseif humanoid:FindFirstChild("MaxArmor") then
                          maxArmor = humanoid.MaxArmor.Value
                      elseif plr.Character:FindFirstChild("MaxArmor") then
                          maxArmor = plr.Character.MaxArmor.Value
                      elseif humanoid:FindFirstChild("MaxShield") then
                          maxArmor = humanoid.MaxShield.Value
                      elseif plr.Character:FindFirstChild("MaxShield") then
                          maxArmor = plr.Character.MaxShield.Value
                      end
                  
                      local armorPercent = armorValue / maxArmor
                      local barPos = Vector2.new(screenPos.X + size.X + 5, screenPos.Y - size.Y * 1.5)
                      local barSize = Vector2.new(0, size.Y * 3)
                  
                      -- Background bar
                      lines.armorBarBackground.From = barPos
                      lines.armorBarBackground.To = barPos + Vector2.new(0, barSize.Y)
                      lines.armorBarBackground.Color = Color3.fromRGB(25, 25, 25)
                      lines.armorBarBackground.Thickness = 4
                      lines.armorBarBackground.Visible = true
                  
                      if armorValue > 0 then
                          local armorBarStart = barPos
                          local armorBarEnd = barPos + Vector2.new(0, barSize.Y)
                          local currentHeight = barSize.Y * (1 - armorPercent)
                          lines.armorBar.From = armorBarStart + Vector2.new(0, currentHeight)
                          lines.armorBar.To = armorBarEnd
                          lines.armorBar.Color = ESP.ArmorBarColor
                          lines.armorBar.Thickness = 2
                          lines.armorBar.Visible = true
                          lines.armorBar.ZIndex = 2
                      else
                          lines.armorBar.Visible = false
                      end
                  else
                      lines.armorBar.Visible = false
                      lines.armorBarBackground.Visible = false
                  end

                  -- Equipped Item
                  if ESP.ShowEquippedItem or ESP.ShowDistance then
                      lines.itemText.Position = Vector2.new(screenPos.X, screenPos.Y + size.Y * 2)
                      local text = ""
                      
                      if ESP.ShowEquippedItem then
                          local tool = plr.Character:FindFirstChildOfClass("Tool")
                          if tool then
                              text = tool.Name
                          end
                      end
                      
                      if ESP.ShowDistance then
                          local distance = math.floor((camera.CFrame.Position - rootPart.Position).Magnitude)
                          local distanceText = "[ " .. tostring(distance) .. "m ]"
                          
                          if text ~= "" then
                              local padding = math.floor((#text - #distanceText) / 2)
                              if padding > 0 then
                                  distanceText = string.rep(" ", padding) .. distanceText
                              end
                              text = text .. "\n" .. distanceText
                          else
                              text = distanceText
                          end
                      end
                      
                      if text ~= "" then
                          lines.itemText.Text = text
                          lines.itemText.Visible = true
                          lines.itemText.Color = ESP.ShowEquippedItem and ESP.EquippedItemColor or ESP.DistanceColor
                      else
                          lines.itemText.Visible = false
                      end
                  else
                      lines.itemText.Visible = false
                  end

                  -- Skeleton ESP
                  if ESP.ShowSkeleton then
                      UpdateSkeleton(plr.Character, true)
                  else
                      for _, line in pairs({
                          "skeletonHead", "skeletonSpineUpper", "skeletonSpineLower",
                          "skeletonLeftShoulder", "skeletonLeftUpperArm", "skeletonLeftLowerArm",
                          "skeletonRightShoulder", "skeletonRightUpperArm", "skeletonRightLowerArm",
                          "skeletonLeftHip", "skeletonLeftUpperLeg", "skeletonLeftLowerLeg",
                          "skeletonRightHip", "skeletonRightUpperLeg", "skeletonRightLowerLeg"
                      }) do
                          if lines[line] then
                              lines[line].Visible = false
                          end
                      end
                  end

              else
                  for _, drawing in pairs(lines) do
                      drawing.Visible = false
                  end
              end
          else
              for _, drawing in pairs(lines) do
                  drawing.Visible = false
              end
          end

          if not players:FindFirstChild(plr.Name) then
              connection:Disconnect()
              for _, drawing in pairs(lines) do
                  drawing:Remove()
              end
          end
      end)
  end

  coroutine.wrap(UpdateESP)()
end

-- Initialize ESP for existing players
for _, v in pairs(players:GetChildren()) do
  CreateESP(v)
end

-- Initialize ESP for new players
players.PlayerAdded:Connect(CreateESP)

return ESP
