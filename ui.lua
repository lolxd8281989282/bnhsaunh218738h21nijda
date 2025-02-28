-- Load the new library
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Consistt/Ui/main/UnLeaked"))()

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

-- Add more toggles for the Main section...

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

-- Add more toggles and sliders for the Visuals section...

-- Settings tab (assuming it's created by the library)
local SettingsTab = Init:NewTab("Settings")

-- Finalize
Notif:Notify("Successfully Initialized", 3, "success")
