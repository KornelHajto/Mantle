local activeState = {
    focusedHash = nil,
    backspaceTimer = 0.0,
    textInput = ""
}

return function(Mantle, text, placeholder, x, y, width, style)
    width = width or 200
    local height = 40
    text = text or ""

    local theme = Mantle.Theme
    local defaults = (theme.styles and theme.styles.Input) or {}

    local function pick(key, fallback)
        if style and style[key] ~= nil then return style[key] end
        if defaults[key] ~= nil then return defaults[key] end
        return fallback
    end

    local bgColor      = pick("backgroundColor", theme.colors.primary)
    local borderCol    = pick("borderColor", theme.colors.accent)
    local textColor    = pick("textColor", theme.colors.text)
    local placeholderC = pick("placeholderColor", { 150, 150, 150, 255 })
    local radius       = pick("borderRadius", 0.0)

    local id = tostring(x) .. tostring(y)
    local isFocused = (activeState.focusedHash == id)

    local mouseX, mouseY = love.mouse.getPosition()

    local isBlocked = Mantle.IsMouseBlocked()
    local isHovered = (not isBlocked) and
        (mouseX >= x and mouseX <= x + width and
            mouseY >= y and mouseY <= y + height)

    -- Track mouse clicks
    local wasPressed = Mantle._inputPressed or {}
    local wasDown = wasPressed[id] or false
    local isDown = love.mouse.isDown(1)
    local isReleased = wasDown and not isDown
    wasPressed[id] = isDown
    Mantle._inputPressed = wasPressed

    if isReleased then
        if isHovered then
            activeState.focusedHash = id
            love.keyboard.setTextInput(true)
        else
            if isFocused then 
                activeState.focusedHash = nil
                love.keyboard.setTextInput(false)
            end
        end
    end

    if isFocused then
        -- Get text input from love.textinput callback
        if Mantle._textInputBuffer and #Mantle._textInputBuffer > 0 then
            text = text .. Mantle._textInputBuffer
            Mantle._textInputBuffer = ""
        end

        -- Handle backspace
        if love.keyboard.isDown("backspace") then
            local dt = love.timer.getDelta()
            activeState.backspaceTimer = activeState.backspaceTimer - dt

            if love.keyboard.isScancodeDown("backspace") and (activeState.backspaceTimer <= 0) then
                if #text > 0 then
                    text = string.sub(text, 1, -2)
                end
                activeState.backspaceTimer = 0.1
            end
        else
            activeState.backspaceTimer = 0
        end
    end

    local focusBorderColor = isFocused and theme.colors.highlight or borderCol

    love.graphics.setColor(bgColor[1]/255, bgColor[2]/255, bgColor[3]/255, bgColor[4]/255)
    love.graphics.rectangle("fill", x, y, width, height)
    
    love.graphics.setColor(focusBorderColor[1]/255, focusBorderColor[2]/255, focusBorderColor[3]/255, focusBorderColor[4]/255)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle("line", x, y, width, height)

    local displayTxt = text
    local txtColor = textColor

    if #text == 0 then
        displayTxt = placeholder or ""
        txtColor = placeholderC
    end

    local font = theme.font or love.graphics.getFont()
    local oldFont = love.graphics.getFont()
    love.graphics.setFont(font)
    
    local availableW = width - 20
    local textW = font:getWidth(displayTxt)

    if textW > availableW then
        while font:getWidth("..." .. displayTxt) > availableW and #displayTxt > 0 do
            displayTxt = string.sub(displayTxt, 2)
        end
        displayTxt = "..." .. displayTxt
    end

    love.graphics.setColor(txtColor[1]/255, txtColor[2]/255, txtColor[3]/255, txtColor[4]/255)
    love.graphics.print(displayTxt, x + 10, y + 10)

    if isFocused then
        if (math.floor(love.timer.getTime() * 2) % 2) == 0 then
            local cursorX = x + 10 + font:getWidth(displayTxt) + 2
            love.graphics.setColor(theme.colors.highlight[1]/255, theme.colors.highlight[2]/255, theme.colors.highlight[3]/255, theme.colors.highlight[4]/255)
            love.graphics.rectangle("fill", math.floor(cursorX), y + 8, 2, 24)
        end
    end
    
    love.graphics.setFont(oldFont)
    love.graphics.setColor(1, 1, 1, 1) -- Reset color

    return text
end
