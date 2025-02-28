local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/lolxd8281989282/bnhsaunh218738h21nijda/refs/heads/main/Library.lua"))()

local Window = Library:New({
    Name = "dracula.lol | beta",
    Accent = Color3.fromRGB(255, 255, 255) -- Change accent to white
})

-- Visual Page
local VisualPage = Window:Page({
    Name = "visuals"
})

-- Create tabs for Enemies, Friendlies, Local, Extra
local TabContainer = VisualPage:TabContainer({
    Side = "Top"
})

-- Enemies Tab
local EnemiesTab = TabContainer:Tab({
    Name = "Enemies"
})

local EnemiesSection = EnemiesTab:Section({
    Name = "",
    Side = "Left"
})

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

-- Friendlies Tab
local FriendliesTab = TabContainer:Tab({
    Name = "Friendlies"
})

local FriendliesSection = FriendliesTab:Section({
    Name = "",
    Side = "Left"
})

-- Copy the same toggles and settings from Enemies tab
FriendliesSection:Toggle({
    Name = "Enabled"
})

FriendliesSection:Toggle({
    Name = "Name"
})

FriendliesSection:Toggle({
    Name = "Bounding Box"
})

FriendliesSection:Toggle({
    Name = "Health Bar"
})

FriendliesSection:Toggle({
    Name = "Health Number"
})

FriendliesSection:Toggle({
    Name = "Head Dot"
})

FriendliesSection:Toggle({
    Name = "Offscreen Arrows"
})

FriendliesSection:Slider({
    Name = "Arrow Size",
    Min = 0,
    Max = 100,
    Default = 50
})

FriendliesSection:Slider({
    Name = "Arrow Position",
    Min = 0,
    Max = 100,
    Default = 25
})

FriendliesSection:Dropdown({
    Name = "Arrow Types",
    Default = "None",
    Options = {"None", "Health Bar"}
})

FriendliesSection:Toggle({
    Name = "Tool"
})

FriendliesSection:Toggle({
    Name = "Distance"
})

FriendliesSection:Toggle({
    Name = "Flags"
})

FriendliesSection:Dropdown({
    Name = "Flag Types",
    Default = "Display Name",
    Options = {"Display Name", "Username"}
})

FriendliesSection:Toggle({
    Name = "Chams"
})

FriendliesSection:Dropdown({
    Name = "Chams Types",
    Default = "Inline",
    Options = {"Inline", "Outline"}
})

-- Local Tab
local LocalTab = TabContainer:Tab({
    Name = "Local"
})

local LocalSection = LocalTab:Section({
    Name = "",
    Side = "Left"
})

-- Copy the same toggles and settings
LocalSection:Toggle({
    Name = "Enabled"
})

LocalSection:Toggle({
    Name = "Name"
})

LocalSection:Toggle({
    Name = "Bounding Box"
})

LocalSection:Toggle({
    Name = "Health Bar"
})

LocalSection:Toggle({
    Name = "Health Number"
})

LocalSection:Toggle({
    Name = "Head Dot"
})

LocalSection:Toggle({
    Name = "Tool"
})

LocalSection:Toggle({
    Name = "Distance"
})

LocalSection:Toggle({
    Name = "Flags"
})

LocalSection:Dropdown({
    Name = "Flag Types",
    Default = "Display Name",
    Options = {"Display Name", "Username"}
})

LocalSection:Toggle({
    Name = "Chams"
})

LocalSection:Dropdown({
    Name = "Chams Types",
    Default = "Inline",
    Options = {"Inline", "Outline"}
})

-- Extra Tab
local ExtraTab = TabContainer:Tab({
    Name = "Extra"
})

local ExtraSection = ExtraTab:Section({
    Name = "",
    Side = "Left"
})

ExtraSection:Toggle({
    Name = "Disable Layered Clothing"
})

-- Other Pages (keeping them from the original UI)
local AimPage = Window:Page({
    Name = "aim"
})

-- Aimbot Page Sections
local AimbotSection = AimPage:Section({
    Name = "Aimbot",
    Side = "Left"
})

local RagePage = Window:Page({
    Name = "rage"
})

-- Rage Page Sections
local RageSection = RagePage:Section({
    Name = "Rage",
    Side = "Left"
})

local MiscPage = Window:Page({
    Name = "misc"
})

-- Misc Page Sections
local MiscSection = MiscPage:Section({
    Name = "Misc",
    Side = "Left"
})

local PlayerPage = Window:Page({
    Name = "player-list"
})

-- Keep the existing PlayerList function
local PlayerList = PlayerPage:PlayerList({})

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
