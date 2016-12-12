-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
--  main.lua (44/71)
-- =============================================================
-- Kernel: Xevious Movment
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
local group 		= display.newGroup()
local player
local playerSize 	= 40
local debugEn 		= true -- Enable debug settings

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
player.fixedRotation = true
player.vx 				= 0
player.vy 				= 0
player.extraV			= 300
player.minX 			= centerX - 300 + playerSize/2
player.maxX 			= centerX + 300 - playerSize/2
player.minY 			= top + 50 + playerSize/2 
player.maxY 			= bottom - 50 - playerSize/2

-- ==
--    3. Add event listeners to primary object.
-- ==

-- onJoystick() - Listener for Easy Inputs joystick input events.
--
player.onJoystick = function( self, event )
	-- Once the stick is past the inner circle start steering
	--
	if( event.state == "on" ) then
		player.vx = event.nx * player.extraV
		player.vy = event.ny * player.extraV

	elseif( event.state == "off" ) then
		player.vx = 0
		player.vy = 0
	end

	return false
end; listen( "onJoystick", player )

-- enterFrame() - Called every frame, this moves the player based on input values
--                and calculations.
--
player.enterFrame = function( self )

	self:setLinearVelocity( self.vx, self.vy )

	if(self.x < self.minX ) then
		self.x = self.minX
	elseif(self.x > self.maxX ) then
		self.x = self.maxX
	end

	if(self.y < self.minY ) then
		self.y = self.minY
	elseif(self.y > self.maxY ) then
		self.y = self.maxY
	end

end; listen( "enterFrame", player )

-- ==
--    4. Create input object - A virtual joystick in this case.
-- ==
oneStick.create( group, { joyParams = { doNorm = true } } )


-- ==
--    5. If debugEn is 'true', show the min and max X bounds
-- ==
if( debugEn ) then
	local tmp = display.newLine( player.minX - playerSize/2, player.minY - playerSize/2, player.minX - playerSize/2, player.maxY + playerSize/2 )
	tmp.strokeWidth = 2
	local tmp = display.newLine( player.maxX + playerSize/2, player.minY - playerSize/2, player.maxX + playerSize/2, player.maxY + playerSize/2 )
	tmp.strokeWidth = 2
	local tmp = display.newLine( player.minX - playerSize/2, player.minY - playerSize/2, player.maxX + playerSize/2, player.minY - playerSize/2 )
	tmp.strokeWidth = 2
	local tmp = display.newLine( player.minX - playerSize/2, player.maxY + playerSize/2, player.maxX + playerSize/2, player.maxY + playerSize/2 )
	tmp.strokeWidth = 2
end

