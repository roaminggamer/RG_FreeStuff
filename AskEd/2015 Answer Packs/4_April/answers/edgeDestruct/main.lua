-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"The user destroy objects when they reached the edge of the screen.", 
	"",
	"Tip: Change buffer to make objects destroy sooner or later than edge."
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
-- 4. Set up Rectangle to show 'bounds'
local width = display.actualContentWidth - 2 * buffer
local height = display.actualContentHeight - 2 * buffer
local boundRect = display.newRect( display.contentCenterX, display.contentCenterY, width, height )
boundRect:setFillColor(0,0,0,0)
boundRect:setStrokeColor(1,1,0)
boundRect.strokeWidth = 2

--
-- 5. Function to check if object is onScreen
local function isOnScreen( obj, edgeBuffer )
	edgeBuffer = edgeBuffer or 0

	local minX = display.contentCenterX - display.actualContentWidth/2 + edgeBuffer
	local maxX = display.contentCenterX + display.actualContentWidth/2 - edgeBuffer

	local minY = display.contentCenterY - display.actualContentHeight/2 + edgeBuffer
	local maxY = display.contentCenterY + display.actualContentHeight/2 - edgeBuffer

	if( obj.x < minX or obj.x > maxX or obj.y < minY or obj.y > maxY ) then
		return false
	end
	return true
end

--
-- 6. Set up physics
local physics = require "physics"
physics.start()
physics.setGravity( 0, 0 )

--
-- 7. Function to create and fire bullet.  Fires at any passed in target object.
local function fireBullet( )
    -- a. Create a 'bullet' 
    local bullet = display.newCircle( display.contentCenterX, display.contentCenterY, 15 )
	physics.addBody( bullet, "dynamic", { radius = 15 } )

	-- b. Generate a random velocity vector and apply to the bullet
	local speed = 250
	local vec = angle2Vector( mRand( 0, 359), true )
	vec = scaleVec( vec, speed )
	--print(vec.x, vec.y)
    bullet:setLinearVelocity( vec.x, vec.y )

    -- c. Add 'enterFrame' listener to delete 'bullet' once it is out of bounds 
    function bullet.enterFrame( self )
    	if( not isOnScreen( self, buffer ) ) then
    		Runtime:removeEventListener( "enterFrame", self )
    		display.remove( self )
    	end
    end
    Runtime:addEventListener( "enterFrame", bullet )

    
    -- c. Schedule 'auto-destruct' 
    --timer.performWithDelay( 10000, function() display.remove( bullet ) end )
end

--
-- 8. Create a 'Turret'
local turret = display.newCircle( display.contentCenterX, display.contentCenterY, 15 )
turret:setFillColor(1,0,0,0.5)
turret:setStrokeColor(1,0,1)
turret.strokeWidth = 2

--
-- 9. Fire a bullet at 'fireRate' forever
timer.performWithDelay( 250, function() fireBullet( ) end, -1  ) 
