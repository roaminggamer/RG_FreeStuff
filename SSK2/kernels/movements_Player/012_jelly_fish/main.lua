-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
--  main.lua (33/62)
-- =============================================================
-- Kernel: Jelly Fish Movement (left-joy steer; right button squirt/thrust)
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
local getInfo           = system.getInfo
local getTimer          = system.getTimer
local mRand				= math.random
--
-- Common SSK Display Object Builders
local newCircle = ssk.display.newCircle;local newRect = ssk.display.newRect
local newImageRect = ssk.display.newImageRect;local newSprite = ssk.display.newSprite
local quickLayers = ssk.display.quickLayers
--
-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist
--
-- Common SSK Helper Functions
local isValid = display.isValid;local isInBounds = ssk.easyIFC.isInBounds
local normRot = ssk.misc.normRot;local easyAlert = ssk.misc.easyAlert
-- =============================================================
-- =============================================================
-- =============================================================
--
-- Setup physics
local physics = require "physics"
physics.start()
physics.setGravity(0,0)
--physics.setDrawMode("hybrid")

--
-- Be lazy and use RG Collision calculator
local myCC = ssk.cc:newCalculator()
myCC:addNames( "player", "foot", "platform", "trigger" )
myCC:collidesWith( "player", { "platform", "trigger" } )
myCC:collidesWith( "foot", { "platform" } )

local layers = quickLayers( nil, "background", "world", { "content" } )

local function createPlayer( x, y, impulseMag )

	-- Create player with a foot
	local player = newImageRect( layers.content, x, y, "images/arrow.png",
		{ size = 150, fill = _C_, scale = 0.5, density = 1, target = 0 }, 
		{ bounce = 0, friction = 0, calculator = myCC, 
		  colliderName = "player", linearDamping = 1 } )

	function player.onJoystick( self, event )
		--table.dump(event)
		--if( event.state == "on" ) then
		if( event.phase ~= "ended" ) then
			self.target = event.angle
		end
	end; listen( "onJoystick", player )

	function player.onOneTouch( self, event )
		if( event.phase == "began" ) then
			ssk.actions.movep.impulseForward( self, { mag = impulseMag })
		end
	end; listen( "onOneTouch", player )

	function player.enterFrame( self )
		ssk.actions.face( self, { angle = self.target, rate = 180 } )
	end; listen( "enterFrame", player )

	ssk.camera.tracking( player, layers.world )
end



local function createRandomOther( radius, numToCreate )
	for i = 1, numToCreate do
		newImageRect( layers.world, 
					  centerX + mRand( -radius, radius ), 
					  centerY + mRand( -radius, radius ),
					  "images/triangle.png",
					  { size = mRand( 40, 80), fill = randomColor(), alpha = mRand(2,8)/10, 
					    rotation = mRand(1,359) } )
	end
end


createPlayer( centerX, centerY, 5 )
ssk.easyInputs.oneStickOneTouch.create( layers.background )

createRandomOther( 2000, 800 )