local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/matas3535/gamesneeze/main/Library.lua"))()

local Window = Library:New({
    Name = "dracula.lol | beta"
})

-- Visual Page
local VisualPage = Window:Page({
    Name = "visuals"
})

-- Create the sections using MultiSection
local EnemiesTab, FriendliesTab, LocalTab, ExtraTab = VisualPage:MultiSection({
    Sections = {"Enemies", "Friendlies", "Local", "Extra"},
    Side = "Left"
})

-- Enemies Tab Content
EnemiesTab:Toggle({
    Name = "Enabled"
})

EnemiesTab:Toggle({
    Name = "Name"
})

EnemiesTab:Toggle({
    Name = "Bounding Box"
})

EnemiesTab:Toggle({
    Name = "Health Bar"
})

EnemiesTab:Toggle({
    Name = "Health Number"
})

EnemiesTab:Toggle({
    Name = "Head Dot"
})

EnemiesTab:Toggle({
    Name = "Offscreen Arrows"
})

EnemiesTab:Slider({
    Name = "Arrow Size",
    Min = 0,
    Max = 100,
    Default = 50,
    Suffix = "/100"
})

EnemiesTab:Slider({
    Name = "Arrow Position",
    Min = 0,
    Max = 100,
    Default = 25,
    Suffix = "/100"
})

EnemiesTab:Dropdown({
    Name = "Arrow Types",
    Default = "None",
    Options = {"None", "Health Bar"}
})

EnemiesTab:Toggle({
    Name = "Tool"
})

EnemiesTab:Toggle({
    Name = "Distance"
})

EnemiesTab:Toggle({
    Name = "Flags"
})

EnemiesTab:Dropdown({
    Name = "Flag Types",
    Default = "Display Name",
    Options = {"Display Name", "Username"}
})

EnemiesTab:Toggle({
    Name = "Chams"
})

EnemiesTab:Dropdown({
    Name = "Chams Types",
    Default = "Inline",
    Options = {"Inline", "Outline"}
})

-- Friendlies Tab Content (copy same structure as Enemies)
-- Local Tab Content (copy same structure, excluding arrows)

-- Extra Tab Content
ExtraTab:Toggle({
    Name = "Disable Layered Clothing"
})

-- Other Pages
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
    KeybindName = "UI Toggle",
    Mode = "Toggle"
})

MainSettingsSection:Toggle({
    Name = "Disable Movement if Open"
})

MainSettingsSection:Button({
    Name = "Join Discord"
})

MainSettingsSection:Button({
    Name = "Copy Discord"
})

MainSettingsSection:Button({
    Name = "Rejoin Server"
})

MainSettingsSection:Button({
    Name = "Copy Join Script"
})

MainSettingsSection:Button({
    Name = "Unload"
})

-- Config Section
local ConfigSection = SettingsPage:Section({
    Name = "Config",
    Side = "Right"
})

ConfigSection:TextBox({
    Default = "",
    Placeholder = "Enter config name...",
    Max = 100
})

ConfigSection:Dropdown({
    Name = "Config",
    Default = "none",
    Options = {"none"}
})

ConfigSection:Button({
    Name = "Load"
})

ConfigSection:Button({
    Name = "Save"
})

ConfigSection:Button({
    Name = "Create"
})

ConfigSection:Button({
    Name = "Delete"
})

Window:Initialize()
