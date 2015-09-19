local math2d = require "plugin.math2d"

local physics = require "physics"
physics.start()
physics.setGravity(0,0)
--physics.setDrawMode("hybrid")

local left = display.contentCenterX - display.actualContentWidth/2
local right = display.contentCenterX + display.actualContentWidth/2
local top = display.contentCenterY - display.actualContentHeight/2
local bottom = display.contentCenterY + display.actualContentHeight/2


local circ = display.newImageRect( "sonic.png", 80, 80 )
circ.x = display.contentCenterX
circ.y = display.contentCenterY

physics.addBody( circ, "kinematic", { bounce = 1, radius = 40 } )

circ.angularVelocity = 90

circ.redMin = -32
circ.redMax = 32
circ.tweenAngle = circ.redMax - circ.redMin


-- debug only to show initial angles
--[[
local vec = math2d.angle2Vector( circ.redMin, true )
vec = math2d.scale( vec, 100 )
local tmp = display.newLine( circ.x, circ.y, vec.x, vec.y )
tmp:setStrokeColor( 1, 0, 0 )
vec = math2d.add( circ, vec )

local vec = math2d.angle2Vector( circ.redMax, true )
vec = math2d.scale( vec, 100 )
vec = math2d.add( circ, vec )
local tmp = display.newLine( circ.x, circ.y, vec.x, vec.y )
tmp:setStrokeColor( 0, 1, 0 )
--]]


-- If you UNCOMMENT debug code above, COMMENT THE BELOW OUT
----[[
local function spawnCircles()
	local buffer 	= 50
	local size 		= 20
	local x, y

	local from = math.random(1,4)

	if( from == 1 ) then
		-- left
		x = left - buffer
		y = math.random( top - buffer, bottom + buffer )

	elseif( from == 2 ) then
		-- right
		x = right + buffer
		y = math.random( top - buffer, bottom + buffer )

	elseif( from == 3 ) then
		-- top
		x = math.random( left - buffer, right + buffer )
		y = top - buffer

	else
		-- bottom
		x = math.random( left - buffer, right + buffer )
		y = bottom + buffer
	end

	local vec 		= math2d.sub( x , y, display.contentCenterX, display.contentCenterY, true )
	local rotation 	= math2d.vector2Angle( vec )
	local len 		= math2d.length(vec)
	local speed 	= 100 -- math.random( 50, 200 )
	local time 		= 1000 * len / speed

	local tmp = display.newCircle( x, y, size/2)
	transition.to( tmp, { x = display.contentCenterX, y = display.contentCenterY, time = time , onComplete = display.remove } )

	physics.addBody( tmp, "dynamic", { bounce = 1, radius = size/2 } )

	tmp.isSensor = true

	tmp.isBall = true 

	tmp.collision = function( self, event ) 
		local other = event.other -- The circle in middle
		if( other.isBall ) then return false end -- Exit if hittig other ball
		if( event.phase == "began" ) then

			-- Get angle between circle and me
			local vec = math2d.diff( other.x, other.y, self.x, self.y, true )
			local angle = math2d.vector2Angle( vec )

			local otherRot = event.other.rotation
			-- Normalize both angles to be in the range [ 0, 360 ] to simplify comparisons
			while( angle > 360 ) do angle = angle - 360 end
			while( angle < 0 ) do angle = angle + 360 end

			while( otherRot > 360 ) do otherRot = otherRot - 360 end
			while( otherRot < 0 ) do otherRot = otherRot + 360 end

			-- Delta angles > 180 goof up comparison since we're only looking at a half-sweep
			local deltaAngle = math.abs(otherRot - angle)
			if( deltaAngle > 180 ) then 
				deltaAngle = math.abs(angle - otherRot)
			end

			if( deltaAngle <= other.tweenAngle/2 ) then
				print("HIT RED", otherRot, angle, deltaAngle )
				self:setFillColor( 1, 0, 0 )
			else
				print("HIT BLUE", otherRot, angle, deltaAngle )
				self:setFillColor( 0, 0, 1 )
			end

		end
		return true
	end
	tmp:addEventListener( "collision" )
	timer.performWithDelay( 300, spawnCircles )
end

spawnCircles()

--]]