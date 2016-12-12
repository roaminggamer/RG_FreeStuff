-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016
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
local twoTouch 		= ssk.easyInputs.twoTouch

-- Forward Declarations
local drawTrail
local playerSize = 40

-- Locals
local player
local target
local angle = 0

local example = {}
function example.stop()
	physics.pause()
	ignoreList( { "onTwoTouchLeft", "onTwoTouchRight", "enterFrame" }, player )
	timer.cancel( player.myTimer )
end

function example.run( group )
	--
	-- Start and Configure  physics
	local physics = require "physics"
	physics.start()
	physics.setGravity(0,10)
	physics.setDrawMode("hybrid")


	-- create a 'wrapRect' as a proxy for wrapping calculations
	--
	local wrapRect = newRect( group, centerX, centerY, 
		                       { w = fullw + playerSize, h = fullh + playerSize,
		                         fill = { 0, 1, 1, 0.1}, stroke = {1,1,0,0.5}, strokeWidth = 1 } )
	

	-- Initialize 'input'
	--
	twoTouch.create( group, { debugEn = true, keyboardEn = true } )

	-- Create an 'arrow' as our player
	--
	player = newImageRect( group, centerX, centerY, "images/arrow.png", { size = playerSize }, { } )
	player.linearDamping = 0.5
	player.angularDamping = 1

	player.leftInput  = false
	player.rightInput = false


	-- Draw new 'trail' dot every 100 ms
	-- 
	player.timer = drawTrail
	player.myTimer = timer.performWithDelay( 100, player, -1 )

	-- Have player  start listening for enterFrame event
	--
	player.enterFrame = function( self )

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
		--actions.movep.limitV( self, { rate = 300 } )

		actions.movep.dampDown( self, { rate = 100, damping = 1.25 })

		actions.scene.rectWrap( self, wrapRect )		

	end; listen( "enterFrame", player )


	-- Start listening for two touch events
	player.onTwoTouchLeft = function( self, event )
		if(event.phase == "began" ) then
			self.leftInput = true
		elseif(event.phase == "ended" ) then
			self.leftInput = false
		end
		return false
	end; listen( "onTwoTouchLeft", player )	
	
	player.onTwoTouchRight = function( self, event )
		if(event.phase == "began" ) then
			self.rightInput = true
		elseif(event.phase == "ended" ) then
			self.rightInput = false
		end
		return false
	end; listen( "onTwoTouchRight", player )	


	-- create 'platforms' to land on
	--
	local plat = newRect( group, centerX, centerY+ 50, 
		                   { w = 50, h = 50, fill = _O_}, 
		                   { bodyType = "static"} )

	local plat = newRect( group, centerX - 200, centerY + 0, 
		                   { w = 80, h = 100, fill = _O_}, 
		                   { bodyType = "static"} )

	local plat = newRect( group, centerX + 200, centerY + 0, 
		                   { w = 80, h = 100, fill = _O_}, 
		                   { bodyType = "static"} )


end

-- Helper function to draw a simple 'trail' of dots showing where the player has been
--
drawTrail = function( player )
	local vec = angle2Vector( player.rotation + 180, true )
	vec = scaleVec( vec, player.height/2 + player.contentWidth/8)
	local dot = display.newCircle( player.parent, player.x + vec.x, player.y + vec.y, 
		                            player.contentWidth/8 )
	dot:toBack()
	transition.to( dot, { alpha = 0, time = 750, onComplete = display.remove } )
end



return example
