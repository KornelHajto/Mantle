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
    local mouseX, mouseY = love.mouse.getPosition()
    local isHovered = (mouseX >= x and mouseX <= x + width and
        mouseY >= y and mouseY <= y + height)

    if isHovered then
        local wheelX, wheelY = love.mouse.getWheel()
        if wheelY ~= 0 then
            state.scrollY = state.scrollY - (wheelY * 20) -- Speed = 20px
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

        -- Draw Bar Background
        love.graphics.setColor(0, 0, 0, 0.12)
        love.graphics.rectangle("fill", x + width - barWidth, y, barWidth, height)
        
        -- Draw Handle
        local accent = Mantle.Theme.colors.accent
        love.graphics.setColor(accent[1]/255, accent[2]/255, accent[3]/255, accent[4]/255)
        love.graphics.rectangle("fill", x + width - barWidth, barY, barWidth, barHeight)
        
        love.graphics.setColor(1, 1, 1, 1)
    end

    -- 5. SCISSOR MODE START (Stencil in LÖVE2D)
    love.graphics.push()
    love.graphics.setScissor(x, y, width, height)

    -- 6. Start Layout with OFFSET
    Mantle.Column(x, y - state.scrollY, width, height, 0, contentFunc)

    -- 7. Capture Height
    state.contentHeight = require("mantle.layout").lastHeight

    -- 8. SCISSOR MODE END
    love.graphics.setScissor()
    love.graphics.pop()
end
