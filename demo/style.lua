local Mantle = require("mantle.init")

Mantle.Window({
    width = 400,
    height = 200,
    title = "Style Test",
    draggable = true,
    transparent = false
})

Mantle.Run(function()
    Mantle.LoadFont("demo/assets/Roboto-Regular.ttf", 20)
    Mantle.Clear()

    Mantle.Column(20, 20, 360, 160, 10, function()
        -- 1. Default button (no style)
        Mantle.Button("Default", nil, nil, 120, 40)

        -- 2. Custom per-instance style
        Mantle.Button("Red Rounded", nil, nil, 160, 40, {
            borderRadius    = 0.5,
            backgroundColor = { 255, 0, 0, 255 },
            textColor       = { 255, 255, 255, 255 }
        })

        -- 3. Themed button: tweak global default, then draw
        Mantle.Theme.styles.Button.backgroundColor = { 0, 128, 255, 255 }
        Mantle.Button("Themed", nil, nil, 120, 40)
    end)
end)