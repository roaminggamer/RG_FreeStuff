-- =============================================================
-- player.lua
-- =============================================================

----------------------------------------------------------------------
--	Requires
----------------------------------------------------------------------
local cc = require "scripts.nicer.cc"


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
create = function ( group, speed )
	local group 	= group or display.getCurrentStage()

	-- Create Body
	local body = display.newImageRect( group, "images/bowling_ball.png", 24, 24 )

	body.x = centerX
	body.y = centerY
	body.canJump = false
	physics.addBody( body, "dynamic", {density=1, friction=0, bounce=0 ,filter=cc:getCollisionFilter("player"), radius = 12 } )
	body.gravityScale = 1
	body.isSleepingAllowed = false -- Trick
	body.jumpForce = 14
	body.isFixedRotation = true
	body.isPlayer = true
	body.angularDamping = 1

	body.enterFrame = function( self )
		if( self.canJump ) then
			self.angularVelocity = speed * 2
		else 
			--self.angularVelocity = 0
		end
	end
	Runtime:addEventListener( "enterFrame", body )

	-- Create Foot Sensor
	local foot = display.newRect( group, 0, 0, 10, 40 )
	foot:setFillColor(1,1,1,0)
	foot.x = body.x
	foot.y = body.y 
	physics.addBody( foot, "dynamic", {density=1, friction=0, bounce=0 ,filter=cc:getCollisionFilter("foot") } )
	foot.gravityScale = 0
	foot.isSensor = true
	foot.myBody = body

	body.foot = foot



	foot.myJoint = physics.newJoint( "pivot", foot, body, foot.x, foot.y)

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