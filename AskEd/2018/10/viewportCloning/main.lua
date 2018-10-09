io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================

local back = display.newImageRect( "protoBackX.png", 720, 1386 )
back.x = display.contentCenterX
back.y = display.contentCenterY
if( display.contentWidth > display.contentHeight ) then
	back.rotation = 90
end
-- =====================================================

local game = require "scripts.game"

-- Some examples not functional: 3, 5, 6, 7

--game.run( nil, 1 ) -- First attempt at cloning.
--game.run( nil, 2 ) -- First attempt moved into viewportCloner module.  Same demo now with module.
--game.run( nil, 4 ) 
game.run( nil, 8) -- same as 4 but more extreme?  Can't remember