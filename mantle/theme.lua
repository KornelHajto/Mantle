-- mantle/theme.lua
local Theme = {
    -- Palette
    colors = {
        primary   = { 40, 40, 40, 255 },    -- Dark Gray
        accent    = { 200, 200, 200, 255 }, -- Light Gray
        text      = { 245, 245, 245, 255 }, -- White-ish
        highlight = { 60, 60, 60, 255 }     -- Hover color
    },

    -- Layout defaults
    padding = 10,
    fontSize = 20,
    font = nil -- Will load a custom font here later
}

return Theme
