-- Credits To The Original Devs @xz, @goof
getgenv().Config = {
    Invite = "dracula.lol",
    Version = "1.0",
}

getgenv().luaguardvars = {
    DiscordName = "username#0000",
}

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/lolxd8281989282/bnhsaunh218738h21nijda/refs/heads/main/Library.lua"))()

library:init()

local Window = library.NewWindow({
    title = "dracula.lol | beta",
    size = UDim2.new(0, 525, 0, 650)
})

-- Change accent color to white
library:SetTheme({
    ["Accent"] = Color3.fromRGB(255, 255, 255)
})

-- Set initial watermark state
library.watermark.enabled = true
library.watermark.lock = 'Bottom Right'
library.flags.watermark_enabled = true
library.flags.watermark_pos = 'Bottom Right'
library.flags.watermark_x = 40
library.flags.watermark_y = 1.1

local tabs = {
    Legit = Window:AddTab("Legit"),
    Settings = library:CreateSettingsTab(Window),
}

-- Legit Tab
local Main = tabs.Legit:AddSection("Main", 1)
local Visuals = tabs.Legit:AddSection("Visuals", 2)
local Misc = tabs.Legit:AddSection("Misc", 2)

-- Main Section
Main:AddToggle({text = "Enabled", flag = "main_enabled"})
Main:AddToggle({text = "Silent", flag = "main_silent"})
Main:AddToggle({text = "Camlock", flag = "main_camlock"})
Main:AddToggle({text = "Anti Aim Viewer", flag = "main_anti_aim_viewer"})
Main:AddToggle({text = "Gun TP", flag = "main_gun_tp"})
Main:AddToggle({text = "Closest Part", flag = "main_closest_part"})
Main:AddToggle({text = "Apply Closest Part On GetClo", flag = "main_apply_closest_getclo"})
Main:AddToggle({text = "Smoothing", flag = "main_smoothing"})
Main:AddToggle({text = "Alerts", flag = "main_alerts"})
Main:AddToggle({text = "Auto Prediction", flag = "main_auto_prediction"})
Main:AddToggle({text = "Use Field of View", flag = "main_use_fov"})
Main:AddToggle({text = "Visualize FOV", flag = "main_visualize_fov"})
Main:AddToggle({text = "Use Checks", flag = "main_use_checks"})

Main:AddList({text = "Aim Part", flag = "main_aim_part", values = {"HumanoidRootPart"}, value = "HumanoidRootPart"})
Main:AddList({text = "Checks", flag = "main_checks", values = {"..."}, value = "..."})

Main:AddSlider({text = "Field of View Radius", flag = "main_fov_radius", min = 0, max = 800, value = 80, suffix = "%/800%"})
Main:AddSlider({text = "Alerts Duration", flag = "main_alerts_duration", min = 0, max = 10, value = 4, suffix = "%/10%"})
Main:AddSlider({text = "Smoothing Amount", flag = "main_smoothing_amount", min = 0, max = 100, value = 15, suffix = "%/7%"})

-- Visuals Section
Visuals:AddToggle({text = "Enabled", flag = "visuals_enabled"})
Visuals:AddToggle({text = "Tracer", flag = "visuals_tracer"})
Visuals:AddToggle({text = "Circle", flag = "visuals_circle"})
Visuals:AddToggle({text = "Dot", flag = "visuals_dot"})
Visuals:AddToggle({text = "Dot Filled", flag = "visuals_dot_filled"})
Visuals:AddToggle({text = "Chams", flag = "visuals_chams"})

Visuals:AddList({text = "Part", flag = "visuals_part", values = {"..."}, value = "..."})

Visuals:AddSlider({text = "Thickness", flag = "visuals_thickness", min = 0, max = 10, value = 2, suffix = "%/10%"})
Visuals:AddSlider({text = "Outline Transparency", flag = "visuals_outline_transparency", min = 0, max = 100, value = 5, suffix = "%/1%"})
Visuals:AddSlider({text = "Fill Transparency", flag = "visuals_fill_transparency", min = 0, max = 100, value = 5, suffix = "%/1%"})
Visuals:AddSlider({text = "Dot Size", flag = "visuals_dot_size", min = 0, max = 10, value = 6, suffix = "%/10%"})
Visuals:AddSlider({text = "Part Transparency", flag = "visuals_part_transparency", min = 0, max = 100, value = 5, suffix = "%/1%"})
Visuals:AddSlider({text = "Part Size", flag = "visuals_part_size", min = 0, max = 20, value = 2, suffix = "'/20'"})
Visuals:AddSlider({text = "Circle Size", flag = "visuals_circle_size", min = 0, max = 10, value = 2, suffix = "%/10%"})

Visuals:AddToggle({text = "Part Material", flag = "visuals_part_material"})
Visuals:AddToggle({text = "Neon", flag = "visuals_neon"})

-- Misc Section
Misc:AddToggle({text = "Auto Select", flag = "misc_auto_select"})
Misc:AddToggle({text = "Resolver", flag = "misc_resolver"})
Misc:AddToggle({text = "Jump Offset (AIR)", flag = "misc_jump_offset_air"})
Misc:AddToggle({text = "Spectate", flag = "misc_spectate"})
Misc:AddToggle({text = "Air", flag = "misc_air"})
Misc:AddToggle({text = "Anti Groundshots (AIR)", flag = "misc_anti_groundshots_air"})

Misc:AddSlider({text = "Refresh Rate", flag = "misc_refresh_rate", min = 0, max = 200, value = 200, suffix = "ms/200ms"})
Misc:AddSlider({text = "To Take Off", flag = "misc_to_take_off", min = 0, max = 10, value = 0.4, suffix = "'/1'"})
Misc:AddSlider({text = "Jump Offset", flag = "misc_jump_offset", min = 0, max = 4, value = 0.09, suffix = "'/4'"})

-- Finalize
library:SendNotification("Successfully Initialized", 3, Color3.new(0, 1, 0))
Window:SetOpen(true)

return Window
