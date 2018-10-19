io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
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
-- == Uncomment following lines if you need  physics
local physics = require "physics"
physics.start()
physics.setGravity(0,0)
physics.setDrawMode("hybrid")

-- == Uncomment following line if you need widget library
--local widget = require "widget"

-- =====================================================
-- YOUR CODE BELOW
-- =====================================================
local back = display.newImageRect( "protoBackX.png", 720, 1386 )
back.x = display.contentCenterX
back.y = display.contentCenterY
if( display.contentWidth > display.contentHeight ) then
	back.rotation = 90
end

local bmf = require('bmf2')
local font1 = bmf.loadFont('bangers')
local font2 = bmf.loadFont('bmGlyphArial')


local tmp = bmf.newString( font1, "Font 1" )
tmp.x = cx
tmp.y = cy - 50
tmp:set_align( "left" )
physics.addBody( tmp, "static" )

local tmp = bmf.newString( font1, "Font 1" )
tmp.x = cx
tmp.y = cy + 50
print("A")
tmp:set_align( "center" )
print("B")

physics.addBody( tmp, "static" )

