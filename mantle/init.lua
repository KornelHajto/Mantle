local Mantle = {}

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

-- LOVE2D state
local drawCallback = nil

-- POST-DRAW QUEUE (Z-Index Layer)
local postDrawQueue = {}

-- INPUT BLOCKING STATE
local currentBlockRect = nil
local nextBlockRect = nil

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

function Mantle.Run(callback)
    drawCallback = callback
    
    -- Update window with configured settings
    love.window.setTitle(config.title)
    love.window.setMode(config.width, config.height, {
        borderless = config.transparent,
        resizable = false,
        vsync = 1
    })
end

-- ============================
-- INPUT BLOCKING API
-- ============================

function Mantle.SetInputBlock(x, y, w, h)
    nextBlockRect = { x = x, y = y, w = w, h = h }
end

function Mantle.IsMouseBlocked()
    if not currentBlockRect then return false end
    local mx, my = love.mouse.getPosition()
    return (mx >= currentBlockRect.x and mx <= currentBlockRect.x + currentBlockRect.w and
        my >= currentBlockRect.y and my <= currentBlockRect.y + currentBlockRect.h)
end

-- ============================
-- LAYOUT API
-- ============================

function Mantle.Column(x, y, w, h, padding, contentFunc)
    Layout.Begin("column", x, y, w, h, padding)
    contentFunc()
    Layout.End()
end

function Mantle.Row(x, y, w, h, padding, contentFunc)
    Layout.Begin("row", x, y, w, h, padding)
    contentFunc()
    Layout.End()
end

-- NEW: Fixed Spacer
function Mantle.Spacer(size)
    Layout.Advance(size, size)
end

-- NEW: Flexible Spacer (Pushes content)
function Mantle.Fill()
    local remaining = Layout.GetRemaining()
    if remaining > 0 then
        Layout.Advance(remaining, remaining)
    end
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

function Mantle.Begin()
    if config.draggable and Core.HandleDrag then
        Core.HandleDrag()
    end
    
    currentBlockRect = nextBlockRect
    nextBlockRect = nil
    postDrawQueue = {}
end

function Mantle.End()
    love.graphics.setScissor() -- End any scissor mode
    for _, drawFunc in ipairs(postDrawQueue) do
        drawFunc()
    end
end

-- LOVE2D callbacks that will be registered
function Mantle._love_draw()
    if drawCallback then
        Mantle.Begin()
        drawCallback()
        Mantle.End()
    end
end

function Mantle._love_textinput(text)
    -- Store text input for the Input widget
    Mantle._textInputBuffer = (Mantle._textInputBuffer or "") .. text
end

-- Register the LOVE callbacks
function Mantle._registerCallbacks()
    love.draw = Mantle._love_draw
    love.textinput = Mantle._love_textinput
end

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
        love.graphics.clear(0, 0, 0, 0)
    else
        love.graphics.clear(color[1]/255, color[2]/255, color[3]/255, color[4]/255)
    end
end

function Mantle.Rect(x, y, w, h, color)
    local finalX, finalY = resolvePos(x, y)
    love.graphics.setColor(checkColor(color)[1]/255, checkColor(color)[2]/255, 
                           checkColor(color)[3]/255, checkColor(color)[4]/255)
    love.graphics.rectangle("fill", finalX, finalY, w, h)
    love.graphics.setColor(1, 1, 1, 1)
    Layout.Advance(w, h)
end

function Mantle.Line(x1, y1, x2, y2, color, thick)
    love.graphics.setColor(checkColor(color)[1]/255, checkColor(color)[2]/255, 
                           checkColor(color)[3]/255, checkColor(color)[4]/255)
    love.graphics.setLineWidth(thick or 1.0)
    love.graphics.line(x1, y1, x2, y2)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setLineWidth(1)
end

function Mantle.Circle(x, y, radius, color)
    love.graphics.setColor(checkColor(color)[1]/255, checkColor(color)[2]/255, 
                           checkColor(color)[3]/255, checkColor(color)[4]/255)
    love.graphics.circle("fill", math.floor(x), math.floor(y), radius)
    love.graphics.setColor(1, 1, 1, 1)
end

function Mantle.Text(text, size, color, x, y)
    -- Create or get a font at the requested size
    local font
    if size and size ~= Mantle.Theme.fontSize then
        -- Use default font at the requested size
        font = love.graphics.newFont(size)
    else
        font = Mantle.Theme.font or love.graphics.getFont()
    end
    
    local oldFont = love.graphics.getFont()
    love.graphics.setFont(font)
    
    local w = font:getWidth(text)
    local h = font:getHeight()

    local finalX, finalY = resolvePos(x, y)

    love.graphics.setColor(checkColor(color)[1]/255, checkColor(color)[2]/255, 
                           checkColor(color)[3]/255, checkColor(color)[4]/255)
    love.graphics.print(text, finalX, finalY)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(oldFont)

    Layout.Advance(w, h)
end

-- ============================
-- WIDGETS
-- ============================

function Mantle.Button(text, x, y, w, h, style)
    w = w or 120
    h = h or 40
    local finalX, finalY = resolvePos(x, y)
    local result = button_logic(Mantle, text, finalX, finalY, w, h, style)
    Layout.Advance(w, h)
    return result
end

function Mantle.Checkbox(text, checked, x, y, style)
    local font = Mantle.Theme.font or love.graphics.getFont()
    local w = 20 + 8 + font:getWidth(text)
    local h = 20
    local finalX, finalY = resolvePos(x, y)
    local result = checkbox_logic(Mantle, text, checked, finalX, finalY, style)
    Layout.Advance(w, h)
    return result
end

function Mantle.Slider(value, x, y, width, style)
    local w = width or 150
    local h = 20
    local finalX, finalY = resolvePos(x, y)
    local result = slider_logic(Mantle, value, finalX, finalY, w, style)
    Layout.Advance(w, h)
    return result
end

function Mantle.Panel(a1, a2, a3, a4, a5, a6, a7)
    local x, y, w, h, color, contentFunc, style

    if type(a3) == "number" then
        x, y, w, h = a1, a2, a3, a4
        color = a5
        contentFunc = a6
        style = a7
    else
        w, h = a1, a2
        color = a3
        contentFunc = a4
        style = a5
        x, y = resolvePos(nil, nil)
    end

    panel_logic(Mantle, x, y, w, h, color, style)

    -- === UPDATE: Pass Inner Bounds to Layout ===
    if contentFunc then
        local padding = 10
        local innerW = (w or 0) - (padding * 2)
        local innerH = (h or 0) - (padding * 2)
        -- Correctly pass 6 arguments: x, y, w, h, padding, func
        Mantle.Column(x + padding, y + padding, innerW, innerH, padding, contentFunc)
    end
    -- ============================================

    Layout.Advance(w, h)
end

function Mantle.Input(text, placeholder, x, y, w, style)
    local finalX, finalY = resolvePos(x, y)
    local width = w or 200
    local height = 40
    local newText = input_logic(Mantle, text, placeholder, finalX, finalY, width, style)
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
Mantle.DrawRectStyle = Core.DrawRectStyle

-- ============================
-- LOVE2D CALLBACKS
-- ============================

function love.draw()
    if not drawCallback then return end
    
    if config.draggable and Core.HandleDrag then
        Core.HandleDrag()
    end

    Mantle.Begin()

    currentBlockRect = nextBlockRect
    nextBlockRect = nil
    postDrawQueue = {}

    -- Call the user's draw function
    drawCallback()

    -- Draw post-draw queue (layers)
    for _, drawFunc in ipairs(postDrawQueue) do
        drawFunc()
    end

    Mantle.End()
end

function love.textinput(text)
    -- Store text input for the Input widget
    Mantle._textInputBuffer = (Mantle._textInputBuffer or "") .. text
end

function love.update(dt)
    -- Update logic can go here if needed
end

return Mantle
