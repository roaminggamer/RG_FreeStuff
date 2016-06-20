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

local arrowSize 		= 30
local trailRadius 		= 5

local timeMult = 2

-- Localized Functions
local mRand 	= math.random 
local getTimer 	= system.getTimer

local angle2Vec 		= math2d.angle2Vector
local vector2Angle 		= math2d.vector2Angle
local normVec 			= math2d.normalize
local scaleVec  		= math2d.scale
local addVec 			= math2d.add
local subVec 			= math2d.sub


-- Forward Declarations
local vecLen
local drawArrow
local onEnterFrame
local drawTrail
local drawTrail2
local drawTrail3

-- Definitions
drawArrow = function( )
	local myColor = { mRand(20,100)/100, mRand(20,100)/100, mRand(20,100)/100 }
	
	local tmp = display.newImageRect( "up.png", arrowSize, arrowSize )
	tmp.x = cx - 150
	tmp.y = cy + 100
	tmp.rotation = 90

	tmp:setFillColor( unpack( myColor) )
	tmp.myColor 	= myColor
	
	tmp.lastTime 	= getTimer()
	tmp.myCount  	= 0

	tmp.enterFrame 	= onEnterFrame
	--Runtime:addEventListener( "enterFrame", tmp )

	transition.to( tmp, { x = cx + 150, time = 3000 * timeMult, onComplete = display.remove } )
	local y0 = tmp.y
	local y1 = tmp.y - math.random(200,250)
	transition.to( tmp, { y = y1, time = 1500 * timeMult, transition = easing.outCirc } )
	transition.to( tmp, { y = y0, delay = 1500 * timeMult, time = 1500 * timeMult, transition = easing.inCirc } )

	tmp.enterFrame = function( self )
		if( self.removeSelf == nil ) then
			Runtime:removeEventListener("enterFrame",self)
			return
		end
		if( self.lx == nil ) then
			self.lx = self.x
			self.ly = self.y
			return
		end

		-- trai making code (rudimentary bread-trail)
		local dot = display.newCircle( self.x, self.y, 5 )
		dot.alpha = 0.25
		dot:toBack()
		transition.to( dot, { alpha = 0, time = 1500 * timeMult, onComplete = display.remove } )

		-- facing code
		local vec = subVec( self.lx, self.ly, self.x, self.y, true )
		self.rotation = vector2Angle( vec ) + 90
		print( vec.x, vec.y , vector2Angle( vec ) )
		self.lx = self.x
		self.lx = self.y
	end
	Runtime:addEventListener("enterFrame", tmp)

end


-- The Test
drawArrow()

timer.performWithDelay( 3000 * timeMult, function() drawArrow() end, -1)