-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

--[[
		The user who asked this question, wanted this effect:
		+ render a transparent circle
		+ show only the edges
		+ have another object 'inside' the cirle
		+ make it so the second object 'bounces' off the inside of the circle
--]]

--
-- 1. Require SSK or at a minimum the RG 2D Math lib
--require "ssk.loadSSK"
require "RGMath2D"

--
-- 2. Require and start physics
local physics = require "physics"
physics.start()
physics.setGravity(0,0)
--physics.setDrawMode( "hybrid" ) -- uncomment for debug rendering

--
-- 3. Set up some variables
local radius1 			= 150
local radius2 			= 10
local moveSpeed 		= 200 -- pixels per second
local moveBuffer 		= 25
local bounceDeviation	= 25 
local cX 				= display.contentCenterX
local cY 				= display.contentCenterY

--
-- 4. Draw the first circle
local circle1 = display.newCircle( cX, cY, radius1 )
circle1:setFillColor(0,0,0,0)
circle1:setStrokeColor(1,0,0)
circle1.strokeWidth = 2

--
-- 5. Draw the second circle
local circle2 = display.newCircle( cX + math.random( -radius1/2, radius1/2), 
	                               cY + math.random( -radius1/2, radius1/2), 
	                               radius2 )
circle1:setFillColor(0,1,0)
physics.addBody( circle2 ) 

-- 
-- 6. Write 'enterFrame' listener to ensure circle2 stays in circle1
local function onEnterFrame( self )
	-- 
	-- Abort early if the object is not valid any more
	if( self.removeSelf == nil ) then
		Runtime:removeEventListener( "enterFrame", self )
		return
	end

	--
	-- Skip frames while this is over 0
	--if( self.skipFrames and self.skipFrames > 0 ) then
		--self.skipFrames = self.skipFrames - 1
		--return
	--end

	--
	-- Calculate position relative to center of 'bounceObj' (the object we bounce off of)
	local vec = ssk.math2d.sub( self, self.bounceObj )
	local len = ssk.math2d.length( vec )

	--
	-- We can exit this function if length is less than:
	--    Half the width of the bounceObject (circle1) +
	--    Half the width of the moving object (circle2) -
	--    An optional 'buffer'
	local maxDist = (self.bounceObj.contentWidth/2 + self.contentWidth/2) - self.buffer
	if( len < maxDist ) then 
		return 
	end

	-- 
	-- Otherwise, we've gone too far, time to change direction
	
	-- Go in exact opposite direction (boring)
	----[[
	   local vx, vy = self:getLinearVelocity()
	   self:setLinearVelocity(-vx, -vy)
	--]]

	-- Change direction and deviate a little
	--[[
	   local vx, vy = self:getLinearVelocity()
	   local angle = ssk.math2d.vector2Angle( -vx, -vy )
	   angle = angle + math.random( -bounceDeviation, bounceDeviation )
	   local vec = ssk.math2d.angle2Vector( angle, true )
	   vec = ssk.math2d.scale( vec, moveSpeed )
	   self:setLinearVelocity( vec.x, vec.y )
	--]]

	--[[
	-- Change the direction
	local vx, vy = self:getLinearVelocity()
	local oldAngle = ssk.math2d.vector2Angle( vx, vy )
	local newAngle = oldAngle - 90
	local vec = ssk.math2d.angle2Vector( newAngle, true  )
	local vec = ssk.math2d.scale( vec, moveSpeed )
	print(round(vx,2), round(vy,2), round(vec.x,2), round(vec.y,2))
	self:setLinearVelocity( vec.x, vec.y )
	--]]


	-- 
	-- Skip the nextFrame to avoid precision errors that cause bounce toggling
	--self.skipFrames = 2
end

--
-- 7. 'Configure' circle2, attach the listener, and start listening.
circle2.buffer 		= moveBuffer
circle2.bounceObj 	= circle1

circle2.enterFrame 	= onEnterFrame
Runtime:addEventListener( "enterFrame", circle2 )

--
-- 8. Move circle 2 in a random direction
local angle = math.random( 0, 359 )
local vec   = ssk.math2d.angle2Vector( angle, true )
      vec   = ssk.math2d.scale( vec, moveSpeed )
circle2:setLinearVelocity( vec.x, vec.y )



