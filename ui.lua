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
local BulletRedirection = tabs.Legit:AddSection("Bullet Redirection", 1)
local AimAssist = tabs.Legit:AddSection("Aim Assist", 2)

-- Bullet Redirection Section
BulletRedirection:AddToggle({text = "Enabled", flag = "br_enabled"})
BulletRedirection:AddToggle({text = "Show FOV", flag = "br_show_fov"})
BulletRedirection:AddToggle({text = "Resolver", flag = "br_resolver"})
BulletRedirection:AddToggle({text = "Use Closest Part", flag = "br_use_closest_part"})
BulletRedirection:AddToggle({text = "Anti Ground Shots", flag = "br_anti_ground_shots"})
BulletRedirection:AddToggle({text = "Use Air Part", flag = "br_use_air_part"})
BulletRedirection:AddToggle({text = "KO Check", flag = "br_ko_check"})
BulletRedirection:AddToggle({text = "Grabbed Check", flag = "br_grabbed_check"})

BulletRedirection:AddSlider({text = "Prediction", flag = "br_prediction", min = 0, max = 34, value = 13, suffix = "/3.4"})
BulletRedirection:AddSlider({text = "Radius", flag = "br_radius", min = 0, max = 250, value = 0, suffix = "/250"})
BulletRedirection:AddSlider({text = "HitChance", flag = "br_hitchance", min = 0, max = 100, value = 0})
BulletRedirection:AddSlider({text = "AntiGround Shots Value", flag = "br_antiground_value", min = 0, max = 100, value = 0})
BulletRedirection:AddSlider({text = "Resolver Tuning", flag = "br_resolver_tuning", min = 0, max = 100, value = 0})

BulletRedirection:AddList({text = "Part", flag = "br_part", values = {"HumanoidRootPart"}, value = "HumanoidRootPart"})
BulletRedirection:AddList({text = "Air Part", flag = "br_air_part", values = {"Head"}, value = "Head"})

-- Aim Assist Section
AimAssist:AddToggle({text = "Enabled", flag = "aa_enabled"})
AimAssist:AddToggle({text = "Smoothing", flag = "aa_smoothing"})
AimAssist:AddToggle({text = "Add Shake", flag = "aa_add_shake"})
AimAssist:AddToggle({text = "Show FOV", flag = "aa_show_fov"})
AimAssist:AddToggle({text = "Use Circle Radius", flag = "aa_use_circle_radius"})
AimAssist:AddToggle({text = "Resolver", flag = "aa_resolver"})
AimAssist:AddToggle({text = "Unlock On Target Death", flag = "aa_unlock_target_death"})
AimAssist:AddToggle({text = "Unlock On My Death", flag = "aa_unlock_my_death"})

AimAssist:AddSlider({text = "Prediction", flag = "aa_prediction", min = 0, max = 32, value = 13, suffix = "/3.2"})
AimAssist:AddSlider({text = "Smooth Amount", flag = "aa_smooth_amount", min = 0, max = 100, value = 0})
AimAssist:AddSlider({text = "Shake Value", flag = "aa_shake_value", min = 0, max = 100, value = 0, suffix = "/100"})
AimAssist:AddSlider({text = "Shake Multiplier", flag = "aa_shake_multiplier", min = 0, max = 10, value = 1, suffix = "/10"})
AimAssist:AddSlider({text = "Resolver Time", flag = "aa_resolver_time", min = 0, max = 100, value = 0})
AimAssist:AddSlider({text = "Radius", flag = "aa_radius", min = 0, max = 250, value = 20, suffix = "/250"})

AimAssist:AddList({text = "Part", flag = "aa_part", values = {"Head"}, value = "Head"})
AimAssist:AddList({text = "Speed", flag = "aa_speed", values = {"..."}, value = "..."})
AimAssist:AddList({text = "Key", flag = "aa_key", values = {"..."}, value = "..."})

-- Finalize
library:SendNotification("Successfully Initialized", 3, Color3.new(0, 1, 0))
Window:SetOpen(true)

return Window
