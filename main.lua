-- Load the UI library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/lolxd8281989282/bnhsaunh218738h21nijda/refs/heads/main/Library.lua"))()

-- Load the ESP module
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/lolxd8281989282/bnhsaunh218738h21nijda/refs/heads/main/esp.lua"))()

-- Initialize ESP
ESP:Init()

-- Load and execute the UI, passing the Library and ESP module
loadstring(game:HttpGet("https://raw.githubusercontent.com/lolxd8281989282/bnhsaunh218738h21nijda/refs/heads/main/ui.lua"))()(Library, ESP)

print("Main script executed successfully")
