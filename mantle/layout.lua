-- mantle/layout.lua
local Layout = {}

-- This stack stores {x, y, padding} for nested layouts
local stack = {}

function Layout.Begin(type, x, y, padding)
    local startX, startY = x, y

    -- If we are in a nested layout, use its cursor as our start
    if #stack > 0 then
        local parent = stack[#stack]
        startX = parent.cursorX
        startY = parent.cursorY
    end

    table.insert(stack, {
        type = type,
        startX = startX or 0,
        startY = startY or 0,
        cursorX = startX or 0,
        cursorY = startY or 0,
        padding = padding or 10,
        maxChildWidth = 0, -- For columns
        maxChildHeight = 0 -- For rows
    })
end

function Layout.End()
    local finished = table.remove(stack)

    -- Now, tell the *parent* layout how much space this layout group took
    if #stack > 0 then
        local totalW = (finished.type == "row") and finished.cursorX - finished.startX or finished.maxChildWidth
        local totalH = (finished.type == "column") and finished.cursorY - finished.startY or finished.maxChildHeight
        Layout.Advance(totalW, totalH)
    end
end

-- Get the drawing position for the *next* widget
function Layout.GetCursor()
    if #stack == 0 then return nil end
    return stack[#stack].cursorX, stack[#stack].cursorY
end

-- Move the cursor after a widget is drawn
function Layout.Advance(w, h)
    if #stack == 0 then return end
    local current = stack[#stack]

    if current.type == "column" then
        current.cursorY = current.cursorY + h + current.padding
        current.maxChildWidth = math.max(current.maxChildWidth, w)
    elseif current.type == "row" then
        current.cursorX = current.cursorX + w + current.padding
        current.maxChildHeight = math.max(current.maxChildHeight, h)
    end
end

return Layout
