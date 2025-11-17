local Mantle = require("mantle.init")

-- 1. SETUP
Mantle.Window({
    width = 600,
    height = 350,
    title = "Scientific Graph",
    transparent = true, -- No borders, transparent background
    draggable = true    -- Move it by clicking anywhere
})

-- 2. APP STATE (Variables that live across frames)
local scale = 50.0     -- 50 pixels = 1 unit
local originX = 300    -- Center of the window
local originY = 175
local timeOffset = 0.0 -- For animation

-- 3. THE APP LOOP
Mantle.Run(function()
    -- A. Logic
    timeOffset = timeOffset + 0.02

    -- B. Draw
    Mantle.Clear() -- Clears to transparent

    -- Background Panel
    Mantle.Panel(0, 0, 600, 350, { 34, 136, 78, 255 })

    -- Axes (Black lines, slightly transparent)
    Mantle.Line(0, originY, 600, originY, { 0, 0, 0, 150 }) -- X Axis
    Mantle.Line(originX, 0, originX, 350, { 0, 0, 0, 150 }) -- Y Axis

    -- Grid System
    -- Vertical Lines (X values -6 to 6)
    for i = -6, 6 do
        if i ~= 0 then
            local x = originX + (i * scale)
            Mantle.Line(x, 0, x, 350, { 0, 0, 0, 40 })
            Mantle.Text(tostring(i), x + 2, originY + 2, 10, { 0, 0, 0, 180 })
        end
    end

    -- Horizontal Lines (Y values -3 to 3)
    for i = -3, 3 do
        if i ~= 0 then
            local y = originY - (i * scale)
            Mantle.Line(0, y, 600, y, { 0, 0, 0, 40 })
            Mantle.Text(tostring(i), originX + 2, y + 2, 10, { 0, 0, 0, 180 })
        end
    end

    -- C. The Sine Wave (Manual Drawing for Accuracy)
    local lastX, lastY = -1, -1

    -- Loop through pixels across the screen
    for screenX = 0, 600, 2 do
        -- 1. Math: Convert Screen -> Graph Coordinates
        local mathX = (screenX - originX) / scale

        -- 2. Math: Calculate Sine
        local mathY = math.sin(mathX + timeOffset)

        -- 3. Math: Convert Graph -> Screen Coordinates
        local screenY = originY - (mathY * scale)

        -- 4. Draw Segment
        if lastX ~= -1 then
            Mantle.Line(lastX, lastY, screenX, screenY, { 20, 20, 20, 200 }, 2.0)
        end

        lastX = screenX
        lastY = screenY
    end

    -- D. The Cursor Indicator
    local cursorMathX = 2.5
    local cursorScreenX = originX + (cursorMathX * scale)

    -- Dashed Line
    Mantle.DrawDashedLine(cursorScreenX, 0, cursorScreenX, 350, 2, { 0, 0, 0, 150 })

    -- The Dot
    local dotMathY = math.sin(cursorMathX + timeOffset)
    local dotScreenY = originY - (dotMathY * scale)

    Mantle.Circle(cursorScreenX, dotScreenY, 5, { 0, 0, 0 })

    -- The Value Text
    local valueStr = string.format("%.2f", dotMathY)
    Mantle.Text(valueStr, 50, 40, 60, { 0, 0, 0, 100 })

    -- Decoration Dots (Top Right)
    Mantle.Circle(550, 20, 6, { 0, 0, 0, 50 })
    Mantle.Circle(570, 20, 6, { 0, 0, 0, 50 })
    Mantle.Circle(590, 20, 6, { 0, 0, 0, 50 })
end)
