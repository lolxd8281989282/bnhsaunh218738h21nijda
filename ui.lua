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

-- Create ESP Preview after window initialization
local function CreateESPPreview()
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

    return PreviewModel
end

-- Initialize the UI first
Window:Initialize()

-- Create ESP Preview after UI initialization
local PreviewModel = CreateESPPreview()

return Window
