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
local physics = require "physics"
physics.start()
physics.setGravity(0,10)
physics.setDrawMode("hybrid")

-- =====================================================
-- Example
-- =====================================================
local size 		= 80
local radius 	= 38 

local y0 		= cy - 200
local y1			= cy + 200
local tween 	= (y1 - y0) - size
local targetY 	= y0 + tween/2 + size/2


local function createParts( x, text, restitution )
	restitution = restitution or 1

	local dropMarker =  display.newImageRect( "rg256.png", size, size )
	dropMarker.x = x
	dropMarker.y = y0
	dropMarker:setFillColor( 1, 0, 0, 0.25 )

	local targetMarker =  display.newImageRect( "rg256.png", size, size )
	targetMarker.x = x
	targetMarker.y = targetY
	targetMarker:setFillColor( 0, 1, 0, 0.25 )

	local block =  display.newImageRect( "corona.png", size, size )
	block.x = x
	block.y = y1
	physics.addBody( block, "kinematic", { bounce = 0 } )

	local label = display.newText( text, block.x, block.y + 100, nil, 20)

	local ball =  display.newImageRect( "rg256.png", size, size )
	ball.x = x
	ball.y = dropMarker.y
	physics.addBody( ball, "dynamic", { bounce = restitution, radius = radius } )
	
	return ball, block
end
-- 

-- Wrong
local ball, block =  createParts( cx - 225, "Wrong 1" )

local ball, block =  createParts( cx - 75, "Wrong 2", 0.5 )

-- Close
local restitution = 0.5
local ball, block =  createParts( cx + 75, "Close: " .. restitution, restitution )
ball.first = true
function block.collision( self, event )
	local other = event.other
	if( event.phase == "began" ) then
		if( other.first ) then
			other.first = false
		else
			event.contact.bounce = 1 
		end		
	end
	return false
end; block:addEventListener("collision")

-- Perfect
local restitution = 0.5 + radius/tween
local ball, block =  createParts( cx + 225, "Close: " .. restitution, restitution )

ball.first = true
function block.collision( self, event )
	local other = event.other
	if( event.phase == "began" ) then
		if( other.first ) then
			other.first = false
		else
			event.contact.bounce = 1 
		end		
	end
	return false
end; block:addEventListener("collision")

