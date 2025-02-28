-- Load the new library
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Consistt/Ui/main/UnLeaked"))()

-- Set your logo's asset ID
library.logo = "http://www.roblox.com/asset/?id=101603088342043"

-- Set up initial configuration
library.rank = "developer"
local Wm = library:Watermark("dracula.lol | v" .. library.version .. " | " .. library:GetUsername() .. " | rank: " .. library.rank)
local FpsWm = Wm:AddWatermark("fps: " .. library.fps)
coroutine.wrap(function()
    while wait(.75) do
        FpsWm:Text("fps: " .. library.fps)
    end
end)()

-- Set up notifications
local Notif = library:InitNotifications()

-- Initialize the library
library.title = "dracula.lol | beta"
library:Introduction()
wait(1)
local Init = library:Init()

-- Create the Legit tab
local LegitTab = Init:NewTab("Legit")

-- Main Section
local MainSection = LegitTab:NewSection("Main")

MainSection:NewToggle("Enabled", false, function(value)
    -- Your enabled logic here
end)

MainSection:NewToggle("Silent", false, function(value)
    -- Your silent logic here
end)

MainSection:NewToggle("Camlock", false, function(value)
    -- Your camlock logic here
end)

MainSection:NewToggle("Anti Aim Viewer", false, function(value)
    -- Your anti aim viewer logic here
end)

MainSection:NewToggle("Gun TP", false, function(value)
    -- Your gun TP logic here
end)

MainSection:NewToggle("Closest Part", false, function(value)
    -- Your closest part logic here
end)

MainSection:NewToggle("Apply Closest Part On GetClo", false, function(value)
    -- Your apply closest part logic here
end)

MainSection:NewToggle("Smoothing", false, function(value)
    -- Your smoothing logic here
end)

MainSection:NewToggle("Alerts", false, function(value)
    -- Your alerts logic here
end)

MainSection:NewToggle("Auto Prediction", false, function(value)
    -- Your auto prediction logic here
end)

MainSection:NewToggle("Use Field of View", false, function(value)
    -- Your use field of view logic here
end)

MainSection:NewToggle("Visualize FOV", false, function(value)
    -- Your visualize FOV logic here
end)

MainSection:NewToggle("Use Checks", false, function(value)
    -- Your use checks logic here
end)

MainSection:NewDropdown("Aim Part", {"HumanoidRootPart"}, function(value)
    -- Your aim part logic here
end)

MainSection:NewDropdown("Checks", {"..."}, function(value)
    -- Your checks logic here
end)

MainSection:NewSlider("Field of View Radius", 0, 800, 80, function(value)
    -- Your FOV radius logic here
end)

MainSection:NewSlider("Alerts Duration", 0, 10, 4, function(value)
    -- Your alerts duration logic here
end)

MainSection:NewSlider("Smoothing Amount", 0, 7, 15, function(value)
    -- Your smoothing amount logic here
end)

-- Visuals Section
local VisualsSection = LegitTab:NewSection("Visuals")

VisualsSection:NewToggle("Enabled", false, function(value)
    -- Your visuals enabled logic here
end)

VisualsSection:NewLabel("Misc")

VisualsSection:NewToggle("Tracer", false, function(value)
    -- Your tracer logic here
end)

VisualsSection:NewToggle("Auto Select", false, function(value)
    -- Your auto select logic here
end)

VisualsSection:NewToggle("Resolver", false, function(value)
    -- Your resolver logic here
end)

VisualsSection:NewToggle("Jump Offset (AIR)", false, function(value)
    -- Your jump offset logic here
end)

VisualsSection:NewToggle("Spectate", false, function(value)
    -- Your spectate logic here
end)

VisualsSection:NewToggle("Air", false, function(value)
    -- Your air logic here
end)

VisualsSection:NewToggle("Anti Groundshots (AIR)", false, function(value)
    -- Your anti groundshots logic here
end)

VisualsSection:NewSlider("Refresh Rate", 0, 200, 200, function(value)
    -- Your refresh rate logic here
end)

VisualsSection:NewSlider("To Take Off", 0, 1, 0.4, function(value)
    -- Your to take off logic here
end)

VisualsSection:NewSlider("Jump Offset", 0, 4, 0.09, function(value)
    -- Your jump offset logic here
end)

VisualsSection:NewSlider("Dot Size", 0, 10, 6, function(value)
    -- Your dot size logic here
end)

VisualsSection:NewSlider("Part Transparency", 0, 1, 0.05, function(value)
    -- Your part transparency logic here
end)

VisualsSection:NewSlider("Part Size", 0, 20, 2, function(value)
    -- Your part size logic here
end)

VisualsSection:NewSlider("Circle Size", 0, 10, 2, function(value)
    -- Your circle size logic here
end)

VisualsSection:NewToggle("Part Material", false, function(value)
    -- Your part material logic here
end)

VisualsSection:NewToggle("Neon", false, function(value)
    -- Your neon logic here
end)

-- Settings tab (assuming it's created by the library)
local SettingsTab = Init:NewTab("Settings")

-- Finalize
Notif:Notify("Successfully Initialized", 3, "success")
