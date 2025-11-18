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
local scroll_logic = require("mantle.widgets.scroll")
local dropdown_logic = require("mantle.widgets.dropdown")

-- Internal Configuration
local config = {
    width = 800,
    height = 600,
    title = "Mantle App",
    transparent = false,
    draggable = false,
    targetFPS = 60
}

-- POST-DRAW QUEUE (Z-Index Layer)
local postDrawQueue = {}

-- INPUT BLOCKING STATE
-- Used to prevent clicks from bleeding through popups (like Dropdowns)
local currentBlockRect = nil -- The block active for THIS frame
local nextBlockRect = nil    -- The block being built for the NEXT frame

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

        -- 1. Promote Blocker for this frame
        -- Take the blocking request from the previous frame and apply it now
        currentBlockRect = nextBlockRect
        nextBlockRect = nil -- Reset for new requests

        -- 2. Reset Queue
        postDrawQueue = {}

        -- 3. Draw Main UI
        if drawCallback then drawCallback() end

        -- 4. Draw Popups (Top Layer)
        rl.EndScissorMode() -- Ensure we draw over scroll areas
        for _, drawFunc in ipairs(postDrawQueue) do
            drawFunc()
        end

        rl.EndDrawing()
        Mantle.End()
    end

    rl.CloseWindow()
end

-- ============================
-- INPUT BLOCKING API
-- ============================

-- Call this to block input in a specific area for the NEXT frame
-- (Used by Dropdowns/Popups)
function Mantle.SetInputBlock(x, y, w, h)
    -- Simple implementation: last call wins (supports one active popup)
    -- A more complex version would support a list of blocked rects
    nextBlockRect = { x = x, y = y, w = w, h = h }
end

-- Widgets call this to see if they are allowed to react to the mouse
function Mantle.IsMouseBlocked()
    if not currentBlockRect then return false end

    local m = rl.GetMousePosition()
    -- Check if mouse is inside the blocked rectangle
    return (m.x >= currentBlockRect.x and m.x <= currentBlockRect.x + currentBlockRect.w and
        m.y >= currentBlockRect.y and m.y <= currentBlockRect.y + currentBlockRect.h)
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
-- ASSETS & LAYERS
-- ============================

function Mantle.LoadFont(path, size)
    local font = Assets.LoadFont(path, size)
    Mantle.Theme.font = font
    Mantle.Theme.fontSize = size
end

function Mantle.Layer(drawFunc)
    table.insert(postDrawQueue, drawFunc)
end

-- ============================
-- FRAMEWORK LIFECYCLE
-- ============================

function Mantle.Begin() end

function Mantle.End() end

-- ============================
-- GRAPHICS WRAPPERS
-- ============================

local function resolvePos(x, y)
    if x and y then return x, y end
    local lx, ly = Layout.GetCursor()
    if lx then return lx, ly end
    return x or 0, y or 0
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
    rl.DrawLineEx({ x = x1, y = y1 }, { x = x2, y = y2 }, thick or 1.0, checkColor(color))
end

function Mantle.Circle(x, y, radius, color)
    rl.DrawCircle(math.floor(x), math.floor(y), radius, checkColor(color))
end

function Mantle.Text(text, size, color, x, y)
    local font = Mantle.Theme.font or rl.GetFontDefault()
    local fontSize = size or Mantle.Theme.fontSize
    local spacing = 1.0

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
    local w = 20 + 8 + rl.MeasureText(text, Mantle.Theme.fontSize)
    local h = 20
    local finalX, finalY = resolvePos(x, y)
    local result = checkbox_logic(Mantle, text, checked, finalX, finalY)
    Layout.Advance(w, h)
    return result
end

function Mantle.Slider(value, x, y, width)
    local w = width or 150
    local h = 20
    local finalX, finalY = resolvePos(x, y)
    local result = slider_logic(Mantle, value, finalX, finalY, w)
    Layout.Advance(w, h)
    return result
end

function Mantle.Panel(a1, a2, a3, a4, a5, a6)
    local x, y, w, h, color, contentFunc

    if type(a3) == "number" then
        x, y, w, h = a1, a2, a3, a4
        color = a5
        contentFunc = a6
    else
        w, h = a1, a2
        color = a3
        contentFunc = a4
        x, y = resolvePos(nil, nil)
    end

    panel_logic(Mantle, x, y, w, h, color)

    if contentFunc then
        Mantle.Column(x + 10, y + 10, 10, contentFunc)
    end

    Layout.Advance(w, h)
end

function Mantle.Input(text, placeholder, x, y, w)
    local finalX, finalY = resolvePos(x, y)
    local width = w or 200
    local height = 40
    local newText = input_logic(Mantle, text, placeholder, finalX, finalY, width)
    Layout.Advance(width, height)
    return newText
end

function Mantle.ScrollArea(width, height, contentFunc)
    width = width or 200
    height = height or 200
    local x, y = resolvePos(nil, nil)
    scroll_logic(Mantle, width, height, contentFunc, x, y)
    Layout.Advance(width, height)
end

function Mantle.Dropdown(options, selectedIndex, x, y, w)
    local finalX, finalY = resolvePos(x, y)
    local width = w or 150
    local height = 40

    local newIndex = dropdown_logic(Mantle, options, selectedIndex, finalX, finalY, width)

    Layout.Advance(width, height)
    return newIndex
end

-- ============================
-- CORE HELPERS
-- ============================

Mantle.DrawFooter = Core.DrawFooter
Mantle.DrawDashedLine = Core.DrawDashedLine
Mantle.DrawWave = Core.DrawWave
Mantle.DrawIcon = Core.DrawIcon

return Mantle
