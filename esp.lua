local ESP = {
   Enabled = false,
   TeamCheck = false,
   Outline = false,
   SelfESP = false,
   ShowNames = false,
   ShowBoxes = false,
   ShowHealthBars = false,
   ShowArmorBar = false,
   ShowHeadDot = false,
   ShowDistance = false,
   ShowWeapon = false,
   ShowFlags = false,
   ShowBone = false,
   BulletTracers = false,
   BoxColor = Color3.fromRGB(255, 255, 255),
   NameColor = Color3.fromRGB(255, 255, 255),
   HealthBarColor = Color3.fromRGB(0, 255, 0),
   ArmorBarColor = Color3.fromRGB(0, 150, 255),
   HeadDotColor = Color3.fromRGB(255, 255, 255),
   DistanceColor = Color3.fromRGB(255, 255, 255),
   WeaponColor = Color3.fromRGB(255, 255, 255),
   FlagsColor = Color3.fromRGB(255, 255, 255),
   BoneColor = Color3.fromRGB(255, 255, 255),
   BulletTracersColor = Color3.fromRGB(139, 0, 0),
   BoxThickness = 1,
   TextSize = 14,
   TextFont = Drawing.Fonts.UI,
   MaxDistance = 1000,
   OutlineThickness = 3,
   TracerDuration = 1.5,
   Objects = {},
   Connections = {}
}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local CurrentCamera = Workspace.CurrentCamera

-- Helper Functions
local function CreateDrawing(type, properties)
   local drawing = Drawing.new(type)
   for property, value in pairs(properties) do
       drawing[property] = value
   end
   return drawing
end

local function IsOnScreen(position)
   local _, onScreen = CurrentCamera:WorldToViewportPoint(position)
   return onScreen
end

local function GetDistanceFromCamera(position)
   return (CurrentCamera.CFrame.Position - position).Magnitude
end

local function IsTeamMate(player)
   if not ESP.TeamCheck then return false end
   return player.Team == LocalPlayer.Team
end

local function GetEquippedWeapon(character)
   for _, child in pairs(character:GetChildren()) do
       if child:IsA("Tool") then
           return child.Name
       end
   end
   return "None"
end

local function GetPlayerFlags(player, character)
   local flags = {}
   local humanoid = character:FindFirstChildOfClass("Humanoid")
   
   if humanoid then
       if humanoid.Jump then
           table.insert(flags, "Jumping")
       end
       if humanoid.Sit then
           table.insert(flags, "Sitting")
       end
   end
   
   return flags
end

-- ESP Object
local ESPObject = {}
ESPObject.__index = ESPObject

function ESPObject.new(player)
   local self = setmetatable({}, ESPObject)
   self.Player = player
   self.Character = player.Character or player.CharacterAdded:Wait()
   self.Drawings = {
       Box = CreateDrawing("Square", {Thickness = ESP.BoxThickness, Filled = false, Transparency = 1, Color = ESP.BoxColor, Visible = false}),
       BoxOutline = CreateDrawing("Square", {Thickness = ESP.OutlineThickness, Filled = false, Transparency = 1, Color = Color3.new(0, 0, 0), Visible = false}),
       Name = CreateDrawing("Text", {Text = player.Name, Size = ESP.TextSize, Font = ESP.TextFont, Center = true, Outline = true, Color = ESP.NameColor, Visible = false}),
       HealthBar = CreateDrawing("Line", {Thickness = 2, Color = ESP.HealthBarColor, Visible = false}),
       HealthBarOutline = CreateDrawing("Line", {Thickness = 4, Color = Color3.new(0, 0, 0), Visible = false}),
       ArmorBar = CreateDrawing("Line", {Thickness = 2, Color = ESP.ArmorBarColor, Visible = false}),
       ArmorBarOutline = CreateDrawing("Line", {Thickness = 4, Color = Color3.new(0, 0, 0), Visible = false}),
       HeadDot = CreateDrawing("Circle", {Radius = 3, Filled = true, Color = ESP.HeadDotColor, Visible = false}),
       HeadDotOutline = CreateDrawing("Circle", {Radius = 4, Filled = false, Thickness = 1, Color = Color3.new(0, 0, 0), Visible = false}),
       Distance = CreateDrawing("Text", {Size = ESP.TextSize, Font = ESP.TextFont, Center = true, Outline = true, Color = ESP.DistanceColor, Visible = false}),
       Weapon = CreateDrawing("Text", {Size = ESP.TextSize, Font = ESP.TextFont, Center = true, Outline = true, Color = ESP.WeaponColor, Visible = false}),
       Flags = CreateDrawing("Text", {Size = ESP.TextSize, Font = ESP.TextFont, Center = true, Outline = true, Color = ESP.FlagsColor, Visible = false}),
       Bone = CreateDrawing("Line", {Thickness = 1, Color = ESP.BoneColor, Visible = false}),
       BoneOutline = CreateDrawing("Line", {Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false})
   }
   
   self.Connections = {}
   
   -- Connect to CharacterAdded event
   table.insert(self.Connections, player.CharacterAdded:Connect(function(char)
       self.Character = char
   end))
   
   return self
end

function ESPObject:Update()
   if not self.Player or not self.Player.Parent then
       self:Remove()
       return false
   end

   local character = self.Character
   if not character or not ESP.Enabled then
       self:Hide()
       return true
   end

   -- Check if it's the local player and SelfESP is disabled
   if self.Player == LocalPlayer and not ESP.SelfESP then
       self:Hide()
       return true
   end
   
   -- Check team
   if IsTeamMate(self.Player) and ESP.TeamCheck then
       self:Hide()
       return true
   end

   local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
   local humanoid = character:FindFirstChildOfClass("Humanoid")
   if not humanoidRootPart or not humanoid then
       self:Hide()
       return true
   end

   -- Check if player is alive
   if humanoid.Health <= 0 then
       self:Hide()
       return true
   end

   local position, onScreen = CurrentCamera:WorldToViewportPoint(humanoidRootPart.Position)
   if not onScreen or GetDistanceFromCamera(humanoidRootPart.Position) > ESP.MaxDistance then
       self:Hide()
       return true
   end

   local size = (CurrentCamera:WorldToViewportPoint(humanoidRootPart.Position - Vector3.new(0, 3, 0)).Y - CurrentCamera:WorldToViewportPoint(humanoidRootPart.Position + Vector3.new(0, 2.6, 0)).Y) / 2

   -- Update Box
   if ESP.ShowBoxes then
       self.Drawings.Box.Size = Vector2.new(size * 1.5, size * 1.8)
       self.Drawings.Box.Position = Vector2.new(position.X - size * 1.5 / 2, position.Y - size * 1.8 / 2)
       self.Drawings.Box.Color = ESP.BoxColor
       self.Drawings.Box.Visible = true
       
       if ESP.Outline then
           self.Drawings.BoxOutline.Size = self.Drawings.Box.Size
           self.Drawings.BoxOutline.Position = self.Drawings.Box.Position
           self.Drawings.BoxOutline.Visible = true
       else
           self.Drawings.BoxOutline.Visible = false
       end
   else
       self.Drawings.Box.Visible = false
       self.Drawings.BoxOutline.Visible = false
   end

   -- Update Name
   if ESP.ShowNames then
       self.Drawings.Name.Position = Vector2.new(position.X, position.Y - size * 1.8 / 2 - 15)
       self.Drawings.Name.Color = ESP.NameColor
       self.Drawings.Name.Visible = true
   else
       self.Drawings.Name.Visible = false
   end

   -- Update Health Bar
   if ESP.ShowHealthBars and humanoid then
       local health = humanoid.Health / humanoid.MaxHealth
       self.Drawings.HealthBarOutline.From = Vector2.new(position.X - size * 1.5 / 2 - 5, position.Y + size * 1.8 / 2)
       self.Drawings.HealthBarOutline.To = Vector2.new(position.X - size * 1.5 / 2 - 5, position.Y - size * 1.8 / 2)
       self.Drawings.HealthBarOutline.Visible = true
       
       self.Drawings.HealthBar.From = Vector2.new(position.X - size * 1.5 / 2 - 5, position.Y + size * 1.8 / 2)
       self.Drawings.HealthBar.To = Vector2.new(position.X - size * 1.5 / 2 - 5, position.Y + size * 1.8 / 2 - (size * 1.8 * health))
       self.Drawings.HealthBar.Color = ESP.HealthBarColor
       self.Drawings.HealthBar.Visible = true
   else
       self.Drawings.HealthBar.Visible = false
       self.Drawings.HealthBarOutline.Visible = false
   end

   -- Update Armor Bar
   if ESP.ShowArmorBar then
       local armor = humanoid:GetAttribute("Armor") or 0
       local maxArmor = humanoid:GetAttribute("MaxArmor") or 100
       local armorPercentage = armor / maxArmor
       
       self.Drawings.ArmorBarOutline.From = Vector2.new(position.X + size * 1.5 / 2 + 5, position.Y + size * 1.8 / 2)
       self.Drawings.ArmorBarOutline.To = Vector2.new(position.X + size * 1.5 / 2 + 5, position.Y - size * 1.8 / 2)
       self.Drawings.ArmorBarOutline.Visible = true
       
       self.Drawings.ArmorBar.From = Vector2.new(position.X + size * 1.5 / 2 + 5, position.Y + size * 1.8 / 2)
       self.Drawings.ArmorBar.To = Vector2.new(position.X + size * 1.5 / 2 + 5, position.Y + size * 1.8 / 2 - (size * 1.8 * armorPercentage))
       self.Drawings.ArmorBar.Color = ESP.ArmorBarColor
       self.Drawings.ArmorBar.Visible = true
   else
       self.Drawings.ArmorBar.Visible = false
       self.Drawings.ArmorBarOutline.Visible = false
   end

   -- Update Head Dot
   if ESP.ShowHeadDot then
       local head = character:FindFirstChild("Head")
       if head then
           local headPosition = CurrentCamera:WorldToViewportPoint(head.Position)
           self.Drawings.HeadDot.Position = Vector2.new(headPosition.X, headPosition.Y)
           self.Drawings.HeadDot.Color = ESP.HeadDotColor
           self.Drawings.HeadDot.Visible = true
           
           if ESP.Outline then
               self.Drawings.HeadDotOutline.Position = self.Drawings.HeadDot.Position
               self.Drawings.HeadDotOutline.Visible = true
           else
               self.Drawings.HeadDotOutline.Visible = false
           end
       else
           self.Drawings.HeadDot.Visible = false
           self.Drawings.HeadDotOutline.Visible = false
       end
   else
       self.Drawings.HeadDot.Visible = false
       self.Drawings.HeadDotOutline.Visible = false
   end

   -- Update Distance
   if ESP.ShowDistance then
       local distance = math.floor(GetDistanceFromCamera(humanoidRootPart.Position))
       self.Drawings.Distance.Text = tostring(distance) .. "m"
       self.Drawings.Distance.Position = Vector2.new(position.X, position.Y + size * 1.8 / 2 + 5)
       self.Drawings.Distance.Color = ESP.DistanceColor
       self.Drawings.Distance.Visible = true
   else
       self.Drawings.Distance.Visible = false
   end

   -- Update Weapon
   if ESP.ShowWeapon then
       local weapon = GetEquippedWeapon(character)
       self.Drawings.Weapon.Text = weapon
       self.Drawings.Weapon.Position = Vector2.new(position.X, position.Y + size * 1.8 / 2 + (ESP.ShowDistance and 20 or 5))
       self.Drawings.Weapon.Color = ESP.WeaponColor
       self.Drawings.Weapon.Visible = true
   else
       self.Drawings.Weapon.Visible = false
   end

   -- Update Flags
   if ESP.ShowFlags then
       local flags = GetPlayerFlags(self.Player, character)
       if #flags > 0 then
           self.Drawings.Flags.Text = table.concat(flags, ", ")
           self.Drawings.Flags.Position = Vector2.new(position.X, position.Y + size * 1.8 / 2 + 
               (ESP.ShowDistance and ESP.ShowWeapon and 35 or 
               (ESP.ShowDistance or ESP.ShowWeapon) and 20 or 5))
           self.Drawings.Flags.Color = ESP.FlagsColor
           self.Drawings.Flags.Visible = true
       else
           self.Drawings.Flags.Visible = false
       end
   else
       self.Drawings.Flags.Visible = false
   end

   -- Update Bone ESP
   if ESP.ShowBone then
       local head = character:FindFirstChild("Head")
       if head and humanoidRootPart then
           local headPosition = CurrentCamera:WorldToViewportPoint(head.Position)
           
           if ESP.Outline then
               self.Drawings.BoneOutline.From = Vector2.new(position.X, position.Y)
               self.Drawings.BoneOutline.To = Vector2.new(headPosition.X, headPosition.Y)
               self.Drawings.BoneOutline.Visible = true
           else
               self.Drawings.BoneOutline.Visible = false
           end
           
           self.Drawings.Bone.From = Vector2.new(position.X, position.Y)
           self.Drawings.Bone.To = Vector2.new(headPosition.X, headPosition.Y)
           self.Drawings.Bone.Color = ESP.BoneColor
           self.Drawings.Bone.Visible = true
       else
           self.Drawings.Bone.Visible = false
           self.Drawings.BoneOutline.Visible = false
       end
   else
       self.Drawings.Bone.Visible = false
       self.Drawings.BoneOutline.Visible = false
   end

   return true
end

function ESPObject:Hide()
   for _, drawing in pairs(self.Drawings) do
       drawing.Visible = false
   end
end

function ESPObject:Remove()
   for _, drawing in pairs(self.Drawings) do
       drawing:Remove()
   end
   
   for _, connection in pairs(self.Connections) do
       connection:Disconnect()
   end
   
   ESP.Objects[self.Player] = nil
end

-- Bullet Tracer Implementation
local function CreateBulletTracer(origin, destination, color)
   if not ESP.BulletTracers then return end
   
   local tracer = CreateDrawing("Line", {
       Thickness = 2,
       Color = color or ESP.BulletTracersColor,
       Transparency = 1,
       Visible = true,
       From = CurrentCamera:WorldToViewportPoint(origin),
       To = CurrentCamera:WorldToViewportPoint(destination)
   })
   
   local tracerOutline = CreateDrawing("Line", {
       Thickness = 4,
       Color = Color3.new(0, 0, 0),
       Transparency = 1,
       Visible = ESP.Outline,
       From = CurrentCamera:WorldToViewportPoint(origin),
       To = CurrentCamera:WorldToViewportPoint(destination)
   })
   
   -- Remove tracer after duration
   task.delay(ESP.TracerDuration, function()
       tracer:Remove()
       tracerOutline:Remove()
   end)
end

-- Main ESP Functions
function ESP:Init()
   -- Clear any existing connections
   for _, connection in pairs(self.Connections) do
       connection:Disconnect()
   end
   self.Connections = {}
   
   -- Initialize ESP for existing players
   for _, player in pairs(Players:GetPlayers()) do
       if player ~= LocalPlayer or self.SelfESP then
           self.Objects[player] = ESPObject.new(player)
       end
   end
   
   -- Connect to PlayerAdded event
   table.insert(self.Connections, Players.PlayerAdded:Connect(function(player)
       if player ~= LocalPlayer or self.SelfESP then
           self.Objects[player] = ESPObject.new(player)
       end
   end))
   
   -- Connect to PlayerRemoving event
   table.insert(self.Connections, Players.PlayerRemoving:Connect(function(player)
       if self.Objects[player] then
           self.Objects[player]:Remove()
       end
   end))
   
   -- Connect to RenderStepped event
   table.insert(self.Connections, RunService.RenderStepped:Connect(function()
       self:Update()
   end))
   
   -- Connect to bullet fired events (if available)
   local function hookBulletFired()
       if game.ReplicatedStorage:FindFirstChild("Remotes") then
           local bulletEvent = game.ReplicatedStorage.Remotes:FindFirstChild("BulletFired") or 
                              game.ReplicatedStorage.Remotes:FindFirstChild("CreateBullet") or
                              game.ReplicatedStorage.Remotes:FindFirstChild("ShootBullet")
           
           if bulletEvent and bulletEvent:IsA("RemoteEvent") then
               local oldNamecall
               oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                   local args = {...}
                   local method = getnamecallmethod()
                   
                   if method == "FireServer" and self == bulletEvent and ESP.BulletTracers then
                       local origin = args[1]
                       local destination = args[2]
                       
                       if typeof(origin) == "Vector3" and typeof(destination) == "Vector3" then
                           CreateBulletTracer(origin, destination)
                       end
                   end
                   
                   return oldNamecall(self, ...)
               end)
           end
       end
   end
   
   pcall(hookBulletFired)
   
   return self
end

function ESP:Toggle(state)
   self.Enabled = state
   
   if not state then
       for _, object in pairs(self.Objects) do
           object:Hide()
       end
   end
end

function ESP:Update()
   for player, object in pairs(self.Objects) do
       if not object:Update() then
           object:Remove()
           self.Objects[player] = nil
       end
   end
end

return ESP
