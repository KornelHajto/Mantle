local Mantle = {}

local rl = rl
if not rl then error("Mantle: Could not find global 'rl'.") end

-- Imports
Mantle.Theme = require("mantle.theme")
local Core = require("mantle.core")
local Layout = require("mantle.layout")
local Assets = require("mantle.assets")

local button_logic = require("mantle.widgets.button")
local checkbox_logic = require("mantle.widgets.checkbox")
local slider_logic = require("mantle.widgets.slider")
local panel_logic = require("mantle.widgets.panel")
local input_logic = require("mantle.widgets.input")

-- Internal Configuration
local config = {
    width = 800,
    height = 600,
    title = "Mantle App",
    transparent = false,
    draggable = false,
    targetFPS = 60
}

-- Color Helper
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
        if config.draggable and Core.HandleDrag then
            Core.HandleDrag()
        end

        Mantle.Begin()
        rl.BeginDrawing()
        if drawCallback then drawCallback() end
        rl.EndDrawing()
        Mantle.End()
    end

    rl.CloseWindow()
end

-- ============================
-- LAYOUT API
-- ============================

function Mantle.Column(x, y, padding, contentFunc)
    Layout.Begin("column", x, y, padding)
    contentFunc()
    Layout.End()
end

function Mantle.Row(x, y, padding, contentFunc)
    Layout.Begin("row", x, y, padding)
    contentFunc()
    Layout.End()
end

-- ============================
-- ASSETS
-- ============================

function Mantle.LoadFont(path, size)
    local font = Assets.LoadFont(path, size)
    Mantle.Theme.font = font
    Mantle.Theme.fontSize = size
end

-- ============================
-- FRAMEWORK LIFECYCLE
-- ============================

function Mantle.Begin() end

function Mantle.End() end

-- ============================
-- GRAPHICS WRAPPERS (No rl.)
-- ============================

-- Helper function to decide if we use Layout's XY or user's XY
local function resolvePos(x, y)
    if x and y then return x, y end -- User override
    local lx, ly = Layout.GetCursor()
    if lx then return lx, ly end    -- Use layout
    return x or 0, y or 0           -- Default
end

function Mantle.Clear(color)
    if not color then
        rl.ClearBackground(rl.BLANK)
    else
        rl.ClearBackground(checkColor(color))
    end
end

function Mantle.Rect(x, y, w, h, color)
    local finalX, finalY = resolvePos(x, y)
    rl.DrawRectangle(finalX, finalY, w, h, checkColor(color))
    Layout.Advance(w, h)
end

function Mantle.Line(x1, y1, x2, y2, color, thick)
    -- Lines don't really fit the layout model, so we draw them manually.
    rl.DrawLineEx({ x = x1, y = y1 }, { x = x2, y = y2 }, thick or 1.0, checkColor(color))
end

function Mantle.Circle(x, y, radius, color)
    -- Circles also don't have a W/H, so we draw manually.
    rl.DrawCircle(math.floor(x), math.floor(y), radius, checkColor(color))
end

function Mantle.Text(text, size, color, x, y)
    local font = Mantle.Theme.font or rl.GetFontDefault()
    local fontSize = size or Mantle.Theme.fontSize
    local spacing = 1.0 -- Space between letters

    local dims = rl.MeasureTextEx(font, text, fontSize, spacing)
    local w = dims.x
    local h = dims.y

    local finalX, finalY = resolvePos(x, y)

    rl.DrawTextEx(font, text, { x = finalX, y = finalY }, fontSize, spacing, checkColor(color))

    Layout.Advance(w, h)
end

-- ============================
-- WIDGETS
-- ============================

function Mantle.Button(text, x, y, w, h)
    w = w or 120
    h = h or 40
    local finalX, finalY = resolvePos(x, y)
    local result = button_logic(Mantle, text, finalX, finalY, w, h)
    Layout.Advance(w, h)
    return result
end

function Mantle.Checkbox(text, checked, x, y)
    -- Estimate size for layout
    local w = 20 + 8 + rl.MeasureText(text, Mantle.Theme.fontSize)
    local h = 20

    local finalX, finalY = resolvePos(x, y)
    local result = checkbox_logic(Mantle, text, checked, finalX, finalY)
    Layout.Advance(w, h)
    return result
end

function Mantle.Slider(value, x, y, width)
    local w = width or 150
    local h = 20 -- From slider.lua logic

    local finalX, finalY = resolvePos(x, y)
    local result = slider_logic(Mantle, value, finalX, finalY, w)
    Layout.Advance(w, h)
    return result
end

function Mantle.Panel(x, y, width, height, color)
    local finalX, finalY = resolvePos(x, y)
    panel_logic(Mantle, finalX, finalY, width, height, color)
    Layout.Advance(width, height)
end

function Mantle.Input(text, placeholder, x, y, w)
    local finalX, finalY = resolvePos(x, y)
    local width = w or 200
    local height = 40

    local newText = input_logic(Mantle, text, placeholder, finalX, finalY, width)
    Layout.Advance(width, height)

    return newText
end

-- ============================
-- CORE HELPERS
-- ============================

Mantle.DrawFooter = Core.DrawFooter
Mantle.DrawDashedLine = Core.DrawDashedLine
Mantle.DrawWave = Core.DrawWave
Mantle.DrawIcon = Core.DrawIcon
-- Note: We don't expose HandleDrag. It's used internally by Mantle.Run

return Mantle
