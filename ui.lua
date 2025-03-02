return function(Library, ESP)
   if ESP then
       if not ESP.Toggle then
           ESP.Toggle = function(self, state)
               self.Enabled = state
           end
       end
   end

   local Window = Library:New({
       Name = "dracula.lol [private beta]", 
       Accent = Color3.fromRGB(255, 255, 255),
       TextXAlignment = Enum.TextXAlignment.Center
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
   local PlayerESP = Visuals:Section({Name = "player esp", Side = "Left"})
   local LocalCharacter = Visuals:Section({Name = "local character", Side = "Right"})
   local World = Visuals:Section({Name = "world", Side = "Left"})
   local Other = Visuals:Section({Name = "other", Side = "Left"})

   -- Player ESP Section
   PlayerESP:Toggle({
       Name = "enabled",
       Default = false,
       Pointer = "ESP_Enabled",
       callback = function(state)
           if ESP then
               ESP:Toggle(state)
           end
       end
   })

   PlayerESP:Toggle({
       Name = "self",
       Default = false,
       Pointer = "ESP_Self",
       callback = function(state)
           if ESP then
               ESP.TeamMates = state
           end
       end
   })

   PlayerESP:Slider({
       Name = "max distance",
       Minimum = 100,
       Maximum = 2000,
       Default = 1000,
       Suffix = "m",
       Pointer = "ESP_MaxDistance"
   })

   PlayerESP:Dropdown({
       Name = "distance mode",
       Options = {"Dynamic", "Static"},
       Default = "Dynamic",
       Pointer = "ESP_DistanceMode"
   })

   PlayerESP:Slider({
       Name = "outline transparency",
       Minimum = 0,
       Maximum = 1,
       Default = 1,
       Decimals = 0.1,
       Pointer = "ESP_OutlineTransparency"
   })

   PlayerESP:Dropdown({
       Name = "text font",
       Options = {"UI", "System", "Plex", "Monospace"},
       Default = "UI",
       Pointer = "ESP_TextFont"
   })

   PlayerESP:Slider({
       Name = "text size",
       Minimum = 8,
       Maximum = 24,
       Default = 14,
       Pointer = "ESP_TextSize"
   })

   PlayerESP:Label({Name = "esp features"})

   -- ESP Features with working functionality
   PlayerESP:Toggle({Name = "names", Default = false, Pointer = "ESP_Names", callback = function(state) if ESP then ESP.Names = state end end})
   :Colorpicker({Info = "Names Color", Default = Color3.fromRGB(255, 255, 255), callback = function(color) if ESP then ESP.Color = color end end})

   PlayerESP:Toggle({Name = "box", Default = false, Pointer = "ESP_Boxes", callback = function(state) if ESP then ESP.Boxes = state end end})
   :Colorpicker({Info = "Box Color", Default = Color3.fromRGB(255, 255, 255), callback = function(color) if ESP then ESP.Color = color end end})

   PlayerESP:Toggle({Name = "health bar", Default = false, Pointer = "ESP_HealthBar", callback = function(state) if ESP then ESP.HealthBars = state end end})
   :Colorpicker({Info = "Health Bar Color", Default = Color3.fromRGB(0, 255, 0)})

   PlayerESP:Toggle({Name = "armor bar", Default = false, Pointer = "ESP_ArmorBar"})
   :Colorpicker({Info = "Armor Bar Color", Default = Color3.fromRGB(0, 255, 255)})

   PlayerESP:Toggle({Name = "distance", Default = false, Pointer = "ESP_Distance"})
   :Colorpicker({Info = "Distance Color", Default = Color3.fromRGB(255, 255, 255)})

   PlayerESP:Toggle({Name = "weapon", Default = false, Pointer = "ESP_Weapon"})
   :Colorpicker({Info = "Weapon Color", Default = Color3.fromRGB(255, 255, 255)})

   PlayerESP:Toggle({Name = "flags", Default = false, Pointer = "ESP_Flags"})
   :Colorpicker({Info = "Flags Color", Default = Color3.fromRGB(255, 255, 255)})

   PlayerESP:Toggle({Name = "skeleton", Default = false, Pointer = "ESP_Skeleton"})
   :Colorpicker({Info = "Skeleton Color", Default = Color3.fromRGB(255, 255, 255)})

   PlayerESP:Toggle({Name = "bullet tracers", Default = false, Pointer = "ESP_BulletTracers"})
   :Colorpicker({Info = "Tracers Color", Default = Color3.fromRGB(139, 0, 0)})

   PlayerESP:Toggle({Name = "head circle", Default = false, Pointer = "ESP_HeadCircle"})
   :Colorpicker({Info = "Head Circle Color", Default = Color3.fromRGB(255, 255, 255)})

   PlayerESP:Slider({
       Name = "tracer duration",
       Minimum = 0.1,
       Maximum = 5,
       Default = 1.5,
       Decimals = 0.1,
       Suffix = "s",
       Pointer = "ESP_TracerDuration"
   })

   -- Local Character Section
   LocalCharacter:Toggle({Name = "show arms in first person", Default = false, Pointer = "Local_ShowArms"})
   :Colorpicker({Info = "Arms Color", Default = Color3.fromRGB(255, 255, 255)})

   LocalCharacter:Toggle({Name = "character highlight", Default = false, Pointer = "Local_CharHighlight"})
   :Colorpicker({Info = "Highlight Color", Default = Color3.fromRGB(255, 255, 255)})

   LocalCharacter:Toggle({Name = "character material", Default = false, Pointer = "Local_CharMaterial"})
   :Colorpicker({Info = "Material Color", Default = Color3.fromRGB(255, 255, 255)})

   LocalCharacter:Toggle({Name = "custom character", Default = false, Pointer = "Local_CustomChar"})
   :Colorpicker({Info = "Character Color", Default = Color3.fromRGB(255, 255, 255)})

   LocalCharacter:Toggle({Name = "material tools", Default = false, Pointer = "Local_MaterialTools"})
   :Colorpicker({Info = "Tools Color", Default = Color3.fromRGB(255, 255, 255)})

   LocalCharacter:Toggle({Name = "particle aura", Default = false, Pointer = "Local_ParticleAura"})
   :Colorpicker({Info = "Aura Color", Default = Color3.fromRGB(255, 255, 255)})

   -- World Section
   World:Dropdown({Name = "lighting mode", Options = {"Default", "Future", "Compatibility", "Technology"}, Default = "Default", Pointer = "World_LightingMode"})
   World:Slider({Name = "brightness", Minimum = 0, Maximum = 100, Default = 50, Decimals = 1, Pointer = "World_Brightness"})
   World:Slider({Name = "saturation", Minimum = 0, Maximum = 100, Default = 50, Decimals = 1, Pointer = "World_Saturation"})
   World:Slider({Name = "contrast", Minimum = 0, Maximum = 100, Default = 50, Decimals = 1, Pointer = "World_Contrast"})

   -- Other Section
   Other:Toggle({Name = "hide player nametags", Default = false, Pointer = "Other_HideNametags"})

   -- // Settings Section
   local Settings_Main = Settings:Section({Name = "Main", Side = "Left"})
   Settings_Main:ConfigBox({})
   Settings_Main:ButtonHolder({Buttons = {{"Load", function() end}, {"Save", function() end}}})
   Settings_Main:Label({Name = "Unloading will fully unload\neverything, so save your\nconfig before unloading.", Middle = true})
   Settings_Main:Button({Name = "Unload", Callback = function() Window:Unload() end})

   -- // Initialisation
   Window:Initialize()
end
