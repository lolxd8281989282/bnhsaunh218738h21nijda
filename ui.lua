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

-- Set initial watermark state
library.watermark.enabled = true
library.watermark.lock = 'Bottom Right'
library.flags.watermark_enabled = true
library.flags.watermark_pos = 'Bottom Right'
library.flags.watermark_x = 40
library.flags.watermark_y = 1.1

local tabs = {
    Aimbot = Window:AddTab("Aimbot"),
    Visuals = Window:AddTab("Visuals"),
    Misc = Window:AddTab("Misc"),
    Settings = library:CreateSettingsTab(Window),
}

-- Aimbot Tab
local AimbotMain = tabs.Aimbot:AddSection("Aimbot", 1)
local AimbotSettings = tabs.Aimbot:AddSection("Aimbot Settings", 2)

AimbotMain:AddToggle({text = "Enabled", flag = "aimbot_enabled"})
AimbotMain:AddBind({text = "Aim Key", flag = "aimbot_key", key = Enum.KeyCode.E})
AimbotMain:AddList({text = "Aim Part", flag = "aimbot_part", values = {"Head", "Torso"}, value = "Head"})

AimbotSettings:AddSlider({text = "Smoothness", flag = "aimbot_smoothness", min = 1, max = 100, value = 20})
AimbotSettings:AddSlider({text = "FOV", flag = "aimbot_fov", min = 0, max = 800, value = 100})
AimbotSettings:AddToggle({text = "Visible Check", flag = "aimbot_vischeck"})
AimbotSettings:AddToggle({text = "Team Check", flag = "aimbot_teamcheck"})

-- Visuals Tab
local ESPSettings = tabs.Visuals:AddSection("ESP", 1)
local WorldSettings = tabs.Visuals:AddSection("World", 2)

ESPSettings:AddToggle({text = "Enabled", flag = "esp_enabled"})
ESPSettings:AddToggle({text = "Boxes", flag = "esp_boxes"})
ESPSettings:AddToggle({text = "Names", flag = "esp_names"})
ESPSettings:AddToggle({text = "Tracers", flag = "esp_tracers"})
ESPSettings:AddToggle({text = "Team Color", flag = "esp_teamcolor"})

WorldSettings:AddToggle({text = "Fullbright", flag = "world_fullbright"})
WorldSettings:AddToggle({text = "Remove Fog", flag = "world_nofog"})
WorldSettings:AddSlider({text = "Time of Day", flag = "world_time", min = 0, max = 24, value = 12})

-- Misc Tab
local MovementSection = tabs.Misc:AddSection("Movement", 1)
local ExploitsSection = tabs.Misc:AddSection("Exploits", 2)

MovementSection:AddToggle({text = "Speed", flag = "move_speed"})
MovementSection:AddSlider({text = "Speed Amount", flag = "move_speed_value", min = 16, max = 200, value = 16})
MovementSection:AddToggle({text = "Bunny Hop", flag = "move_bhop"})

ExploitsSection:AddButton({text = "Unlock All Skins", callback = function()
    -- Add your unlock skins logic here
    library:SendNotification("Skins Unlocked", 3)
end})

ExploitsSection:AddToggle({text = "Anti-Aim", flag = "exploit_antiaim"})

-- Finalize
library:SendNotification("UI Loaded", 3, Color3.new(0, 1, 0))
Window:SetOpen(true)

return Window
