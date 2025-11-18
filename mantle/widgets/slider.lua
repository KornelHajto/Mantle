local rl = rl

local function clamp(val, min, max)
    return math.max(min, math.min(max, val))
end

return function(Mantle, value, x, y, width)
    width = width or 150
    local height = 20
    local knobRadius = 8

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
    rl.DrawLine(x, railY, x + width, railY, Mantle.Theme.colors.accent)

    rl.DrawLine(x, railY, knobX, railY, Mantle.Theme.colors.highlight)

    rl.DrawCircle(math.floor(knobX), math.floor(knobY), knobRadius, Mantle.Theme.colors.text)
    rl.DrawCircleLines(math.floor(knobX), math.floor(knobY), knobRadius, Mantle.Theme.colors.primary)

    return value
end
