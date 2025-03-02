return function(Library, ESP)
   -- First, ensure ESP has the proper Toggle function
   if ESP then
       -- Only create Toggle function if it doesn't exist
       if not ESP.Toggle then
           ESP.Toggle = function(self, state)
               self.Enabled = state
           end
       end
   end

   -- Remove assertions since we'll handle ESP differently according to documentation
   local Window = Library:New({
       Name = "dracula.lol [private beta]", 
       Accent = Color3.fromRGB(255, 255, 255),
       TextXAlignment = Enum.TextXAlignment.Center  -- Center the title text
   })

   -- // Pages
   local Main = Window:Page({Name = "aim-assist"})
   local Visuals = Window:Page({Name = "visuals"})
   local Players = Window:Page({Name = "players-list"})
   local Settings = Window:Page({Name = "settings"})

   -- // Sections for aim-assist
   local General = Main:Section({Name = "general", Side = "Left"})
   local HVH = Main:Section({Name = "hvh", Side = "Right"})
   local Visualization = Main:Section({Name = "visualization", Side = "Left"})

   -- // General Section
   General:Toggle({Name = "ragebot", Default = false, Pointer = "General_Ragebot"})
   General:Toggle({Name = "auto fire", Default = false, Pointer = "General_AutoFire"})
   General:Toggle({Name = "defensive", Default = false, Pointer = "General_Defensive"})
   General:Toggle({Name = "auto equip", Default = false, Pointer = "General_AutoEquip"})
   General:Dropdown({Name = "target hitbox", Options = {"head", "torso", "random"}, Default = "head", Pointer = "Target_Hitbox"})
   General:Dropdown({Name = "prediction", Options = {"auto", "manual"}, Default = "auto", Pointer = "Prediction_Mode"})
   General:Dropdown({Name = "shot delay", Options = {"none", "custom"}, Default = "none", Pointer = "Shot_Delay"})
   General:Slider({Name = "field of view", Minimum = 0, Maximum = 100, Default = 100, Suffix = "", Pointer = "FOV_Value"})
   General:Slider({Name = "fire cooldown", Minimum = 0, Maximum = 1000, Default = 5, Suffix = "ms", Pointer = "Fire_Cooldown"})
   General:Toggle({Name = "target selection", Default = false, Pointer = "Target_Selection"})

   -- // HVH Section
   HVH:Toggle({Name = "velocity desync", Default = false, Pointer = "HVH_VelocityDesync"})
   HVH:Toggle({Name = "auto lockout", Default = false, Pointer = "HVH_AutoLockout"})
   HVH:Toggle({Name = "follow target", Default = false, Pointer = "HVH_FollowTarget"})
   HVH:Toggle({Name = "auto stomp", Default = false, Pointer = "HVH_AutoStomp"})
   HVH:Toggle({Name = "auto ammo", Default = false, Pointer = "HVH_AutoAmmo"})
   HVH:Toggle({Name = "auto armor", Default = false, Pointer = "HVH_AutoArmor"})
   HVH:Toggle({Name = "anti stomp", Default = false, Pointer = "HVH_AntiStomp"})
   HVH:Toggle({Name = "void hide", Default = false, Pointer = "HVH_VoidHide"})

   -- // Visualization Section
   Visualization:Toggle({Name = "3d target circle", Default = false, Pointer = "Vis_3DTargetCircle"})
   Visualization:Toggle({Name = "view target", Default = false, Pointer = "Vis_ViewTarget"})
   Visualization:Toggle({Name = "face target", Default = false, Pointer = "Vis_FaceTarget"})

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

   -- ESP Section with simplified toggle
   ESP_Section:Toggle({
       Name = "Enabled", 
       Default = false, 
       Pointer = "ESP_Enabled", 
       callback = function(state)
           if ESP and type(ESP.Toggle) == "function" then
               ESP:Toggle(state)
           end
       end
   })

   -- Rest of ESP settings
   ESP_Section:Toggle({
       Name = "Self", 
       Default = false, 
       Pointer = "ESP_Self", 
       callback = function(state)
           if ESP and type(ESP) == "table" then
               ESP.SelfESP = state
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
               if ESP and type(ESP.ToggleFeature) == "function" then
                   ESP:ToggleFeature(property, state)
               end
           end
       })
       :Colorpicker({
           Info = name .. " Color", 
           Default = default_color, 
           Pointer = "ESP_" .. property .. "Color", 
           callback = function(color)
               if ESP and type(ESP.UpdateColor) == "function" then
                   ESP:UpdateColor(property, color)
               end
           end
       })
   end

   -- Create ESP features with their respective colors
   createESPFeature("Names", "Names", Color3.fromRGB(255, 255, 255))
   createESPFeature("Box", "Boxes", Color3.fromRGB(255, 255, 255))
   createESPFeature("Health Bar", "HealthBars", Color3.fromRGB(0, 255, 0))
   createESPFeature("Armor Bar", "ArmorBar", Color3.fromRGB(0, 255, 255))
   createESPFeature("Distance", "Distance", Color3.fromRGB(255, 255, 255))
   createESPFeature("Weapon", "Weapon", Color3.fromRGB(255, 255, 255))
   createESPFeature("Flags", "Flags", Color3.fromRGB(255, 255, 255))
   createESPFeature("Skeleton", "Bone", Color3.fromRGB(255, 255, 255))
   createESPFeature("Bullet Tracers", "BulletTracers", Color3.fromRGB(139, 0, 0))
   createESPFeature("Head Circle", "HeadCircle", Color3.fromRGB(255, 255, 255))

   ESP_Section:Slider({
       Name = "Tracer Duration", 
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
