local rl = rl
local Mantle = require("mantle.init")

rl.SetConfigFlags(rl.FLAG_WINDOW_UNDECORATED + rl.FLAG_WINDOW_TRANSPARENT)
rl.InitWindow(600, 350, "Graph Widget")
rl.SetTargetFPS(60)

local scale = 50.0

local originX = 300
local originY = 175

local timeOffset = 0.0

while not rl.WindowShouldClose() do
    Mantle.HandleDrag()
    timeOffset = timeOffset + 0.02

    Mantle.Begin()
    rl.BeginDrawing()
    rl.ClearBackground(rl.BLANK)

    Mantle.Panel(0, 0, 600, 350, { 46, 139, 87, 255 })

    rl.DrawLine(0, originY, 600, originY, { 0, 0, 0, 150 })
    rl.DrawLine(originX, 0, originX, 350, { 0, 0, 0, 150 })


    for i = -6, 6 do
        local x = originX + (i * scale)

        if i ~= 0 then
            rl.DrawLine(x, 0, x, 350, { 0, 0, 0, 40 })
            rl.DrawText(tostring(i), x + 2, originY + 2, 10, { 0, 0, 0, 180 })
        end
    end

    for i = -3, 3 do
        local y = originY - (i * scale)

        if i ~= 0 then
            rl.DrawLine(0, y, 600, y, { 0, 0, 0, 40 })
            -- Draw Number
            rl.DrawText(tostring(i), originX + 2, y + 2, 10, { 0, 0, 0, 180 })
        end
    end

    local lastX, lastY = -1, -1

    for screenX = 0, 600, 2 do
        local mathX = (screenX - originX) / scale

        local mathY = math.sin(mathX + timeOffset)

        local screenY = originY - (mathY * scale)

        if lastX ~= -1 then
            rl.DrawLineEx({ x = lastX, y = lastY }, { x = screenX, y = screenY }, 2.0, { 20, 20, 20, 200 })
        end

        lastX = screenX
        lastY = screenY
    end

    local cursorMathX = 2.5
    local cursorScreenX = originX + (cursorMathX * scale)

    Mantle.DrawDashedLine(cursorScreenX, 0, cursorScreenX, 350, 2, { 0, 0, 0, 150 })

    local dotMathY = math.sin(cursorMathX + timeOffset)
    local dotScreenY = originY - (dotMathY * scale)

    rl.DrawCircle(cursorScreenX, dotScreenY, 5, rl.BLACK)

    local valueText = string.format("%.2f", dotMathY)
    rl.DrawText(valueText, 50, 40, 60, { 0, 0, 0, 100 })

    rl.EndDrawing()
    Mantle.End()
end

rl.CloseWindow()
