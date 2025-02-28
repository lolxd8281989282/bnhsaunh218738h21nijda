local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/matas3535/gamesneeze/main/Library.lua"))()

local Window = Library:New({
    Name = "dracula.lol | beta",
    Style = 1,
    PageAmmount = 6,
    Size = Vector2.new(554, 629),
    Accent = Color3.fromRGB(255, 255, 255)
})

-- Visual Page
local VisualPage = Window:Page({
    Name = "visuals"
})

-- Create the tab container
local TabContainer = VisualPage:MultiSection({
    Sections = {"Enemies", "Friendlies", "Local"},
    Side = "Left",
    Fill = true
})

local EnemiesTab, FriendliesTab, LocalTab = TabContainer[1], TabContainer[2], TabContainer[3]

-- Enemies Tab Content
EnemiesTab:Toggle({
    Name = "Enabled",
    Default = false,
    Flag = "EnemiesESPEnabled"
})

EnemiesTab:Toggle({
    Name = "Name",
    Default = false,
    Flag = "EnemiesESPName"
})

EnemiesTab:Toggle({
    Name = "Bounding Box",
    Default = false,
    Flag = "EnemiesESPBox"
})

EnemiesTab:Toggle({
    Name = "Health Bar",
    Default = false,
    Flag = "EnemiesESPHealthBar"
})

EnemiesTab:Toggle({
    Name = "Health Number",
    Default = false,
    Flag = "EnemiesESPHealthNumber"
})

EnemiesTab:Toggle({
    Name = "Head Dot",
    Default = false,
    Flag = "EnemiesESPHeadDot"
})

EnemiesTab:Toggle({
    Name = "Offscreen Arrows",
    Default = false,
    Flag = "EnemiesESPArrows"
})

EnemiesTab:Slider({
    Name = "Arrow Size",
    Default = 50,
    Min = 0,
    Max = 100,
    Flag = "EnemiesESPArrowSize"
})

EnemiesTab:Slider({
    Name = "Arrow Position",
    Default = 25,
    Min = 0,
    Max = 100,
    Flag = "EnemiesESPArrowPosition"
})

EnemiesTab:Dropdown({
    Name = "Arrow Types",
    Default = "None",
    Options = {"None", "Health Bar"},
    Flag = "EnemiesESPArrowType"
})

EnemiesTab:Toggle({
    Name = "Tool",
    Default = false,
    Flag = "EnemiesESPTool"
})

EnemiesTab:Toggle({
    Name = "Distance",
    Default = false,
    Flag = "EnemiesESPDistance"
})

EnemiesTab:Toggle({
    Name = "Flags",
    Default = false,
    Flag = "EnemiesESPFlags"
})

EnemiesTab:Dropdown({
    Name = "Flag Types",
    Default = "Display Name",
    Options = {"Display Name", "Username"},
    Flag = "EnemiesESPFlagType"
})

EnemiesTab:Toggle({
    Name = "Chams",
    Default = false,
    Flag = "EnemiesESPChams"
})

EnemiesTab:Dropdown({
    Name = "Chams Types",
    Default = "Inline",
    Options = {"Inline", "Outline"},
    Flag = "EnemiesESPChamsType"
})

-- Friendlies Tab Content (copy same structure as Enemies)
-- Local Tab Content (copy relevant toggles and settings, excluding arrows)

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

-- Players Page with PlayerList
local PlayerPage = Window:Page({
    Name = "player-list"
})

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
    Flag = "UIToggleKey"
})

MainSettingsSection:Toggle({
    Name = "Disable Movement if Open",
    Default = false,
    Flag = "DisableMovementWhenOpen"
})

MainSettingsSection:Button({
    Name = "Join Discord",
    Callback = function()
        -- Add discord join logic here
    end
})

MainSettingsSection:Button({
    Name = "Copy Discord",
    Callback = function()
        -- Add discord copy logic here
    end
})

MainSettingsSection:Button({
    Name = "Rejoin Server",
    Callback = function()
        -- Add rejoin server logic here
    end
})

MainSettingsSection:Button({
    Name = "Copy Join Script",
    Callback = function()
        -- Add copy join script logic here
    end
})

MainSettingsSection:Button({
    Name = "Unload",
    Callback = function()
        Window:Unload()
    end
})

-- Config Section
local ConfigSection = SettingsPage:Section({
    Name = "Config",
    Side = "Right"
})

ConfigSection:TextBox({
    Name = "Config Name",
    Default = "",
    Placeholder = "Enter config name...",
    Flag = "ConfigName"
})

ConfigSection:Dropdown({
    Name = "Config",
    Default = "none",
    Options = {"none"},
    Flag = "SelectedConfig"
})

ConfigSection:Button({
    Name = "Load",
    Callback = function()
        local configName = Flags.SelectedConfig
        if configName ~= "none" then
            Window:LoadConfig(configName)
        end
    end
})

ConfigSection:Button({
    Name = "Save",
    Callback = function()
        local configName = Flags.ConfigName
        if configName ~= "" then
            local config = Window:GetConfig()
            -- Add logic to save the config
        end
    end
})

ConfigSection:Button({
    Name = "Create",
    Callback = function()
        local configName = Flags.ConfigName
        if configName ~= "" then
            local config = Window:GetConfig()
            -- Add logic to create a new config
        end
    end
})

ConfigSection:Button({
    Name = "Delete",
    Callback = function()
        local configName = Flags.SelectedConfig
        if configName ~= "none" then
            -- Add logic to delete the selected config
        end
    end
})

Window:Initialize()
