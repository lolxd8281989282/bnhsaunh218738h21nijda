-- Load the UI library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/lolxd8281989282/bnhsaunh218738h21nijda/refs/heads/main/Library.lua"))()

-- Load the ESP module
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/lolxd8281989282/bnhsaunh218738h21nijda/refs/heads/main/esp.lua"))()

-- Load and execute the UI
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/lolxd8281989282/bnhsaunh218738h21nijda/refs/heads/main/ui.lua"))()
local Window = UI()  -- Execute the UI function to get the Window object

-- Initialize the UI
if Window and type(Window.Initialize) == "function" then
    Window:Initialize()
else
    warn("Failed to initialize UI: Window object or Initialize function not found")
end

-- Initialize ESP
if ESP and type(ESP.Initialize) == "function" then
    ESP:Initialize()
else
    warn("Failed to initialize ESP: ESP object or Initialize function not found")
end

print("Main script executed successfully")

