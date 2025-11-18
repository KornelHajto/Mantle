local rl = rl

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

    local mouseX = rl.GetMouseX()
    local mouseY = rl.GetMouseY()

    local isBlocked = Mantle.IsMouseBlocked()
    local isHovered = (not isBlocked) and
        (mouseX >= x - knobRadius and mouseX <= x + width + knobRadius and
            mouseY >= y and mouseY <= y + height)

    if isHovered and rl.IsMouseButtonDown(0) then
        local relativeX = mouseX - x
        value = relativeX / width

        value = clamp(value, 0.0, 1.0)
    end


    local railY = y + (height / 2)
    rl.DrawLine(x, railY, x + width, railY, trackColor)

    rl.DrawLine(x, railY, knobX, railY, fillColor)

    rl.DrawCircle(math.floor(knobX), math.floor(knobY), knobRadius, knobColor)
    rl.DrawCircleLines(math.floor(knobX), math.floor(knobY), knobRadius, knobBorder)

    return value
end
