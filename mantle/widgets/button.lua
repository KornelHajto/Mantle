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

    local mouseX, mouseY = love.mouse.getPosition()
    local isDown = love.mouse.isDown(1)
    
    -- Track button releases
    local wasPressed = Mantle._buttonPressed or {}
    local buttonId = tostring(x) .. "_" .. tostring(y)
    local wasDown = wasPressed[buttonId] or false
    local isReleased = wasDown and not isDown
    wasPressed[buttonId] = isDown
    Mantle._buttonPressed = wasPressed

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

    love.graphics.setColor(color[1]/255, color[2]/255, color[3]/255, color[4]/255)
    love.graphics.rectangle("fill", x, y, width, height)

    if s.borderColor then
        love.graphics.setColor(s.borderColor[1]/255, s.borderColor[2]/255, s.borderColor[3]/255, s.borderColor[4]/255)
        love.graphics.setLineWidth(1)
        love.graphics.rectangle("line", x, y, width, height)
    end

    local font = Mantle.Theme.font or love.graphics.getFont()
    local oldFont = love.graphics.getFont()
    love.graphics.setFont(font)
    
    local txtWidth = font:getWidth(text)
    local txtHeight = font:getHeight()

    local txtX = x + (width - txtWidth) / 2
    local txtY = y + (height - txtHeight) / 2

    love.graphics.setColor(s.textColor[1]/255, s.textColor[2]/255, s.textColor[3]/255, s.textColor[4]/255)
    love.graphics.print(text, math.floor(txtX), math.floor(txtY))
    
    love.graphics.setFont(oldFont)
    love.graphics.setColor(1, 1, 1, 1) -- Reset color

    return isHovered and isReleased
end
