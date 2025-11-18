local Mantle = require("mantle.init")

-- Configure window
Mantle.Window({
    width = 500,
    height = 400,
    title = "Mantle Style System Demo",
    draggable = true,
    transparent = false
})

-- Run the application
Mantle.Run(function()
    -- Load font
    Mantle.LoadFont("demo/assets/Roboto-Regular.ttf", 20)
    
    -- Clear background
    Mantle.Clear({ 30, 30, 30, 255 })
    
    -- Main content
    Mantle.Column(20, 20, 460, 360, 15, function()
        -- Title
        Mantle.Text("Mantle Style System Demo", 28, { 255, 255, 255, 255 })
        
        Mantle.Spacer(10)
        
        -- Section 1: Default Button
        Mantle.Text("1. Default Button (no style override)", 16, { 200, 200, 200, 255 })
        Mantle.Spacer(5)
        Mantle.Button("Default Style", nil, nil, 180, 40)
        
        Mantle.Spacer(20)
        
        -- Section 2: Custom Per-Instance Style
        Mantle.Text("2. Custom Per-Instance Style", 16, { 200, 200, 200, 255 })
        Mantle.Spacer(5)
        Mantle.Button("Red Rounded", nil, nil, 180, 40, {
            borderRadius    = 0.5,
            backgroundColor = { 220, 50, 50, 255 },
            hoverColor      = { 255, 80, 80, 255 },
            activeColor     = { 180, 30, 30, 255 },
            textColor       = { 255, 255, 255, 255 },
            borderColor     = { 255, 100, 100, 255 }
        })
        
        Mantle.Spacer(20)
        
        -- Section 3: Global Theme Modified
        Mantle.Text("3. Global Theme Modified", 16, { 200, 200, 200, 255 })
        Mantle.Spacer(5)
        
        -- Modify global theme before drawing
        Mantle.Theme.styles.Button.backgroundColor = { 50, 150, 255, 255 }
        Mantle.Theme.styles.Button.borderRadius = 0.3
        
        Mantle.Button("Themed Button", nil, nil, 180, 40)
        
        -- Reset theme for other demos
        Mantle.Theme.styles.Button.backgroundColor = nil
        Mantle.Theme.styles.Button.borderRadius = 0.15
        
        Mantle.Spacer(20)
        
        -- Section 4: Other Styled Widgets
        Mantle.Text("4. Other Styled Widgets", 16, { 200, 200, 200, 255 })
        Mantle.Spacer(5)
        
        Mantle.Row(nil, nil, 460, 60, 10, function()
            -- Custom slider
            local sliderVal = 0.6
            Mantle.Text("Slider:", 16, { 200, 200, 200, 255 })
            Mantle.Slider(sliderVal, nil, nil, 200, {
                fillColor  = { 100, 255, 100, 255 },
                knobColor  = { 255, 255, 255, 255 },
                knobRadius = 10
            })
        end)
        
        Mantle.Spacer(10)
        
        -- Custom checkbox
        local checkVal = true
        Mantle.Checkbox("Styled Checkbox", checkVal, nil, nil, {
            borderRadius = 0.4,
            checkColor   = { 255, 200, 50, 255 },
            borderColor  = { 200, 200, 200, 255 }
        })
        
        Mantle.Spacer(10)
        
        -- Custom panel
        Mantle.Panel(200, 60, { 60, 60, 80, 255 }, function()
            Mantle.Text("Custom Panel", 16, { 255, 255, 255, 255 })
        end, {
            borderRadius    = 0.25,
            backgroundColor = { 80, 50, 120, 255 },
            borderColor     = { 150, 100, 200, 255 }
        })
    end)
end)
