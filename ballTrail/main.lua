io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar

-- Use SSK Math2D library
local math2d = require "RGMath2D"

-- Locals
local cx = display.contentCenterX
local cy = display.contentCenterY

local speed 			= 150 -- in pixels-per-second
local turnEvery			= 3 -- Turn every time the (counter % this value)  == 0
local trailEvery		= 3 -- Add trail point every time the (counter % this value)  == 0
local turnByDegrees		= 35

local ballRadius 		= 15
local trailRadius 		= 5

-- Localized Functions
local mRand 	= math.random 
local getTimer 	= system.getTimer

local angle2Vec = math2d.angle2Vector
local normVec 	= math2d.normalize
local scaleVec  = math2d.scale
local addVec 	= math2d.add


-- Forward Declarations
local vecLen
local drawBall
local onEnterFrame
local drawTrail
local drawTrail2
local drawTrail3

-- Definitions
drawBall = function( )
	local myColor = { mRand(20,100)/100, mRand(20,100)/100, mRand(20,100)/100 }
	
	local tmp = display.newCircle( cx, cy, ballRadius )	

	tmp:setFillColor( unpack( myColor) )
	tmp.myColor 	= myColor
	tmp.rotation 	= mRand(0,359)
	
	tmp.lastTime 	= getTimer()
	tmp.myCount  	= 0

	tmp.enterFrame 	= onEnterFrame
	Runtime:addEventListener( "enterFrame", tmp )


	timer.performWithDelay( 10000, 
		function()			
			transition.to( tmp, { alpha = 0, time = 2000, onComplete = display.remove })
		end )
	timer.performWithDelay( 11800, 
		function()			
			Runtime:removeEventListener( "enterFrame", tmp )
		end )

end

onEnterFrame = function( self, event )
	local curTime = getTimer()
	local dt      = curTime - self.lastTime
	self.lastTime = curTime

	self.myCount = self.myCount + 1
	-- Move the ball by a calculated amount in the current 'facing' direction
	local vec = angle2Vec( self.rotation, true ) 
	vec = normVec( vec )
	local dist = (dt * speed) / 1000
	vec = scaleVec( vec, dist )

	self.lx = self.x -- x before move (useful for non-basic trails)
	self.ly = self.x -- y before move (useful for non-basic trails)
	self.x = self.x + vec.x
	self.y = self.y + vec.y

	-- Turn?
	if( self.myCount % turnEvery == 0 ) then
		self.rotation = self.rotation + mRand( -turnByDegrees, turnByDegrees ) -- small turns only
	end

	-- Add trail point?
	if( self.myCount % trailEvery == 0 ) then
		drawTrail2( self )
	end

end

-- Basic Trail
drawTrail = function( obj )
	local tmp = display.newCircle(obj.x, obj.y , trailRadius)	
	tmp.fill = { type="image", filename="chalk.png" }
	tmp:setFillColor( unpack( obj.myColor ) )

	transition.to( tmp, { delay = 5000, time = 1000, alpha = 0, onComplete = display.remove })
	obj:toFront()
end


-- Line Trail with Gaps
drawTrail2 = function( obj )
	if( not obj.last ) then
		obj.last = {x = obj.x, y = obj.y, rotation = obj.rotation}
		return
	end

	local tmp = display.newRect( obj.last.x, obj.last.y, 7, 12 )	
	tmp.rotation = obj.last.rotation
	tmp.fill = { type="image", filename="chalk.png" }
	tmp:setFillColor( unpack( obj.myColor ) )
	obj.last = nil

	transition.to( tmp, { delay = 5000, time = 1000, alpha = 0, onComplete = display.remove })
	obj:toFront()
end

-- Footprint Trail with Gaps
drawTrail3 = function( obj )
	if( not obj.last ) then
		obj.last = {x = obj.x, y = obj.y, rotation = obj.rotation}
		return
	end
	local tmp = display.newRect( obj.x, obj.y, 15, 15 )	
	tmp.rotation = obj.rotation
	tmp.fill = { type="image", filename="dog.png" }
	tmp:setFillColor( unpack( obj.myColor ) )

	transition.to( tmp, { delay = 5000, time = 1000, alpha = 0, onComplete = display.remove })
	obj:toFront()

	local tmp = display.newRect( obj.last.x, obj.last.y, 15, 15 )	
	tmp.rotation = obj.last.rotation
	tmp.fill = { type="image", filename="dog.png" }
	tmp:setFillColor( unpack( obj.myColor ) )
	tmp.xScale = -1

	obj.last = nil

	transition.to( tmp, { delay = 5000, time = 1000, alpha = 0, onComplete = display.remove })
	obj:toFront()

end

-- The Test
drawBall()

timer.performWithDelay( 1500, function() drawBall() end, -1)