local Mantle = {}

local rl = rl
if not rl then error("Mantle: Could not find global 'rl'.") end

Mantle.Theme = require("mantle.theme")

local button_logic = require("mantle.widgets.button")
local checkbox_logic = require("mantle.widgets.checkbox")

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

return Mantle
