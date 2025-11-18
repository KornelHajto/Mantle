local Mantle = require("mantle.init")
local rl = rl

-- 1. WINDOW SETUP
Mantle.Window({
    width = 600,
    height = 500,
    title = "Dropdown & Layer Demo",
    draggable = true,
    transparent = true
})

-- 2. ASSETS
Mantle.LoadFont("assets/roboto.ttf", 20)

-- 3. THEME SETUP
local Pal = {
    bg = { 30, 30, 46, 255 },
    panel = { 50, 50, 75, 255 },
    accent = { 137, 180, 250, 255 },
    text = { 205, 214, 244, 255 },
    dim = { 147, 153, 178, 255 }
}
Mantle.Theme.colors.primary = Pal.panel
Mantle.Theme.colors.text = Pal.text
Mantle.Theme.colors.accent = Pal.accent
Mantle.Theme.colors.highlight = { 69, 71, 90, 255 }

-- 4. APP STATE
local resolutions = { "1920x1080", "1280x720", "800x600", "640x480" }
local resIndex = 1

local qualities = { "Low", "Medium", "High", "Ultra" }
local qualIndex = 3

local isVsync = true

-- 5. RUN LOOP
Mantle.Run(function()
    Mantle.Clear()
    Mantle.Panel(0, 0, 600, 500, Pal.bg) -- Main Background

    Mantle.Column(50, 50, 20, function()
        Mantle.Text("Graphics Settings", 30, Pal.accent)

        -- Container Panel
        Mantle.Panel(500, 350, Pal.panel, function()
            -- A. Row of Controls
            Mantle.Row(nil, nil, 40, function()
                -- Column 1: Dropdowns
                Mantle.Column(nil, nil, 10, function()
                    Mantle.Text("Resolution", 14, Pal.dim)

                    -- DROPDOWN 1
                    resIndex = Mantle.Dropdown(resolutions, resIndex, nil, nil, 200)

                    Mantle.Text("Texture Quality", 14, Pal.dim)

                    -- DROPDOWN 2
                    qualIndex = Mantle.Dropdown(qualities, qualIndex, nil, nil, 200)
                end)

                -- Column 2: Checkboxes
                Mantle.Column(nil, nil, 15, function()
                    Mantle.Text("Display Options", 14, Pal.dim)
                    isVsync = Mantle.Checkbox("Enable V-Sync", isVsync)
                    Mantle.Checkbox("Show FPS", true)

                    Mantle.Rect(0, 0, 0, 20, { 0, 0, 0, 0 }) -- Spacer
                    Mantle.Button("Reset Default", nil, nil, 150, 40)
                end)
            end)

            -- B. Bottom Section (To prove layering)
            Mantle.Rect(0, 0, 0, 30, { 0, 0, 0, 0 }) -- Space
            Mantle.Line(0, 0, 460, 0, Pal.dim, 1.0) -- Divider Line
            Mantle.Rect(0, 0, 0, 10, { 0, 0, 0, 0 }) -- Space

            Mantle.Text("The dropdowns above will float OVER this button!", 14, { 243, 139, 168, 255 })

            -- If layering works, the dropdown menu covers this button when opened.
            if Mantle.Button("Apply Settings", nil, nil, 460, 50) then
                print("Settings Applied: " .. resolutions[resIndex] .. " / " .. qualities[qualIndex])
            end
        end)
    end)
end)
