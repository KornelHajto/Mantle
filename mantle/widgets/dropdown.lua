-- State management
local dropdownStates = {}

return function(Mantle, options, selectedIndex, x, y, width)
    width = width or 150
    local height = 40

    -- 1. Manage State
    local id = tostring(x) .. tostring(y)
    if not dropdownStates[id] then
        dropdownStates[id] = { isOpen = false, pendingIndex = nil }
    end
    local state = dropdownStates[id]

    -- If we clicked something last frame, update selectedIndex now
    if state.pendingIndex then
        selectedIndex = state.pendingIndex
        state.pendingIndex = nil
    end

    -- 2. Draw The Header
    local currentText = options[selectedIndex] or "Select..."

    if Mantle.Button(currentText, x, y, width, height) then
        state.isOpen = not state.isOpen
    end

    -- Draw Arrow (simple triangle approximation with lines)
    love.graphics.setColor(Mantle.Theme.colors.text[1]/255, Mantle.Theme.colors.text[2]/255, 
                           Mantle.Theme.colors.text[3]/255, Mantle.Theme.colors.text[4]/255)
    love.graphics.polygon("fill", 
        x + width - 15, y + 15,
        x + width - 5, y + 15,
        x + width - 10, y + 25
    )
    love.graphics.setColor(1, 1, 1, 1)

    -- 3. Deferred List Drawing
    if state.isOpen then
        local listY = y + height + 5

        Mantle.Layer(function()
            local itemHeight = 35
            local totalHeight = #options * itemHeight

            -- Block input for the dropdown menu area
            Mantle.SetInputBlock(x, listY, width, totalHeight)

            -- Shadow
            love.graphics.setColor(0, 0, 0, 0.2)
            love.graphics.rectangle("fill", x + 5, listY + 5, width, totalHeight)

            -- Background
            local primary = Mantle.Theme.colors.primary
            love.graphics.setColor(primary[1]/255, primary[2]/255, primary[3]/255, primary[4]/255)
            love.graphics.rectangle("fill", x, listY, width, totalHeight)
            
            local accent = Mantle.Theme.colors.accent
            love.graphics.setColor(accent[1]/255, accent[2]/255, accent[3]/255, accent[4]/255)
            love.graphics.setLineWidth(1)
            love.graphics.rectangle("line", x, listY, width, totalHeight)

            local mouseX, mouseY = love.mouse.getPosition()

            -- Track mouse releases for dropdown
            local wasPressed = Mantle._dropdownPressed or {}
            local wasDown = wasPressed[id] or false
            local isDown = love.mouse.isDown(1)
            local isReleased = wasDown and not isDown
            wasPressed[id] = isDown
            Mantle._dropdownPressed = wasPressed

            local font = Mantle.Theme.font or love.graphics.getFont()
            local oldFont = love.graphics.getFont()
            love.graphics.setFont(font)

            for i, option in ipairs(options) do
                local itemY = listY + (i - 1) * itemHeight
                local isHovered = (mouseX >= x and mouseX <= x + width and
                    mouseY >= itemY and mouseY <= itemY + itemHeight)

                if isHovered then
                    local highlight = Mantle.Theme.colors.highlight
                    love.graphics.setColor(highlight[1]/255, highlight[2]/255, highlight[3]/255, highlight[4]/255)
                    love.graphics.rectangle("fill", x, itemY, width, itemHeight)

                    if isReleased then
                        state.pendingIndex = i
                        state.isOpen = false
                    end
                end

                -- Draw Option Text
                local textColor = Mantle.Theme.colors.text
                love.graphics.setColor(textColor[1]/255, textColor[2]/255, textColor[3]/255, textColor[4]/255)
                love.graphics.print(option, x + 10, itemY + 8)
            end
            
            love.graphics.setFont(oldFont)
            love.graphics.setColor(1, 1, 1, 1)
        end)
    end

    return selectedIndex
end
