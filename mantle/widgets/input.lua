local rl = rl

local activeState = {
    focusedHash = nil,
    backspaceTimer = 0.0
}

return function(Mantle, text, placeholder, x, y, width)
    width = width or 200
    local height = 40
    text = text or ""

    local id = tostring(x) .. tostring(y)
    local isFocused = (activeState.focusedHash == id)

    local mouse = rl.GetMousePosition()

    local isBlocked = Mantle.IsMouseBlocked()
    local isHovered = (not isBlocked) and
        (mouse.x >= x and mouse.x <= x + width and
            mouse.y >= y and mouse.y <= y + height)

    if rl.IsMouseButtonPressed(0) then
        if isHovered then
            activeState.focusedHash = id
        else
            if isFocused then activeState.focusedHash = nil end
        end
    end

    if isFocused then
        local key = rl.GetKeyPressed()
        while key > 0 do
            if (key >= 32) and (key <= 125) then
                text = text .. string.char(key)
            end
            key = rl.GetKeyPressed()
        end

        if rl.IsKeyDown(rl.KEY_BACKSPACE) then
            activeState.backspaceTimer = activeState.backspaceTimer - rl.GetFrameTime()

            if rl.IsKeyPressed(rl.KEY_BACKSPACE) or activeState.backspaceTimer < 0 then
                if #text > 0 then
                    text = string.sub(text, 1, -2)
                end
                activeState.backspaceTimer = 0.1
            end
        else
            activeState.backspaceTimer = 0
        end
    end

    local borderColor = isFocused and Mantle.Theme.colors.highlight or Mantle.Theme.colors.accent
    rl.DrawRectangle(x, y, width, height, Mantle.Theme.colors.primary)
    rl.DrawRectangleLines(x, y, width, height, borderColor)

    local displayTxt = text
    local txtColor = Mantle.Theme.colors.text

    if #text == 0 then
        displayTxt = placeholder or ""
        txtColor = { 150, 150, 150, 255 }
    end

    local font = Mantle.Theme.font or rl.GetFontDefault()
    local availableW = width - 20
    local textW = rl.MeasureTextEx(font, displayTxt, Mantle.Theme.fontSize, 1).x

    if textW > availableW then
        while rl.MeasureTextEx(font, "..." .. displayTxt, Mantle.Theme.fontSize, 1).x > availableW do
            displayTxt = string.sub(displayTxt, 2)
        end
        displayTxt = "..." .. displayTxt
    end

    rl.DrawTextEx(font, displayTxt, { x = x + 10, y = y + 10 }, Mantle.Theme.fontSize, 1, txtColor)

    if isFocused then
        if (math.floor(rl.GetTime() * 2) % 2) == 0 then
            local cursorX = x + 10 + rl.MeasureTextEx(font, displayTxt, Mantle.Theme.fontSize, 1).x + 2
            rl.DrawRectangle(math.floor(cursorX), y + 8, 2, 24, Mantle.Theme.colors.highlight)
        end
    end

    return text
end
