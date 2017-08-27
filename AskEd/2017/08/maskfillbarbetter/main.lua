io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)

local mRand = math.random
local getTimer = system.getTimer

local centerX   = display.contentCenterX
local centerY   = display.contentCenterY
local fullw     = display.actualContentWidth
local fullh     = display.actualContentHeight
local left      = centerX - fullw/2
local right     = left + fullw
local top       = centerY - fullh/2
local bottom    = top + fullh

-- =====================================
-- Usage Sample Begins
-- =====================================
local group = display.newGroup()

local progressBarM = require "progressBar"

local hud1 = progressBarM.new( group, centerX, centerY - 100, { debugEn = true } )

local hud2 = progressBarM.new( group, centerX, centerY - 50, 
                               { width = 254, height = 72, debugEn = true } )

local hud3 = progressBarM.new( group, centerX, centerY + 80, { debugEn = true } )

local percent = 100
local dir = -1

local label = display.newText( group, percent, centerX, centerY )

hud1:set(percent/100)
hud2:set(percent/100)
hud3:set(percent/100)

timer.performWithDelay( 10, 
    function()
        percent = percent + dir
        if( percent == 0 ) then 
            dir = 1
        elseif( percent == 100 ) then 
            dir = -1 
        end
        label.text = percent
        hud1:set(percent/100)
        hud2:set(percent/100)
        hud3:set(percent/100)

        hud3.rotation = hud3.rotation + 1
    end, -1)

