local Mantle = {}

local rl = rl
if not rl then error("Mantle: Could not find global 'rl'.") end

Mantle.Theme = require("mantle.theme")

local button_logic = require("mantle.widgets.button")
local checkbox_logic = require("mantle.widgets.checkbox")
local slider_logic = require("mantle.widgets.slider")
local panel_logic = require("mantle.widgets.panel")
local Core = require("mantle.core")

function Mantle.Begin()
    -- Any global frame setup
end

function Mantle.End()
    -- Any global frame cleanup
end

function Mantle.Button(text, x, y, w, h)
    return button_logic(Mantle, text, x, y, w, h)
end

function Mantle.Checkbox(text, checked, x, y)
    return checkbox_logic(Mantle, text, checked, x, y)
end

function Mantle.Slider(value, x, y, width)
    return slider_logic(Mantle, value, x, y, width)
end

function Mantle.Panel(x, y, width, height, color)
    return panel_logic(Mantle, x, y, width, height, color)
end

-- Helper functions from Core
Mantle.DrawFooter = Core.DrawFooter
Mantle.DrawDashedLine = Core.DrawDashedLine
Mantle.DrawWave = Core.DrawWave
Mantle.DrawIcon = Core.DrawIcon
Mantle.HandleDrag = Core.HandleDrag

return Mantle
