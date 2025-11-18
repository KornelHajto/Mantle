local rl = rl

-- Merge local style with theme defaults
local function resolveStyle(Mantle, style)
    local theme = Mantle.Theme
    local defaults = (theme.styles and theme.styles.Button) or {}

    local function pick(key, fallback)
        if style and style[key] ~= nil then return style[key] end
        if defaults[key] ~= nil then return defaults[key] end
        return fallback
    end

    return {
        borderRadius    = pick("borderRadius", 0),
        backgroundColor = pick("backgroundColor", theme.colors.primary),
        textColor       = pick("textColor", theme.colors.text),
        borderColor     = pick("borderColor", theme.colors.accent),
        hoverColor      = pick("hoverColor", theme.colors.highlight),
        activeColor     = pick("activeColor", theme.colors.accent)
    }
end

return function(Mantle, text, x, y, width, height, style)
    width = width or 120
    height = height or 40

    local s = resolveStyle(Mantle, style)

    local mouseX = rl.GetMouseX()
    local mouseY = rl.GetMouseY()
    local isDown = rl.IsMouseButtonDown(0)
    local isReleased = rl.IsMouseButtonReleased(0)

    local isBlocked = Mantle.IsMouseBlocked()

    local isHovered = (not isBlocked) and
        (mouseX >= x and mouseX <= x + width and
            mouseY >= y and mouseY <= y + height)

    local color = s.backgroundColor

    if isHovered then
        if isDown then
            color = s.activeColor
        else
            color = s.hoverColor
        end
    end

    local rect = { x = x, y = y, width = width, height = height }

    if s.borderRadius > 0 then
        rl.DrawRectangleRounded(rect, s.borderRadius, 12, color)
        if s.borderColor then
            rl.DrawRectangleRoundedLines(rect, s.borderRadius, 12, 1, s.borderColor)
        end
    else
        rl.DrawRectangle(x, y, width, height, color)
        if s.borderColor then
            rl.DrawRectangleLines(x, y, width, height, s.borderColor)
        end
    end

    local font = Mantle.Theme.font or rl.GetFontDefault()
    local fontSize = Mantle.Theme.fontSize
    local spacing = 1.0

    local dims = rl.MeasureTextEx(font, text, fontSize, spacing)

    local txtX = x + (width - dims.x) / 2
    local txtY = y + (height - dims.y) / 2

    rl.DrawTextEx(
        font,
        text,
        { x = math.floor(txtX), y = math.floor(txtY) },
        fontSize,
        spacing,
        s.textColor
    )

    return isHovered and isReleased
end
