-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"The user wanted to make a car with an antenna and a driver that would move",
	"when the car moved.", 
	"",
	"This demo shows an 'antenna'.  Adding a driver would be similar."
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end

--
-- Load SSK
require "ssk2.loadSSK"
_G.ssk.init()
_G.ssk.init( { launchArgs 				= ..., 
	            enableAutoListeners 	= true,
	            exportCore 				= true,
	            exportColors 			= true,
	            exportSystem 			= true,
	            exportSystem 			= true,
	            debugLevel 				= 0 } )
--
-- Useful Localizations
-- SSK
--
local newCircle 	= ssk.display.newCircle
local newRect 		= ssk.display.newRect
local newImageRect 	= ssk.display.newImageRect
local newAngleLine 	= ssk.display.newAngleLine
local easyIFC   	= ssk.easyIFC
local isInBounds    = ssk.easyIFC.isInBounds
local persist 		= ssk.persist
local isValid 		= display.isValid
local easyFlyIn 	= easyIFC.easyFlyIn

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
-- Set up physics
local physics = require "physics"
physics.start()
physics.setGravity( 0, 10 )

--
-- Car Body & Wheels
local filter = { groupIndex = - 1 }
-- Body Size and PositioningVariables
local jointsRadius = 12
local neckLength = 6
local segmentLen  = 100
local segmentThickness = jointsRadius * 2 - 2

-- ==
--   body
-- ==	
local body = display.newRect( 0, 0, 160, 60 )
body.x = 150
body.y = 300
body:setFillColor( 1, 1, 0 )
physics.addBody( body, { density = 0.2, filter = filter } )
body.linearDamping = 0
body.angularDamping = 0
body.isSleepingAllowed = false

-- ==
--   antenna
-- ==	
local antenna = display.newRect( 0, 0, 5, 60 )
antenna.anchorY = 1
antenna.x = body.x - body.contentWidth/2 + 20
antenna.y = body.y - body.contentHeight/2 + 20
antenna:setFillColor( 1, 0, 0 )
physics.addBody( antenna, { density = 0.005, filter = filter } )
antenna.isSleepingAllowed = false
local joint = physics.newJoint( "pivot", antenna, body, antenna.x, antenna.y )	
joint.isLimitEnabled = true
joint:setRotationLimits( -15, 15 )
antenna.linearDamping = 1

-- ==
--   left wheel
-- ==	
local leftWheel = display.newImageRect( "coronaLogo.png", 48, 48 )
leftWheel.x = body.x - body.contentWidth/2 + 15
leftWheel.y = body.y + body.contentHeight/2
physics.addBody( leftWheel, { density = 0.05, filter = filter, friction = 100, radius = 24 } )
leftWheel.linearDamping = 0
leftWheel.angularDamping = 0
physics.newJoint( "pivot", leftWheel, body, leftWheel.x, leftWheel.y )	

-- ==
--   right wheel
-- ==	
local rightWheel = display.newImageRect( "coronaLogo.png", 48, 48 )	
rightWheel.x = body.x + body.contentWidth/2 - 15
rightWheel.y = body.y + body.contentHeight/2
physics.addBody( rightWheel, { density = 0.05, filter = filter, friction = 100, radius = 24 } )
rightWheel.linearDamping = 0
rightWheel.angularDamping = 0
physics.newJoint( "pivot", rightWheel, body, rightWheel.x, rightWheel.y )


-- ==
--   Ground
-- ==	
local groundA = display.newRect( 0, 0, 60, 20 )
groundA.x = body.x - 70
groundA.y = body.y + 100
groundA:setFillColor( 0.2, 0.2, 0.2 )
physics.addBody( groundA, "static", { friction = 1 } )

local groundB = display.newRect( 0, 0, 200, 20 )
groundB.x = groundA.x + groundA.contentWidth + 50
groundB.y = groundA.y + 49
groundB:setFillColor( 0.2, 0.2, 0.2 )
groundB.rotation = 30
physics.addBody( groundB, "static", { friction = 1 } )

local groundC = display.newRect( 0, 0, 600, 20 )
groundC.x = groundA.x + groundA.contentWidth + 420
groundC.y = groundA.y + 97
groundC:setFillColor( 0.2, 0.2, 0.2 )
physics.addBody( groundC, "static", { friction = 1 } )

local groundD = display.newRect( 0, 0, 40, 40 )
groundD.x = groundC.x + groundC.contentWidth/2 + 20
groundD.y = groundC.y - 10
groundD:setFillColor( 0.2, 0.2, 0.2 )
physics.addBody( groundD, "static", { friction = 1 } )


-- 
-- Give car a "kick" every 5 seconds
timer.performWithDelay( 5000, 
	function() 
		body:applyLinearImpulse( -7 * body.mass, 0, body.x, body.y  ) 
		-- show position of kick
		local tmp = display.newCircle( body.x + body.contentWidth/2, body.y, 1 )
		transition.to( tmp, { xScale = 20, yScale = 20, alpha = 0.1, time = 250, onComplete = display.remove  })
	end, -1 )
