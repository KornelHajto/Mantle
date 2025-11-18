local rl = rl

return function(Mantle, text, checked, x, y)
    local size = 20
    local padding = 8

    local font = Mantle.Theme.font or rl.GetFontDefault()
    local fontSize = Mantle.Theme.fontSize

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

    rl.DrawRectangleLines(x, y, size, size, Mantle.Theme.colors.accent)
    if checked then
        local margin = 4
        rl.DrawRectangle(x + margin, y + margin, size - margin * 2, size - margin * 2, Mantle.Theme.colors.highlight)
    end

    rl.DrawTextEx(font, text, { x = x + size + padding, y = y }, fontSize, 1, Mantle.Theme.colors.text)

    return checked
end
