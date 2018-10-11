io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
--require "ssk2.loadSSK"
--_G.ssk.init( { measure = false } )
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================
local cx     = display.contentCenterX
local cy     = display.contentCenterY
local fullw  = display.actualContentWidth
local fullh  = display.actualContentHeight
local left   = cx - fullw/2
local right  = cx + fullw/2
local top    = cy - fullh/2
local bottom = cy + fullh/2
-- =====================================================
-- =====================================================
local back = display.newImageRect( "protoBackX.png", 720, 1386 )
back.x = display.contentCenterX
back.y = display.contentCenterY
if( display.contentWidth > display.contentHeight ) then
	back.rotation = 90
end
-- =====================================================
-- =====================================================

local pathDraw = require "pathDraw"

local dude = display.newImageRect( "yellow_round.png", 32, 32 )
dude.x = 100
dude.y = 100

-- Attach path drawing code to 'back'
local options = {
	debugEn 		= true,
	minDist 		= 20, 
	followObj 	= dude,
	speed 		= 500
}
pathDraw.attach( back, options )
