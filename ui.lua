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
    local ESP = Visuals:Section({Name = "ESP", Side = "Right"})
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
    :Colorpicker({Info = "Chams Color", Default = Color3.fromRGB(139, 0, 0), Pointer = "Tagret_UI_ChamsColor"})
    Target_UI:Toggle({Name = "Hit Logs", Default = false, Pointer = "TargetUI_HitLogs"})
    Target_UI:Toggle({Name = "Hit Sound", Default = false, Pointer = "TargetUI_HitSound"})

    -- ESP Section
    ESP:Toggle({Name = "Enabled", Default = false, Pointer = "ESP_Enabled"})
    ESP:Toggle({Name = "Self", Default = false, Pointer = "ESP_Self"})
    ESP:Slider({Name = "Max Distance", Minimum = 1, Maximum = 30, Default = 1.5, Decimals = 0.1, Pointer = "ESP_MaxDistance"})
    ESP:Dropdown({Name = "Distance Mode", Options = {"Dynamic", "Static"}, Default = "Dynamic", Pointer = "ESP_DistanceMode"})
    ESP:Slider({Name = "Outline Transparency", Minimum = 1, Maximum = 30, Default = 1.5, Decimals = 0.1, Pointer = "ESP_OutlineTransparency"})
    ESP:Dropdown({Name = "Text Font", Options = {"UI", "System", "Plex", "Monospace"}, Default = "UI", Pointer = "ESP_TextFont"})
    ESP:Slider({Name = "Text Size", Minimum = 1, Maximum = 30, Default = 1.5, Decimals = 0.1, Pointer = "ESP_TextSize"})

    ESP:Label({Name = "ESP Features", Middle = false})
    ESP:Toggle({Name = "Names", Default = false, Pointer = "ESP_Names"})
    :Colorpicker({Info = "Names Color", Default = Color3.fromRGB(255, 255, 255), Pointer = "ESP_NameColor"})
    ESP:Toggle({Name = "Box", Default = false, Pointer = "ESP_Box"})
    :Colorpicker({Info = "Box Color", Default = Color3.fromRGB(255, 255, 255), Pointer = "ESP_BoxColor"})
    ESP:Toggle({Name = "Bone", Default = false, Pointer = "ESP_Bone"})
    :Colorpicker({Info = "Bone Color", Default = Color3.fromRGB(255, 255, 255), Pointer = "ESP_BoneColor"})
    ESP:Toggle({Name = "Health Bar", Default = false, Pointer = "ESP_HealthBar"})
    :Colorpicker({Info = "Health Bar Color", Default = Color3.fromRGB(127, 255, 0), Pointer = "ESP_HealthBarColor"})
    ESP:Toggle({Name = "Armor Bar", Default = false, Pointer = "ESP_ArmorBar"})
    :Colorpicker({Info = "Armor Bar Color", Default = Color3.fromRGB(0, 255, 255), Pointer = "ESP_ArmorBarColor"})
    ESP:Toggle({Name = "Distance", Default = false, Pointer = "ESP_Distance"})
    :Colorpicker({Info = "Distance Color", Default = Color3.fromRGB(255, 255, 255), Pointer = "ESP_DistanceColor"})
    ESP:Toggle({Name = "Weapon", Default = false, Pointer = "ESP_Weapon"})
    :Colorpicker({Info = "Weapon Color", Default = Color3.fromRGB(255, 255, 255), Pointer = "ESP_WeaponColor"})
    ESP:Toggle({Name = "Flags", Default = false, Pointer = "ESP_Flags"})
    :Colorpicker({Info = "Flags Color", Default = Color3.fromRGB(255, 255, 255), Pointer = "ESP_FlagsColor"})

    ESP:Toggle({Name = "Bullet Tracers", Default = false, Pointer = "ESP_BulletTracers"})
    :Colorpicker({Info = "Bullet Tracers Color", Default = Color3.fromRGB(139, 0, 0), Pointer = "ESP_BulletTracersColor"})
    ESP:Slider({Name = "Duration", Minimum = 1, Maximum = 30, Default = 1.5, Decimals = 0.1, Pointer = "ESP_TracerDuration"})

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

    -- Initialize ESP with default settings
    if ESP and type(ESP.new) == "function" then
        local esp = ESP.new({
            Enabled = false,
            TeamCheck = false,
            ShowBoxes = false,
            ShowNames = false,
            ShowDistance = false,
            ShowHealthBars = false,
            BoxColor = Color3.fromRGB(255, 255, 255),
            NameColor = Color3.fromRGB(255, 255, 255),
            DistanceColor = Color3.fromRGB(255, 255, 255),
            TextSize = 13,
            Distance = 1000
        })
        
        if esp and type(esp.Initialize) == "function" then
            esp:Initialize()
        end

        -- Connect ESP settings to UI toggles
        local function updateESPFromUI()
            if esp and type(esp.UpdateSettings) == "function" then
                esp:UpdateSettings({
                    Enabled = Library.pointers.ESP_Enabled:Get(),
                    ShowBoxes = Library.pointers.ESP_Box:Get(),
                    BoxColor = Library.pointers.ESP_BoxColor:Get(),
                    ShowNames = Library.pointers.ESP_Names:Get(),
                    ShowHealthBars = Library.pointers.ESP_HealthBar:Get(),
                    ShowDistance = Library.pointers.ESP_Distance:Get(),
                    TextSize = Library.pointers.ESP_TextSize:Get(),
                    Distance = Library.pointers.ESP_MaxDistance:Get()
                })
            end
        end

        -- Connect the update function to UI changes
        for _, pointer in pairs(Library.pointers) do
            if type(pointer) == "table" and type(pointer.Set) == "function" then
                local originalSet = pointer.Set
                pointer.Set = function(self, value)
                    originalSet(self, value)
                    task.spawn(function()
                        updateESPFromUI()
                    end)
                    return value
                end
            end
        end

        -- Initial update of ESP settings
        updateESPFromUI()
    else
        warn("ESP module not loaded correctly")
    end
end
