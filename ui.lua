local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/matas3535/gamesneeze/main/Library.lua"))()

local Window = Library:New({
    Name = "dracula.lol | beta",
})

-- Visual Page
local VisualPage = Window:Page({
    Name = "visuals"
})

-- Create the tab container
local EnemiesTab, FriendliesTab, LocalTab = VisualPage:MultiSection({
    Sections = {"Enemies", "Friendlies", "Local"},
    Side = "Left"
})

-- Enemies Tab Content
local EnemiesToggle = EnemiesTab:Toggle({
    Name = "Enabled",
    callback = function(value)
        print("Enemies ESP Enabled:", value)
    end
})

EnemiesTab:Toggle({
    Name = "Name",
    callback = function(value)
        print("Enemies Name ESP:", value)
    end
})

EnemiesTab:Toggle({
    Name = "Bounding Box",
    callback = function(value)
        print("Enemies Box ESP:", value)
    end
})

EnemiesTab:Toggle({
    Name = "Health Bar",
    callback = function(value)
        print("Enemies Health Bar:", value)
    end
})

EnemiesTab:Toggle({
    Name = "Health Number",
    callback = function(value)
        print("Enemies Health Number:", value)
    end
})

EnemiesTab:Toggle({
    Name = "Head Dot",
    callback = function(value)
        print("Enemies Head Dot:", value)
    end
})

EnemiesTab:Toggle({
    Name = "Offscreen Arrows",
    callback = function(value)
        print("Enemies Offscreen Arrows:", value)
    end
})

EnemiesTab:Slider({
    Name = "Arrow Size",
    Min = 0,
    Max = 100,
    Default = 50,
    callback = function(value)
        print("Enemies Arrow Size:", value)
    end
})

EnemiesTab:Slider({
    Name = "Arrow Position",
    Min = 0,
    Max = 100,
    Default = 25,
    callback = function(value)
        print("Enemies Arrow Position:", value)
    end
})

EnemiesTab:Dropdown({
    Name = "Arrow Types",
    Default = "None",
    Options = {"None", "Health Bar"},
    callback = function(value)
        print("Enemies Arrow Type:", value)
    end
})

EnemiesTab:Toggle({
    Name = "Tool",
    callback = function(value)
        print("Enemies Tool ESP:", value)
    end
})

EnemiesTab:Toggle({
    Name = "Distance",
    callback = function(value)
        print("Enemies Distance ESP:", value)
    end
})

EnemiesTab:Toggle({
    Name = "Flags",
    callback = function(value)
        print("Enemies Flags ESP:", value)
    end
})

EnemiesTab:Dropdown({
    Name = "Flag Types",
    Default = "Display Name",
    Options = {"Display Name", "Username"},
    callback = function(value)
        print("Enemies Flag Type:", value)
    end
})

EnemiesTab:Toggle({
    Name = "Chams",
    callback = function(value)
        print("Enemies Chams:", value)
    end
})

EnemiesTab:Dropdown({
    Name = "Chams Types",
    Default = "Inline",
    Options = {"Inline", "Outline"},
    callback = function(value)
        print("Enemies Chams Type:", value)
    end
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
    KeybindName = "UI Toggle",
    Mode = "Toggle",
    Callback = function(Input, State)
        print("UI Toggle:", Input, State)
    end
})

MainSettingsSection:Toggle({
    Name = "Disable Movement if Open",
    callback = function(value)
        print("Disable Movement:", value)
    end
})

MainSettingsSection:Button({
    Name = "Join Discord",
    callback = function()
        print("Join Discord button clicked")
    end
})

MainSettingsSection:Button({
    Name = "Copy Discord",
    callback = function()
        print("Copy Discord button clicked")
    end
})

MainSettingsSection:Button({
    Name = "Rejoin Server",
    callback = function()
        print("Rejoin Server button clicked")
    end
})

MainSettingsSection:Button({
    Name = "Copy Join Script",
    callback = function()
        print("Copy Join Script button clicked")
    end
})

MainSettingsSection:Button({
    Name = "Unload",
    callback = function()
        Window:Unload()
    end
})

-- Config Section
local ConfigSection = SettingsPage:Section({
    Name = "Config",
    Side = "Right"
})

ConfigSection:TextBox({
    Default = "",
    Placeholder = "Enter config name...",
    Max = 100,
    Callback = function(value)
        print("Config Name:", value)
    end
})

ConfigSection:Dropdown({
    Name = "Config",
    Default = "none",
    Options = {"none"},
    callback = function(value)
        print("Selected Config:", value)
    end
})

ConfigSection:Button({
    Name = "Load",
    callback = function()
        print("Load Config button clicked")
    end
})

ConfigSection:Button({
    Name = "Save",
    callback = function()
        print("Save Config button clicked")
    end
})

ConfigSection:Button({
    Name = "Create",
    callback = function()
        print("Create Config button clicked")
    end
})

ConfigSection:Button({
    Name = "Delete",
    callback = function()
        print("Delete Config button clicked")
    end
})

Window:Initialize()
