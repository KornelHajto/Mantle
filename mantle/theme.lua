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
    font = nil, -- Will load a custom font here later

    -- Per-widget default styles (can be overridden per instance)
    styles = {
        Button = {
            borderRadius    = 0.15, -- 0.0 - 1.0 rounded rectangle
            backgroundColor = nil,  -- falls back to Theme.colors.primary
            textColor       = nil,  -- falls back to Theme.colors.text
            borderColor     = nil,  -- falls back to Theme.colors.accent
            hoverColor      = nil,  -- falls back to Theme.colors.highlight
            activeColor     = nil   -- falls back to Theme.colors.accent
        },

        Slider = {
            trackColor  = nil, -- default: Theme.colors.accent (line)
            fillColor   = nil, -- default: Theme.colors.highlight
            knobColor   = nil, -- default: Theme.colors.text
            knobBorder  = nil, -- default: Theme.colors.primary
            knobRadius  = 8
        },

        Panel = {
            borderRadius = 0.10,
            backgroundColor = nil, -- default: Theme.colors.primary
            borderColor = nil      -- optional border
        },

        Input = {
            borderRadius = 0.0,
            backgroundColor = nil,
            borderColor = nil,
            placeholderColor = { 150, 150, 150, 255 },
            textColor = nil
        },

        Checkbox = {
            borderRadius = 0.15,
            boxColor     = nil, -- default: Theme.colors.primary
            checkColor   = nil, -- default: Theme.colors.accent
            borderColor  = nil
        }
    }
}

return Theme
