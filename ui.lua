local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/lolxd8281989282/bnhsaunh218738h21nijda/refs/heads/main/Library.lua"))()
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/lolxd8281989282/bnhsaunh218738h21nijda/refs/heads/main/esp.lua"))() -- Update with your actual repo for ESP

local Window = Library:New({
    Name = "dracula.lol | beta",
    Accent = Color3.fromRGB(255, 255, 255)
})

-- Create the Visual page
local VisualPage = Window:Page({
    Name = "visuals"
})

-- Create the ESP section
local ESPSection = VisualPage:Section({
    Name = "ESP",
    Side = "Left"
})

-- Initialize ESP with default settings
local espSettings = {
    Enabled = false,
    TeamCheck = false,
    ShowBoxes = false,
    ShowNames = false,
    ShowDistance = false,
    ShowHealthBars = false,
    ShowHeadDot = false,
    ShowSkeleton = false,
    Outline = false,
    SelfESP = false,
    BoxType = "Full",
    Distance = 1000
}

local espInstance = ESP.Init(espSettings)

-- Add ESP toggles
ESPSection:Toggle({
    Name = "Enabled",
    Callback = function(Value)
        espSettings.Enabled = Value
        espInstance:UpdateSettings(espSettings)
    end
})

ESPSection:Toggle({
    Name = "Team Check",
    Callback = function(Value)
        espSettings.TeamCheck = Value
        espInstance:UpdateSettings(espSettings)
    end
})

ESPSection:Toggle({
    Name = "Outline",
    Callback = function(Value)
        espSettings.Outline = Value
        espInstance:UpdateSettings(espSettings)
    end
})

ESPSection:Toggle({
    Name = "Self ESP",
    Callback = function(Value)
        espSettings.SelfESP = Value
        espInstance:UpdateSettings(espSettings)
    end
})

ESPSection:Slider({
    Name = "Distance",
    Min = 0,
    Max = 2000,
    Default = 1000,
    Callback = function(Value)
        espSettings.Distance = Value
        espInstance:UpdateSettings(espSettings)
    end
})

ESPSection:Label({
    Name = "Box",
})

ESPSection:Toggle({
    Name = "Enabled",
    Callback = function(Value)
        espSettings.ShowBoxes = Value
        espInstance:UpdateSettings(espSettings)
    end
})

ESPSection:Toggle({
    Name = "Fill Box",
    Callback = function(Value)
        -- This option is not directly supported in the current ESP implementation
        -- You may need to add this feature to the ESP module if needed
    end
})

ESPSection:Dropdown({
    Name = "Box Type",
    Default = "Full",
    Options = {"Corners", "Full"},
    Callback = function(Value)
        espSettings.BoxType = Value
        espInstance:UpdateSettings(espSettings)
    end
})

local OtherSection = VisualPage:Section({
    Name = "Other",
    Side = "Right"
})

OtherSection:Toggle({
    Name = "Equipped Item",
    Callback = function(Value)
        -- This option is not directly supported in the current ESP implementation
        -- You may need to add this feature to the ESP module if needed
    end
})

OtherSection:Toggle({
    Name = "Skeleton",
    Callback = function(Value)
        espSettings.ShowSkeleton = Value
        espInstance:UpdateSettings(espSettings)
    end
})

OtherSection:Toggle({
    Name = "Head Dot",
    Callback = function(Value)
        espSettings.ShowHeadDot = Value
        espInstance:UpdateSettings(espSettings)
    end
})

OtherSection:Toggle({
    Name = "Distance",
    Callback = function(Value)
        espSettings.ShowDistance = Value
        espInstance:UpdateSettings(espSettings)
    end
})

OtherSection:Toggle({
    Name = "Health Bar",
    Callback = function(Value)
        espSettings.ShowHealthBars = Value
        espInstance:UpdateSettings(espSettings)
    end
})

OtherSection:Label({
    Name = "Name",
})

OtherSection:Toggle({
    Name = "Enabled",
    Callback = function(Value)
        espSettings.ShowNames = Value
        espInstance:UpdateSettings(espSettings)
    end
})

-- Aimbot Page
local AimPage = Window:Page({
    Name = "aim"
})

-- Aimbot Page Sections
local AimbotSection = AimPage:Section({
    Name = "Aimbot",
    Side = "Left"
})

-- Rage Page
local RagePage = Window:Page({
    Name = "rage"
})

-- Rage Page Sections
local RageSection = RagePage:Section({
    Name = "Rage",
    Side = "Left"
})

-- Misc Page
local MiscPage = Window:Page({
    Name = "misc"
})

-- Options Section
local OptionsSection = MiscPage:Section({
    Name = "Options",
    Side = "Left"
})

OptionsSection:Toggle({
    Name = "Local Chums",
})

OptionsSection:Toggle({
    Name = "Hit Tracers",
})

OptionsSection:Toggle({
    Name = "Hit Sound",
})

OptionsSection:Toggle({
    Name = "NoClip",
})

OptionsSection:Toggle({
    Name = "On Head Bar",
})

OptionsSection:Toggle({
    Name = "Spin Do Head Crosshair",
})

OptionsSection:Toggle({
    Name = "Target Strafe",
})

OptionsSection:Toggle({
    Name = "View Player",
})

OptionsSection:Slider({
    Name = "Horizontal Distance",
    Min = 0,
    Max = 2000,
    Default = 1000,
})

OptionsSection:Slider({
    Name = "Vertical Distance",
    Min = 0,
    Max = 2000,
    Default = 1000,
})

OptionsSection:Slider({
    Name = "Stride Speed",
    Min = 0,
    Max = 2000,
    Default = 1000,
})

-- Movement Section
local MovementSection = MiscPage:Section({
    Name = "Movement",
    Side = "Right"
})

MovementSection:Toggle({
    Name = "WalkSpeed",
})

MovementSection:Toggle({
    Name = "JumpPower",
})

MovementSection:Toggle({
    Name = "Fly",
})

MovementSection:Toggle({
    Name = "SpinBot",
})

MovementSection:Slider({
    Name = "WalkSpeed Value",
    Min = 0,
    Max = 100,
    Default = 28,
})

MovementSection:Slider({
    Name = "JumpPower Value",
    Min = 0,
    Max = 100,
    Default = 60,
})

MovementSection:Slider({
    Name = "Fly Speed",
    Min = 0,
    Max = 200,
    Default = 100,
})

MovementSection:Slider({
    Name = "Spin Speed Value",
    Min = 0,
    Max = 2000,
    Default = 1000,
})

-- Players Page
local PlayerPage = Window:Page({
    Name = "player-list"
})

-- Keep the existing PlayerList function
local PlayerList = PlayerPage:PlayerList({})

-- Settings Page
local SettingsPage = Window:Page({
    Name = "settings"
})

-- Settings Page Sections
local MainSettingsSection = SettingsPage:Section({
    Name = "Main",
    Side = "Left"
})

MainSettingsSection:Keybind({
    Name = "Open / Close",
    Default = Enum.KeyCode.RightShift,
})

MainSettingsSection:Toggle({
    Name = "Disable Movement if Open",
})

MainSettingsSection:Button({
    Name = "Join Discord",
})

MainSettingsSection:Button({
    Name = "Copy Discord",
})

MainSettingsSection:Button({
    Name = "Rejoin Server",
})

MainSettingsSection:Button({
    Name = "Copy Join Script",
})

MainSettingsSection:Button({
    Name = "Unload",
})

-- Add Config Section (Simplified)
local ConfigSection = SettingsPage:Section({
    Name = "Config",
    Side = "Right"
})

ConfigSection:TextBox({
    Name = "Config Name",
    Default = "",
    Placeholder = "Enter config name...",
})

ConfigSection:Dropdown({
    Name = "Config",
    Default = "none",
    Options = {"none"},
})

ConfigSection:Button({
    Name = "Load",
})

ConfigSection:Button({
    Name = "Save",
})

ConfigSection:Button({
    Name = "Create",
})

ConfigSection:Button({
    Name = "Delete",
})

Window:Initialize() -- DO NOT REMOVE
