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
    local ESPSection = Visuals:Section({Name = "ESP", Side = "Left"})
    ESPSection:Toggle({Name = "Enabled", Default = ESP.Settings.Enabled, Pointer = "Enabled"})
    ESPSection:Toggle({Name = "Team Check", Default = ESP.Settings.TeamCheck, Pointer = "TeamCheck"})
    ESPSection:Toggle({Name = "Show Names", Default = ESP.Settings.ShowNames, Pointer = "ShowNames"})
    ESPSection:Toggle({Name = "Show Boxes", Default = ESP.Settings.ShowBoxes, Pointer = "ShowBoxes"})
    ESPSection:Toggle({Name = "Show Health Bars", Default = ESP.Settings.ShowHealthBars, Pointer = "ShowHealthBars"})
    ESPSection:Toggle({Name = "Show Equipped Item", Default = ESP.Settings.ShowEquippedItem, Pointer = "ShowEquippedItem"})
    ESPSection:Toggle({Name = "Show Skeleton", Default = ESP.Settings.ShowSkeleton, Pointer = "ShowSkeleton"})
    ESPSection:Toggle({Name = "Show Head Dot", Default = ESP.Settings.ShowHeadDot, Pointer = "ShowHeadDot"})
    ESPSection:Toggle({Name = "Show Distance", Default = ESP.Settings.ShowDistance, Pointer = "ShowDistance"})
    ESPSection:Slider({Name = "Max Distance", Minimum = 100, Maximum = 2000, Default = ESP.Settings.Distance, Decimals = 0, Pointer = "Distance"})
    ESPSection:Colorpicker({Name = "Box Color", Info = "ESP Box Color", Default = ESP.Settings.BoxColor, Pointer = "BoxColor"})
    ESPSection:Colorpicker({Name = "Name Color", Info = "ESP  Pointer = "BoxColor"})
    ESPSection:Colorpicker({Name = "Name Color", Info = "ESP Name Color", Default = ESP.Settings.NameColor, Pointer = "NameColor"})
    ESPSection:Colorpicker({Name = "Health Bar Color", Info = "ESP Health Bar Color", Default = Color3.fromRGB(0, 255, 0), Pointer = "HealthBarColor"})

    -- // Other Visuals Section
    local OtherVisualsSection = Visuals:Section({Name = "Other Visuals", Side = "Right"})
    OtherVisualsSection:Toggle({Name = "Third Person", Default = ESP.Settings.ThirdPerson, Pointer = "ThirdPerson"})
    OtherVisualsSection:Slider({Name = "Camera FOV", Minimum = 30, Maximum = 120, Default = ESP.Settings.CameraFOV, Decimals = 0, Pointer = "CameraFOV"})
    OtherVisualsSection:Slider({Name = "Camera Amount", Minimum = 0, Maximum = 100, Default = ESP.Settings.CameraAmount, Decimals = 0, Pointer = "CameraAmount"})
    OtherVisualsSection:Toggle({Name = "Custom Fog", Default = ESP.Settings.CustomFog, Pointer = "CustomFog"})
    OtherVisualsSection:Slider({Name = "Fog Distance", Minimum = 0, Maximum = 1000, Default = ESP.Settings.FogDistance, Decimals = 0, Pointer = "FogDistance"})
    OtherVisualsSection:Toggle({Name = "Custom Brightness", Default = ESP.Settings.CustomBrightness, Pointer = "CustomBrightness"})
    OtherVisualsSection:Slider({Name = "Brightness Strength", Minimum = 0, Maximum = 100, Default = ESP.Settings.BrightnessStrength, Decimals = 0, Pointer = "BrightnessStrength"})

    -- // Movement Section
    local MovementSection = Main:Section({Name = "Movement", Side = "Left"})
    MovementSection:Toggle({Name = "Speed Enabled", Default = ESP.Settings.SpeedEnabled, Pointer = "SpeedEnabled"})
    MovementSection:Slider({Name = "Speed Amount", Minimum = 0, Maximum = 100, Default = ESP.Settings.SpeedAmount, Decimals = 0, Pointer = "SpeedAmount"})
    MovementSection:Toggle({Name = "Flight Enabled", Default = ESP.Settings.FlightEnabled, Pointer = "FlightEnabled"})
    MovementSection:Slider({Name = "Flight Amount", Minimum = 0, Maximum = 100, Default = ESP.Settings.FlightAmount, Decimals = 0, Pointer = "FlightAmount"})

    -- // Settings Section
    local SettingsSection = Settings:Section({Name = "Settings", Side = "Left"})
    SettingsSection:Toggle({Name = "Stream Proof", Default = ESP.Settings.StreamProof, Pointer = "StreamProof"})

    -- Function to save config
    local function SaveConfig()
        local config = {}
        for setting, value in pairs(ESP.Settings) do
            config[setting] = value
        end
        writefile("ESP_Config.json", game:GetService("HttpService"):JSONEncode(config))
    end

    -- Function to load config
    local function LoadConfig()
        if isfile("ESP_Config.json") then
            local config = game:GetService("HttpService"):JSONDecode(readfile("ESP_Config.json"))
            for setting, value in pairs(config) do
                if ESP.Settings[setting] ~= nil then
                    ESP.Settings[setting] = value
                    if Library.pointers[setting] then
                        Library.pointers[setting]:Set(value)
                    end
                end
            end
        end
    end

    SettingsSection:Button({Name = "Save Config", Callback = SaveConfig})
    SettingsSection:Button({Name = "Load Config", Callback = LoadConfig})

    return ESP
end

