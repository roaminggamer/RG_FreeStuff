-- Test content scaling for common screen resolutions

local screens = {
    {'iPhone 3 ',  320,  480},
    {'iPhone 4 ',  640,  960},
    {'iPhone 5 ',  640,  1136},
    {'iPhone 6 ',  750,  1334},
    {'iPhone 6+', 1080, 1920},
    {'iPad Mini', 768,  1024},
    {'iPad Air ',  1536, 2048},

    {'medium 1 ', 400, 854},
    {'medium 2 ', 480, 800},
    {'medium 3 ', 480, 854},
    {'medium 4 ', 600, 800},

    {'high 1   ', 540, 960},
    {'high 2   ', 600, 1024},
    {'high 3   ', 800, 1024},

    {'xhigh 1  ', 720, 1280},
    {'xhigh 2  ', 768, 1280},
    {'xhigh 3  ', 768, 1366},
    {'xhigh 4  ', 800, 1280},

    {'xxhigh 1 ', 1200, 1920},
    {'xxhigh 2 ', 1600, 2560}
}

local modes = {1, 1.5, 2, 3, 4, 6, 8}

local contentW, contentH = 320, 480

for i = 1, #screens do
    local s = screens[i]
    local name, w, h = unpack(s)
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
    if _m < 2 then
        local scale = math.max(contentW / w, contentH / h)
        _w, _h = w * scale, h * scale
    end

    print(name, 'screen: ', w .. ' x ' .. h, 'aspect:', h / w)
    print('', '',  'content:', math.floor(_w) .. ' x ' .. math.floor(_h), 'scale:', s[2] / _w)
    print('')
end