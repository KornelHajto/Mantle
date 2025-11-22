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

    love.graphics.setColor(bg[1]/255, bg[2]/255, bg[3]/255, bg[4]/255)
    love.graphics.rectangle("fill", x, y, width, height)
    
    if borderCol then
        love.graphics.setColor(borderCol[1]/255, borderCol[2]/255, borderCol[3]/255, borderCol[4]/255)
        love.graphics.setLineWidth(1)
        love.graphics.rectangle("line", x, y, width, height)
    end
    
    love.graphics.setColor(1, 1, 1, 1) -- Reset color
end
