local rl = rl

return function(Mantle, x, y, width, height, color, style)
    local theme = Mantle.Theme
    local defaults = (theme.styles and theme.styles.Panel) or {}

    local function pick(key, fallback)
        if style and style[key] ~= nil then return style[key] end
        if defaults[key] ~= nil then return defaults[key] end
        return fallback
    end

    local bg        = pick("backgroundColor", color or theme.colors.primary)
    local radius    = pick("borderRadius", 0.1)
    local borderCol = pick("borderColor", nil)

    local rect = {
        x = x,
        y = y,
        width = width,
        height = height
    }

    local segments = 20

    rl.DrawRectangleRounded(rect, radius, segments, bg)
    
    if borderCol then
        rl.DrawRectangleRoundedLines(rect, radius, segments, 1, borderCol)
    end
end
