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
    local isHovered = (mouse.x >= x and mouse.x <= x + width and
        mouse.y >= y and mouse.y <= y + height)

    if isHovered then
        local wheel = rl.GetMouseWheelMove()
        if wheel ~= 0 then
            state.scrollY = state.scrollY - (wheel * 20) -- Speed = 20px
        end
    end

    -- 3. Clamp Scrolling (Don't scroll past content)
    -- We use contentHeight from the PREVIOUS frame because we haven't drawn this frame yet.
    local maxScroll = math.max(0, state.contentHeight - height)
    if state.scrollY < 0 then state.scrollY = 0 end
    if state.scrollY > maxScroll then state.scrollY = maxScroll end

    -- 4. Draw Scrollbar (Visual Feedback)
    if state.contentHeight > height then
        local barWidth = 6
        local barHeight = (height / state.contentHeight) * height
        local barY = y + (state.scrollY / state.contentHeight) * height

        -- Draw Bar Background
        rl.DrawRectangle(x + width - barWidth, y, barWidth, height, { 0, 0, 0, 30 })
        -- Draw Handle
        rl.DrawRectangle(x + width - barWidth, barY, barWidth, barHeight, Mantle.Theme.colors.accent)
    end

    -- 5. SCISSOR MODE START
    -- Tell GPU: "Only draw pixels inside this box"
    rl.BeginScissorMode(x, y, width, height)

    -- 6. Start Layout with OFFSET
    -- We start a column, but shift the Y start position UP by scrollY
    -- This moves all child buttons up.
    Mantle.Column(x, y - state.scrollY, 0, contentFunc)

    -- 7. Capture Height
    -- We read the value we added to layout.lua
    state.contentHeight = require("mantle.layout").lastHeight

    -- 8. SCISSOR MODE END
    rl.EndScissorMode()

    -- Return nothing (Container)
end
