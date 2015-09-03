-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

-- Load SSK
require "ssk.loadSSK"

--
-- Set up physics
local physics = require "physics"
physics.start()
physics.setGravity( 0, 0 )

--

-- Forward Declarations
-- SSK 
local angle2Vector      = ssk.math2d.angle2Vector
local vector2Angle      = ssk.math2d.vector2Angle
local scaleVec          = ssk.math2d.scale
local addVec            = ssk.math2d.add
local subVec            = ssk.math2d.sub
local normVec           = ssk.math2d.normalize
local getNormals        = ssk.math2d.normals
local vecLen            = ssk.math2d.length
local vecLen2           = ssk.math2d.length2
-- Lua and Corona 
local mAbs              = math.abs
local mRand             = math.random
local getInfo           = system.getInfo
local getTimer          = system.getTimer
local strMatch          = string.match
local strFormat         = string.format
--
-- A place to store our 'balls'
local balls = {}
local colors = { _R_, _G_, _Y_, _C_ }
local colorNames = { "RED", "GREEN", "YELLOW", "CYAN"}
local spawnTimer
local onCollision
local spawnArrow

--
-- Target
local tmp = display.newCircle( centerX, centerY, 40 )
tmp:setFillColor(1,0,1)
physics.addBody( tmp, "static", { radius = 40 } )


-- The balls
--
-- Min distance to start away is worst case (i.e. Corner of screen)
local vec = subVec( centerX, centerY, left, top, true)
local minLen = vecLen( vec )

onCollision = function( self, event )
	if( event.phase == "began" ) then
		balls[self] = nil
		print("My approach angle: ", self.approachAngle, " color: ", colorNames[self.myColor])
		display.remove( self)
	end
	return true
end

spawnArrow =  function()
	local size 		= 20
	local speed 	= 200
	
	local approachAngle = math.random(0,360)
	local startOffset = angle2Vector( approachAngle, true )
	local velocityVec = table.shallowCopy( startOffset )
	
	startOffset = scaleVec( startOffset, minLen )
	velocityVec = scaleVec( velocityVec, -speed )

	local tmp = display.newCircle( startOffset.x + centerX, startOffset.y + centerY, size/2 )
	physics.addBody( tmp, "dynamic", { radius = size/2 } )
	tmp.isSensor = true
	tmp.approachAngle = approachAngle

	tmp.myColor = math.random(1,#colors)
	tmp:setFillColor( unpack(colors[tmp.myColor]) )

	tmp.collision = onCollision
	tmp:addEventListener( "collision" )

	tmp:setLinearVelocity( velocityVec.x, velocityVec.y )

	balls[tmp] = tmp
	timer.performWithDelay( 3000, spawnArrow  )
end

spawnArrow()

