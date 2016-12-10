
require "ssk2.loadSSK"
_G.ssk.init()
_G.ssk.init( { launchArgs           = ..., 
               enableAutoListeners  = true,
               exportCore           = true,
               exportColors         = true,
               exportSystem         = true,
               exportSystem         = true,
               debugLevel           = 0 } )
-- Useful Localizations
-- SSK
--
local newCircle 		= ssk.display.newCircle
local newRect 			= ssk.display.newRect
local newImageRect 		= ssk.display.newImageRect
local newAngleLine 		= ssk.display.newAngleLine
local easyIFC   		= ssk.easyIFC
local oleft 			= ssk.misc.oleft
local oright 			= ssk.misc.oright
local otop 				= ssk.misc.otop
local obottom			= ssk.misc.obottom
local isInBounds    	= ssk.easyIFC.isInBounds
local secondsToTimer	= ssk.misc.secondsToTimer
local isValid 			= display.isValid

local normRot			= ssk.misc.normRot

local addVec			= ssk.math2d.add
local subVec			= ssk.math2d.sub
local diffVec			= ssk.math2d.diff
local lenVec			= ssk.math2d.length
local len2Vec			= ssk.math2d.length2
local normVec			= ssk.math2d.normalize
local vector2Angle	= ssk.math2d.vector2Angle
local angle2Vector	= ssk.math2d.angle2Vector
local scaleVec			= ssk.math2d.scale

-- Corona & Lua
--
local mAbs              = math.abs
local mRand             = math.random
local mDeg              = math.deg
local mRad              = math.rad
local mCos              = math.cos
local mSin              = math.sin
local mAcos             = math.acos
local mAsin             = math.asin
local mSqrt             = math.sqrt
local mCeil             = math.ceil
local mFloor            = math.floor
local mAtan2            = math.atan2
local mPi               = math.pi

local getInfo           = system.getInfo
local getTimer          = system.getTimer
local strMatch          = string.match
local strFormat         = string.format
local pairs             = pairs

--
-- Interesting bits start after this...
-- 
local physics = require "physics"
physics.start()
physics.setGravity(0,0)

local ballSpeed = 500 -- 100 pixels per second

-- Walls
local lw = newRect( nil, left, centerY, { fill = _B_, w = 40, h = fullh, anchorX = 0 }, { bodyType = "static",  bounce = 1, friction = 0 } )
local rw = newRect( nil, right, centerY, { fill = _B_, w = 40, h = fullh, anchorX = 1 }, { bodyType = "static",  bounce = 1, friction = 0 } )
local tw = newRect( nil, centerX, top, { fill = _B_, w = fullw, h = 40, anchorY = 0 }, { bodyType = "static",  bounce = 1, friction = 0 } )
local bw = newRect( nil, centerX, bottom, { fill = _B_, w = fullw, h = 40, anchorY = 1 }, { bodyType = "static",  bounce = 1, friction = 0 } )
  
local enterFrame = function( self )
   local vx,vy = self:getLinearVelocity()
   vx,vy = normVec( vx, vy )
   vx,vy = scaleVec( vx, vy, ballSpeed )
   self:setLinearVelocity( vx, vy )
end

local function newBall( x, y, angle )
   local ball = newCircle( nil, x, y, { radius = 25, fill = randomColor(), stroke = randomColor(), strokeWidth = 2 }, { bounce = 1, friction = 0, isFixedRotation = true } )
   ball.isBall = true
   local vec = angle2Vector( angle, true )
   vec = scaleVec( vec, ballSpeed )
   ball:setLinearVelocity( vec.x, vec.y )
   ball.enterFrame = enterFrame
   listen( "enterFrame", ball )
end


for i = 1, 25 do
   timer.performWithDelay( (i-1) * 500, function() newBall( centerX, centerY, mRand(0,359) ) end )
end

--newBall( centerX + 40, centerY, 45 )
--newBall( centerX - 40, centerY, 135 )
--newBall( centerX, centerY + 40, 270 )
--newBall( centerX, centerY - 40, 315 )
