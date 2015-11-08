-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"The user was having trouble making bullets bounce as he expected them to.", 
	"",
	"This answer shows a 'wrong' and 'right' way to make bullets."
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end

--
-- 1. Load SSK
--require "ssk.loadSSK"


--
-- 2. Forward Declarations
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
-- 3. Set som parameters for the demo
local buffer  = 140


--
-- 4. Set up physics
local physics = require "physics"
physics.start()
physics.setGravity( 0, 0 )
physics.setDrawMode("hybrid")

--
-- 5. Function to create and fire bullet.  Fires at any passed in target object.
local function fireBullet( angle, isGood )
    -- a. Create a 'bullet' 
    local bullet = display.newCircle( display.contentCenterX, display.contentCenterY, 15 )

    if( isGood ) then
		physics.addBody( bullet, "dynamic", { radius = 15 } )
		bullet:setFillColor(0,1,0,0.5)
		bullet.x = bullet.x + 20
	else
		physics.addBody( bullet, "dynamic"  )
		bullet:setFillColor(1,0,0,0.5)
		bullet.x = bullet.x - 20
	end

	-- b. Generate a random velocity vector and apply to the bullet
	local speed = 250
	local vec = angle2Vector( angle, true )
	vec = scaleVec( vec, speed )
	--print(vec.x, vec.y)
    bullet:setLinearVelocity( vec.x, vec.y )

    -- c. Schedule 'auto-destruct' 
    timer.performWithDelay( 5000, function() display.remove( bullet ) end )
end

--
-- 6. Create a 'Turret'
local turret = display.newCircle( display.contentCenterX, display.contentCenterY, 15 )
turret:setFillColor(1,0,0,0.5)
turret:setStrokeColor(1,0,1)
turret.strokeWidth = 2

-- Create two walls to hit
--
local wall = display.newRect( display.contentCenterX - display.actualContentWidth/2 + 80,
                              display.contentCenterY, 40, 200  )
physics.addBody( wall, "static"  )
wall:setFillColor(1,0,0,0.5)
wall.rotation = 15 

local wall = display.newRect( display.contentCenterX + display.actualContentWidth/2 - 80,
                              display.contentCenterY, 40, 200  )
physics.addBody( wall, "static"  )
wall:setFillColor(0,1,0,0.5)
wall.rotation = -15 

--
-- 7. Fire a bullet at 'fireRate' forever
timer.performWithDelay( 1000, function() fireBullet( 90, true ) end, -1  ) 
timer.performWithDelay( 1000, function() fireBullet( -90, false ) end, -1  ) 
