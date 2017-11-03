
--
-- Image info and sheet used for making bars
--
local bars = require "bars" -- sprite sheet info
local barSheet = graphics.newImageSheet( "bars.png", bars.sheet )


local progressBarM = {}

function progressBarM.new( group, x, y, params )
    group = group or display.currentStage
    params = params or {}
    local width = params.width or 132
    local height = params.height or 36
    local debugEn = params.debugEn or false

    local hud = display.newGroup()
    group:insert(hud)
    hud.x = x
    hud.y = y

    -- Make the bar tray/background
    hud.tray = display.newImageRect( hud, barSheet, 1, 132, 36 )
    hud.tray.y = 5 -- offset to handle shadow which hoses up vertical centering
    
    -- Create a masked group to hold the bar art
    hud.barGroup = display.newGroup()    
    hud:insert(hud.barGroup)    
    --
    local mask = graphics.newMask( "mask.png" )
    hud.barGroup:setMask( mask )
    hud.barGroup.maskScaleX = 120/(204-6) -- scale acounting for bar art width versus non-black part of mask
    hud.barGroup.maskScaleY = 16/(36-12) -- scale acounting for bar art height versus non-black part of mask
    --
    --display.newRect( hud.barGroup, 0, 0, 10000, 1000) -- used for debug while working out odd sizes
    --
    hud.bar = display.newImageRect( hud.barGroup, barSheet, 2, 124, 24 )
    -- your art size is slightly off and slightly misaligned
    -- width is actually 123, but 124 would be a better fit.
    hud.bar.x = 0.5
    hud.bar.y = hud.bar.y - 0.5
    --
    -- Now use anchoring ot make calcuations easier
    hud.bar.anchorX = 0
    hud.bar.x = hud.bar.x - 124/2    

    -- calculate X0 for 100% ON
    hud.bar.x0 = hud.bar.x

    -- Resize the hud if an width or height was supplied
    --
    local scaleX = width/132
    local scaleY = height/36
    hud:scale(scaleX, scaleY)

    -- Add functions to set/get'percent'
    function hud.set( self, value )
        value = value or 1
        value = (value > 1) and 1 or value
        value = (value < 0) and 0 or value

        local bw = 124 -- self.bar.contentWidth
        local ox = bw * (1-value)

        self.bar.x = self.bar.x0 - ox

        self._percent = value
    end

    function hud.get( self, value )
        return self._percent
    end

    if( debugEn ) then
        display.newLine( hud, 0, -12, 0, 12 ).strokeWidth = 2
        display.newLine( hud, -0.25 * 132, -12, -0.25 * 132, 12 ).strokeWidth = 2
        display.newLine( hud, 0.25 * 132, -12, 0.25 * 132, 12 ).strokeWidth = 2
    end
    return hud
end

return progressBarM
