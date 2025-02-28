local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/lolxd8281989282/bnhsaunh218738h21nijda/refs/heads/main/Library.lua"))()

-- Create the window
local Window = Library:New({
    Name = "dracula.lol | beta",
    Accent = Color3.fromRGB(255, 255, 255)
})

-- Visual Page
local VisualPage = Window:Page({
    Name = "visuals"
})

-- Visual Page Sections
local ESPSection = VisualPage:Section({
    Name = "ESP",
    Side = "Left"
})

-- Make sure all toggles have Default and Callback properties
ESPSection:Toggle({
    Name = "Enabled",
    Default = false,
    Callback = function(Value)
        -- Add callback functionality here
    end
})

ESPSection:Toggle({
    Name = "Team Check",
    Default = false,
    Callback = function(Value)
        -- Add callback functionality here
    end
})

ESPSection:Toggle({
    Name = "Outline",
    Default = false,
    Callback = function(Value)
        -- Add callback functionality here
    end
})

ESPSection:Toggle({
    Name = "Self ESP",
    Default = false,
    Callback = function(Value)
        -- Add callback functionality here
    end
})

ESPSection:Slider({
    Name = "Distance",
    Min = 0,
    Max = 2000,
    Default = 1000,
    Callback = function(Value)
        -- Add callback functionality here
    end
})

ESPSection:Label({
    Name = "Box"
})

ESPSection:Toggle({
    Name = "Enabled",
    Default = false,
    Callback = function(Value)
        -- Add callback functionality here
    end
})

ESPSection:Toggle({
    Name = "Fill Box",
    Default = false,
    Callback = function(Value)
        -- Add callback functionality here
    end
})

ESPSection:Dropdown({
    Name = "Box Type",
    Default = "Corners",
    Options = {"Corners", "Full", "3D"},
    Callback = function(Value)
        -- Add callback functionality here
    end
})

local OtherSection = VisualPage:Section({
    Name = "Other",
    Side = "Right"
})

OtherSection:Toggle({
    Name = "Equipped Item",
    Default = false,
    Callback = function(Value)
        -- Add callback functionality here
    end
})

OtherSection:Toggle({
    Name = "Skeleton",
    Default = false,
    Callback = function(Value)
        -- Add callback functionality here
    end
})

OtherSection:Toggle({
    Name = "Head Dot",
    Default = false,
    Callback = function(Value)
        -- Add callback functionality here
    end
})

OtherSection:Toggle({
    Name = "Distance",
    Default = false,
    Callback = function(Value)
        -- Add callback functionality here
    end
})

OtherSection:Toggle({
    Name = "Armor Bar",
    Default = false,
    Callback = function(Value)
        -- Add callback functionality here
    end
})

OtherSection:Label({
    Name = "Name"
})

OtherSection:Toggle({
    Name = "Enabled",
    Default = false,
    Callback = function(Value)
        -- Add callback functionality here
    end
})

-- Aimbot Page
local AimPage = Window:Page({
    Name = "aim"
})

-- Aimbot Section
local AimbotSection = AimPage:Section({
    Name = "Aimbot",
    Side = "Left"
})

-- Rage Page
local RagePage = Window:Page({
    Name = "rage"
})

-- Rage Section
local RageSection = RagePage:Section({
    Name = "Rage",
    Side = "Left"
})

-- Misc Page
local MiscPage = Window:Page({
    Name = "misc"
})

-- Misc Section
local MiscSection = MiscPage:Section({
    Name = "Misc",
    Side = "Left"
})

-- Players Page
local PlayerPage = Window:Page({
    Name = "player-list"
})

local PlayerList = PlayerPage:PlayerList({})

-- Settings Page
local SettingsPage = Window:Page({
    Name = "settings"
})

-- Settings Section
local MainSettingsSection = SettingsPage:Section({
    Name = "Main",
    Side = "Left"
})

MainSettingsSection:Keybind({
    Name = "Open / Close",
    Default = Enum.KeyCode.RightShift,
    Callback = function(Key)
        -- Add callback functionality here
    end
})

-- Initialize the window first
Window:Initialize()

-- Then create ESP Preview
local PreviewGui = Instance.new("ScreenGui")
PreviewGui.Name = "ESPPreview"
PreviewGui.Parent = game:GetService("CoreGui")

local PreviewFrame = Instance.new("Frame")
PreviewFrame.Name = "PreviewFrame"
PreviewFrame.Size = UDim2.new(0, 200, 0, 300)
PreviewFrame.Position = UDim2.new(1, -220, 0.5, -150)
PreviewFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
PreviewFrame.BorderSizePixel = 0
PreviewFrame.Parent = PreviewGui

local PreviewTitle = Instance.new("TextLabel")
PreviewTitle.Name = "Title"
PreviewTitle.Size = UDim2.new(1, 0, 0, 30)
PreviewTitle.BackgroundTransparency = 1
PreviewTitle.Text = "ESP Preview"
PreviewTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
PreviewTitle.TextSize = 14
PreviewTitle.Font = Enum.Font.SourceSansBold
PreviewTitle.Parent = PreviewFrame

local PreviewContent = Instance.new("Frame")
PreviewContent.Name = "Content"
PreviewContent.Size = UDim2.new(1, -20, 1, -40)
PreviewContent.Position = UDim2.new(0, 10, 0, 30)
PreviewContent.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
PreviewContent.BorderSizePixel = 0
PreviewContent.Parent = PreviewFrame

local PreviewModel = Instance.new("ViewportFrame")
PreviewModel.Name = "Model"
PreviewModel.Size = UDim2.new(1, 0, 1, 0)
PreviewModel.BackgroundTransparency = 1
PreviewModel.Parent = PreviewContent

return Window
