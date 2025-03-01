return function(Library, ESP)
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

    -- // Target Aim Section
    TargetAim:Toggle({Name = "Enabled", Default = false, Pointer = "TargetEnabled"})
    :Keybind({Default = Enum.KeyCode.E, KeybindName = "Target", Mode = "Toggle", Pointer = "TargetBind"})
    TargetAim:Dropdown({Name = "Method", Options = {"Silent", "Sticky"}, Default = "Silent", Pointer = "TargetMethod"})
    TargetAim:Toggle({Name = "Index (Mouse M1)", Default = false, Pointer = "TargetIndex"})
    TargetAim:Toggle({Name = "Notifications", Default = false, Pointer = "TargetNotifications"})
    TargetAim:Toggle({Name = "Resolver", Default = false, Pointer = "TargetResolver"})
    :Keybind({Default = Enum.KeyCode.T, KeybindName = "Resolver", Mode = "Toggle", Pointer = "ResolverBind"})
    TargetAim:Dropdown({Name = "Target Hit Part:", Options = {"Head", "Neck", "Body", "Right Arm", "Left Arm", "Pelvis", "Right Leg", "Left Leg"}, Default = "Head", Pointer = "TargetAim"})
    TargetAim:Slider({Name = "Size", Min = 1, Max = 30, Default = 1.5, Decimals = 0.1, Pointer = "TargetJumpOffset"})

    -- // Field of View Section
    FOV:Dropdown({Name = "Mode", Options = {"Static", "Dynamic"}, Default = "Static", Pointer = "FOVMode"})
    FOV:Toggle({Name = "Visible", Default = false, Pointer = "FOVVisible"})
    FOV:Toggle({Name = "Filled", Default = false, Pointer = "FOVFilled"})
    FOV:Colorpicker({Name = "FOV Color", Info = "Field of View Color", Default = Color3.fromRGB(255, 255, 255), Pointer = "FOVColor"})
    FOV:Slider({Name = "Size", Min = 1, Max = 30, Default = 1.5, Decimals = 0.1, Pointer = "FOVMain_Smoothness"})
    FOV:Slider({Name = "Visibility", Min = 1, Max = 30, Default = 1.5, Decimals = 0.1, Pointer = "FOVMain_Visibility"})
    FOV:Slider({Name = "Fluctuation", Min = 1, Max = 30, Default = 1.5, Decimals = 0.1, Pointer = "FOVMain_Fluctuation"})
    FOV:Slider({Name = "Transparency", Min = 1, Max = 30, Default = 1.5, Pointer = "FOVMain_Transparency"})
    FOV:Slider({Name = "Rotation", Min = 1, Max = 30, Default = 1.5, Decimals = 0.1, Pointer = "FOVMain_Rotation"})
    FOV:Toggle({Name = "Auto Select", Default = false, Pointer = "FOVAutoSelect"})

    -- // ESP Section
    local ESP_Section = Visuals:Section({Name = "ESP", Side = "Right"})
    ESP_Section:Toggle({Name = "Enabled", Default = false, Pointer = "ESP_Enabled", callback = function(value)
        ESP:Toggle(value)
    end})
    ESP_Section:Toggle({Name = "Self", Default = false, Pointer = "ESP_Self", callback = function(value)
        ESP.SelfESP = value
    end})
    ESP_Section:Slider({Name = "Max Distance", Min = 100, Max = 2000, Default = 1000, Suffix = "m", Pointer = "ESP_MaxDistance", callback = function(value)
        ESP.MaxDistance = value
    end})
    ESP_Section:Dropdown({Name = "Distance Mode", Options = {"Dynamic", "Static"}, Default = "Dynamic", Pointer = "ESP_DistanceMode"})
    ESP_Section:Slider({Name = "Outline Transparency", Min = 0, Max = 1, Default = 1, Decimals = 0.1, Pointer = "ESP_OutlineTransparency", callback = function(value)
        ESP.OutlineTransparency = value
    end})
    ESP_Section:Dropdown({Name = "Text Font", Options = {"UI", "System", "Plex", "Monospace"}, Default = "UI", Pointer = "ESP_TextFont", callback = function(value)
        ESP.TextFont = Drawing.Fonts[value]
    end})
    ESP_Section:Slider({Name = "Text Size", Min = 8, Max = 24, Default = 14, Pointer = "ESP_TextSize", callback = function(value)
        ESP.TextSize = value
    end})

    ESP_Section:Label({Name = "ESP Features", Middle = false})
    ESP_Section:Toggle({Name = "Names", Default = false, Pointer = "ESP_Names", callback = function(value)
        ESP.ShowNames = value
    end})
    :Colorpicker({Info = "Names Color", Default = Color3.fromRGB(255, 255, 255), Pointer = "ESP_NameColor", callback = function(value)
        ESP.NameColor = value
    end})
    ESP_Section:Toggle({Name = "Box", Default = false, Pointer = "ESP_Box", callback = function(value)
        ESP.ShowBoxes = value
    end})
    :Colorpicker({Info = "Box Color", Default = Color3.fromRGB(255, 255, 255), Pointer = "ESP_BoxColor", callback = function(value)
        ESP.BoxColor = value
    end})
    ESP_Section:Toggle({Name = "Bone", Default = false, Pointer = "ESP_Bone", callback = function(value)
        ESP.ShowBone = value
    end})
    :Colorpicker({Info = "Bone Color", Default = Color3.fromRGB(255, 255, 255), Pointer = "ESP_BoneColor", callback = function(value)
        ESP.BoneColor = value
    end})
    ESP_Section:Toggle({Name = "Health Bar", Default = false, Pointer = "ESP_HealthBar", callback = function(value)
        ESP.ShowHealthBars = value
    end})
    :Colorpicker({Info = "Health Bar Color", Default = Color3.fromRGB(0, 255, 0), Pointer = "ESP_HealthBarColor", callback = function(value)
        ESP.HealthBarColor = value
    end})
    ESP_Section:Toggle({Name = "Armor Bar", Default = false, Pointer = "ESP_ArmorBar", callback = function(value)
        ESP.ShowArmorBar = value
    end})
    :Colorpicker({Info = "Armor Bar Color", Default = Color3.fromRGB(0, 255, 255), Pointer = "ESP_ArmorBarColor", callback = function(value)
        ESP.ArmorBarColor = value
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
    ESP_Section:Slider({Name = "Duration", Min = 0.1, Max = 5, Default = 1.5, Decimals = 0.1, Suffix = "s", Pointer = "ESP_TracerDuration", callback = function(value)
        ESP.TracerDuration = value
    end})

    -- // Settings Section
    local Settings_Main = Settings:Section({Name = "Main", Side = "Left"})
    Settings_Main:ConfigBox({})
    Settings_Main:ButtonHolder({Buttons = {{"Load", function() end}, {"Save", function() end}}})
    Settings_Main:Label({Name = "Unloading will fully unload\neverything, so save your\nconfig before unloading.", Middle = true})
    Settings_Main:Button({Name = "Unload", Callback = function() Window:Unload() end})

    -- // Initialize
    Window:Initialize()
end
