-- Load the UI library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/lolxd8281989282/bnhsaunh218738h21nijda/refs/heads/main/Library.lua"))()

-- Load the ESP module
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/lolxd8281989282/bnhsaunh218738h21nijda/refs/heads/main/esp.lua"))()

-- Create the window
local Window = Library:New({Name = "dracula.lol | beta", Accent = Color3.fromRGB(255, 255, 255)})

-- Load and execute the UI
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/lolxd8281989282/bnhsaunh218738h21nijda/refs/heads/main/ui.lua"))()
if type(UI) == "function" then
    UI(Window, Library, ESP)
else
    warn("UI script did not return a function")
end

-- Initialize the UI
Window:Initialize()

print("Main script executed successfully")
