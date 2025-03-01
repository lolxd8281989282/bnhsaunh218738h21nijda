return function(Library, ESP)
    if ESP then
        if not ESP.Toggle then
            ESP.Toggle = function(self, state)
                self.Enabled = state
            end
        end
    end

    local Window = Library:New({
        Name = "dracula.lol | beta",
        Accent = Color3.fromRGB(255, 255, 255)
    })

    -- Pages
    local Main = Window:Page({Name = "aim-assist"})
    local Visuals = Window:Page({Name = "visuals"})
    local Players = Window:Page({Name = "players-list"})
    local Settings = Window:Page({Name = "settings"})

    -- Sections
    local TargetAim = Main:Section({Name = "Target Aim", Side = "Left"})
    local FOV = Main:Section({Name = "Field of View", Side = "Right"})
    local Prediction = Main:Section({Name = "Prediction", Side = "Left"})
    local GunMods = Main:Section({Name = "Gun Exploits (Da Hood Only)", Side = "Right"})

    -- Target Aim Section
    local targetEnabled = TargetAim:Toggle({
        Name = "Enabled",
        Default = false,
        Pointer = "TargetEnabled"
    })

    targetEnabled:Keybind({
        Default = Enum.KeyCode.E,
        KeybindName = "Target",
        Mode = "Toggle",
        Pointer = "TargetBind"
    })

    -- Visuals Section
    local Target_UI = Visuals:Section({Name = "Target UI", Side = "Left"})
    local ESP_Section = Visuals:Section({Name = "ESP", Side = "Right"})

    -- ESP Section with fixed sliders
    ESP_Section:Toggle({
        Name = "Enabled",
        Default = false,
        Pointer = "ESP_Enabled",
        Callback = function(Value)
            if ESP and type(ESP.Toggle) == "function" then
                ESP:Toggle(Value)
            end
        end
    })

    ESP_Section:Toggle({
        Name = "Self",
        Default = false,
        Pointer = "ESP_Self",
        Callback = function(state)
            if ESP then
                ESP.SelfESP = state
            end
        end
    })

    -- Fixed Max Distance slider
    ESP_Section:Slider({
        Name = "Max Distance",
        Min = 100,
        Max = 2000,
        Default = 1000,
        Suffix = "m",
        Decimals = 0,
        Pointer = "ESP_MaxDistance",
        Callback = function(value)
            if ESP then
                ESP.MaxDistance = value
            end
        end
    })

    ESP_Section:Dropdown({
        Name = "Distance Mode",
        Options = {"Dynamic", "Static"},
        Default = "Dynamic",
        Pointer = "ESP_DistanceMode"
    })

    ESP_Section:Slider({
        Name = "Outline Transparency",
        Min = 0,
        Max = 1,
        Default = 1,
        Decimals = 1,
        Pointer = "ESP_OutlineTransparency"
    })

    ESP_Section:Dropdown({
        Name = "Text Font",
        Options = {"UI", "System", "Plex", "Monospace"},
        Default = "UI",
        Pointer = "ESP_TextFont"
    })

    -- Fixed Text Size slider
    ESP_Section:Slider({
        Name = "Text Size",
        Min = 8,
        Max = 24,
        Default = 14,
        Decimals = 0,
        Pointer = "ESP_TextSize",
        Callback = function(value)
            if ESP then
                ESP.TextSize = value
            end
        end
    })

    ESP_Section:Label({Name = "ESP Features"})

    -- ESP Features
    local function createESPFeature(name, property, default_color)
        ESP_Section:Toggle({
            Name = name,
            Default = false,
            Pointer = "ESP_" .. property
        }):Colorpicker({
            Info = name .. " Color",
            Default = default_color,
            Pointer = "ESP_" .. property .. "Color"
        })
    end

    createESPFeature("Names", "Names", Color3.fromRGB(255, 255, 255))
    createESPFeature("Box", "Boxes", Color3.fromRGB(255, 255, 255))
    createESPFeature("Health Bar", "HealthBars", Color3.fromRGB(0, 255, 0))
    createESPFeature("Armor Bar", "ArmorBar", Color3.fromRGB(0, 255, 255))
    createESPFeature("Distance", "Distance", Color3.fromRGB(255, 255, 255))
    createESPFeature("Weapon", "Weapon", Color3.fromRGB(255, 255, 255))
    createESPFeature("Flags", "Flags", Color3.fromRGB(255, 255, 255))
    createESPFeature("Bone", "Bone", Color3.fromRGB(255, 255, 255))

    -- Bullet Tracers
    ESP_Section:Toggle({
        Name = "Bullet Tracers",
        Default = false,
        Pointer = "ESP_BulletTracers"
    }):Colorpicker({
        Info = "Bullet Tracers Color",
        Default = Color3.fromRGB(139, 0, 0),
        Pointer = "ESP_BulletTracersColor"
    })

    ESP_Section:Slider({
        Name = "Duration",
        Min = 0.1,
        Max = 5,
        Default = 1.5,
        Decimals = 1,
        Suffix = "s",
        Pointer = "ESP_TracerDuration"
    })

    -- Atmosphere Section
    local Atmosphere = Visuals:Section({Name = "Atmosphere", Side = "Left"})
    local Rain = Visuals:Section({Name = "Rain", Side = "Left"})

    Atmosphere:Toggle({Name = "Enabled", Default = false, Pointer = "Atmosphere_Enabled"})
    Atmosphere:Toggle({Name = "Ambient", Default = false, Pointer = "Atmosphere_Ambient"})
        :Colorpicker({Info = "Ambient Color", Default = Color3.fromRGB(139, 0, 0), Pointer = "Atmosphere_AmbientColor"})
    Atmosphere:Toggle({Name = "Time Modifier", Default = false, Pointer = "Atmosphere_TimeModifier"})
    Atmosphere:Toggle({Name = "Fog", Default = false, Pointer = "Atmosphere_Fog"})
        :Colorpicker({Info = "Fog Color", Default = Color3.fromRGB(139, 0, 0), Pointer = "Atmosphere_FogColor"})
    Atmosphere:Toggle({Name = "Brightness", Default = false, Pointer = "Atmosphere_Brightness"})

    Rain:Toggle({Name = "Enabled", Default = false, Pointer = "Rain_Enabled"})
        :Colorpicker({Info = "Rain Color", Default = Color3.fromRGB(255, 255, 255), Pointer = "Rain_RainColor"})

    -- Settings
    local Settings_Main = Settings:Section({Name = "Main", Side = "Left"})
    Settings_Main:ConfigBox({})
    Settings_Main:ButtonHolder({
        Buttons = {
            {"Load", function() end},
            {"Save", function() end}
        }
    })
    Settings_Main:Label({
        Name = "Unloading will fully unload\neverything, so save your\nconfig before unloading.",
        Middle = true
    })
    Settings_Main:Button({
        Name = "Unload",
        Callback = function()
            Window:Unload()
        end
    })

    Window:Initialize()
    return Window
end
