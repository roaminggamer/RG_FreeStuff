-- =============================================================
-- player.lua
-- =============================================================

----------------------------------------------------------------------
--	Requires
----------------------------------------------------------------------
local cc = require "scripts.cc"


----------------------------------------------------------------------
-- Declarations
----------------------------------------------------------------------
-- Locals

-- Forward Declarations
local create 
local destroy

local getTimer 	= system.getTimer
local mRand 	= math.random


-- Callbacks/Listeners

----------------------------------------------------------------------
-- Definitions
----------------------------------------------------------------------
create = function ( group )
	local group 	= group or display.getCurrentStage()

	-- Create Body
	local body = display.newRect( group, 0, 0, 30, 50 )
	body:setFillColor(0,0,0,0)
	body:setStrokeColor( 0,1,1 )
	body.strokeWidth = 2
	body.x = centerX
	body.y = centerY
	body.canJump = false
	physics.addBody( body, "dynamic", {density=1, friction=0, bounce=0 ,filter=cc:getCollisionFilter("player") } )
	body.gravityScale = 1
	body.isSleepingAllowed = false -- Trick
	body.jumpForce = 26
	body.isFixedRotation = true
	body.isPlayer = true

	-- Create Foot Sensor
	local foot = display.newRect( group, 0, 0, 10, 20 )
	foot:setFillColor(0,0,0,0)
	foot:setStrokeColor( 1,1,1 )
	foot.strokeWidth = 2
	foot.x = centerX
	foot.y = body.y + body.contentHeight/2 
	physics.addBody( foot, "dynamic", {density=1, friction=0, bounce=0 ,filter=cc:getCollisionFilter("foot") } )
	foot.gravityScale = 0
	foot.isSensor = true
	foot.myBody = body

	body.foot = foot

	foot.myJoint = physics.newJoint( "weld", foot, body, foot.x, foot.y)

	foot.collision = function( self, event )
		if(event.phase == "began") then
			self.myBody.canJump = true
		elseif(event.phase == "ended") then
			self.myBody.canJump = false
		end
		return false
	end
	foot:addEventListener( "collision" )

	body.onJump = function( self, event )
		if( self.canJump ) then
			self:applyLinearImpulse( 0, -self.jumpForce, self.x, self.y )
		end
	end
	listen( "onJump", body )

end

-- Placeholder for a clean-up function to destroy the player.
--
destroy = function ( group )
end


----------------------------------------------------------------------
-- Module Packaging
----------------------------------------------------------------------
public = {}
public.create 	= create
public.destroy 	= destroy
return public