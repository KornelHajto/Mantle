local Assets = {}

local cache = {
    fonts = {},
    textures = {}
}

function Assets.LoadFont(path, size)
    local id = path .. tostring(size)

    if not cache.fonts[id] then
        local info = love.filesystem.getInfo(path)
        if not info then
            print("Mantle Warning: Font file not found: " .. path)
            return love.graphics.newFont(size)
        end
        cache.fonts[id] = love.graphics.newFont(path, size)
        cache.fonts[id]:setFilter("linear", "linear")
    end

    return cache.fonts[id]
end

function Assets.LoadTexture(path)
    if not cache.textures[path] then
        local info = love.filesystem.getInfo(path)
        if not info then
            print("Mantle Warning: Image file not found: " .. path)
            return nil
        end
        cache.textures[path] = love.graphics.newImage(path)
        cache.textures[path]:setFilter("linear", "linear")
    end
    return cache.textures[path]
end

return Assets
