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

    -- // Visuals Sections
    local PlayerESP = Visuals:Section({Name = "player esp", Side = "Left"})
    local LocalCharacter = Visuals:Section({Name = "local character", Side = "Left"})
    local World = Visuals:Section({Name = "world", Side = "Right"})
    local Game = Visuals:Section({Name = "game", Side = "Right"})
    local HUD = Visuals:Section({Name = "hud", Side = "Left"})

    -- Player ESP Section
    PlayerESP:Toggle({Name = "enabled", Default = false, Pointer = "ESP_Enabled",
        callback = function(state)
            if ESP and type(ESP.Toggle) == "function" then
                ESP:Toggle(state)
            end
        end
    })
    :Colorpicker({Info = "ESP Color", Default = Color3.fromRGB(255, 255, 255)})

    local function createESPFeature(name, property, default_color)
        PlayerESP:Toggle({
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

    -- Box with dropdown
    PlayerESP:Toggle({Name = "box", Default = false, Pointer = "ESP_Boxes"})
    :Colorpicker({Info = "Box Color", Default = Color3.fromRGB(255, 255, 255)})
    PlayerESP:Dropdown({
        Name = "box type",
        Options = {"2D", "3D", "corner"},
        Default = "2D",
        Pointer = "ESP_BoxType",
        callback = function(value)
            if ESP and type(ESP.UpdateBoxType) == "function" then
                ESP:UpdateBoxType(value:lower())
            end
        end
    })

    -- Rest of ESP features
    createESPFeature("name", "Names", Color3.fromRGB(255, 255, 255))
    createESPFeature("distance", "Distance", Color3.fromRGB(255, 255, 255))
    createESPFeature("chams", "Chams", Color3.fromRGB(255, 255, 255))
    createESPFeature("skeleton", "Bone", Color3.fromRGB(255, 255, 255))
    createESPFeature("head circle", "HeadCircle", Color3.fromRGB(255, 255, 255))
    createESPFeature("highlight", "Highlight", Color3.fromRGB(255, 255, 255))
    createESPFeature("armor bar", "ArmorBar", Color3.fromRGB(0, 255, 255))

    -- Health bar implementation
    PlayerESP:Toggle({
        Name = "health bar",
        Default = false,
        Pointer = "ESP_HealthBars",
        callback = function(state)
            if ESP and type(ESP.ToggleFeature) == "function" then
                ESP:ToggleFeature("HealthBars", state)
            end
        end
    })
    :Colorpicker({
        Info = "Health Bar Color",
        Default = Color3.fromRGB(0, 255, 0),
        Pointer = "ESP_HealthBarsColor",
        callback = function(color)
            if ESP and type(ESP.UpdateColor) == "function" then
                ESP:UpdateColor("HealthBars", color)
            end
        end
    })

    createESPFeature("health text", "HealthText", Color3.fromRGB(255, 255, 255))
    PlayerESP:Toggle({Name = "fonts", Default = false, Pointer = "ESP_Fonts"})
    :Colorpicker({Info = "Font Color", Default = Color3.fromRGB(255, 255, 255)})

    -- Local Character Section
    LocalCharacter:Toggle({Name = "show arms in first person", Default = false, Pointer = "Local_ShowArms"})
    LocalCharacter:Toggle({Name = "character highlight", Default = false, Pointer = "Local_CharHighlight"})
    :Colorpicker({Info = "Highlight Color", Default = Color3.fromRGB(255, 255, 255)})
    LocalCharacter:Toggle({Name = "character chams", Default = false, Pointer = "Local_CharacterChams"})
    :Colorpicker({Info = "Chams Color", Default = Color3.fromRGB(255, 255, 255)})
    LocalCharacter:Toggle({Name = "weapon chams", Default = false, Pointer = "Local_WeaponChams"})
    :Colorpicker({Info = "Weapon Color", Default = Color3.fromRGB(255, 255, 255)})
    LocalCharacter:Toggle({Name = "material tools", Default = false, Pointer = "Local_MaterialTools"})
    :Colorpicker({Info = "Tools Color", Default = Color3.fromRGB(255, 255, 255)})
    LocalCharacter:Toggle({Name = "particle aura", Default = false, Pointer = "Local_ParticleAura"})
    :Colorpicker({Info = "Aura Color", Default = Color3.fromRGB(255, 255, 255)})

    -- World Section
    World:Toggle({Name = "lighting mode", Default = false, Pointer = "World_LightingMode"})
    World:Toggle({Name = "shadowmap", Default = false, Pointer = "World_Shadowmap"})
    World:Slider({Name = "world time", Minimum = 0, Maximum = 24, Default = 4.5, Decimals = 0.1, Suffix = "", Pointer = "World_Time"})
    World:Toggle({Name = "atmosphere", Default = false, Pointer = "World_Atmosphere"})
    :Colorpicker({Info = "Atmosphere Color", Default = Color3.fromRGB(255, 255, 255)})
    World:Slider({Name = "saturation", Minimum = 0, Maximum = 1, Default = 0.1, Decimals = 0.01, Pointer = "World_Saturation"})
    World:Slider({Name = "contrast", Minimum = 0, Maximum = 1, Default = 0.05, Decimals = 0.01, Pointer = "World_Contrast"})
    World:Toggle({Name = "textures", Default = false, Pointer = "World_Textures"})
    World:Toggle({Name = "ambient", Default = false, Pointer = "World_Ambient"})
    :Colorpicker({Info = "Ambient Color", Default = Color3.fromRGB(255, 255, 255)})
    World:Toggle({Name = "weather", Default = false, Pointer = "World_Weather"})
    World:Toggle({Name = "skybox", Default = false, Pointer = "World_Skybox"})
    World:Toggle({Name = "tint", Default = false, Pointer = "World_Tint"})
    :Colorpicker({Info = "Tint Color", Default = Color3.fromRGB(255, 255, 255)})

    -- Game Section
    Game:Slider({Name = "player bullet volume", Minimum = 0, Maximum = 1, Default = 0.5, Decimals = 0.1, Suffix = "", Pointer = "Game_BulletVolume"})
    Game:Toggle({Name = "local bullet tracers", Default = false, Pointer = "Game_LocalTracers"})
    :Colorpicker({Info = "Local Tracer Color", Default = Color3.fromRGB(255, 255, 255)})
    Game:Toggle({Name = "shot notifications", Default = false, Pointer = "Game_ShotNotifs"})
    Game:Toggle({Name = "local bullet sound", Default = false, Pointer = "Game_BulletSound"})
    Game:Toggle({Name = "damage number", Default = false, Pointer = "Game_DamageNumber"})
    Game:Toggle({Name = "3d hit marker", Default = false, Pointer = "Game_3DHitMarker"})
    Game:Toggle({Name = "2d hit marker", Default = false, Pointer = "Game_2DHitMarker"})
    Game:Toggle({Name = "hit particle", Default = false, Pointer = "Game_HitParticle"})
    Game:Toggle({Name = "hit overlay", Default = false, Pointer = "Game_HitOverlay"})
    Game:Toggle({Name = "hit sound", Default = false, Pointer = "Game_HitSound"})
    Game:Toggle({Name = "hit chams", Default = false, Pointer = "Game_HitChams"})

    -- HUD Section
    HUD:Toggle({Name = "server position indicator", Default = false, Pointer = "HUD_ServerPos"})
    HUD:Toggle({Name = "center panel", Default = false, Pointer = "HUD_CenterPanel"})
    HUD:Toggle({Name = "show chat", Default = false, Pointer = "HUD_ShowChat"})

    -- // Settings Section
    local Settings_Main = Settings:Section({Name = "Main", Side = "Left"})
    Settings_Main:ConfigBox({})
    Settings_Main:ButtonHolder({Buttons = {{"Load", function() end}, {"Save", function() end}}})
    Settings_Main:Label({Name = "Unloading will fully unload\neverything, so save your\nconfig before unloading.", Middle = true})
    Settings_Main:Button({Name = "Unload", Callback = function() Window:Unload() end})

    -- // Initialisation
    Window:Initialize()
end
