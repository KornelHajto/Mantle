local Layout = {}

-- This stack stores {x, y, padding} for nested layouts
local stack = {}

-- === NEW: Store the size of the most recently finished layout ===
-- The ScrollArea widget reads these to know how tall the content was.
Layout.lastWidth = 0
Layout.lastHeight = 0

function Layout.Begin(type, x, y, w, h, padding)
    local startX, startY = x, y

    -- If we are in a nested layout, use its cursor as our start
    if #stack > 0 then
        local parent = stack[#stack]
        -- If x/y were not provided (nil), use the parent's cursor
        if not startX then startX = parent.cursorX end
        if not startY then startY = parent.cursorY end
    end

    table.insert(stack, {
        type = type,
        startX = startX or 0,
        startY = startY or 0,

        width = w or 0,
        height = h or 0,

        cursorX = startX or 0,
        cursorY = startY or 0,
        padding = padding or 10,
        maxChildWidth = 0, -- For columns
        maxChildHeight = 0 -- For rows
    })
end

function Layout.End()
    local finished = table.remove(stack)

    -- Calculate exactly how big that group was
    local totalW = (finished.type == "row") and (finished.cursorX - finished.startX) or finished.maxChildWidth
    local totalH = (finished.type == "column") and (finished.cursorY - finished.startY) or finished.maxChildHeight

    -- === NEW: Save the size so widgets (like ScrollArea) can read it ===
    Layout.lastWidth = totalW
    Layout.lastHeight = totalH

    -- Now, tell the *parent* layout how much space this layout group took
    if #stack > 0 then
        Layout.Advance(totalW, totalH)
    end
end

function Layout.GetCursor()
    if #stack == 0 then return nil end
    return stack[#stack].cursorX, stack[#stack].cursorY
end

function Layout.Advance(w, h)
    if #stack == 0 then return end
    local current = stack[#stack]

    if current.type == "column" then
        current.cursorY = current.cursorY + h + current.padding

        current.maxChildWidth = math.max(current.maxChildWidth, w)

        current.maxChildHeight = current.maxChildHeight + h + current.padding
    elseif current.type == "row" then
        current.cursorX = current.cursorX + w + current.padding

        current.maxChildHeight = math.max(current.maxChildHeight, h)

        current.maxChildWidth = current.maxChildWidth + w + current.padding
    end
end

function Layout.GetRemaining()
    if #stack == 0 then return 0 end
    local current = stack[#stack]

    if current.type == "column" then
        if current.height == 0 then return 0 end     -- No limit defined
        local used = current.cursorY - current.startY
        return math.max(0, current.height - used)
    else                                            -- row
        if current.width == 0 then return 0 end     -- No limit defined
        local used = current.cursorX - current.startX
        return math.max(0, current.width - used)
    end
end

return Layout
