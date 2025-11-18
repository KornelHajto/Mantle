local Mantle = require("mantle.init")
local rl = rl

-- 1. WINDOW CONFIGURATION
Mantle.Window({
    width = 1000,
    height = 700,
    title = "Mantle Framework Showcase",
    draggable = true,
    transparent = true
})

-- 2. LOAD ASSETS
-- Ensure 'assets/roboto.ttf' exists, or change this to a font you have
Mantle.LoadFont("assets/roboto.ttf", 20)

-- 3. THEME (Dracula-inspired)
local Pal = {
    bg     = { 30, 30, 46, 255 },
    panel  = { 50, 50, 75, 255 },
    header = { 40, 40, 60, 255 },
    text   = { 205, 214, 244, 255 },
    dim    = { 147, 153, 178, 255 },
    accent = { 137, 180, 250, 255 },
    alert  = { 243, 139, 168, 255 }
}
Mantle.Theme.colors.primary = Pal.panel
Mantle.Theme.colors.text = Pal.text
Mantle.Theme.colors.accent = Pal.accent
Mantle.Theme.colors.highlight = { 69, 71, 90, 255 }

-- 4. APPLICATION STATE
-- We define these OUTSIDE the loop so they remember their values.

-- Dropdown Data
local resolutions = { "1920x1080", "1280x720", "800x600" }
local resIndex = 1
local qualities = { "Low", "Medium", "High", "Ultra" }
local qualIndex = 3

-- Input Data
local serverName = "Production-Server-01"

-- Checkbox Data (Generate 20 states)
local checks = {}
for i = 1, 20 do checks[i] = false end

-- 5. MAIN LOOP
Mantle.Run(function()
    Mantle.Clear()

    -- === ROOT CONTAINER ===
    Mantle.Panel(0, 0, 1000, 700, Pal.bg)

    -- === TOP HEADER ===
    Mantle.Panel(1000, 60, Pal.header, function()
        Mantle.Row(nil, nil, nil, nil, 10, function()
            Mantle.Text("MANTLE DASHBOARD", 24, Pal.accent)
            Mantle.Spacer(50)
            Mantle.Text("v2.0.0 - Stable Build", 14, Pal.dim)

            -- Push user info to the right (Manual spacer for now)
            Mantle.Spacer(400)
            Mantle.Button("Log Out", nil, nil, 120, 35)
        end)
    end)

    -- === MAIN CONTENT SPLIT ===
    Mantle.Row(nil, nil, nil, nil, 0, function()
        -- LEFT: SETTINGS PANEL
        Mantle.Panel(400, 640, Pal.panel, function()
            Mantle.Text("Server Configuration", 20, Pal.text)
            Mantle.Rect(0, 0, 0, 10, { 0, 0, 0, 0 }) -- Margin

            -- A. Dropdowns (Z-Index Test)
            Mantle.Text("Display Resolution", 14, Pal.dim)
            resIndex = Mantle.Dropdown(resolutions, resIndex, nil, nil, 250)

            Mantle.Rect(0, 0, 0, 10, { 0, 0, 0, 0 })

            Mantle.Text("Render Quality", 14, Pal.dim)
            -- This dropdown will overlap the input field below when opened!
            qualIndex = Mantle.Dropdown(qualities, qualIndex, nil, nil, 250)

            Mantle.Rect(0, 0, 0, 20, { 0, 0, 0, 0 })

            -- B. Input Field
            Mantle.Text("Hostname", 14, Pal.dim)
            serverName = Mantle.Input(serverName, "Enter name...", nil, nil, 300)

            Mantle.Rect(0, 0, 0, 40, { 0, 0, 0, 0 })

            -- C. Overlap Test Button
            -- If the Dropdown input blocking works, clicking "High" won't click this button.
            Mantle.Text("Overlay Test Zone", 14, Pal.alert)
            if Mantle.Button("DANGER ZONE", nil, nil, 350, 50) then
                print("Danger button clicked!")
            end
        end)

        -- RIGHT: SCROLLABLE LIST
        -- We wrap the scroll area in a column to give it padding/structure
        Mantle.Column(nil, nil, 0, 0, 0, function()
            -- We use a transparent container for the list area
            Mantle.Panel(600, 640, { 0, 0, 0, 0 }, function()
                Mantle.Text("Active Modules", 20, Pal.text)
                Mantle.Text("Scroll down to see virtualization status.", 14, Pal.dim)

                -- === SCROLL AREA START ===
                Mantle.ScrollArea(560, 550, function()
                    for i = 1, 20 do
                        Mantle.Row(nil, nil, nil, nil, 10, function()
                            -- Stateful Checkbox
                            checks[i] = Mantle.Checkbox("Module " .. i, checks[i])

                            -- Dynamic Status Text
                            local status = checks[i] and "Active" or "Disabled"
                            local color = checks[i] and { 100, 255, 100, 255 } or Pal.dim
                            Mantle.Text(status, 14, color)
                        end)
                    end

                    Mantle.Rect(0, 0, 0, 20, { 0, 0, 0, 0 })
                    Mantle.Button("Save Configuration", nil, nil, 500, 50)
                    Mantle.Rect(0, 0, 0, 50, { 0, 0, 0, 0 }) -- Bottom padding
                end)
                -- === SCROLL AREA END ===
            end)
        end)
    end)
end)
