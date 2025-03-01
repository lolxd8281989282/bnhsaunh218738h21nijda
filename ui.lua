return function(Window, Library, ESP)
   -- // Pages
   local Main = Window:Page({Name = "aim-assist"})
   local Visuals = Window:Page({Name = "visuals"})
   local Players = Window:Page({Name = "players-list"})
   local Settings = Window:Page({Name = "settings"})

   -- // Sections
   local TargetAim = Main:Section({Name = "Target Aim", Side = "Left"})
   local FOV = Main:Section({Name = "Field of View", Side = "Right"})
   local Prediction = Main:Section({Name = "Prediction", Side = "Left"})
   local GunMods = Main:Section({Name = "Gun Exploits (Da Hood Only)", Side = "Right"})

   -- // ESP Section
   local ESP_Section = Visuals:Section({Name = "ESP", Side = "Right"})

   -- ESP Settings
   ESP_Section:Toggle({Name = "Enabled", Default = false, Pointer = "ESP_Enabled", callback = function(value)
       ESP.Enabled = value
   end})

   ESP_Section:Toggle({Name = "Self", Default = false, Pointer = "ESP_Self", callback = function(value)
       ESP.SelfESP = value
   end})

   ESP_Section:Slider({Name = "Max Distance", Minimum = 0, Maximum = 2000, Default = 1000, Decimals = 0, Suffix = " studs", Pointer = "ESP_MaxDistance", callback = function(value)
       ESP.MaxDistance = value
   end})

   -- Box Settings
   ESP_Section:Toggle({Name = "Box", Default = false, Pointer = "ESP_Box", callback = function(value)
       ESP.ShowBoxes = value
   end})
   :Colorpicker({Info = "Box Color", Default = Color3.fromRGB(255, 255, 255), Pointer = "ESP_BoxColor", callback = function(value)
       ESP.BoxColor = value
   end})

   -- Name Settings
   ESP_Section:Toggle({Name = "Names", Default = false, Pointer = "ESP_Names", callback = function(value)
       ESP.ShowNames = value
   end})
   :Colorpicker({Info = "Names Color", Default = Color3.fromRGB(255, 255, 255), Pointer = "ESP_NameColor", callback = function(value)
       ESP.NameColor = value
   end})

   -- Other ESP Features
   ESP_Section:Toggle({Name = "Health Bar", Default = false, Pointer = "ESP_HealthBar", callback = function(value)
       ESP.ShowHealthBars = value
   end})
   :Colorpicker({Info = "Health Bar Color", Default = Color3.fromRGB(0, 255, 0), Pointer = "ESP_HealthBarColor", callback = function(value)
       ESP.HealthBarColor = value
   end})

   ESP_Section:Toggle({Name = "Armor Bar", Default = false, Pointer = "ESP_ArmorBar", callback = function(value)
       ESP.ShowArmorBar = value
   end})
   :Colorpicker({Info = "Armor Bar Color", Default = Color3.fromRGB(0, 150, 255), Pointer = "ESP_ArmorBarColor", callback = function(value)
       ESP.ArmorBarColor = value
   end})

   ESP_Section:Toggle({Name = "Head Dot", Default = false, Pointer = "ESP_HeadDot", callback = function(value)
       ESP.ShowHeadDot = value
   end})
   :Colorpicker({Info = "Head Dot Color", Default = Color3.fromRGB(255, 255, 255), Pointer = "ESP_HeadDotColor", callback = function(value)
       ESP.HeadDotColor = value
   end})

   ESP_Section:Toggle({Name = "Bone", Default = false, Pointer = "ESP_Bone", callback = function(value)
       ESP.ShowBone = value
   end})
   :Colorpicker({Info = "Bone Color", Default = Color3.fromRGB(255, 255, 255), Pointer = "ESP_BoneColor", callback = function(value)
       ESP.BoneColor = value
   end})

   ESP_Section:Toggle({Name = "Distance", Default = false, Pointer = "ESP_Distance", callback = function(value)
       ESP.ShowDistance = value
   end})
   :Colorpicker({Info = "Distance Color", Default = Color3.fromRGB(255, 255, 255), Pointer = "ESP_DistanceColor", callback = function(value)
       ESP.DistanceColor = value
   end})

   ESP_Section:Toggle({Name = "Weapon", Default = false, Pointer = "ESP_Weapon", callback = function(value)
       ESP.ShowWeapon = value
   end})
   :Colorpicker({Info = "Weapon Color", Default = Color3.fromRGB(255, 255, 255), Pointer = "ESP_WeaponColor", callback = function(value)
       ESP.WeaponColor = value
   end})

   ESP_Section:Toggle({Name = "Flags", Default = false, Pointer = "ESP_Flags", callback = function(value)
       ESP.ShowFlags = value
   end})
   :Colorpicker({Info = "Flags Color", Default = Color3.fromRGB(255, 255, 255), Pointer = "ESP_FlagsColor", callback = function(value)
       ESP.FlagsColor = value
   end})

   ESP_Section:Toggle({Name = "Bullet Tracers", Default = false, Pointer = "ESP_BulletTracers", callback = function(value)
       ESP.BulletTracers = value
   end})
   :Colorpicker({Info = "Bullet Tracers Color", Default = Color3.fromRGB(139, 0, 0), Pointer = "ESP_BulletTracersColor", callback = function(value)
       ESP.BulletTracersColor = value
   end})

   ESP_Section:Slider({Name = "Duration", Minimum = 0.1, Maximum = 5, Default = 1.5, Decimals = 1, Suffix = "s", Pointer = "ESP_TracerDuration", callback = function(value)
       ESP.TracerDuration = value
   end})

   -- Team Check
   ESP_Section:Toggle({Name = "Team Check", Default = false, Pointer = "ESP_TeamCheck", callback = function(value)
       ESP.TeamCheck = value
   end})

   -- Outline
   ESP_Section:Toggle({Name = "Outline", Default = false, Pointer = "ESP_Outline", callback = function(value)
       ESP.Outline = value
   end})

   -- Update ESP when settings change
   ESP_Section:Button({Name = "Update ESP", Callback = function()
       ESP:Update()
   end})
end
