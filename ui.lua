-- Credits To The Original Devs @xz, @goof
getgenv().Config = {
    Invite = "informant.wtf",
    Version = "0.0",
}

getgenv().luaguardvars = {
    DiscordName = "username#0000",
}

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/lolxd8281989282/bnhsaunh218738h21nijda/refs/heads/main/Library.lua"))()

library:init()

local Window = library.NewWindow({
    title = "Informant.Wtf",
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
    Players = Window:AddTab("Players"),
    Visuals = Window:AddTab("Visuals"),
    Misc = Window:AddTab("Misc"),
    Settings = library:CreateSettingsTab(Window),
}

-- Legit Tab
local AimAssist = tabs.Legit:AddSection("Aim Assist", 1)
local BulletRedirection = tabs.Legit:AddSection("Bullet Redirection", 2)
local MiscSection = tabs.Legit:AddSection("Misc", 2)

-- Aim Assist Section
AimAssist:AddList({text = "Aimbot", flag = "aimbot", values = {"none", "..."}, value = "none"})
AimAssist:AddToggle({text = "Prediction", flag = "prediction"})
AimAssist:AddList({text = "Mouse", flag = "mouse_settings", values = {"..."}, value = "..."})
AimAssist:AddSlider({text = "[Mouse] Smoothing", flag = "mouse_smoothing", min = 0, max = 100, value = 1.0})
AimAssist:AddSlider({text = "[Camera] Smoothing", flag = "camera_smoothing", min = 0, max = 100, value = 55.0})
AimAssist:AddList({text = "Prediction Method", flag = "prediction_method", values = {"Division", "..."}, value = "Division"})
AimAssist:AddSlider({text = "Prediction X", flag = "prediction_x", min = 0, max = 100, value = 7.5})
AimAssist:AddSlider({text = "Prediction Y", flag = "prediction_y", min = 0, max = 100, value = 6.9})
AimAssist:AddSlider({text = "Prediction Z", flag = "prediction_z", min = 0, max = 100, value = 5.6})
AimAssist:AddToggle({text = "Use Custom Aim Part", flag = "custom_aim_part"})

-- Misc Section
MiscSection:AddToggle({text = "Shake", flag = "shake"})
MiscSection:AddToggle({text = "Resolver", flag = "resolver"})
MiscSection:AddToggle({text = "Auto Prediction", flag = "auto_prediction"})
MiscSection:AddToggle({text = "Only in FOV", flag = "only_in_fov"})
MiscSection:AddToggle({text = "Show FOV", flag = "show_fov"})
MiscSection:AddSlider({text = "FOV Value", flag = "fov_value", min = 0, max = 100, value = 40})

-- Finalize
library:SendNotification("UI Loaded", 3, Color3.new(0, 1, 0))
Window:SetOpen(true)

return Window
