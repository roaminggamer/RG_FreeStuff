-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
--  main.lua (47/79)
-- =============================================================
-- Kernel: Lunar Lander Movement (Easy Inputs - Two Touch )
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
_G.fontN 	= "Raleway-Light.ttf" 
_G.fontB 	= "Raleway-Black.ttf" 
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
local twoTouch 		= ssk.easyInputs.twoTouch
local actions 			= ssk.actions

-- =============================================================
-- Locals
-- =============================================================
local group 		= display.newGroup()
local playerSize 	= 40
local player
local target
local angle 		= 0


-- ==
--    1. Start and Configure  physics
-- ==
local physics = require "physics"
physics.start()
physics.setGravity(0,10)
physics.setDrawMode("hybrid")


-- ==
--    2. Create a 'wrapRect' as a proxy for wrapping calculations
-- ==
local wrapRect = newRect( group, centerX, centerY, 
	                       { w = fullw + playerSize, h = fullh + playerSize,
	                         fill = { 0, 1, 1, 0.1}, stroke = {1,1,0,0.5}, strokeWidth = 1 } )

-- ==
--    3. Create primary object: Player/Ship
-- ==
player = newImageRect( group, centerX, centerY, "images/arrow.png", { size = playerSize }, { } )
player.linearDamping = 0.5
player.angularDamping = 1
player.leftInput  = false
player.rightInput = false


-- ==
--    4. Add event listeners to primary object.
-- ==

-- onTwoTouchLeft() - Left touch event from twoTouch.
--
player.onTwoTouchLeft = function( self, event )
	if(event.phase == "began" ) then
		self.leftInput = true
	elseif(event.phase == "ended" ) then
		self.leftInput = false
	end
	return false
end; listen( "onTwoTouchLeft", player )	

-- onTwoTouchRight() - Right touch event from twoTouch.
--
player.onTwoTouchRight = function( self, event )
	if(event.phase == "began" ) then
		self.rightInput = true
	elseif(event.phase == "ended" ) then
		self.rightInput = false
	end
	return false
end; listen( "onTwoTouchRight", player )	

-- enterFrame() - Called every frame, this moves the player based on input values
--                and calculations.
--
player.enterFrame = function( self )

	-- Are the input flags toggled?  If so, rotate the polayer/ship.
	if( self.leftInput and not self.rightInput ) then
		actions.face( self, { angle = self.rotation - 90, rate = 90 } )

	elseif( not self.leftInput and self.rightInput ) then
		actions.face( self, { angle = self.rotation + 90, rate = 90 } )

	else
		actions.face( self, { pause = true } )
	end

	local rate = 0
	rate = rate + ( (self.leftInput) and 10 or 0 )
	rate = rate + ( (self.rightInput) and 10 or 0 )
	if( rate > 0 ) then
		actions.movep.thrustForward( self, { rate = rate } )
	end

	-- Limit Velocity to maximum rate of 300 pixels per second
	actions.movep.dampDown( self, { rate = 100, damping = 2 })

	actions.scene.rectWrap( self, wrapRect )		

end; listen( "enterFrame", player )

-- ==
--    5. Create input object - An Easy Inputs 'twoTouch'.
-- ==
local input = twoTouch.create( group, { debugEn = true, keyboardEn = true } )
input:toBack()

-- ==
--    6. Create 'plaforms' to practice landing on.
-- ==
local plat = newRect( group, centerX, centerY+ 50, 
	                   { w = 50, h = 50, fill = _O_}, 
	                   { bodyType = "static"} )

local plat = newRect( group, centerX - 200, centerY + 0, 
	                   { w = 80, h = 100, fill = _O_}, 
	                   { bodyType = "static"} )

local plat = newRect( group, centerX + 200, centerY + 0, 
	                   { w = 80, h = 100, fill = _O_}, 
	                   { bodyType = "static"} )