-- mantle/core.lua
local rl = rl -- Local ref to global

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
        if gradient.vertical then
            rl.DrawRectangleGradientV(rect.x, rect.y, rect.width, rect.height,
                gradient.from, gradient.to)
        else
            rl.DrawRectangleGradientH(rect.x, rect.y, rect.width, rect.height,
                gradient.from, gradient.to)
        end
    elseif bg then
        if roundness > 0 then
            rl.DrawRectangleRounded(rect, roundness, 12, bg)
        else
            rl.DrawRectangle(rect.x, rect.y, rect.width, rect.height, bg)
        end
    end

    if border and borderW > 0 then
        if roundness > 0 then
            rl.DrawRectangleRoundedLines(rect, roundness, 12, borderW, border)
        else
            rl.DrawRectangleLinesEx(rect, borderW, border)
        end
    end
end

function Core.HandleDrag()
    -- 1. Start Dragging
    if rl.IsMouseButtonPressed(0) then
        dragState.active = true

        -- Use window-relative mouse position
        local mouse = rl.GetMousePosition()
        dragState.mouseX = mouse.x
        dragState.mouseY = mouse.y

        -- Store initial window position
        local winPos = rl.GetWindowPosition()
        dragState.winX = winPos.x
        dragState.winY = winPos.y
    end

    -- 2. Stop Dragging
    if rl.IsMouseButtonReleased(0) then
        dragState.active = false
    end

    -- 3. Update Position (only when dragging)
    if dragState.active and rl.IsMouseButtonDown(0) then
        -- Get current window position
        local winPos = rl.GetWindowPosition()
        
        -- Get current mouse position (window-relative)
        local mouse = rl.GetMousePosition()

        -- Calculate where the window should be:
        -- Current window position + mouse offset from grab point
        local newX = winPos.x + mouse.x - dragState.mouseX
        local newY = winPos.y + mouse.y - dragState.mouseY

        -- Move window to new position
        rl.SetWindowPosition(math.floor(newX), math.floor(newY))
    end
end

return Core
