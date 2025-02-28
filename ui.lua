local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/lolxd8281989282/bnhsaunh218738h21nijda/refs/heads/main/Library.lua"))()
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/lolxd8281989282/bnhsaunh218738h21nijda/refs/heads/main/esp.lua"))() -- Update with your actual repo for ESP

-- Create the window
local Window = Library:New({
    Name = "dracula.lol | beta",
    Accent = Color3.fromRGB(255, 255, 255)
})

-- Create ESP Preview
local PreviewGui = Instance.new("ScreenGui")
PreviewGui.Name = "ESPPreview"
PreviewGui.Parent = game.CoreGui

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

-- Visual Page
local VisualPage = Window:Page({
    Name = "visuals"
})

-- Create tabs
local TabButtons = Instance.new("Frame")
TabButtons.Size = UDim2.new(1, 0, 0, 30)
TabButtons.BackgroundTransparency = 1
TabButtons.Parent = VisualPage.Container

local function CreateTab(name, position)
    local tab = Instance.new("TextButton")
    tab.Size = UDim2.new(0.25, -5, 1, 0)
    tab.Position = position
    tab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tab.Text = name
    tab.TextColor3 = Color3.fromRGB(255, 255, 255)
    tab.Font = Enum.Font.SourceSans
    tab.TextSize = 14
    tab.Parent = TabButtons
    return tab
end

local EnemiesTab = CreateTab("Enemies", UDim2.new(0, 0, 0, 0))
local FriendliesTab = CreateTab("Friendlies", UDim2.new(0.25, 0, 0, 0))
local LocalTab = CreateTab("Local", UDim2.new(0.5, 0, 0, 0))
local ExtraTab = CreateTab("Extra", UDim2.new(0.75, 0, 0, 0))

-- ESP Settings Section
local ESPSection = VisualPage:Section({
    Name = "ESP Settings",
    Side = "Left"
})

ESPSection:Toggle({
    Name = "Enabled",
    Default = false,
    Callback = function(Value)
        ESP.Enabled = Value
        UpdatePreview()
    end
})

ESPSection:Toggle({
    Name = "Name",
    Default = false,
    Callback = function(Value)
        ESP.ShowNames = Value
        UpdatePreview()
    end
})

ESPSection:Toggle({
    Name = "Bounding Box",
    Default = false,
    Callback = function(Value)
        ESP.ShowBoxes = Value
        UpdatePreview()
    end
})

ESPSection:Toggle({
    Name = "Health Bar",
    Default = false,
    Callback = function(Value)
        ESP.ShowHealthBars = Value
        UpdatePreview()
    end
})

ESPSection:Toggle({
    Name = "Health Number",
    Default = false,
    Callback = function(Value)
        ESP.ShowHealthText = Value
        UpdatePreview()
    end
})

ESPSection:Toggle({
    Name = "Head Dot",
    Default = false,
    Callback = function(Value)
        ESP.ShowHeadDot = Value
        UpdatePreview()
    end
})

ESPSection:Toggle({
    Name = "Tool",
    Default = false,
    Callback = function(Value)
        ESP.ShowEquippedItem = Value
        UpdatePreview()
    end
})

ESPSection:Toggle({
    Name = "Distance",
    Default = false,
    Callback = function(Value)
        ESP.ShowDistance = Value
        UpdatePreview()
    end
})

ESPSection:Slider({
    Name = "Max Distance",
    Min = 0,
    Max = 2000,
    Default = 1000,
    Callback = function(Value)
        ESP.Distance = Value
        UpdatePreview()
    end
})

-- Chams Section
local ChamsSection = VisualPage:Section({
    Name = "Chams",
    Side = "Right"
})

ChamsSection:Toggle({
    Name = "Enabled",
    Default = false,
    Callback = function(Value)
        ESP.Chams = Value
        UpdatePreview()
    end
})

ChamsSection:Dropdown({
    Name = "Chams Type",
    Default = "Outline",
    Options = {"Inline", "Outline"},
    Callback = function(Value)
        ESP.ChamsType = Value
        UpdatePreview()
    end
})

-- Colors Section
local ColorsSection = VisualPage:Section({
    Name = "Colors",
    Side = "Right"
})

ColorsSection:ColorPicker({
    Name = "Box Color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(Value)
        ESP.BoxColor = Value
        UpdatePreview()
    end
})

ColorsSection:ColorPicker({
    Name = "Name Color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(Value)
        ESP.NameColor = Value
        UpdatePreview()
    end
})

ColorsSection:ColorPicker({
    Name = "Health Bar Color",
    Default = Color3.fromRGB(0, 255, 0),
    Callback = function(Value)
        ESP.HealthBarColor = Value
        UpdatePreview()
    end
})

-- Extra Section
local ExtraSection = VisualPage:Section({
    Name = "Extra",
    Side = "Left"
})

ExtraSection:Toggle({
    Name = "Team Check",
    Default = false,
    Callback = function(Value)
        ESP.TeamCheck = Value
        UpdatePreview()
    end
})

ExtraSection:Toggle({
    Name = "Use Team Color",
    Default = false,
    Callback = function(Value)
        ESP.UseTeamColor = Value
        UpdatePreview()
    end
})

-- Aim Page
local AimPage = Window:Page({
    Name = "aim"
})

-- Aimbot Section
local AimbotSection = AimPage:Section({
    Name = "Aimbot",
    Side = "Left"
})

AimbotSection:Toggle({
    Name = "Enabled",
    Default = false,
    Callback = function(Value)
        -- Implement aimbot toggle
    end
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

RageSection:Toggle({
    Name = "Enabled",
    Default = false,
    Callback = function(Value)
        -- Implement rage toggle
    end
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

MiscSection:Toggle({
    Name = "Bhop",
    Default = false,
    Callback = function(Value)
        -- Implement bhop toggle
    end
})

-- Players Page
local PlayerPage = Window:Page({
    Name = "player-list"
})

-- Player List
local PlayerList = PlayerPage:PlayerList({})

-- Settings Page
local SettingsPage = Window:Page({
    Name = "settings"
})

-- Settings Section
local SettingsSection = SettingsPage:Section({
    Name = "Settings",
    Side = "Left"
})

SettingsSection:Keybind({
    Name = "Menu Key",
    Default = Enum.KeyCode.RightShift,
    Callback = function(Key)
        -- Implement menu key binding
    end
})

-- Config Section
local ConfigSection = SettingsPage:Section({
    Name = "Config",
    Side = "Right"
})

ConfigSection:Textbox({
    Name = "Config Name",
    Default = "",
    Placeholder = "Enter config name...",
    Callback = function(Value)
        -- Implement config name input
    end
})

ConfigSection:Dropdown({
    Name = "Config",
    Default = "None",
    Options = {"None"},
    Callback = function(Value)
        -- Implement config selection
    end
})

ConfigSection:Button({
    Name = "Load",
    Callback = function()
        -- Implement config loading
    end
})

ConfigSection:Button({
    Name = "Save",
    Callback = function()
        -- Implement config saving
    end
})

-- Preview update function
function UpdatePreview()
    -- Update the preview model based on current ESP settings
    local model = PreviewModel:FindFirstChild("PreviewCharacter")
    if not model then
        -- Create preview character if it doesn't exist
        model = Instance.new("Model")
        model.Name = "PreviewCharacter"
        
        local torso = Instance.new("Part")
        torso.Size = Vector3.new(2, 2, 1)
        torso.Position = Vector3.new(0, 0, 0)
        torso.Parent = model
        
        local head = Instance.new("Part")
        head.Size = Vector3.new(1, 1, 1)
        head.Position = Vector3.new(0, 1.5, 0)
        head.Parent = model
        
        model.Parent = PreviewModel
    end
    
    -- Update preview visuals based on ESP settings
    if ESP.Enabled then
        -- Update box
        if ESP.ShowBoxes then
            -- Draw box preview
        end
        
        -- Update health bar
        if ESP.ShowHealthBars then
            -- Draw health bar preview
        end
        
        -- Update name
        if ESP.ShowNames then
            -- Draw name preview
        end
        
        -- Update other visual elements...
    end
end

-- Initialize the UI
Window:Initialize()

-- Initial preview update
UpdatePreview()

return Window
