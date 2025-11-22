-- mantle/core.lua
local Core = {}

local dragState = {
    active  = false,
    mouseX  = 0,
    mouseY  = 0,
    winX    = 0,
    winY    = 0
}

-- The function we designed for the weather widget footer
function Core.DrawFooter(x, y, width, height, color, roundness)
    -- LÖVE2D doesn't have rounded rectangles by default
    -- We'll draw a simple rectangle for now
    -- For rounded corners, you'd need a custom implementation or library
    
    love.graphics.setColor(color[1]/255, color[2]/255, color[3]/255, color[4]/255)
    
    -- Draw the base rectangle
    love.graphics.rectangle("fill", x, y, width, height)
    
    -- Draw a rectangle over the top 50% to square off the top
    love.graphics.rectangle("fill", x, y, width, height / 2)
    
    love.graphics.setColor(1, 1, 1, 1) -- Reset color
end

function Core.DrawDashedLine(startX, startY, endX, endY, thick, color)
    local segmentLength = 5
    local gapLength = 5

    -- Calculate distance and direction
    local dx = endX - startX
    local dy = endY - startY
    local length = math.sqrt(dx * dx + dy * dy)

    local angle = math.atan2(dy, dx)
    local cosA = math.cos(angle)
    local sinA = math.sin(angle)

    love.graphics.setColor(color[1]/255, color[2]/255, color[3]/255, color[4]/255)
    love.graphics.setLineWidth(thick)

    -- Draw segments
    for i = 0, length, (segmentLength + gapLength) do
        local px = startX + (cosA * i)
        local py = startY + (sinA * i)

        local px2 = startX + (cosA * (i + segmentLength))
        local py2 = startY + (sinA * (i + segmentLength))

        -- Don't draw past the end
        if i + segmentLength > length then break end

        love.graphics.line(px, py, px2, py2)
    end
    
    love.graphics.setColor(1, 1, 1, 1) -- Reset color
    love.graphics.setLineWidth(1) -- Reset line width
end

function Core.DrawWave(x, y, width, height, amplitude, frequency, offset, color)
    local midY = y + (height / 2)
    local step = 2 -- Lower = smoother, Higher = faster

    love.graphics.setColor(color[1]/255, color[2]/255, color[3]/255, color[4]/255)
    love.graphics.setLineWidth(2.0)

    for i = 0, width, step do
        -- Math Logic
        local val1 = math.sin((i + offset) * frequency) * amplitude
        local val2 = math.sin((i + step + offset) * frequency) * amplitude

        -- Draw line from point A to point B
        love.graphics.line(
            x + i, midY + val1,
            x + i + step, midY + val2
        )
    end
    
    love.graphics.setColor(1, 1, 1, 1) -- Reset color
    love.graphics.setLineWidth(1) -- Reset line width
end

function Core.DrawIcon(texture, centerX, centerY, scale, tint)
    if not texture then return end
    
    local w = texture:getWidth() * scale
    local h = texture:getHeight() * scale

    -- Set tint color
    if tint then
        love.graphics.setColor(tint[1]/255, tint[2]/255, tint[3]/255, tint[4]/255)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end

    -- Draw centered
    love.graphics.draw(
        texture,
        centerX - (w / 2), centerY - (h / 2),
        0,
        scale, scale
    )
    
    love.graphics.setColor(1, 1, 1, 1) -- Reset color
end

-- DrawRectStyle: unified rectangle drawing with style support
function Core.DrawRectStyle(rect, style, themeDefaults)
    local s = style or {}
    local t = themeDefaults or {}

    local roundness = s.borderRadius or t.borderRadius or 0
    local bg        = s.backgroundColor or t.backgroundColor
    local border    = s.borderColor or t.borderColor
    local borderW   = s.borderWidth or t.borderWidth or 1
    local gradient  = s.gradient -- e.g. { from = {...}, to = {...}, vertical = true }

    if gradient then
        -- LÖVE2D doesn't have built-in gradient rectangles
        -- We'll need to use a mesh or shader for this
        -- For now, just use the 'from' color
        if bg then
            love.graphics.setColor(bg[1]/255, bg[2]/255, bg[3]/255, bg[4]/255)
            love.graphics.rectangle("fill", rect.x, rect.y, rect.width, rect.height)
        end
    elseif bg then
        love.graphics.setColor(bg[1]/255, bg[2]/255, bg[3]/255, bg[4]/255)
        love.graphics.rectangle("fill", rect.x, rect.y, rect.width, rect.height)
    end

    if border and borderW > 0 then
        love.graphics.setColor(border[1]/255, border[2]/255, border[3]/255, border[4]/255)
        love.graphics.setLineWidth(borderW)
        love.graphics.rectangle("line", rect.x, rect.y, rect.width, rect.height)
    end
    
    love.graphics.setColor(1, 1, 1, 1) -- Reset color
    love.graphics.setLineWidth(1) -- Reset line width
end

function Core.HandleDrag()
    -- 1. Start Dragging
    if love.mouse.isDown(1) and not dragState.active then
        dragState.active = true

        -- Use window-relative mouse position
        local mx, my = love.mouse.getPosition()
        dragState.mouseX = mx
        dragState.mouseY = my

        -- Store initial window position
        local wx, wy = love.window.getPosition()
        dragState.winX = wx
        dragState.winY = wy
    end

    -- 2. Stop Dragging
    if not love.mouse.isDown(1) and dragState.active then
        dragState.active = false
    end

    -- 3. Update Position (only when dragging)
    if dragState.active and love.mouse.isDown(1) then
        -- Get current mouse position (window-relative)
        local mx, my = love.mouse.getPosition()

        -- Calculate where the window should be:
        -- Initial window position + mouse offset from grab point
        local newX = dragState.winX + mx - dragState.mouseX
        local newY = dragState.winY + my - dragState.mouseY

        -- Move window to new position
        love.window.setPosition(math.floor(newX), math.floor(newY))
    end
end

return Core
