local Mantle = require("mantle.init")
local rl = rl

-- 1. WINDOW CONFIG
Mantle.Window({
    width = 1000,
    height = 700,
    title = "Mantle Dashboard",
    draggable = true,
    transparent = true
})

-- 3. COLOR PALETTE (Dracula-ish)
local Pal = {
    bg      = { 30, 30, 46, 150 },
    sidebar = { 40, 40, 60, 150 },
    panel   = { 50, 50, 75, 150 },
    accent  = { 137, 180, 250 },
    success = { 166, 227, 161 },
    text    = { 205, 214, 244 },
    textDim = { 147, 153, 178 }
}

-- Update Theme Colors
Mantle.Theme.colors.primary = Pal.panel
Mantle.Theme.colors.text = Pal.text
Mantle.Theme.colors.accent = Pal.accent
Mantle.Theme.colors.highlight = { 69, 71, 90, 255 }

-- 4. STATE
local searchTxt = ""
local serverName = "Alpha-1"
local cpuLimit = 0.75
local isOnline = true
local isBackup = false

-- 5. RUN LOOP
Mantle.Run(function()
    -- === FIX: LOAD FONT INSIDE THE LOOP ===
    -- The asset manager will cache this, so it only actually loads once.
    Mantle.LoadFont("demo/assets/roboto.ttf", 20)
    -- ======================================

    Mantle.Clear()

    -- A. MAIN CONTAINER
    Mantle.Panel(0, 0, 1000, 700, Pal.bg)

    Mantle.Row(0, 0, 0, function()
        -- === LEFT SIDEBAR ===
        Mantle.Panel(250, 700, Pal.sidebar, function()
            Mantle.Text("MANTLE", 40, Pal.accent)
            Mantle.Text("v1.0.0", 16, Pal.textDim)

            Mantle.Rect(0, 0, 0, 30, { 0, 0, 0, 0 })

            Mantle.Text("MENU", 14, Pal.textDim)
            Mantle.Button("Dashboard", nil, nil, 210, 40)
            Mantle.Button("Analytics", nil, nil, 210, 40)
            Mantle.Button("Users", nil, nil, 210, 40)
            Mantle.Button("Settings", nil, nil, 210, 40)

            Mantle.Rect(0, 0, 0, 250, { 0, 0, 0, 0 })

            Mantle.Panel(210, 80, { 0, 0, 0, 50 }, function()
                Mantle.Text("Admin User", 18, Pal.text)
                Mantle.Text("admin@mantle.dev", 12, Pal.textDim)
            end)
        end)

        -- === RIGHT CONTENT AREA ===
        Mantle.Column(nil, nil, 0, function()
            -- 1. HEADER BAR
            Mantle.Panel(750, 80, Pal.bg, function()
                Mantle.Row(nil, nil, 20, function()
                    Mantle.Text("Overview", 30, Pal.text)
                    Mantle.Rect(0, 0, 250, 0, { 0, 0, 0, 0 })
                    searchTxt = Mantle.Input(searchTxt, "Search...", nil, nil, 250)
                end)
            end)

            -- 2. DASHBOARD GRID
            Mantle.Column(nil, nil, 20, function()
                -- ROW 1: STATS CARDS
                Mantle.Row(nil, nil, 20, function()
                    Mantle.Panel(350, 180, Pal.panel, function()
                        Mantle.Text("CPU Usage", 20, Pal.textDim)
                        Mantle.Text("78%", 48, Pal.accent)
                        Mantle.Text("Limit Threshold", 14, Pal.textDim)
                        cpuLimit = Mantle.Slider(cpuLimit, nil, nil, 310)
                    end)

                    Mantle.Panel(350, 180, Pal.panel, function()
                        Mantle.Text("Server Status", 20, Pal.textDim)
                        local statusColor = isOnline and Pal.success or { 231, 130, 132, 255 }
                        local statusText = isOnline and "ONLINE" or "OFFLINE"
                        Mantle.Text(statusText, 30, statusColor)
                        Mantle.Rect(0, 0, 0, 10, { 0, 0, 0, 0 })
                        isOnline = Mantle.Checkbox("Active Power", isOnline)
                        isBackup = Mantle.Checkbox("Auto-Backup", isBackup)
                    end)
                end)

                -- ROW 2: CONFIGURATION
                Mantle.Panel(720, 250, Pal.panel, function()
                    Mantle.Text("Configuration", 24, Pal.text)
                    Mantle.Rect(0, 0, 0, 10, { 0, 0, 0, 0 })

                    Mantle.Row(nil, nil, 40, function()
                        Mantle.Column(nil, nil, 15, function()
                            Mantle.Text("Server Name", 16, Pal.textDim)
                            serverName = Mantle.Input(serverName, "Server name...", nil, nil, 300)
                            Mantle.Button("Save Changes", nil, nil, 300, 40)
                        end)

                        Mantle.Column(nil, nil, 10, function()
                            Mantle.Text("Traffic Activity", 16, Pal.textDim)
                            Mantle.Rect(nil, nil, 320, 100, { 0, 0, 0, 50 })
                        end)
                    end)
                end)
            end)
        end)
    end)
end)
