-- Load the UI library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/lolxd8281989282/bnhsaunh218738h21nijda/refs/heads/main/Library.lua"))()

-- Load the ESP module
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/lolxd8281989282/bnhsaunh218738h21nijda/refs/heads/main/esp.lua"))()

-- Create the main window
local Window = Library:New({
    Name = "dracula.lol | beta",
    Accent = Color3.fromRGB(255, 255, 255)
})

-- Create the Visual page
local VisualPage = Window:Page({
    Name = "visuals"
})

-- Create the ESP section
local ESPSection = VisualPage:Section({
    Name = "ESP",
    Side = "Left"
})

-- Add the ESP toggle
ESPSection:Toggle({
    Name = "Enabled",
    Callback = function(Value)
        ESP:Toggle(Value)
    end
})

-- Add other UI elements as needed (you can copy them from your existing ui.lua)

-- Initialize the UI
Window:Initialize()
