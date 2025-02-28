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
  Settings = library:CreateSettingsTab(Window),
}

-- Legit Tab
local AimbotSettingsLeft = tabs.Legit:AddSection("Aimbot Settings", 1)
local AimbotSettingsRight = tabs.Legit:AddSection("Aimbot Settings", 2)

-- Left Aimbot Settings
AimbotSettingsLeft:AddToggle({text = "Enable Aimbot", flag = "enable_aimbot"})
AimbotSettingsLeft:AddToggle({text = "Phantom Force Aimbot", flag = "phantom_force_aimbot"})
AimbotSettingsLeft:AddToggle({text = "Body Hit", flag = "body_hit"})
AimbotSettingsLeft:AddToggle({text = "Aimbot Prediction", flag = "aimbot_prediction"})
AimbotSettingsLeft:AddToggle({text = "Draw FOV", flag = "draw_fov"})
AimbotSettingsLeft:AddToggle({text = "Knifebot", flag = "knifebot"})
AimbotSettingsLeft:AddToggle({text = "Smoothing", flag = "smoothing"})

AimbotSettingsLeft:AddSlider({text = "Aimbot Prediction X", flag = "aimbot_prediction_x", min = 0, max = 100, value = 5})
AimbotSettingsLeft:AddSlider({text = "Aimbot Prediction Y", flag = "aimbot_prediction_y", min = 0, max = 100, value = 5})
AimbotSettingsLeft:AddSlider({text = "Aimbot Prediction Z", flag = "aimbot_prediction_z", min = 0, max = 100, value = 5})

AimbotSettingsLeft:AddList({text = "Target Bone", flag = "target_bone", values = {"Head"}, value = "Head"})
AimbotSettingsLeft:AddList({text = "Aimbot Type", flag = "aimbot_type", values = {"Default"}, value = "Default"})
AimbotSettingsLeft:AddList({text = "Cleaner's", flag = "cleaners", values = {"Default"}, value = "Default"})
AimbotSettingsLeft:AddList({text = "Knocked", flag = "knocked", values = {"Default"}, value = "Default"})

-- Right Aimbot Settings
AimbotSettingsRight:AddToggle({text = "Enable Silent Aim", flag = "enable_silent_aim"})
AimbotSettingsRight:AddToggle({text = "Silent Aim Ricochet", flag = "silent_aim_ricochet"})
AimbotSettingsRight:AddToggle({text = "Silent Aim Prediction", flag = "silent_aim_prediction"})

AimbotSettingsRight:AddList({text = "Silent Aim Target Part", flag = "silent_aim_target", values = {"Head"}, value = "Head"})

AimbotSettingsRight:AddSlider({text = "Silent Aim Prediction X", flag = "silent_prediction_x", min = 0, max = 100, value = 5})
AimbotSettingsRight:AddSlider({text = "Silent Aim Prediction Y", flag = "silent_prediction_y", min = 0, max = 100, value = 5})
AimbotSettingsRight:AddSlider({text = "Silent Aim Prediction Z", flag = "silent_prediction_z", min = 0, max = 100, value = 5})

AimbotSettingsRight:AddBind({text = "Trigger Bot Key", flag = "triggerbot_key", key = Enum.KeyCode.E})

-- Finalize
library:SendNotification("UI Loaded", 3, Color3.new(0, 1, 0))
Window:SetOpen(true)

return Window
