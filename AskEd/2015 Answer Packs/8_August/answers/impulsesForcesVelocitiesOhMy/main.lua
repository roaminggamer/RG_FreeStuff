-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"The use was a little unclear on how physics forces and movement work.", 
	"",
	"This demo shows: impulses, velocities, forces, and speed limits."
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end


--
-- Set up physics
local physics = require "physics"
physics.start()
physics.setGravity( 0, 0 )


--
-- Set Velocity Example
local function setLinearVelocity()
	local label = display.newText( "setLinearVelocity:", 10, 200, native.systemFont, 22 )
	label.anchorX = 0
	
	local tmp = display.newImageRect( "yellow_round.png", 40, 40 )
	tmp.x = 250
	tmp.y = 200

	physics.addBody( tmp )

	tmp:setLinearVelocity( 50, 0 )

	local label2 = display.newText( "vx: 0", 10, label.y + 25, native.systemFont, 22 )
	label2.anchorX = 0
	label2.enterFrame = function( self )
		local vx, vy = tmp:getLinearVelocity()
		if( vx ) then
			self.text = "vx: " .. string.format("%2.2f", vx )
		end
	end
	Runtime:addEventListener( "enterFrame", label2 )
end

--
-- Impulse Example
local function applyLinearImpulse()
	local label = display.newText( "applyLinearImpulse:", 10, 300, native.systemFont, 22 )
	label.anchorX = 0

	local tmp = display.newImageRect( "yellow_round.png", 40, 40 )
	tmp.x = 250
	tmp.y = 300

	physics.addBody( tmp )
	timer.performWithDelay( 1000, 
		function()
			tmp:applyLinearImpulse( 3 * tmp.mass, 0, tmp.x, tmp.y  )
		end )

	local label2 = display.newText( "vx: 0", 10, label.y + 25, native.systemFont, 22 )
	label2.anchorX = 0
	label2.enterFrame = function( self )
		local vx, vy = tmp:getLinearVelocity()
		if( vx ) then
			self.text = "vx: " .. string.format("%2.2f", vx )
		end
	end
	Runtime:addEventListener( "enterFrame", label2 )
end

--
-- Force Example
local function applyForce()
	local label = display.newText( "applyForce:", 10, 400, native.systemFont, 22 )
	label.anchorX = 0
	
	local tmp = display.newImageRect( "yellow_round.png", 40, 40 )
	tmp.x = 250
	tmp.y = 400

	physics.addBody( tmp )
	
	tmp.enterFrame = function( self )
		self:applyForce( 1 * self.mass, 0, self.x, self.y )
	end
	Runtime:addEventListener( "enterFrame", tmp )

	local label2 = display.newText( "vx: 0", 10, label.y + 25, native.systemFont, 22 )
	label2.anchorX = 0
	label2.enterFrame = function( self )
		local vx, vy = tmp:getLinearVelocity()
		if( vx ) then
			self.text = "vx: " .. string.format("%2.2f", vx )
		end
	end
	Runtime:addEventListener( "enterFrame", label2 )
end

--
-- Force (with speed limit) Example
local function applyForceLimitV()
	local label = display.newText( "applyForceLimitV:", 10, 500, native.systemFont, 22 )
	label.anchorX = 0
	
	local tmp = display.newImageRect( "yellow_round.png", 40, 40 )
	tmp.x = 250
	tmp.y = 500

	physics.addBody( tmp )
	
	tmp.enterFrame = function( self )
		self:applyForce( 3 * self.mass, 0, self.x, self.y )
		local vx, vy = self:getLinearVelocity()
		if( vx > 100 ) then
			self:setLinearVelocity( 100, vy )
		end
	end
	Runtime:addEventListener( "enterFrame", tmp )

	local label2 = display.newText( "vx: 0", 10, label.y + 25, native.systemFont, 22 )
	label2.anchorX = 0
	label2.enterFrame = function( self )
		local vx, vy = tmp:getLinearVelocity()
		if( vx ) then
			self.text = "vx: " .. string.format("%2.2f", vx )
		end
	end
	Runtime:addEventListener( "enterFrame", label2 )
end


--
-- Start after 1.5 seconds
setLinearVelocity()
applyLinearImpulse()
applyForce()
applyForceLimitV()
