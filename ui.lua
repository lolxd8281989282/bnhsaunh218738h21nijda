-- Load the Library
local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/lolxd8281989282/bnhsaunh218738h21nijda/refs/heads/main/Library.lua"))()
end)

if not success then
    warn("Failed to load Library:", Library)
    return
end

-- Create the window
local Window = Library:New({
    Name = "dracula.lol | beta",
    Accent = Color3.fromRGB(255, 255, 255)
})

-- Visual Page
local VisualPage = Window:Page({
    Name = "visuals"
})

-- Create sections for Enemies, Friendlies, Local, Extra
local EnemiesSection = VisualPage:Section({
    Name = "Enemies",
    Side = "Left"
})

local FriendliesSection = VisualPage:Section({
    Name = "Friendlies",
    Side = "Right"
})

local LocalSection = VisualPage:Section({
    Name = "Local",
    Side = "Left"
})

local ExtraSection = VisualPage:Section({
    Name = "Extra",
    Side = "Right"
})

-- Enemies Section
EnemiesSection:Toggle({
    Name = "Enabled"
})

EnemiesSection:Toggle({
    Name = "Name"
})

EnemiesSection:Toggle({
    Name = "Bounding Box"
})

EnemiesSection:Toggle({
    Name = "Health Bar"
})

EnemiesSection:Toggle({
    Name = "Health Number"
})

EnemiesSection:Toggle({
    Name = "Head Dot"
})

EnemiesSection:Toggle({
    Name = "Offscreen Arrows"
})

EnemiesSection:Slider({
    Name = "Arrow Size",
    Min = 0,
    Max = 100,
    Default = 50
})

EnemiesSection:Slider({
    Name = "Arrow Position",
    Min = 0,
    Max = 100,
    Default = 25
})

EnemiesSection:Dropdown({
    Name = "Arrow Types",
    Default = "None",
    Options = {"None", "Health Bar"}
})

EnemiesSection:Toggle({
    Name = "Tool"
})

EnemiesSection:Toggle({
    Name = "Distance"
})

EnemiesSection:Toggle({
    Name = "Flags"
})

EnemiesSection:Dropdown({
    Name = "Flag Types",
    Default = "Display Name",
    Options = {"Display Name", "Username"}
})

EnemiesSection:Toggle({
    Name = "Chams"
})

EnemiesSection:Dropdown({
    Name = "Chams Types",
    Default = "Inline",
    Options = {"Inline", "Outline"}
})

-- Friendlies Section (copy the same toggles and settings from Enemies section)
-- Local Section (copy the same toggles and settings, excluding Offscreen Arrows)
-- Extra Section
ExtraSection:Toggle({
    Name = "Disable Layered Clothing"
})

-- Other Pages (keeping them from the original UI)
local AimPage = Window:Page({
    Name = "aim"
})

local RagePage = Window:Page({
    Name = "rage"
})

local MiscPage = Window:Page({
    Name = "misc"
})

local PlayerPage = Window:Page({
    Name = "player-list"
})

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

-- Initialize the UI
Window:Initialize()
