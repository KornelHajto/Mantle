local Mantle = require("mantle.init")
local rl = rl

Mantle.Window({ width = 1000, height = 700, title = "Scroll Demo", draggable = true, transparent = true })
Mantle.LoadFont("assets/roboto.ttf", 20)

local Pal = { bg = { 30, 30, 46, 255 }, panel = { 50, 50, 75, 255 }, text = { 205, 214, 244, 255 }, accent = { 137, 180, 250, 255 } }
Mantle.Theme.colors.primary = Pal.panel
Mantle.Theme.colors.text = Pal.text
Mantle.Theme.colors.accent = Pal.accent

-- 1. STATE STORAGE (Outside the loop!)
local checkboxStates = {}

-- Initialize them all to false
for i = 1, 50 do checkboxStates[i] = false end

Mantle.Run(function()
    Mantle.Clear()
    Mantle.Panel(0, 0, 1000, 700, Pal.bg)

    Mantle.Row(0, 0, 0, function()
        -- Left Side
        Mantle.Panel(300, 700, Pal.panel, function()
            Mantle.Text("Settings", 30, Pal.accent)
            Mantle.Text("This side does not scroll.", 16, Pal.text)
        end)

        -- Right Side
        Mantle.Column(nil, nil, 20, function()
            Mantle.Text("Advanced Configuration", 24, Pal.text)

            Mantle.ScrollArea(650, 600, function()
                Mantle.Text("General Options", 20, Pal.accent)

                for i = 1, 50 do
                    Mantle.Row(nil, nil, 10, function()
                        -- 2. USE THE STATE
                        -- Read from table, then Save result back to table
                        checkboxStates[i] = Mantle.Checkbox("Option " .. i, checkboxStates[i])

                        Mantle.Text("Description for option " .. i, 14, { 100, 100, 100, 255 })
                    end)
                end

                Mantle.Rect(0, 0, 0, 20, { 0, 0, 0, 0 })
                Mantle.Button("Save All Changes", nil, nil, 600, 50)
                Mantle.Rect(0, 0, 0, 50, { 0, 0, 0, 0 })
            end)
        end)
    end)
end)
