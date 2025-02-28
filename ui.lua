local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/lolxd8281989282/bnhsaunh218738h21nijda/refs/heads/main/Library.lua"))()
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/lolxd8281989282/bnhsaunh218738h21nijda/refs/heads/main/esp.lua"))() -- Update with your actual repo for ESP

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
  Default = false,
  Callback = function(Value)
    ESP.Enabled = Value
  end
})

ESPSection:Toggle({
  Name = "Team Check",
  Default = false,
  Callback = function(Value)
    ESP.TeamCheck = Value
  end
})

ESPSection:Toggle({
  Name = "Outline",
  Default = false,
  Callback = function(Value)
    ESP.Outline = Value
  end
})

ESPSection:Toggle({
  Name = "Self ESP",
  Default = false,
  Callback = function(Value)
    ESP.SelfESP = Value
  end
})

ESPSection:Slider({
  Name = "Distance",
  Min = 0,
  Max = 2000,
  Default = 1000,
  Callback = function(Value)
    ESP.Distance = Value
  end
})

-- Box Section
local BoxSection = VisualPage:Section({
  Name = "Box",
  Side = "Left"
})

BoxSection:Toggle({
  Name = "Enabled",
  Default = false,
  Callback = function(Value)
    ESP.ShowBoxes = Value
  end
})

BoxSection:Toggle({
  Name = "Fill Box",
  Default = false,
  Callback = function(Value)
    ESP.FillBox = Value
  end
})

BoxSection:Dropdown({
  Name = "Box Type",
  Default = "Corners",
  Options = {"Corners", "Full"},
  Callback = function(Value)
    ESP.BoxType = Value
  end
})

-- Other Section
local OtherSection = VisualPage:Section({
  Name = "Other",
  Side = "Right"
})

OtherSection:Toggle({
  Name = "Equipped Item",
  Default = false,
  Callback = function(Value)
    ESP.ShowEquippedItem = Value
  end
})

OtherSection:Toggle({
  Name = "Skeleton",
  Default = false,
  Callback = function(Value)
    ESP.ShowSkeleton = Value
  end
})

OtherSection:Toggle({
  Name = "Head Dot",
  Default = false,
  Callback = function(Value)
    ESP.ShowHeadDot = Value
  end
})

OtherSection:Toggle({
  Name = "Distance",
  Default = false,
  Callback = function(Value)
    ESP.ShowDistance = Value
  end
})

OtherSection:Toggle({
  Name = "Health Bar",
  Default = false,
  Callback = function(Value)
    ESP.ShowHealthBars = Value
  end
})

OtherSection:Toggle({
  Name = "Armor Bar",
  Default = false,
  Callback = function(Value)
    ESP.ShowArmorBar = Value
  end
})

-- Name Section
local NameSection = VisualPage:Section({
  Name = "Name",
  Side = "Right"
})

NameSection:Toggle({
  Name = "Enabled",
  Default = false,
  Callback = function(Value)
    ESP.ShowNames = Value
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

Window:Initialize()
