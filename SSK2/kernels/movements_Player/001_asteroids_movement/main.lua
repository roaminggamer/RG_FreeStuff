-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
--  main.lua  (66/59)
-- =============================================================
-- Kernel: Asteroids Movement + Screen Wrapping
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
-- LOAD & INITIALIZE - SSK 2
-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init()
_G.ssk.init( { launchArgs 				= ..., 
	            enableAutoListeners 	= true,
	            exportCore 				= true,
	            exportColors 			= true,
	            exportSystem 			= true,
	            exportSystem 			= true,
	            gameFont 				= "Prime.ttf",
	            debugLevel 				= 0 } )
-- =============================================================
-- KERNEL CODE BEGINS BELOW
-- =============================================================

-- =============================================================
-- Localizations
-- =============================================================
local newRect 			= ssk.display.newRect
local newImageRect 	= ssk.display.newImageRect
local oneStick 		= ssk.easyInputs.oneStick
local face 				= ssk.actions.face
local thrustForward	= ssk.actions.movep.thrustForward
local limitV			= ssk.actions.movep.limitV
local rectWrap 		= ssk.actions.scene.rectWrap

-- =============================================================
-- Locals
-- =============================================================
local player
local playerSize 	= 40
local group 		= display.newGroup()

local debugEn 		= false -- Set this to 'true' to shrink wrap rect
                          -- This will let you see better how it works

-- ==
--    Start and Configure physics
-- ==
local physics = require "physics"
physics.start()
physics.setGravity(0,0)
--physics.setDrawMode("hybrid")


-- ==
--    Create a 'wrapRect' as a proxy for wrapping calculations
-- ==
-- SSK 2 makes it easy to achieve screen wrapping.
--
-- All that is required is:	
-- 1. A proxy object (usually hidden) to define the wrapping area.
--
-- Notes: 
--
--  a. This example is smaller than the screen size, so you can see the wrapping happen.
-- 
--  b. Usually, the proxy object will be as wide as the screen + half the size of the largest
--     object that will wrap.
--
--  c. The extra margin/buffer is to ensure no popping is visible. That is, you want to wrap
--     to occur offscreen or it may have a unpleasing visual effect.
--
--
local offset = (debugEn) and -200 or playerSize
local wrapRect = newRect( group, centerX, centerY, 
	                       { w = fullw + offset,  h = fullh + offset,
	                         fill = {0,1,1,0.1}, stroke = {1,1,0,0.5}, strokeWidth = 2 } )


-- ==
--    Create primary object: Player
-- ==
player = newImageRect( group, centerX, centerY,  "images/arrow.png",
	                    { size = playerSize }, { } )

player.linearDamping = 1.5 	-- Set this kind of high to stop fast 
player.facing 			= 0		-- Direction we want player to face.
player.thrustPercent	= 0		-- Percentage of thrust to apply.
player.thrustForce	= 50 		-- Base thrust magnitude.
player.maxSpeed 		= 250		-- Maximum rate in pixels-per-second.


-- ==
--    Add event listeners to primary object.
-- ==

-- onJoystick() - Listener for Easy Inputs joystick input events.
--
player.onJoystick = function( self, event )
	-- Once the stick is past the inner circle start steering
	--
	if( event.state == "on" ) then
		self.facing = event.angle

		-- Start accelerating once the stick percent rises over 20%
		-- This allows us to steer without thrusting too.
		if( event.percent > 20 ) then
			self.thrustPercent = event.percent/100			
		else
			self.thrustPercent = 0
		end

	elseif( event.state == "off" ) then
		self.thrustPercent = 0
	end

	return false
end; listen( "onJoystick", player )


-- enterFrame() - Called every frame, this moves the player based on input values
--                and calculations.
--
player.enterFrame = function( self )
	
	-- Face our latest 'facing' angle at a rate of 540 degrees-per-second.
	face( self, { angle = self.facing, rate = 540 })		
	
	-- Accelerate forward and limit our max speed.
	-- 
	if( self.thrustPercent > 0 ) then			
		thrustForward( self, { rate = self.thrustForce * self.thrustPercent } )
		limitV( self, { rate = self.maxSpeed } )
	end		

	-- Do wrapping
	--
	rectWrap( self, wrapRect )


end; listen( "enterFrame", player )


-- ==
--    4. Create input object - A virtual joystick in this case.
-- ==
oneStick.create( group, {} )