-- // Tables
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/lolxd8281989282/bnhsaunh218738h21nijda/refs/heads/main/Library.lua"))() -- Could Also Save It In Your Workspace And Do loadfile("Library.lua")()

-- // Init
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

-- // ESP Section
local ESP = Visuals:Section({Name = "ESP", Side = "Left"})

-- ESP Toggle
ESP:Toggle({Name = "Enabled", Default = false, Pointer = "ESP_Enabled"})

-- ESP Features
ESP:Toggle({Name = "Boxes", Default = false, Pointer = "ESP_Boxes"})
ESP:Toggle({Name = "Names", Default = false, Pointer = "ESP_Names"})
ESP:Toggle({Name = "Tracers", Default = false, Pointer = "ESP_Tracers"})
ESP:Toggle({Name = "Team Check", Default = true, Pointer = "ESP_TeamCheck"})

-- ESP Colors
ESP:Colorpicker({Name = "ESP Color", Info = "ESP Main Color", Default = Color3.fromRGB(255, 255, 255), Pointer = "ESP_Color"})
ESP:Colorpicker({Name = "Team Color", Info = "ESP Team Color", Default = Color3.fromRGB(0, 255, 0), Pointer = "ESP_TeamColor"})
ESP:Colorpicker({Name = "Enemy Color", Info = "ESP Enemy Color", Default = Color3.fromRGB(255, 0, 0), Pointer = "ESP_EnemyColor"})

-- ESP Settings
ESP:Slider({Name = "ESP Distance", Min = 0, Max = 2000, Default = 1000, Decimals = 0, Suffix = " studs", Pointer = "ESP_Distance"})
ESP:Slider({Name = "Text Size", Min = 8, Max = 24, Default = 14, Decimals = 0, Pointer = "ESP_TextSize"})
ESP:Dropdown({Name = "Font", Options = {"UI", "System", "Plex", "Monospace"}, Default = "Plex", Pointer = "ESP_Font"})

-- // Other sections (kept from original example)
local Target_UI = Visuals:Section({Name = "Target UI", Side = "Left"})
local Atmosphere = Visuals:Section({Name = "Atmosphere", Side = "Left"})
local Rain = Visuals:Section({Name = "Rain", Side = "Left"})

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
:Colorpicker({Info = "Chams Color", Default = Color3.fromRGB(139, 0, 0), Pointer = "Tagret_UI_ChamsColor"})
Target_UI:Toggle({Name = "Hit Logs", Default = false, Pointer = "TargetUI_HitLogs"})
Target_UI:Toggle({Name = "Hit Sound", Default = false, Pointer = "TargetUI_HitSound"})

-- Atmosphere Section (New)
Atmosphere:Toggle({Name = "Enabled", Default = false, Pointer = "Atmosphere_Enabled"})
Atmosphere:Toggle({Name = "Ambient", Default = false, Pointer = "Atmosphere_Ambient"})
:Colorpicker({Info = "Ambient Color", Default = Color3.fromRGB(139, 0, 0), Pointer = "Atmosphere_AmbientColor"})
Atmosphere:Toggle({Name = "Time Modifier", Default = false, Pointer = "Atmosphere_TimeModifier"})
Atmosphere:Toggle({Name = "Fog", Default = false, Pointer = "Atmosphere_Fog"})
:Colorpicker({Info = "Fog Color", Default = Color3.fromRGB(139, 0, 0), Pointer = "Atmosphere_FogColor"})
Atmosphere:Toggle({Name = "Brightness", Default = false, Pointer = "Atmosphere_Brightness"})

-- Rain Section (New)
Rain:Toggle({Name = "Enabled", Default = false, Pointer = "Rain_Enabled"})
:Colorpicker({Info = "Rain Color", Default = Color3.fromRGB(255, 255, 255), Pointer = "Rain_RainColor"})

-- // Settings Section (kept from original example)
local Settings_Main = Settings:Section({Name = "Main", Side = "Left"})
Settings_Main:ConfigBox({})
Settings_Main:ButtonHolder({Buttons = {{"Load", function() end}, {"Save", function() end}}})
Settings_Main:Label({Name = "Unloading will fully unload\neverything, so save your\nconfig before unloading.", Middle = true})
Settings_Main:Button({Name = "Unload", Callback = function() Window:Unload() end})

-- // Initialisation
Window:Initialize()

-- // ESP Integration
local ESP = require("esp")

-- Initialize ESP settings based on UI values
ESP.Enabled = Window.pointers.ESP_Enabled.Value
ESP.Boxes = Window.pointers.ESP_Boxes.Value
ESP.Names = Window.pointers.ESP_Names.Value
ESP.Tracers = Window.pointers.ESP_Tracers.Value
ESP.TeamColor = Window.pointers.ESP_TeamCheck.Value
ESP.Color = Window.pointers.ESP_Color.Value
ESP.TeamColor = Window.pointers.ESP_TeamColor.Value
ESP.EnemyColor = Window.pointers.ESP_EnemyColor.Value
ESP.MaxDistance = Window.pointers.ESP_Distance.Value
ESP.TextSize = Window.pointers.ESP_TextSize.Value
ESP.Font = Drawing.Fonts[Window.pointers.ESP_Font.Value]

-- Set up listeners for ESP settings
Window.pointers.ESP_Enabled:OnChanged(function(value)
    ESP.Enabled = value
end)

Window.pointers.ESP_Boxes:OnChanged(function(value)
    ESP.Boxes = value
end)

Window.pointers.ESP_Names:OnChanged(function(value)
    ESP.Names = value
end)

Window.pointers.ESP_Tracers:OnChanged(function(value)
    ESP.Tracers = value
end)

Window.pointers.ESP_TeamCheck:OnChanged(function(value)
    ESP.TeamColor = value
end)

Window.pointers.ESP_Color:OnChanged(function(value)
    ESP.Color = value
end)

Window.pointers.ESP_TeamColor:OnChanged(function(value)
    ESP.TeamColor = value
end)

Window.pointers.ESP_EnemyColor:OnChanged(function(value)
    ESP.EnemyColor = value
end)

Window.pointers.ESP_Distance:OnChanged(function(value)
    ESP.MaxDistance = value
end)

Window.pointers.ESP_TextSize:OnChanged(function(value)
    ESP.TextSize = value
end)

Window.pointers.ESP_Font:OnChanged(function(value)
    ESP.Font = Drawing.Fonts[value]
end)

-- You can add more ESP configuration here based on your UI settings

return Window
