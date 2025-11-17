-- Simple wrapper for raylib
return function(texture, x, y, scale)
    rl.DrawTextureEx(texture, { x = x, y = y }, 0, scale or 1.0, rl.WHITE)
end
