return function(Library, ESP)
   -- Remove assertions since we'll handle ESP differently according to documentation
   local Window = Library:New({Name = "dracula.lol | beta", Accent = Color3.fromRGB(255, 255, 255)})

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

   -- // Target Aim Section
   TargetAim:Toggle({Name = "Enabled", Default = false, Pointer = "TargetEnabled"})
   :Keybind({Default = Enum.KeyCode.E, KeybindName = "Target", Mode = "Toggle", Pointer = "TargetBind"})
   TargetAim:Dropdown({Name = "Method", Options = {"Silent", "Sticky"}, Default = "Silent", Pointer = "TargetMethod"})
   TargetAim:Toggle({Name = "Index (Mouse M1)", Default = false, Pointer = "TargetIndex"})
   TargetAim:Toggle({Name = "Notifications", Default = false, Pointer = "TargetNotifications"})
   TargetAim:Toggle({Name = "Resolver", Default = false, Pointer = "TargetResolver"})
   :Keybind({Default = Enum.KeyCode.T, KeybindName = "Resolver", Mode = "Toggle", Pointer = "ResolverBind"})
   TargetAim:Dropdown({Name = "Target Hit Part:", Options = {"Head", "Neck", "Body", "Right Arm", "Left Arm", "Pelvis", "Right Leg", "Left Leg"}, Default = "Head", Pointer = "TargetAim"})
   TargetAim:Slider({Name = "Size", Minimum = 1, Maximum = 30, Default = 1.5, Decimals = 0.1, Pointer = "TargetJumpOffset"})

   -- // Field of View Section
   FOV:Dropdown({Name = "Mode", Options = {"Static", "Dynamic"}, Default = "Static", Pointer = "FOVMode"})
   FOV:Toggle({Name = "Visible", Default = false, Pointer = "FOVVisible"})
   FOV:Toggle({Name = "Filled", Default = false, Pointer = "FOVFilled"})
   FOV:Colorpicker({Name = "FOV Color", Info = "Field of View Color", Default = Color3.fromRGB(255, 255, 255), Pointer = "FOVColor"})
   FOV:Slider({Name = "Size", Minimum = 1, Maximum = 30, Default = 1.5, Decimals = 0.1, Pointer = "FOVMain_Smoothness"})
   FOV:Slider({Name = "Visibility", Minimum = 1, Maximum = 30, Default = 1.5, Decimals = 0.1, Pointer = "FOVMain_Visibility"})
   FOV:Slider({Name = "Fluctuation", Minimum = 1, Maximum = 30, Default = 1.5, Decimals = 0.1, Pointer = "FOVMain_Fluctuation"})
   FOV:Slider({Name = "Transparency", Minimum = 1, Maximum = 30, Default = 1.5, Decimals = 0.1, Pointer = "FOVMain_Transparency"})
   FOV:Slider({Name = "Rotation", Minimum = 1, Maximum = 30, Default = 1.5, Decimals = 0.1, Pointer = "FOVMain_Rotation"})
   FOV:Toggle({Name = "Auto Select", Default = false, Pointer = "FOVAutoSelect"})

   -- // Prediction Section
   Prediction:Toggle({Name = "Use Prediction", Default = false, Pointer = "PredictionEnabled"})
   Prediction:Toggle({Name = "Ping Based", Default = false, Pointer = "PredictionPingBased"})
   Prediction:Label({Name = "X Axis Prediction"})
   Prediction:Slider({Name = "Value", Minimum = 1, Maximum = 30, Default = 1.5, Decimals = 0.1, Pointer = "PredictionX"})
   Prediction:Label({Name = "Y Axis Prediction"})
   Prediction:Slider({Name = "Value", Minimum = 1, Maximum = 30, Default = 1.5, Decimals = 0.1, Pointer = "PredictionY"})
   Prediction:Toggle({Name = "Strafe", Default = false, Pointer = "PredictionStrafe"})
   Prediction:Toggle({Name = "Destroy Cheaters Bypass", Default = false, Pointer = "PredictionBypass"})
   Prediction:Toggle({Name = "Vehicle Strafe", Default = false, Pointer = "PredictionVehicle"})

   -- // Gun Exploits Section
   GunMods:Toggle({Name = "No Recoil", Default = false, Pointer = "GunNoRecoil"})
   GunMods:Toggle({Name = "Rapid Fire", Default = false, Pointer = "GunRapidFire"})
   GunMods:Slider({Name = "Fire Rate Modification", Minimum = 1, Maximum = 30, Default = 1.5, Decimals = 0.1, Pointer = "GunFireRate"})
   GunMods:Toggle({Name = "Apply To Current Gun", Default = false, Pointer = "GunApplyCurrent"})

   -- // Visuals Section
   local Target_UI = Visuals:Section({Name = "Target UI", Side = "Left"})
   local ESP_Section = Visuals:Section({Name = "ESP", Side = "Right"})
   local Atmosphere = Visuals:Section({Name = "Atmosphere", Side = "Left"})
   local Rain= Visuals:Section({Name = "Rain", Side = "Left"})

   -- Target UI Section
   Target_UI:Toggle({Name = "Enabled", Default = false, Pointer = "TargetUI_Enabled"})
   Target_UI:Slider({Name = "Target UI Offset", Minimum = 1, Maximum = 30, Default = 1.5, Decimals = 0.1, Pointer = "TargetUI_Offset"})

   Target_UI:Label({Name = "Target Visuals", Middle = false})
   Target_UI:Toggle({Name = "Highlight", Default = false, Pointer = "TargetUI_Highlight"})
   :Colorpicker({Info = "Highlight Color", Default = Color3.fromRGB(255, 255, 255), Pointer = "TargetUI_HighlightColor"})
   Target_UI:Slider({Name = "Fill Transparency", Minimum = 1, Maximum = 30, Default = 1.5, Decimals = 0.1, Pointer = "TargetUI_FillTransparency"})

   Target_UI:Label({Name = "Hit Feedback", Middle = false})
   Target_UI:Toggle({Name = "Hit Marker", Default = false, Pointer = "TargetUI_HitMarker"})
   Target_UI:Toggle({Name = "Chams", Default = false, Pointer = "TargetUI_Chams"})
   :Colorpicker({Info = "Chams Color", Default = Color3.fromRGB(139, 0, 0), Pointer = "Target_UI_ChamsColor"})
   Target_UI:Toggle({Name = "Hit Logs", Default = false, Pointer = "TargetUI_HitLogs"})
   Target_UI:Toggle({Name = "Hit Sound", Default = false, Pointer = "TargetUI_HitSound"})

   -- ESP Section with fixed implementation
   ESP_Section:Toggle({
       Name = "Enabled", 
       Default = false, 
       Pointer = "ESP_Enabled", 
       callback = function(state)
           if ESP and type(ESP) == "table" then
               ESP.Enabled = state
           end
       end
   })
   
   ESP_Section:Toggle({
       Name = "Self", 
       Default = false, 
       Pointer = "ESP_Self", 
       callback = function(state)
           if ESP and type(ESP) == "table" then
               ESP.Self = state
           end
       end
   })

   ESP_Section:Slider({
       Name = "Max Distance", 
       Minimum = 100, 
       Maximum = 2000, 
       Default = 1000, 
       Suffix = "m", 
       Pointer = "ESP_MaxDistance", 
       callback = function(value)
           if ESP and type(ESP) == "table" then
               ESP.MaxDistance = value
           end
       end
   })

   ESP_Section:Dropdown({
       Name = "Distance Mode", 
       Options = {"Dynamic", "Static"}, 
       Default = "Dynamic", 
       Pointer = "ESP_DistanceMode",
       callback = function(value)
           if ESP and type(ESP) == "table" then
               ESP.DistanceMode = value
           end
       end
   })

   ESP_Section:Slider({
       Name = "Outline Transparency", 
       Minimum = 0, 
       Maximum = 1, 
       Default = 1, 
       Decimals = 0.1, 
       Pointer = "ESP_OutlineTransparency", 
       callback = function(value)
           if ESP and type(ESP) == "table" then
               ESP.OutlineTransparency = value
           end
       end
   })

   ESP_Section:Dropdown({
       Name = "Text Font", 
       Options = {"UI", "System", "Plex", "Monospace"}, 
       Default = "UI", 
       Pointer = "ESP_TextFont", 
       callback = function(value)
           if ESP and type(ESP) == "table" and Drawing and Drawing.Fonts then
               ESP.TextFont = Drawing.Fonts[value]
           end
       end
   })

   ESP_Section:Slider({
       Name = "Text Size", 
       Minimum = 8, 
       Maximum = 24, 
       Default = 14, 
       Pointer = "ESP_TextSize", 
       callback = function(value)
           if ESP and type(ESP) == "table" then
               ESP.TextSize = value
           end
       end
   })

   ESP_Section:Label({Name = "ESP Features", Middle = false})
   
   -- ESP Features with proper implementation
   local function createESPFeature(name, property, default_color)
       ESP_Section:Toggle({
           Name = name, 
           Default = false, 
           Pointer = "ESP_" .. property, 
           callback = function(state)
               if ESP and type(ESP) == "table" then
                   ESP[property] = state
               end
           end
       })
       :Colorpicker({
           Info = name .. " Color", 
           Default = default_color, 
           Pointer = "ESP_" .. property .. "Color", 
           callback = function(color)
               if ESP and type(ESP) == "table" then
                   ESP[property .. "Color"] = color
               end
           end
       })
   end

   -- Create ESP features with their respective colors
   createESPFeature("Names", "Names", Color3.fromRGB(255, 255, 255))
   createESPFeature("Box", "Boxes", Color3.fromRGB(255, 255, 255))
   createESPFeature("Health Bar", "HealthBar", Color3.fromRGB(0, 255, 0))
   createESPFeature("Armor Bar", "ArmorBar", Color3.fromRGB(0, 255, 255))
   createESPFeature("Distance", "Distance", Color3.fromRGB(255, 255, 255))
   createESPFeature("Weapon", "Weapon", Color3.fromRGB(255, 255, 255))
   createESPFeature("Flags", "Flags", Color3.fromRGB(255, 255, 255))

   -- Bullet Tracers
   ESP_Section:Toggle({
       Name = "Bullet Tracers", 
       Default = false, 
       Pointer = "ESP_BulletTracers", 
       callback = function(state)
           if ESP and type(ESP) == "table" then
               ESP.BulletTracers = state
           end
       end
   })
   :Colorpicker({
       Info = "Bullet Tracers Color", 
       Default = Color3.fromRGB(139, 0, 0), 
       Pointer = "ESP_BulletTracersColor", 
       callback = function(color)
           if ESP and type(ESP) == "table" then
               ESP.BulletTracersColor = color
           end
       end
   })

   ESP_Section:Slider({
       Name = "Duration", 
       Minimum = 0.1, 
       Maximum = 5, 
       Default = 1.5, 
       Decimals = 0.1, 
       Suffix = "s", 
       Pointer = "ESP_TracerDuration", 
       callback = function(value)
           if ESP and type(ESP) == "table" then
               ESP.TracerDuration = value
           end
       end
   })

   -- Atmosphere Section
   Atmosphere:Toggle({Name = "Enabled", Default = false, Pointer = "Atmosphere_Enabled"})
   Atmosphere:Toggle({Name = "Ambient", Default = false, Pointer = "Atmosphere_Ambient"})
   :Colorpicker({Info = "Ambient Color", Default = Color3.fromRGB(139, 0, 0), Pointer = "Atmosphere_AmbientColor"})
   Atmosphere:Toggle({Name = "Time Modifier", Default = false, Pointer = "Atmosphere_TimeModifier"})
   Atmosphere:Toggle({Name = "Fog", Default = false, Pointer = "Atmosphere_Fog"})
   :Colorpicker({Info = "Fog Color", Default = Color3.fromRGB(139, 0, 0), Pointer = "Atmosphere_FogColor"})
   Atmosphere:Toggle({Name = "Brightness", Default = false, Pointer = "Atmosphere_Brightness"})

   -- Rain Section
   Rain:Toggle({Name = "Enabled", Default = false, Pointer = "Rain_Enabled"})
   :Colorpicker({Info = "Rain Color", Default = Color3.fromRGB(255, 255, 255), Pointer = "Rain_RainColor"})

   -- // Settings Section
   local Settings_Main = Settings:Section({Name = "Main", Side = "Left"})
   Settings_Main:ConfigBox({})
   Settings_Main:ButtonHolder({Buttons = {{"Load", function() end}, {"Save", function() end}}})
   Settings_Main:Label({Name = "Unloading will fully unload\neverything, so save your\nconfig before unloading.", Middle = true})
   Settings_Main:Button({Name = "Unload", Callback = function() Window:Unload() end})

   -- // Initialisation
   Window:Initialize()
end
