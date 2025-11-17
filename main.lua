-- main.lua
local Mantle = require("mantle.init")
local rl = rl

rl.InitWindow(800, 600, "Mantle Demo")
rl.SetTargetFPS(60)

-- === APP STATE ===
-- You hold the data here!
local showDebug = false
local enableSound = true

while not rl.WindowShouldClose() do
    Mantle.Begin()
    rl.BeginDrawing()
    rl.ClearBackground(rl.RAYWHITE)

    rl.DrawText("Mantle Control Panel", 50, 50, 30, rl.DARKGRAY)

    -- === THE CHECKBOXES ===
    -- Syntax: variable = Widget(Text, variable, x, y)

    showDebug = Mantle.Checkbox("Show Debug Info", showDebug, 50, 120)

    enableSound = Mantle.Checkbox("Enable Sound", enableSound, 50, 160)

    -- Logic based on the checkbox
    if showDebug then
        rl.DrawText("Debug Mode: ON", 50, 300, 20, rl.RED)
    end

    rl.EndDrawing()
    Mantle.End()
end

rl.CloseWindow()
