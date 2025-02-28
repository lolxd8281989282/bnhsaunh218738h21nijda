-- Debug: Print when the script starts
print("Starting ui.lua script")

-- Load the Library first and wait for it
local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/lolxd8281989282/bnhsaunh218738h21nijda/refs/heads/main/Library.lua"))()
end)

if not success then
    warn("Failed to load Library:", Library)
    return
else
    print("Library loaded successfully:", Library)
end

-- Load the ESP module
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/YourGitHubUsername/YourRepository/main/esp.lua"))()

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
    Callback = function(Value)
        ESP.Enabled = Value
    end
})

ESPSection:Toggle({
    Name = "Team Check",
    Callback = function(Value)
        ESP.TeamCheck = Value
    end
})

ESPSection:Toggle({
    Name = "Box ESP",
    Callback = function(Value)
        ESP.ShowBoxes = Value
    end
})

ESPSection:Toggle({
    Name = "Name ESP",
    Callback = function(Value)
        ESP.ShowNames = Value
    end
})

ESPSection:Toggle({
    Name = "Health Bar",
    Callback = function(Value)
        ESP.ShowHealthBars = Value
    end
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

local SettingsPage = Window:Page({
    Name = "settings"
})

-- Debug: Print before initializing the window
print("About to initialize the window")

-- Initialize the window
Window:Initialize()

-- Debug: Print after initializing the window
print("Window initialized")

-- Create ESP Preview
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

    print("ESP Preview created")
end

-- Create the preview
CreateESPPreview()

print("ui.lua script completed")

return Window

