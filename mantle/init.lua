-- mantle/init.lua
local Mantle = {}

-- 1. Detect Raylib (Handles different naming conventions)
-- TSnake41's binding usually exposes a global 'rl' or 'raylib'
local rl = rl

if not rl then
    error("Mantle: Could not find global 'raylib'. Are you running this with raylua_s.exe?")
end

-- 2. Load Submodules
Mantle.Theme = require("mantle.theme")

-- 3. State Management (For "Immediate Mode" logic)
local state = {
    mouseX = 0,
    mouseY = 0,
    isMouseDown = false
}

function Mantle.Begin()
    -- Update inputs once per frame
    state.mouseX = rl.GetMouseX()
    state.mouseY = rl.GetMouseY()
    state.isMouseDown = rl.IsMouseButtonDown(0)
end

function Mantle.End()
    -- Clean up or draw tooltips here later
end

-- 4. The First Widget: A Button
function Mantle.Button(text, x, y, width, height)
    width = width or 120
    height = height or 40

    -- Logic: Hover & Click
    local isHovered = (state.mouseX >= x and state.mouseX <= x + width and
        state.mouseY >= y and state.mouseY <= y + height)

    local isClicked = isHovered and rl.IsMouseButtonReleased(0)

    -- Styling (Reading from your Theme)
    local bgColor = isHovered and Mantle.Theme.colors.highlight or Mantle.Theme.colors.primary
    local txtColor = Mantle.Theme.colors.text

    -- Drawing
    rl.DrawRectangle(x, y, width, height, bgColor)
    rl.DrawRectangleLines(x, y, width, height, Mantle.Theme.colors.accent)

    -- Center Text (Simple math for now)
    local txtWidth = rl.MeasureText(text, Mantle.Theme.fontSize)
    local txtX = x + (width - txtWidth) / 2
    local txtY = y + (height - Mantle.Theme.fontSize) / 2

    rl.DrawText(text, math.floor(txtX), math.floor(txtY), Mantle.Theme.fontSize, txtColor)

    return isClicked
end

return Mantle
