local Mantle = {}

local rl = rl
if not rl then error("Mantle: Could not find global 'rl'.") end

-- Imports
Mantle.Theme = require("mantle.theme")
local Core = require("mantle.core")

local button_logic = require("mantle.widgets.button")
local checkbox_logic = require("mantle.widgets.checkbox")
local slider_logic = require("mantle.widgets.slider")
local panel_logic = require("mantle.widgets.panel")

-- Internal Configuration
local config = {
    width = 800,
    height = 600,
    title = "Mantle App",
    transparent = false,
    draggable = false,
    targetFPS = 60
}

-- Color Helper (Converts {r,g,b} to Raylib Color)
local function checkColor(c)
    if c and #c == 3 then return { c[1], c[2], c[3], 255 } end
    return c or { 0, 0, 0, 0 }
end

-- ============================
-- WINDOW MANAGEMENT
-- ============================

function Mantle.Window(settings)
    for k, v in pairs(settings) do config[k] = v end
end

function Mantle.Run(drawCallback)
    if config.transparent then
        rl.SetConfigFlags(rl.FLAG_WINDOW_UNDECORATED + rl.FLAG_WINDOW_TRANSPARENT)
    end

    rl.InitWindow(config.width, config.height, config.title)
    rl.SetTargetFPS(config.targetFPS)

    while not rl.WindowShouldClose() do
        -- Handle Auto-Drag
        if config.draggable and Core.HandleDrag then
            Core.HandleDrag()
        end

        Mantle.Begin()
        rl.BeginDrawing()

        -- Run user code
        if drawCallback then drawCallback() end

        rl.EndDrawing()
        Mantle.End()
    end

    rl.CloseWindow()
end

-- ============================
-- FRAMEWORK LIFECYCLE
-- ============================

function Mantle.Begin()
    -- Global frame setup
end

function Mantle.End()
    -- Global frame cleanup
end

-- ============================
-- GRAPHICS WRAPPERS (No rl.)
-- ============================

function Mantle.Clear(color)
    if not color then
        rl.ClearBackground(rl.BLANK)
    else
        rl.ClearBackground(checkColor(color))
    end
end

function Mantle.Rect(x, y, w, h, color)
    rl.DrawRectangle(x, y, w, h, checkColor(color))
end

function Mantle.Line(x1, y1, x2, y2, color, thick)
    rl.DrawLineEx({ x = x1, y = y1 }, { x = x2, y = y2 }, thick or 1.0, checkColor(color))
end

function Mantle.Circle(x, y, radius, color)
    rl.DrawCircle(math.floor(x), math.floor(y), radius, checkColor(color))
end

function Mantle.Text(text, x, y, size, color)
    rl.DrawText(text, x, y, size, checkColor(color))
end

-- ============================
-- WIDGETS
-- ============================

function Mantle.Button(text, x, y, w, h)
    return button_logic(Mantle, text, x, y, w, h)
end

function Mantle.Checkbox(text, checked, x, y)
    return checkbox_logic(Mantle, text, checked, x, y)
end

function Mantle.Slider(value, x, y, width)
    return slider_logic(Mantle, value, x, y, width)
end

function Mantle.Panel(x, y, width, height, color)
    return panel_logic(Mantle, x, y, width, height, color)
end

-- ============================
-- CORE HELPERS
-- ============================

Mantle.DrawFooter = Core.DrawFooter
Mantle.DrawDashedLine = Core.DrawDashedLine
Mantle.DrawWave = Core.DrawWave
Mantle.DrawIcon = Core.DrawIcon

return Mantle
