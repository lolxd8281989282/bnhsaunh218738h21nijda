-- Create a function to load our modules
local function LoadModule(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    
    if not success then
        warn("Failed to load module from: " .. url)
        warn("Error: " .. tostring(result))
        return nil
    end
    
    return result
end

-- Load our modules with error handling
local Library = LoadModule("https://raw.githubusercontent.com/lolxd8281989282/bnhsaunh218738h21nijda/refs/heads/main/Library.lua")
if not Library then return end

local ESP = LoadModule("https://raw.githubusercontent.com/lolxd8281989282/bnhsaunh218738h21nijda/refs/heads/main/esp.lua")
if not ESP then return end

-- Initialize ESP
ESP:Init()

-- Load UI with error handling
local UI = LoadModule("https://raw.githubusercontent.com/lolxd8281989282/bnhsaunh218738h21nijda/refs/heads/main/ui.lua")
if not UI then return end

-- Execute UI with our loaded modules
UI(Library, ESP)

print("Script loaded successfully!")
