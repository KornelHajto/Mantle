local rl = rl

return function(Mantle, x, y, width, height, color)
    color = color or Mantle.Theme.colors.primary

    local rect = {
        x = x,
        y = y,
        width = width,
        height = height
    }

    local roundness = 0.1
    local segments = 20

    rl.DrawRectangleRounded(rect, roundness, segments, color)
end
