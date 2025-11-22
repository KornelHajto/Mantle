-- Simple test to verify Mantle works with LÖVE2D
local Mantle = require("mantle.init")

Mantle.Window({
    width = 400,
    height = 300,
    title = "Mantle LÖVE2D Test"
})

local counter = 0
local sliderValue = 0.5
local checked = false
local textInput = ""
local selectedIndex = 1

Mantle.Run(function()
    Mantle.Clear({30, 30, 30, 255})
    
    Mantle.Column(20, 20, 360, 260, 10, function()
        Mantle.Text("Mantle LÖVE2D Test", 24, {255, 255, 255, 255})
        
        Mantle.Spacer(10)
        
        if Mantle.Button("Click Me: " .. counter, nil, nil, 200, 40) then
            counter = counter + 1
        end
        
        Mantle.Spacer(5)
        
        checked = Mantle.Checkbox("Enable feature", checked)
        
        Mantle.Spacer(5)
        
        sliderValue = Mantle.Slider(sliderValue, nil, nil, 200)
        Mantle.Text(string.format("Value: %.2f", sliderValue), 16, {200, 200, 200, 255})
        
        Mantle.Spacer(5)
        
        textInput = Mantle.Input(textInput, "Type something...", nil, nil, 300)
        
        Mantle.Spacer(5)
        
        selectedIndex = Mantle.Dropdown({"Option 1", "Option 2", "Option 3"}, selectedIndex, nil, nil, 200)
    end)
end)
