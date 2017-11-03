-- define module
local M = {}

local getSpriteGfx = function(group, spritespath, spritename)
    local imagePath = string.gsub(spritespath,"%.","/") -- magic characters escaped with percentage
    local imageNfo = require("images.sprites."..spritespath)
    local imageSheet = graphics.newImageSheet( "images/sprites/"..imagePath..".png", imageNfo:getSheet() )
    local imageRect = display.newImageRect(
        group,
        imageSheet,
        imageNfo:getFrameIndex(spritename),
        imageNfo.sheet.frames[imageNfo:getFrameIndex(spritename)].width,
        imageNfo.sheet.frames[imageNfo:getFrameIndex(spritename)].height
    )
    --unrequire("images.sprites"..spritespath)
    imageNfo = nil
    imageSheet = nil
    return imageRect
end

function M.new(options)
    --{ parent, maskXstart, x, y, maxval, tag, barprefix, useback}
    local hud = display.newGroup()
    options.parent:insert(hud)
    
    local bar = options.barprefix
    local useback = options.useback or false
    hud._x = options.x or 0
    hud._y = options.y or 0
    
    hud._tag = options.tag
    hud._maxval = options.maxval or 30
    hud._debug = options.debug or true

    local tray = getSpriteGfx(hud, "bars", bar.."backing-ui")
    tray.y = hud._y
    tray.x = hud._x
    hud._tray = tray
    
    local fillbar = getSpriteGfx(hud, "bars", bar.."fillcolor-ui")
    fillbar.y = hud._y
    fillbar.x = hud._x
    fillbar.startX = fillbar.x
    hud._fillbar = fillbar

    local mask = graphics.newMask( "images/masks/bars/"..bar.."mask-ui.png" )
    
    ----------
    -- Comment this out
    ----------
    fillbar:setMask( mask )
    hud._mask = mask
    
    hud.setValue = function( value, notransition )
        value = value or 0
        if value > hud._maxval then 
            value = hud._maxval
        end
        if value < 1 then 
            value = 0
        end

        local ox = value*hud._fillbar.width/hud._maxval
        local adj = -(hud._fillbar.width-ox)
        if notransition then
            hud._fillbar.x = adj
        else
            transition.to(hud._fillbar, {
                time=200,
                x=adj,
                tag=hud._tag,
            })
        end
        hud._value = value
    end
    hud.setValue(hud._maxval, true)
    hud.setValue(500, true)
    return hud
end

return M