local rl = rl

return function(Mantle, text, x, y, width, height)
    width = width or 120
    height = height or 40

    local mouseX = rl.GetMouseX()
    local mouseY = rl.GetMouseY()
    local isDown = rl.IsMouseButtonDown(0)
    local isReleased = rl.IsMouseButtonReleased(0)

    local isHovered = (mouseX >= x and mouseX <= x + width
        and mouseY >= y and mouseY <= y + height)

    local color = Mantle.Theme.colors.primary

    if isHovered then
        if isDown then
            color = Mantle.Theme.colors.accent
        else
            color = Mantle.Theme.colors.highlight
        end
    end

    rl.DrawRectangle(x, y, width, height, color)
    rl.DrawRectangleLines(x, y, width, height, Mantle.Theme.colors.accent)

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
        Mantle.Theme.colors.text
    )

    return isHovered and isReleased
end
