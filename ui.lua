local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/matas3535/gamesneeze/main/Library.lua"))()

local Window = Library:New({
    Name = "dracula.lol | beta"
})

-- Visual Page
local VisualPage = Window:Page({
    Name = "visuals"
})

-- Create the sections using MultiSection
local EnemiesTab, FriendliesTab, LocalTab = VisualPage:MultiSection({
    Sections = {"Enemies", "Friendlies", "Local"},
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

-- Create other pages
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
    Mode = "Toggle"
})

-- Config Section
local ConfigSection = SettingsPage:Section({
    Name = "Config",
    Side = "Right"
})

-- Add ESP Preview visibility logic
VisualPage.callback = function()
    -- Show ESP Preview
    if Window.VisualPreview then
        Window.VisualPreview:SetPreviewState(true)
    end
end

-- Hide ESP Preview when switching to other pages
AimPage.callback = function()
    if Window.VisualPreview then
        Window.VisualPreview:SetPreviewState(false)
    end
end

RagePage.callback = function()
    if Window.VisualPreview then
        Window.VisualPreview:SetPreviewState(false)
    end
end

MiscPage.callback = function()
    if Window.VisualPreview then
        Window.VisualPreview:SetPreviewState(false)
    end
end

PlayerPage.callback = function()
    if Window.VisualPreview then
        Window.VisualPreview:SetPreviewState(false)
    end
end

SettingsPage.callback = function()
    if Window.VisualPreview then
        Window.VisualPreview:SetPreviewState(false)
    end
end

Window:Initialize()
