return function(Window, Library, ESP)
    -- Create ESP section
    local Visuals = Window:Page({Name = "visuals"})
    local ESPSection = Visuals:Section({Name = "ESP", Side = "Left"})

    -- Add ESP toggles with correct pointers matching ESP.Settings keys
    ESPSection:Toggle({Name = "Enabled", Default = ESP.Settings.Enabled, Pointer = "Enabled"})
    ESPSection:Toggle({Name = "Show Names", Default = ESP.Settings.ShowNames, Pointer = "ShowNames"})
    ESPSection:Toggle({Name = "Show Boxes", Default = ESP.Settings.ShowBoxes, Pointer = "ShowBoxes"})
    ESPSection:Toggle({Name = "Show Health Bars", Default = ESP.Settings.ShowHealthBars, Pointer = "ShowHealthBars"})
    
    -- Add ESP customization
    ESPSection:Slider({Name = "Max Distance", Minimum = 100, Maximum = 2000, Default = ESP.Settings.Distance, Decimals = 0, Pointer = "Distance"})
    ESPSection:Colorpicker({Name = "Box Color", Info = "ESP Box Color", Default = ESP.Settings.BoxColor, Pointer = "BoxColor"})
    ESPSection:Colorpicker({Name = "Name Color", Info = "ESP Name Color", Default = ESP.Settings.NameColor, Pointer = "NameColor"})
    ESPSection:Colorpicker({Name = "Health Bar Color", Info = "ESP Health Bar Color", Default = ESP.Settings.HealthBarColor, Pointer = "HealthBarColor"})

    -- Update ESP settings when UI changes
    for name, pointer in pairs(Library.pointers) do
        if type(pointer) == "table" and type(pointer.Set) == "function" then
            local originalSet = pointer.Set
            pointer.Set = function(self, value)
                originalSet(self, value)
                -- Update ESP settings using the pointer name
                if ESP.Settings[name] ~= nil then
                    ESP.Settings[name] = value
                    -- Force ESP update when settings change
                    ESP:UpdateESP()
                end
                return value
            end
        end
    end

    -- Initial settings update
    for name, pointer in pairs(Library.pointers) do
        if ESP.Settings[name] ~= nil and type(pointer.Get) == "function" then
            ESP.Settings[name] = pointer:Get()
        end
    end

    return ESP
end

