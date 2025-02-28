local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/lolxd8281989282/bnhsaunh218738h21nijda/refs/heads/main/Library.lua"))()

local Window = Library:New({
    Name = "dracula.lol | beta",
    Accent = Color3.fromRGB(255, 255, 255)
})

-- Visual Page
local VisualPage = Window:Page({
    Name = "visuals"
})

-- ESP Section
local ESPSection = VisualPage:Section({
    Name = "ESP",
    Side = "Left"
})

ESPSection:Toggle({
    Name = "Enabled",
})

ESPSection:Toggle({
    Name = "Team Check",
})

ESPSection:Toggle({
    Name = "Outline",
})

ESPSection:Toggle({
    Name = "Self ESP",
})

ESPSection:Slider({
    Name = "Distance",
    Min = 0,
    Max = 2000,
    Default = 1000,
})

ESPSection:Label({
    Name = "Box",
})

ESPSection:Toggle({
    Name = "Enabled",
})

ESPSection:Toggle({
    Name = "Fill Box",
})

ESPSection:Dropdown({
    Name = "Box Type",
    Default = "Corners",
    Options = {"Corners", "Full", "3D"},
})

-- Local ESP Section
local LocalESPSection = VisualPage:Section({
    Name = "Local ESP",
    Side = "Right"
})

LocalESPSection:Toggle({
    Name = "Enabled",
})

LocalESPSection:Toggle({
    Name = "Viewmodel Chams",
})

LocalESPSection:Toggle({
    Name = "Weapon Chams",
})

LocalESPSection:ColorPicker({
    Name = "Viewmodel Color",
    Default = Color3.fromRGB(255, 0, 0),
})

LocalESPSection:ColorPicker({
    Name = "Weapon Color",
    Default = Color3.fromRGB(0, 255, 0),
})

-- Other Section
local OtherSection = VisualPage:Section({
    Name = "Other",
    Side = "Right"
})

OtherSection:Toggle({
    Name = "Equipped Item",
})

OtherSection:Toggle({
    Name = "Skeleton",
})

OtherSection:Toggle({
    Name = "Head Dot",
})

OtherSection:Toggle({
    Name = "Distance",
})

OtherSection:Toggle({
    Name = "Armor Bar",
})

OtherSection:Label({
    Name = "Name",
})

OtherSection:Toggle({
    Name = "Enabled",
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

-- Misc Page Sections
local MiscSection = MiscPage:Section({
    Name = "Misc",
    Side = "Left"
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

-- Add Config Section
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

Window:Initialize()

return Window
