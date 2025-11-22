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

    local font = theme.font or love.graphics.getFont()
    local textWidth = font:getWidth(text)
    local totalWidth = size + padding + textWidth

    local mouseX, mouseY = love.mouse.getPosition()

    local isBlocked = Mantle.IsMouseBlocked()
    local isHovered = (not isBlocked) and
        (mouseX >= x and mouseX <= x + totalWidth and
            mouseY >= y and mouseY <= y + size)

    -- Track checkbox releases
    local wasPressed = Mantle._checkboxPressed or {}
    local checkboxId = tostring(x) .. "_" .. tostring(y)
    local wasDown = wasPressed[checkboxId] or false
    local isDown = love.mouse.isDown(1)
    local isReleased = wasDown and not isDown
    wasPressed[checkboxId] = isDown
    Mantle._checkboxPressed = wasPressed

    if isHovered and isReleased then
        checked = not checked
    end

    love.graphics.setColor(boxColor[1]/255, boxColor[2]/255, boxColor[3]/255, boxColor[4]/255)
    love.graphics.rectangle("fill", x, y, size, size)
    
    love.graphics.setColor(borderCol[1]/255, borderCol[2]/255, borderCol[3]/255, borderCol[4]/255)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle("line", x, y, size, size)

    if checked then
        local margin = 4
        love.graphics.setColor(checkColor[1]/255, checkColor[2]/255, checkColor[3]/255, checkColor[4]/255)
        love.graphics.rectangle("fill", x + margin, y + margin, size - margin * 2, size - margin * 2)
    end

    local oldFont = love.graphics.getFont()
    love.graphics.setFont(font)
    love.graphics.setColor(textColor[1]/255, textColor[2]/255, textColor[3]/255, textColor[4]/255)
    love.graphics.print(text, x + size + padding, y)
    love.graphics.setFont(oldFont)
    
    love.graphics.setColor(1, 1, 1, 1) -- Reset color

    return checked
end
