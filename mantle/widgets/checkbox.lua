local rl = rl

return function(Mantle, text, checked, x, y)
    local size = 20
    local padding = 8


    local textWidth = rl.MeasureText(text, Mantle.Theme.fontSize)
    local totalWidth = size + padding + textWidth

    local mouseX = rl.GetMouseX()
    local mouseY = rl.GetMouseY()

    local isHovered = (mouseX >= x and mouseX <= x + totalWidth
        and mouseY >= y and mouseY <= y + size)

    rl.DrawRectangleLines(x, y, size, size, Mantle.Theme.colors.accent)
    if checked then
        local margin = 4
        rl.DrawRectangle(x + margin, y + margin, size - margin * 2, size - margin * 2, Mantle.Theme.colors.highlight)
    end

    rl.DrawText(text, x + size + padding, y, Mantle.Theme.fontSize, Mantle.Theme.colors.text)

    return checked
end
