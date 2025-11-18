local Mantle = require("mantle.init")
local rl = rl -- For GetFrameTime and default font

-- 1. WINDOW SETUP
Mantle.Window({
    width = 500,
    height = 550,
    title = "Mantle Font Demo",
    draggable = false
})

-- 2. LOAD FONTS
-- This loads the font AND sets it as the default for Mantle.Theme
Mantle.LoadFont("assets/Roboto.ttf", 22)

-- 3. APP STATE
local sliderVal = 0.5
local isChecked = true

-- 4. RUN
Mantle.Run(function()
    Mantle.Clear({ 240, 240, 240 }) -- Light gray background

    Mantle.Column(30, 30, 20, function()
        -- This text uses the loaded Roboto 22 (from theme)
        Mantle.Text("Mantle UI Demo", 22, { 80, 80, 80 })

        -- This text overrides the size, but still uses Roboto
        Mantle.Text("Custom Fonts Look Professional", 32, { 0, 0, 0 })

        -- This button will use Roboto 22 (from theme)
        Mantle.Button("Smooth Button")

        -- This checkbox will use Roboto 22
        isChecked = Mantle.Checkbox("Smooth Checkbox", isChecked)

        -- This slider will draw... oh, wait.
        sliderVal = Mantle.Slider(sliderVal, nil, nil, 300)

        -- COMPARISON: Draw with the old, pixelated font
        Mantle.Text("--- Comparison ---", 16, { 150, 150, 150 })
        rl.DrawText(
            "This is the OLD default pixel font",
            30, 450, 20, rl.RED
        )
    end)
end)
