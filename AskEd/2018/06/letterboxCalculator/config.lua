-- Author: Lerg - spiralcodestudio.com
-- GitHub: https://github.com/Lerg/smartpixel-config-lua

-- SmartPixel config.lua
-- Uses pixel perfect content scaling when possible

local w, h = display.pixelWidth, display.pixelHeight

local modes = {1, 1.5, 2, 3, 4, 6, 8} -- Scaling factors to try
local contentW, contentH = 640, 960   -- Minimal size your content can fit in

-- Try each mode and find the best one
local _w, _h, _m = w, h, 1
for i = 1, #modes do
    local m = modes[i]
    local lw, lh = w / m, h / m
    if lw < contentW or lh < contentH then
        break
    else
        _w, _h, _m = lw, lh, m
    end
end
-- If scaling is not pixel perfect (between 1 and 2) - use letterbox
if _m < 2 then
    local scale = math.max(contentW / w, contentH / h)
    _w, _h = w * scale, h * scale
end

application = {
    content = {
        width = _w,
        height = _h,
        scale = 'letterbox',
        fps = 60,
        imageSuffix = {
            ['@2x'] = 1.1,
            ['@4x'] = 2.1,
        }
    }
}

-- Uncomment to use the common content scaling
--[[
application = {
    content = {
        width = 640,
        height = 960,
        scale = 'letterbox',
        fps = 60,
        imageSuffix = {
            ['@2x'] = 1.1,
            ['@4x'] = 2.1,
        }
    }
}
--]]