-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
--  main.lua (44/53)
-- =============================================================
-- Kernel: Geometry Wars: Retro Evolved Movement
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
-- Common SSK Display Object Builders
local newRect 			= ssk.display.newRect
local newImageRect 	= ssk.display.newImageRect
local oneStick 		= ssk.easyInputs.oneStick
local face 				= ssk.actions.face

-- SSK 2D Math Library
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale

-- =============================================================
-- Locals
-- =============================================================
local player
local playerSize 	= 40
local group 		= display.newGroup()

-- ==
--    1. Start and Configure  physics
-- ==
local physics = require "physics"
physics.start()
physics.setGravity(0,0)
--physics.setDrawMode("hybrid")

-- ==
--    2. Create primary object: Player
-- ==
player = newImageRect( group, centerX, centerY,  "images/arrow.png",
	                    { size = playerSize }, { } )

player.moving			= false -- Are we moving?
player.moveAngle		= 0 -- Angle we want to be facing
player.movePercent	= 0 -- Percentage of max rate
player.speed 			= 300 -- Rate at which we should move

-- ==
--    3. Add event listeners to primary object.
-- ==

-- onJoystick() - Listener for Easy Inputs joystick input events.
--
player.onJoystick = function( self, event )
	-- Once the stick is past the inner circle start steering
	--
	if( event.state == "on" ) then
		self.moveAngle = event.angle
		self.moving = true
		self.movePercent = event.percent/100

	elseif( event.state == "off" ) then
		self.moving = false
	end

	return false
end; listen( "onJoystick", player )

-- enterFrame() - Called every frame, this moves the player based on input values
--                and calculations.
--
player.enterFrame = function( self )
	-- Turn towards the direction we are moving at a rate of 720 degrees-per-second.
	face( self, { angle = self.moveAngle, rate = 720 })		
	
	-- Move in the 'moveAngle' direction, if we are 'moving'
	-- 
	if( self.moving ) then			
		local vec = angle2Vector( self.moveAngle, true)
		vec = scaleVec( vec, self.speed * player.movePercent )
		self:setLinearVelocity( vec.x, vec.y )
	else
		self:setLinearVelocity( 0, 0 )
	end		
end; listen( "enterFrame", player )


-- ==
--    4. Create input object - A virtual joystick in this case.
-- ==
oneStick.create( group, {} )

