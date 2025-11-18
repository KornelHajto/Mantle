local rl = rl

-- State management
local dropdownStates = {}

return function(Mantle, options, selectedIndex, x, y, width)
    width = width or 150
    local height = 40

    -- 1. Manage State
    local id = tostring(x) .. tostring(y)
    if not dropdownStates[id] then
        -- pendingIndex: Stores the click result from the end of the previous frame
        dropdownStates[id] = { isOpen = false, pendingIndex = nil }
    end
    local state = dropdownStates[id]

    -- === FIX: CHECK FOR PENDING SELECTION ===
    -- If we clicked something last frame, update selectedIndex now
    if state.pendingIndex then
        selectedIndex = state.pendingIndex
        state.pendingIndex = nil -- Clear it so we don't force it forever
    end
    -- ========================================

    -- 2. Draw The Header
    local currentText = options[selectedIndex] or "Select..."

    if Mantle.Button(currentText, x, y, width, height) then
        state.isOpen = not state.isOpen
    end

    -- Draw Arrow
    rl.DrawTriangle(
        { x = x + width - 15, y = y + 15 },
        { x = x + width - 5, y = y + 15 },
        { x = x + width - 10, y = y + 25 },
        Mantle.Theme.colors.text
    )

    -- 3. Deferred List Drawing
    if state.isOpen then
        local listY = y + height + 5

        Mantle.Layer(function()
            local itemHeight = 35
            local totalHeight = #options * itemHeight

            -- Block input for the dropdown menu area
            Mantle.SetInputBlock(x, listY, width, totalHeight)

            -- Shadow
            rl.DrawRectangle(x + 5, listY + 5, width, totalHeight, { 0, 0, 0, 50 })

            -- Background
            rl.DrawRectangle(x, listY, width, totalHeight, Mantle.Theme.colors.primary)
            rl.DrawRectangleLines(x, listY, width, totalHeight, Mantle.Theme.colors.accent)

            local mouse = rl.GetMousePosition()

            for i, option in ipairs(options) do
                local itemY = listY + (i - 1) * itemHeight
                local isHovered = (mouse.x >= x and mouse.x <= x + width and
                    mouse.y >= itemY and mouse.y <= itemY + itemHeight)

                if isHovered then
                    rl.DrawRectangle(x, itemY, width, itemHeight, Mantle.Theme.colors.highlight)

                    -- === FIX: SAVE SELECTION FOR NEXT FRAME ===
                    if rl.IsMouseButtonReleased(0) then
                        state.pendingIndex = i -- Store it!
                        state.isOpen = false
                    end
                    -- ==========================================
                end

                -- Draw Option Text
                rl.DrawTextEx(
                    Mantle.Theme.font or rl.GetFontDefault(),
                    option,
                    { x = x + 10, y = itemY + 8 },
                    Mantle.Theme.fontSize,
                    1,
                    Mantle.Theme.colors.text
                )
            end
        end)
    end

    return selectedIndex
end
