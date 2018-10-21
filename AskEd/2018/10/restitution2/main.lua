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

-- =====================================================
-- Example
-- =====================================================
local gravity 		= 10 
local size 			= 100
local radius 		= size/2 
local y0 			= cy - 200
local y1				= cy + 200
local maxFallDist = y1 - y0 - size 

print("----", size/maxFallDist, radius/maxFallDist, maxFallDist/gravity, math.sqrt(maxFallDist/(gravity^2))-1 )

local physics = require "physics"
physics.start()
physics.setGravity(0,gravity)
physics.setDrawMode("hybrid")



local function calculateFall( x, targetY )

	local restitution = 1

	-- Calculate restitution if needed
	if( targetY ~= y0 ) then 
		local riseDist = maxFallDist - (targetY - y0)

		print( maxFallDist, riseDist)
		restitution =  riseDist / maxFallDist
	end


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

	local label = display.newText( targetY, block.x, block.y + size, nil, 20)

	local ball =  display.newImageRect( "rg256.png", size, size )
	ball.x = x
	ball.y = dropMarker.y
	physics.addBody( ball, "dynamic", { bounce = restitution, radius = radius } )

	--	
	if( targetY ~= y0 ) then 
		ball.first = true
		function block.collision( self, event )
			local other = event.other
			if( event.phase == "began" ) then
				if( other.first ) then
					--local vx, vy = other:getLinearVelocity()
					--print("speed", vy, system.getTimer())
					other.first = false
				else
					event.contact.bounce = 1
				end		
			end
			return false
		end; block:addEventListener("collision")

	end
	
	return ball, block
end
-- 

--
-- Draw Lines and labels
--
local dist = 0
local curY = y0 
local line
while curY < (y1 + radius) do
	line = display.newLine( left + 100, curY, right - 100, curY )
	line.strokeWidth = 2
	--	
	if( dist == 0 ) then
		line:setStrokeColor(0,1,0)
	elseif( dist == maxFallDist ) then
		line:setStrokeColor(1,0,0)
	else
		line:setStrokeColor( 0.25, 0.25, 0.25)
	end
	--
	local tmp = display.newText( curY, left + 100 - 10, curY, nil, 20 )
	tmp.anchorX = 1

	if( dist <= (y1 - y0 - size) ) then
		local tmp = display.newText( dist, right - 100 + 10, curY, nil, 20 )
		tmp.anchorX = 0
	end
	--
	dist = dist + radius
	curY = curY + radius
end

local tmp = display.newText( "Y", left + 100 - 10, y0 - radius, nil, 20 )
tmp.anchorX = 1
local tmp = display.newText( "Dist", right - 100 + 10, y0 - radius, nil, 20 )
tmp.anchorX = 0




-- Wrong
calculateFall( cx - 300, 	120 )
calculateFall( cx - 180, 	170 )
calculateFall( cx - 60, 	220 )
calculateFall( cx + 60, 	270 )
calculateFall( cx + 180, 	320 )
calculateFall( cx + 300, 	370 )
