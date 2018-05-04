-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)

require "ssk2.loadSSK"
_G.ssk.init()

-- Notes for this example ( not part of example )
--
local notes = {
	"The user wanted to 'fire a bullet' from position A to position B. ", 
	"1. Tap any place on the screen to move the 'target'",
	"2. Watch the 'turret' automatically fire at the target position."
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
local diffVec            = ssk.math2d.diff
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
local bulletSpeed       = 150 
local playerMoveSpeed   = 250
local fireRate 			= 5

--
-- 4. Set up physics
local physics = require "physics"
physics.start()
physics.setGravity( 0, 0 )

--
-- 5. Function to create a player (target) that will move when we touch the screen.
local function createPlayer()
	local thePlayer = display.newCircle( display.contentCenterX, display.contentCenterY + 100, 10 )
	thePlayer:setFillColor(0,1,0,0.5)
    thePlayer:setStrokeColor(1,1,0)
    thePlayer.strokeWidth = 2
    thePlayer.isMoving = false
    physics.addBody( thePlayer, "dynamic", { radius = 10 } ) 

	-- Touch mover
	--
	thePlayer.touch = function( self, event )
		-- Only try to move move on 'ended' phase
	    if( event.phase ~= "ended" ) then return true end
	    
	    -- Don't allow new touch till player is done moving from last touch
	    if( self.isMoving == true) then return true end

	    self.isMoving = true

	    -- Call this to clear isMoving flag when we finish our move
		local function onCompleteMove( self )
		    self.isMoving = false
		end

		-- Calculate distance to move, the determine how long it will take at 'playerMoveSpeed'
		local vec = diffVec( self, event )
		local len = vecLen( vec )
		local time = 1000 * len/playerMoveSpeed


		-- Use transition to move player
	    transition.to( thePlayer, { x = event.x, y = event.y, time = time, onComplete = onCompleteMove  } )

	    return true
	end
    Runtime:addEventListener( "touch", thePlayer )

    return thePlayer
end

--
-- 6. Function to create and fire bullet.  Fires at any passed in target object.
local function fireBullet( turret, target )
    -- a. Calculate vector from turret to player
    local velocityVec = diffVec( turret, target )

    -- b. Normalize the vector
    velocityVec = normVec( velocityVec ) 

    -- c. Scale it so we have the right velocity
    velocityVec = scaleVec( velocityVec, bulletSpeed )

    -- d. Create a 'bullet' and make it a sensor object so it won't 'push' player on collision 
    local bullet = display.newCircle( turret.x, turret.y, 5 )
	physics.addBody( bullet, "dynamic", { radius = 5, isSensor = true } )

	-- e. Send the bullet off in the 'firing' direction and at 'bulletSpeed'
    bullet:setLinearVelocity( velocityVec.x, velocityVec.y )

    -- f.  Add a collision listener that only detects if we hit 'target'
    bullet.collision = function( self, event )
    	-- Did we hit the 'target' ?  If so remove the bullet. If not do nothing.
        if( event.other == target ) then 
            timer.performWithDelay(1, function() display.remove(self) end )
        end
        return true 
    end
    bullet:addEventListener( "collision" )
    
    -- g. Schedule 'auto-destruct' in case bullet hits nothing within 10 seconds
    timer.performWithDelay( 10000, function() display.remove( bullet ) end )

end

--
-- 7. Create a 'Turret'
local turret = display.newCircle( display.contentCenterX, display.contentCenterY, 15 )
turret:setFillColor(1,0,0,0.5)
turret:setStrokeColor(1,0,1)
turret.strokeWidth = 2

--
-- 8. Create the Player
local player = createPlayer()

--
-- 9. Fire a bullet at 'fireRate' forever
timer.performWithDelay( 1000/fireRate, function() fireBullet( turret, player ) end, -1  ) 
