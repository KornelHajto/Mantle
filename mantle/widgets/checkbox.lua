local rl = rl

return function(Mantle, text, checked, x, y, style)
    local size = 20
    local padding = 8

    local theme = Mantle.Theme
    local defaults = (theme.styles and theme.styles.Checkbox) or {}

    local function pick(key, fallback)
        if style and style[key] ~= nil then return style[key] end
        if defaults[key] ~= nil then return defaults[key] end
        return fallback
    end

    local boxColor    = pick("boxColor", theme.colors.primary)
    local checkColor  = pick("checkColor", theme.colors.accent)
    local borderCol   = pick("borderColor", theme.colors.accent)
    local textColor   = pick("textColor", theme.colors.text)
    local radius      = pick("borderRadius", 0.15)

    local font = theme.font or rl.GetFontDefault()
    local fontSize = theme.fontSize

    local textDims = rl.MeasureTextEx(font, text, fontSize, 1)
    local totalWidth = size + padding + textDims.x

    local mouseX = rl.GetMouseX()
    local mouseY = rl.GetMouseY()

    local isBlocked = Mantle.IsMouseBlocked()
    local isHovered = (not isBlocked) and
        (mouseX >= x and mouseX <= x + totalWidth and
            mouseY >= y and mouseY <= y + size)

    if isHovered and rl.IsMouseButtonReleased(0) then
        checked = not checked
    end

    local rect = { x = x, y = y, width = size, height = size }

    if radius > 0 then
        rl.DrawRectangleRounded(rect, radius, 8, boxColor)
        rl.DrawRectangleRoundedLines(rect, radius, 8, 1, borderCol)
    else
        rl.DrawRectangle(x, y, size, size, boxColor)
        rl.DrawRectangleLines(x, y, size, size, borderCol)
    end

    if checked then
        local margin = 4
        local checkRect = { x = x + margin, y = y + margin, width = size - margin * 2, height = size - margin * 2 }
        if radius > 0 then
            rl.DrawRectangleRounded(checkRect, radius, 8, checkColor)
        else
            rl.DrawRectangle(x + margin, y + margin, size - margin * 2, size - margin * 2, checkColor)
        end
    end

    rl.DrawTextEx(font, text, { x = x + size + padding, y = y }, fontSize, 1, textColor)

    return checked
end
