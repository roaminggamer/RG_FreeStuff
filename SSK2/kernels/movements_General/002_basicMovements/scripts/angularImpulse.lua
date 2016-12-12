-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016
-- =============================================================
-- Recipe: Angular Impulse (43/73)
-- =============================================================
-- Localizations
-- =============================================================
-- Lua
local getInfo           = system.getInfo
local getTimer          = system.getTimer
local mRand          	= math.random
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
-- =============================================================
-- =============================================================
local twoTouch 		= ssk.easyInputs.twoTouch
-- Forward Declarations
local drawRoom
local drawTrail

-- Locals
local player

local example = {}
function example.stop()
	physics.pause()
	ignoreList( { "onTwoTouchLeft", "onTwoTouchRight"}, player )
	timer.cancel( player.myTimer )
end

function example.run( group )
	--
	-- Start and Configure  physics
	local physics = require "physics"
	physics.start()
	physics.setGravity(0,9.8)
	--physics.setDrawMode("hybrid")
	
	-- Initialize 'input'
	--
	twoTouch.create( group, { debugEn = true, keyboardEn = true } )

	-- Create a room 
	--
	drawRoom( group )

	-- Create a 'ball' as our player
	--
	player = newImageRect( group, centerX, centerY - 50, "images/kenney1.png", 
		                          { size = 80 }, 
		                          { radius = 40, friction = 1 } )
	
	-- Prepare the player for inputs
	--	
	player.linearDamping = 0.5
	player.angularDamping = 0.5

	-- Draw new 'trail' dot every 100 ms
	-- 
	player.timer = drawTrail
	player.myTimer = timer.performWithDelay( 100, player, -1 )

	-- Start listenering for the two touch events
	--
	player.onTwoTouchLeft = function( self, event )
		if( event.phase == "began" ) then
			self:applyAngularImpulse( -500 * self.mass )
		end
		return false
	end; listen( "onTwoTouchLeft", player )

	player.onTwoTouchRight = function( self, event )
		if( event.phase == "began" ) then
			self:applyAngularImpulse( 500 * self.mass )
		end
		return false
	end; listen( "onTwoTouchRight", player )	
end

-- Helper function to draw a simple 'trail' of dots showing where the player has been
--
drawTrail = function( player )
	local dot = display.newCircle( player.parent, player.x, player.y, player.contentWidth/8 )
	dot:toBack()
	transition.to( dot, { alpha = 0, time = 750, onComplete = display.remove } )
end


-- Helper function to draw a simple room for our example
--
drawRoom = function( group )
	-- Walls
	--
	display.setDefault( "textureWrapY", "repeat" )
	local leftWall = newRect( group, left, centerY, { w = 80, h = fullh  }, { bodyType = "static", friction = 1 } )
	leftWall.fill = { type = "image", filename = "images/kenney_wood.png" }
	leftWall.fill.scaleY = 80/fullh
	local rightWall = newRect( group, right, centerY, { w = 80, h = fullh  }, { bodyType = "static", friction = 1 } )
	rightWall.fill = { type = "image", filename = "images/kenney_wood.png" }
	rightWall.fill.scaleY = 80/fullh
	display.setDefault( "textureWrapY", "clampToEdge" )

	-- Floor and Ceiling
	--
	display.setDefault( "textureWrapX", "repeat" )
	local floor = newRect( group, centerX, bottom, { w = fullw, h = 80  }, { bodyType = "static", friction = 1 } )
	floor.fill = { type = "image", filename = "images/kenney_stone.png" }
	floor.fill.scaleX = 80/fullw
	local ceiling = newRect( group, centerX, top, { w = fullw, h = 80  }, { bodyType = "static", friction = 1 } )
	ceiling.fill = { type = "image", filename = "images/kenney_stone.png" }
	ceiling.fill.scaleX = 80/fullw
	display.setDefault( "textureWrapX", "clampToEdge" )
end



return example
