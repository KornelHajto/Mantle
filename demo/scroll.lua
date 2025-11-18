local rl = rl

-- State storage for scroll positions
local scrollStates = {}

return function(Mantle, width, height, contentFunc, x, y)
    -- 1. Generate ID
    local id = tostring(x) .. tostring(y)
    if not scrollStates[id] then
        scrollStates[id] = { scrollY = 0, contentHeight = 0 }
    end
    local state = scrollStates[id]

    -- 2. Handle Input
    local mouse = rl.GetMousePosition()

    -- === INPUT BLOCKING ===
    local isBlocked = Mantle.IsMouseBlocked()
    local isHovered = (not isBlocked) and
        (mouse.x >= x and mouse.x <= x + width and
            mouse.y >= y and mouse.y <= y + height)
    -- ======================

    if isHovered then
        local wheel = rl.GetMouseWheelMove()
        if wheel ~= 0 then
            state.scrollY = state.scrollY - (wheel * 20) -- Scroll Speed
        end
    end

    -- 3. Clamp Scrolling
    local maxScroll = math.max(0, state.contentHeight - height)
    if state.scrollY < 0 then state.scrollY = 0 end
    if state.scrollY > maxScroll then state.scrollY = maxScroll end

    -- 4. Draw Scrollbar
    if state.contentHeight > height then
        local barWidth = 6
        local barHeight = (height / state.contentHeight) * height
        local barY = y + (state.scrollY / state.contentHeight) * height

        rl.DrawRectangle(x + width - barWidth, y, barWidth, height, { 0, 0, 0, 30 })
        rl.DrawRectangle(x + width - barWidth, barY, barWidth, barHeight, Mantle.Theme.colors.accent)
    end

    -- 5. SCISSOR MODE START
    rl.BeginScissorMode(x, y, width, height)

    -- 6. Start Layout with OFFSET
    -- === FIX IS HERE ===
    -- We pass width and 0 (infinite height) to the internal Column
    -- Signature: Column(x, y, w, h, padding, contentFunc)
    Mantle.Column(x, y - state.scrollY, width, 0, 0, contentFunc)
    -- ===================

    -- 7. Capture Height
    -- Read the height from the layout we just finished
    state.contentHeight = require("mantle.layout").lastHeight

    -- 8. SCISSOR MODE END
    rl.EndScissorMode()
end
