-- Example Mantle app using LÖVE2D
-- To run a demo, require it here instead of the example below

-- Require the demo you want to run:
require("demo.weather")

-- Or use the simple example below:
--[[
local Mantle = require("mantle.init")

-- FIX: UTF-8 Degree Symbol
local DEG = "\194\176"

-- 1. WINDOW CONFIG
Mantle.Window({
    width = 350,
    height = 600,
    title = "Weather",
    draggable = true,
    transparent = true
})

-- 2. PALETTE & DATA
local Pal = {
    skyBlue  = { 37, 109, 143, 255 },
    deepBlue = { 24, 71, 99, 255 },
    text     = { 255, 255, 255, 255 },
    textDim  = { 200, 200, 200, 255 },
    redDot   = { 224, 79, 83, 255 }
}

Mantle.Run(function()
    Mantle.Clear()
    
    -- Draw simple UI
    Mantle.Panel(0, 0, 350, 600, Pal.deepBlue)
    
    Mantle.Column(20, 20, 310, 560, 10, function()
        Mantle.Text("Hello LÖVE2D!", 24, Pal.text)
        
        if Mantle.Button("Click Me", nil, nil, 200, 40) then
            print("Button clicked!")
        end
    end)
end)
]]
