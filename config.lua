Config = {
    Item = "tracker", -- Item name to use as a tracker
    LiveSync = true, -- Sync the blips in real-time
    ShowSelf = true, -- Show the player's own blip

    Blip = {
        Settings = {
            color = 0, -- Color of the blip
            scale = 0.7, -- Scale of the blip
            display = 2, -- Display of the blip
            shortRange = false, -- Show the blip on the minimap
            showHeading = true, -- Show the heading with a small arrow
            showCone = true, -- Show a cone in the direction the entity is facing
            coneColor = { 255, 0, 0, 10 }, -- Color of the cone
            showCrewIndicator = true, -- Show a crew indicator
            showFriendIndicator = false, -- Show a friend indicator
        },

        Types = {
            ["default"] = 1, -- Default blip type
            ["dead"] = 84, -- Blip type for dead players
            ["automobile"] = 225, -- Blip type for cars
            ["bike"] = 226, -- Blip type for bikes
            ["boat"] = 427, -- Blip type for boats
            ["heli"] = 64, -- Blip type for helicopters
            ["plane"] = 423, -- Blip type for planes
        }
    }
}