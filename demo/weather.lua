local Mantle = require("mantle.init")
local Assets = require("mantle.assets")
local rl = rl

-- FIX: We define the dynamic strings here
local currentDisplayTime = "00:00"
local currentDisplayDate = "Loading Date..."

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

-- MOCK DATA (Using the robust UTF-8 symbol)
local forecast = {
    { d = "Th", icon = "rain",  t = "4" .. DEG },
    { d = "Fr", icon = "sun",   t = "11" .. DEG },
    { d = "Sa", icon = "cloud", t = "1" .. DEG },
    { d = "Su", icon = "snow",  t = "-2" .. DEG },
    { d = "Mo", icon = "snow",  t = "-5" .. DEG },
    { d = "Tu", icon = "cloud", t = "-3" .. DEG },
    { d = "We", icon = "cloud", t = "-7" .. DEG }
}

Mantle.Run(function()
    -- === LOGIC: Update Time/Date Every Frame ===
    local t = os.date("*t")

    currentDisplayTime = os.date("%I:%M")

    local weekdays = { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" }
    currentDisplayDate = string.format("%d, %s, %d, %d",
        t.day, weekdays[t.wday], t.month, t.year)
    -- =============================================

    -- === LOAD ASSETS (Cache handles loading once) ===
    local fontClock = Assets.LoadFont("demo/assets/Oswald-Bold.ttf", 100)
    Mantle.LoadFont("demo/assets/Roboto-Regular.ttf", 20)

    local cloudImg = Assets.LoadTexture("demo/assets/cloud.png")
    local icons = {
        sun   = Assets.LoadTexture("demo/assets/sun.png"),
        rain  = Assets.LoadTexture("demo/assets/rain.png"),
        snow  = Assets.LoadTexture("demo/assets/snow.png"),
        cloud = Assets.LoadTexture("demo/assets/cloud_icon.png")
    }
    -- ===============================================

    Mantle.Clear()

    -- === 1. BACKGROUND COMPOSITION ===
    Mantle.Panel(0, 0, 350, 600, Pal.deepBlue)

    local topH = 420
    rl.DrawRectangleRounded({ x = 0, y = 0, width = 350, height = topH }, 0.1, 10, Pal.skyBlue)
    rl.DrawRectangle(0, topH - 20, 350, 20, Pal.skyBlue)
    Mantle.Line(0, topH, 350, topH, { 255, 255, 255, 50 }, 1)

    -- === 2. CLOUD LAYER (Behind Text) ===
    if cloudImg then
        local scale = 0.6
        local xPos = (350 - (cloudImg.width * scale)) / 2

        -- Full Opacity
        rl.DrawTextureEx(cloudImg, { x = xPos, y = 20 }, 0, scale, { 255, 255, 255, 255 })
    end

    -- === 3. TEXT LAYER (On Top) ===
    Mantle.Column(0, 160, 350, 400, 0, function()
        -- Clock
        local timeDim = rl.MeasureTextEx(fontClock, currentDisplayTime, 100, 1)
        local timeX = (350 - timeDim.x) / 2
        rl.DrawTextEx(fontClock, currentDisplayTime, { x = timeX, y = 160 }, 100, 1, Pal.text)

        Mantle.Spacer(110)

        -- Date & Temp
        local dateW = rl.MeasureTextEx(Mantle.Theme.font, currentDisplayDate, 20, 1).x
        Mantle.Text(currentDisplayDate, 20, Pal.text, (350 - dateW) / 2, 280)

        local rangeStr = "02" .. DEG .. " - 06" .. DEG
        local rangeW = rl.MeasureTextEx(Mantle.Theme.font, rangeStr, 20, 1).x
        Mantle.Text(rangeStr, 20, Pal.text, (350 - rangeW) / 2, 315)
    end)

    -- === 4. FOOTER LAYER (Forecast) ===
    local footerY = 450

    Mantle.Row(25, footerY, 300, 100, 13, function()
        for i, day in ipairs(forecast) do
            Mantle.Column(nil, nil, 30, 100, 5, function()
                local dayW = rl.MeasureTextEx(Mantle.Theme.font, day.d, 14, 1).x
                local dayX = (30 - dayW) / 2

                local lx, ly = require("mantle.layout").GetCursor()
                Mantle.Text(day.d, 14, Pal.text, lx + dayX, ly)

                Mantle.Spacer(30)

                -- DRAW ICON
                local tex = icons[day.icon]
                if tex then
                    local targetSize = 25
                    local scale = targetSize / tex.width

                    -- Center the icon in the 30px column
                    local offsetX = (30 - (tex.width * scale)) / 2

                    -- FINAL FIX: Added +4 to offsetX for visual alignment
                    Mantle.DrawIcon(tex, lx + offsetX + 4, ly + 30, scale)
                end

                Mantle.Spacer(30)

                -- Temp (Centered)
                local tempW = rl.MeasureTextEx(Mantle.Theme.font, day.t, 16, 1).x
                local tempX = (30 - tempW) / 2

                -- FINAL FIX: Added +3 to tempX for visual alignment
                Mantle.Text(day.t, 16, Pal.text, lx + tempX + 3, ly + 60)
            end)
        end
    end)

    -- Timeline Dots
    local lineY = 550
    Mantle.Line(40, lineY, 310, lineY, { 255, 255, 255, 50 }, 1)

    local spacing = (310 - 40) / 6
    for i = 0, 6 do
        local x = 40 + (i * spacing)
        local col = (i == 0) and Pal.redDot or Pal.text
        local size = (i == 0) and 4 or 3
        Mantle.Circle(x, lineY, size, col)
    end
end)
