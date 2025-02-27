local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/lolxd8281989282/bnhsaunh218738h21nijda/refs/heads/main/Library.lua"))()

local Window = Library:New({
    Name = "dracula.lol | beta",
    Accent = Color3.fromRGB(255, 255, 255) -- Change accent to white
})

-- Visual Page
local VisualPage = Window:Page({
    Name = "visuals"
})

-- World Section
local WorldSection = VisualPage:Section({
    Name = "World",
    Side = "Left"
})

WorldSection:Toggle({
    Name = "Fog",
})

WorldSection:Toggle({
    Name = "Ambient",
})

WorldSection:Toggle({
    Name = "Outdoor Ambient",
})

WorldSection:Toggle({
    Name = "Colorshift Bottom",
})

WorldSection:Toggle({
    Name = "Colorshift Top",
})

WorldSection:Toggle({
    Name = "Global Shadows",
})

WorldSection:Toggle({
    Name = "Fog Start Enabled",
})

WorldSection:Toggle({
    Name = "Fog End Enabled",
})

WorldSection:Slider({
    Name = "Fog Start",
    Min = 0,
    Max = 10000,
    Default = 10000,
    Decimals = 3  -- This will allow for three decimal places
})

WorldSection:Slider({
    Name = "Fog End",
    Min = 0,
    Max = 10000,
    Default = 10000,
    Decimals = 3  -- This will allow for three decimal places
})

-- Visuals Section
local VisualsSection = VisualPage:Section({
    Name = "Visuals",
    Side = "Right"
})

VisualsSection:Toggle({
    Name = "ESP",
    Default = false,
    Callback = function(state)
        ESP:Toggle(state)
    end
})

VisualsSection:Toggle({
    Name = "Bounding Box",
})

VisualsSection:Toggle({
    Name = "Name",
})

VisualsSection:Toggle({
    Name = "Distance",
})

VisualsSection:Toggle({
    Name = "Health Bar",
})

VisualsSection:Toggle({
    Name = "Skeleton",
})

VisualsSection:Toggle({
    Name = "Glow ESP",
})

VisualsSection:Toggle({
    Name = "Tool",
})

VisualsSection:Toggle({
    Name = "Team Text",
})

VisualsSection:Toggle({
    Name = "Tracers",
})

VisualsSection:Dropdown({
    Name = "Box Type",
    Default = "2D Box",
    Options = {"2D Box", "3D Box"},
})

VisualsSection:Toggle({
    Name = "Use Team Color",
})

VisualsSection:Toggle({
    Name = "Fill Box",
})

VisualsSection:Toggle({
    Name = "Gradient Box",
})

VisualsSection:Toggle({
    Name = "Team Check",
})

-- Aimbot Page
local AimPage = Window:Page({
    Name = "aim"
})

-- Options Section
local OptionsSection = AimPage:Section({
    Name = "Options",
    Side = "Left"
})

OptionsSection:Slider({
    Name = "Field Of View",
    Min = 0,
    Max = 70,
    Default = 70,
    Decimals = 3
})

OptionsSection:Slider({
    Name = "Speed",
    Min = 0,
    Max = 100,
    Default = 35
})

OptionsSection:Slider({
    Name = "Smoothness",
    Min = 0,
    Max = 100,
    Default = 15
})

OptionsSection:Slider({
    Name = "Distance",
    Min = 0,
    Max = 1000,
    Default = 800
})

OptionsSection:Slider({
    Name = "Prediction X",
    Min = 0,
    Max = 10,
    Default = 7,
    Decimals = 3
})

OptionsSection:Slider({
    Name = "Prediction Y",
    Min = 0,
    Max = 10,
    Default = 7,
    Decimals = 3
})

OptionsSection:Label({
    Name = "Type"
})

OptionsSection:Dropdown({
    Name = "Target",
    Default = "Camera",
    Options = {"Camera", "Hitbox", "Head"}
})

-- Aimbot Section
local AimbotSection = AimPage:Section({
    Name = "Aimbot",
    Side = "Right"
})

AimbotSection:Toggle({
    Name = "Enabled"
})

AimbotSection:Toggle({
    Name = "Sticky Aim"
})

AimbotSection:Toggle({
    Name = "Visualize FOV"
})

AimbotSection:Toggle({
    Name = "Indicator"
})

AimbotSection:Toggle({
    Name = "Prediction"
})

AimbotSection:Label({
    Name = "Silent Aim"
})

AimbotSection:Toggle({
    Name = "Enabled"
})

AimbotSection:Toggle({
    Name = "Visualize FOV"
})

AimbotSection:Toggle({
    Name = "Indicator"
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
