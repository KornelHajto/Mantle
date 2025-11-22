local function clamp(val, min, max)
    return math.max(min, math.min(max, val))
end

return function(Mantle, value, x, y, width, style)
    width = width or 150
    local height = 20

    local theme = Mantle.Theme
    local defaults = (theme.styles and theme.styles.Slider) or {}

    local function pick(key, fallback)
        if style and style[key] ~= nil then return style[key] end
        if defaults[key] ~= nil then return defaults[key] end
        return fallback
    end

    local trackColor = pick("trackColor", theme.colors.accent)
    local fillColor  = pick("fillColor", theme.colors.highlight)
    local knobColor  = pick("knobColor", theme.colors.text)
    local knobBorder = pick("knobBorder", theme.colors.primary)
    local knobRadius = pick("knobRadius", 8)

    local knobX = x + (width * value)
    local knobY = y + (height / 2)

    local mouseX, mouseY = love.mouse.getPosition()

    local isBlocked = Mantle.IsMouseBlocked()
    local isHovered = (not isBlocked) and
        (mouseX >= x - knobRadius and mouseX <= x + width + knobRadius and
            mouseY >= y and mouseY <= y + height)

    if isHovered and love.mouse.isDown(1) then
        local relativeX = mouseX - x
        value = relativeX / width
        value = clamp(value, 0.0, 1.0)
    end

    local railY = y + (height / 2)
    
    love.graphics.setColor(trackColor[1]/255, trackColor[2]/255, trackColor[3]/255, trackColor[4]/255)
    love.graphics.setLineWidth(2)
    love.graphics.line(x, railY, x + width, railY)

    love.graphics.setColor(fillColor[1]/255, fillColor[2]/255, fillColor[3]/255, fillColor[4]/255)
    love.graphics.line(x, railY, knobX, railY)

    love.graphics.setColor(knobColor[1]/255, knobColor[2]/255, knobColor[3]/255, knobColor[4]/255)
    love.graphics.circle("fill", math.floor(knobX), math.floor(knobY), knobRadius)
    
    love.graphics.setColor(knobBorder[1]/255, knobBorder[2]/255, knobBorder[3]/255, knobBorder[4]/255)
    love.graphics.setLineWidth(1)
    love.graphics.circle("line", math.floor(knobX), math.floor(knobY), knobRadius)
    
    love.graphics.setColor(1, 1, 1, 1) -- Reset color

    return value
end
