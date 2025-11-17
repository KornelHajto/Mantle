-- mantle/core.lua
local rl = rl -- Local ref to global

local Core = {}


local dragState = {
    active = false,
    offsetX = 0,
    offsetY = 0
}

-- The function we designed for the weather widget footer
function Core.DrawFooter(x, y, width, height, color, roundness)
    -- 1. Draw the base (Rounded everywhere)
    local rect = { x = x, y = y, width = width, height = height }
    rl.DrawRectangleRounded(rect, roundness, 10, color)

    -- 2. The Patch (Square off the top)
    -- Draw a normal rectangle over the top 50%
    rl.DrawRectangle(x, y, width, height / 2, color)
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

    -- Draw segments
    for i = 0, length, (segmentLength + gapLength) do
        local px = startX + (cosA * i)
        local py = startY + (sinA * i)

        local px2 = startX + (cosA * (i + segmentLength))
        local py2 = startY + (sinA * (i + segmentLength))

        -- Don't draw past the end
        if i + segmentLength > length then break end

        rl.DrawLineEx({ x = px, y = py }, { x = px2, y = py2 }, thick, color)
    end
end

function Core.DrawWave(x, y, width, height, amplitude, frequency, offset, color)
    local midY = y + (height / 2)
    local step = 2 -- Lower = smoother, Higher = faster

    for i = 0, width, step do
        -- Math Logic
        local val1 = math.sin((i + offset) * frequency) * amplitude
        local val2 = math.sin((i + step + offset) * frequency) * amplitude

        -- Draw line from point A to point B
        rl.DrawLineEx(
            { x = x + i, y = midY + val1 },
            { x = x + i + step, y = midY + val2 },
            2.0, -- Line thickness
            color
        )
    end
end

function Core.DrawIcon(texture, centerX, centerY, scale, tint)
    local w = texture.width * scale
    local h = texture.height * scale

    -- Draw centered
    rl.DrawTextureEx(
        texture,
        { x = centerX - (w / 2), y = centerY - (h / 2) },
        0,
        scale,
        tint or rl.WHITE
    )
end

function Core.HandleDrag()
    -- 1. Start Dragging
    if rl.IsMouseButtonPressed(0) then
        dragState.active = true
        local mouse = rl.GetMousePosition()
        dragState.offsetX = mouse.x
        dragState.offsetY = mouse.y
    end

    -- 2. Stop Dragging
    if rl.IsMouseButtonReleased(0) then
        dragState.active = false
    end

    -- 3. Update Position
    if dragState.active then
        local mouse = rl.GetMousePosition()
        local winPos = rl.GetWindowPosition()

        -- Calculate how much the mouse moved relative to where we grabbed
        local deltaX = mouse.x - dragState.offsetX
        local deltaY = mouse.y - dragState.offsetY

        -- Move the window by that amount
        rl.SetWindowPosition(math.floor(winPos.x + deltaX), math.floor(winPos.y + deltaY))
    end
end

return Core
