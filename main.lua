local Mantle = require("mantle.init") -- Loads your framework

rl.InitWindow(800, 600, "Mantle UI Demo")
rl.SetTargetFPS(60)

while not rl.WindowShouldClose() do
    -- FRAMEWORK START
    Mantle.Begin()

    rl.BeginDrawing()
    rl.ClearBackground(rl.RAYWHITE)

    rl.DrawText("Welcome to Mantle", 50, 50, 30, rl.DARKGRAY)

    -- The Magic: A working button in one line
    if Mantle.Button("Click Me", 50, 100) then
        print("Button was clicked!")
        -- You could change a variable here, e.g., open a menu
    end

    rl.EndDrawing()

    -- FRAMEWORK END
    Mantle.End()
end

rl.CloseWindow()
