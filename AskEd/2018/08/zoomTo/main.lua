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
-- == Uncomment following lines if you need  physics
--local physics = require "physics"
--physics.start()
--physics.setGravity(0,10)
--physics.setDrawMode("hybrid")

-- == Uncomment following line if you need widget library
--local widget = require "widget"

-- =====================================================
local back = display.newImageRect( "protoBackX.png", 720, 1386 )
back.x = display.contentCenterX
back.y = display.contentCenterY
if( display.contentWidth > display.contentHeight ) then
	back.rotation = 90
end
-- =====================================================
local camera = display.newGroup()
local content   = display.newGroup()

camera:insert( content )

camera.x = cx
camera.y = cy
content.x = -cx
content.y = -cy
content.x0 = content.x
content.y0 = content.y

local canExplode = true

local explodeObject
local zoomTo
local revertCamera

zoomTo = function ( obj, time )
	transition.to( content, { x = content.x0 + cx - obj.x, 
		                       y = content.y0 + cy - obj.y,
		                       time = time / 4  } )
	transition.to( camera, { xScale = 3,yScale = 3, time = time } )
end

revertCamera = function( time )
	local function onComplete()
		canExplode = true
	end
	transition.to( content, { x = content.x0, y = content.y0, time = time } )

	transition.to( camera, { xScale = 1, yScale = 1, 
		                      delay = time, time = time/2, onComplete = onComplete } )
end

explodeObject = function( obj )
	if( not canExplode ) then return end
	canExplode = false

	zoomTo( obj, 1500 )

	local function onComplete()
		display.remove(obj)
		revertCamera( 500 )
	end

	transition.to( obj, { delay = 1500, rotation = 360 * 4, alpha = 0, time = 2000, onComplete = onComplete } )
end

local function onTouch( self, event )
	if( event.phase == "ended") then
		self:removeEventListener('touch')
		explodeObject( self )
	end
	return true
end

for i = 1, 10 do
	local tmp = display.newRect( content, left + math.random( 40, fullw - 40), top  + math.random( 40, fullh - 40), 40, 40 )
	tmp.touch = onTouch
	tmp:addEventListener("touch")
end






