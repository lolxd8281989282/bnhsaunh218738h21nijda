return function(Window, Library, ESP)
    -- Create ESP section
    local Visuals = Window:Page({Name = "visuals"})
    local ESPSection = Visuals:Section({Name = "ESP", Side = "Left"})

    -- Add ESP toggles
    ESPSection:Toggle({Name = "Enabled", Default = ESP.Settings.Enabled, Pointer = "ESPEnabled"})
    ESPSection:Toggle({Name = "Show Names", Default = ESP.Settings.ShowNames, Pointer = "ShowNames"})
    ESPSection:Toggle({Name = "Show Boxes", Default = ESP.Settings.ShowBoxes, Pointer = "ShowBoxes"})
    ESPSection:Toggle({Name = "Show Health Bars", Default = ESP.Settings.ShowHealthBars, Pointer = "ShowHealthBars"})
    
    -- Add ESP customization
    ESPSection:Slider({Name = "Max Distance", Minimum = 100, Maximum = 2000, Default = ESP.Settings.Distance, Decimals = 0, Pointer = "Distance"})
    ESPSection:Colorpicker({Name = "Box Color", Info = "ESP Box Color", Default = ESP.Settings.BoxColor, Pointer = "BoxColor"})
    ESPSection:Colorpicker({Name = "Name Color", Info = "ESP Name Color", Default = ESP.Settings.NameColor, Pointer = "NameColor"})
    ESPSection:Colorpicker({Name = "Health Bar Color", Info = "ESP Health Bar Color", Default = ESP.Settings.HealthBarColor, Pointer = "HealthBarColor"})

    -- Update ESP settings when UI changes
    for _, pointer in pairs(Library.pointers) do
        if type(pointer) == "table" and type(pointer.Set) == "function" then
            local originalSet = pointer.Set
            pointer.Set = function(self, value)
                originalSet(self, value)
                -- Update ESP settings
                local setting = pointer.flag
                if ESP.Settings[setting] ~= nil then
                    ESP.Settings[setting] = value
                end
                return value
            end
        end
    end

    return ESP
end

