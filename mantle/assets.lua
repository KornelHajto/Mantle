local rl = rl
local Assets = {}

local cache = {
    fonts = {},
    textures = {}
}

function Assets.LoadFont(path, size)
    local id = path .. tostring(size)

    if not cache.fonts[id] then
        if not rl.FileExists(path) then
            print("Mantle Warning: Font file not found: " .. path)
            return rl.GetFontDefault()
        end
        cache.fonts[id] = rl.LoadFontEx(path, size, nil, 0)

        rl.SetTextureFilter(cache.fonts[id].texture, rl.TEXTURE_FILTER_BILINEAR)
    end

    return cache.fonts[id]
end

function Assets.LoadTexture(path)
    if not cache.textures[path] then
        if not rl.FileExists(path) then
            print("Mantle Warning: Image file not found: " .. path)
            return nil
        end
        cache.textures[path] = rl.LoadTexture(path)
    end
    return cache.textures[path]
end

return Assets
