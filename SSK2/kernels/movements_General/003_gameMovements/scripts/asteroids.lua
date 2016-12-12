-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================

-- =============================================================
-- Localizations
-- =============================================================
-- Lua
local getTimer = system.getTimer; local mRand = math.random
local mAbs = math.abs
local strMatch = string.match; local strGSub = string.gsub; local strSub = string.sub
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
local normRot = math.normRot;local easyAlert = ssk.misc.easyAlert
--
-- SSK 2D Math Library
local addVec = ssk.math2d.add;local subVec = ssk.math2d.sub;local diffVec = ssk.math2d.diff
local lenVec = ssk.math2d.length;local len2Vec = ssk.math2d.length2;
local normVec = ssk.math2d.normalize;local vector2Angle = ssk.math2d.vector2Angle
local angle2Vector = ssk.math2d.angle2Vector;local scaleVec = ssk.math2d.scale
--
-- Specialized SSK Features
local actions = ssk.actions
local rgColor = ssk.RGColor

ssk.misc.countLocals(1)

-- =============================================================
-- =============================================================
local oneStick 		= ssk.easyInputs.oneStick

-- Forward Declarations
local drawRoom


-- Locals
local player
local playerSize = 40


local example = {}

function example.stop()
	physics.pause()
	ignoreList( { "onJoystick", "enterFrame" }, player )
end

function example.run( group )
	--
	-- Start and Configure  physics
	local physics = require "physics"
	physics.start()
	physics.setGravity(0,0)
	--physics.setDrawMode("hybrid")
	
	-- Initialize 'input'
	--
	oneStick.create( group, { debugEn = false, joyParams = { doNorm = true } } )

	-- create a 'wrapRect' as a proxy for wrapping calculations
	--
	local wrapRect = newRect( group, centerX, centerY, 
		                       { w = fullw + playerSize, h = fullh + playerSize,
		                         fill = { 0, 1, 1, 0.1}, stroke = {1,1,0,0.5}, strokeWidth = 1 } )

	-- Create a 'player' as our player
	--
	player = newImageRect( group, centerX, centerY - 50, "images/kenney1.png", { size = playerSize }, { radius = 20 } )

	-- Prepare the player for inputs
	--
	player.isFixedRotation = true
	player.linearDamping = 0.5
	player.forceX = 0
	player.forceY = 0
	player.x = centerX
	player.y = centerY

	-- Start listening for enterFrame event
	--
	player.enterFrame = function( self )
		self:applyForce( self.forceX * self.mass, self.forceY * self.mass, self.x, self.y )
		actions.scene.rectWrap( self, wrapRect )
	end; listen( "enterFrame", player )

	-- Start listening for the one stick (onJoystick) event
	--
	player.onJoystick = function( self, event )
		if( event.state == "on" ) then
			self.forceX = 15 * event.nx
			self.forceY = 15 * event.ny
			self.rotation = event.angle
		elseif( event.state == "off" ) then
			self.forceX = 0
			self.forceY = 0
		end
		return false
	end; listen( "onJoystick", player )
end



return example
