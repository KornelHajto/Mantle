local Mantle = require("mantle.init")
local rl = rl -- We need this for GetFrameTime (Delta Time)

-- 1. SETUP
Mantle.Window({
    width = 600,
    height = 350,
    title = "Scientific Graph",
    transparent = true,
    draggable = true,
    targetFPS = 60 -- Lock it to 60 to prevent screen tearing
})

-- 2. APP STATE
local scale         = 50.0
local originX       = 300
local originY       = 175
local timeOffset    = 0.0

-- 3. OPTIMIZATION: Define colors ONCE to stop Garbage Collection stutter
-- If you create tables {0,0,0} inside the loop, Lua lags.
local colBackground = { 39, 174, 96, 255 }
local colAxis       = { 0, 0, 0, 150 }
local colGrid       = { 0, 0, 0, 40 }
local colText       = { 0, 0, 0, 180 }
local colWave       = { 20, 20, 20, 200 }
local colDot        = { 0, 0, 0, 50 }

-- 4. THE LOOP
Mantle.Run(function()
    -- A. Logic (Use Delta Time for smooth movement)
    local dt = rl.GetFrameTime()
    timeOffset = timeOffset + (2.0 * dt) -- Speed = 2.0 units per second

    -- B. Draw Background
    Mantle.Clear()
    Mantle.Panel(0, 0, 600, 350, colBackground)

    -- C. Axes
    Mantle.Line(0, originY, 600, originY, colAxis)
    Mantle.Line(originX, 0, originX, 350, colAxis)

    -- D. Grid System
    -- Vertical
    for i = -6, 6 do
        if i ~= 0 then
            local x = math.floor(originX + (i * scale)) -- SNAP TO INTEGER
            Mantle.Line(x, 0, x, 350, colGrid)
            Mantle.Text(tostring(i), 10, colText, x + 2, originY + 2)
        end
    end

    -- Horizontal
    for i = -3, 3 do
        if i ~= 0 then
            local y = math.floor(originY - (i * scale)) -- SNAP TO INTEGER
            Mantle.Line(0, y, 600, y, colGrid)
            Mantle.Text(tostring(i), 10, colText, originX + 2, y + 2)
        end
    end

    -- E. Sine Wave (Optimized)
    local lastX, lastY = -1, -1

    -- Step by 2 pixels for performance
    for screenX = 0, 600, 2 do
        local mathX = (screenX - originX) / scale
        local mathY = math.sin(mathX + timeOffset)

        -- SNAP TO INTEGER (Crucial for anti-twitch)
        local screenY = math.floor(originY - (mathY * scale))

        if lastX ~= -1 then
            Mantle.Line(lastX, lastY, screenX, screenY, colWave, 2.0)
        end
        lastX = screenX
        lastY = screenY
    end

    -- F. Cursor Indicator
    local cursorMathX = 2.5
    local cursorScreenX = math.floor(originX + (cursorMathX * scale))

    Mantle.DrawDashedLine(cursorScreenX, 0, cursorScreenX, 350, 2, colAxis)

    local dotMathY = math.sin(cursorMathX + timeOffset)
    local dotScreenY = math.floor(originY - (dotMathY * scale))

    Mantle.Circle(cursorScreenX, dotScreenY, 5, { 0, 0, 0, 255 })

    -- Value Text
    local valueStr = string.format("%.2f", dotMathY)
    Mantle.Text(valueStr, 60, { 0, 0, 0, 100 }, 50, 40)

    -- Decoration
    Mantle.Circle(550, 20, 6, colDot)
    Mantle.Circle(570, 20, 6, colDot)
    Mantle.Circle(590, 20, 6, colDot)
end)
