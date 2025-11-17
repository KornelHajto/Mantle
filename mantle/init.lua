local Mantle = {}

local rl = rl
if not rl then error("Mantle: Could not find global 'rl'.") end

Mantle.Theme = require("mantle.theme")

local button_logic = require("mantle.widgets.button")

function Mantle.Begin()
    -- Any global frame setup
end

function Mantle.End()
    -- Any global frame cleanup
end

function Mantle.Button(text, x, y, w, h)
    return button_logic(Mantle, text, x, y, w, h)
end

return Mantle
