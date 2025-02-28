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
local AimbotSection = tabs.Legit:AddSection("Aimbot", 1)
local AimbotSettingsSection = tabs.Legit:AddSection("Aimbot Settings", 2)

-- Aimbot Section
AimbotSection:AddToggle({text = "Enable Aimbot", flag = "enable_aimbot"})
AimbotSection:AddToggle({text = "Phantom Force Aimbot", flag = "phantom_force_aimbot"})
AimbotSection:AddSlider({text = "Aimbot Offset", flag = "aimbot_offset", min = 0, max = 100, value = 0})
AimbotSection:AddToggle({text = "Draw FOV", flag = "draw_fov"})
AimbotSection:AddToggle({text = "Knifebot", flag = "knifebot"})
AimbotSection:AddSlider({text = "Aimbot Smoothness", flag = "aimbot_smoothness", min = 0, max = 100, value = 0})
AimbotSection:AddList({text = "Target Bone", flag = "target_bone", values = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}, value = "Head"})

-- Aimbot Settings Section
AimbotSettingsSection:AddToggle({text = "Enable Silent Aim", flag = "enable_silent_aim"})
AimbotSettingsSection:AddToggle({text = "Silent Aim Prediction", flag = "silent_aim_prediction"})
AimbotSettingsSection:AddSlider({text = "Silent Aim Prediction X", flag = "silent_aim_prediction_x", min = 0, max = 100, value = 0})
AimbotSettingsSection:AddSlider({text = "Silent Aim Prediction Y", flag = "silent_aim_prediction_y", min = 0, max = 100, value = 0})
AimbotSettingsSection:AddSlider({text = "Silent Aim Prediction Z", flag = "silent_aim_prediction_z", min = 0, max = 100, value = 0})

-- Finalize
library:SendNotification("UI Loaded", 3, Color3.new(0, 1, 0))
Window:SetOpen(true)

return Window
