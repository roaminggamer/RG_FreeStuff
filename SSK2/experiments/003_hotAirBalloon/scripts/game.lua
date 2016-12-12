-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- This example requires SSK 2
-- =============================================================
--
-- Asteroids movement example, using three custom inputs, more
-- akin to the original arcade cabinet version:
-- 
-- - Two buttons to steer left and right.
-- - A 'throttle' control to control thrust.
-- 
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

-- =============================================================
-- Locals
-- =============================================================
local playerSize = 40
local basket
local balloon

-- == 
--    The module (nothing more than a table.)
-- ==
local example = {}

-- ==
--    A. run() - The mechanic example itself, placed in a function to make showing the example easy for me.
-- ==
function example.run( group, options )
	group = group or display.currentStage 

	-- ==
	--    1. Start and Configure  physics
	-- ==
	local physics = require "physics"
	physics.start()
	physics.setGravity(0,10)
	physics.setDrawMode("hybrid")



	balloon = newRect( group, centerX, centerY - 50, { size = 80  }, { gravityScale = -2.5, linearDamping = 1, density = 0.1, isSleepingAllowed = false } )
	basket = newRect( group, centerX, centerY + 50, { size = 40, forceX = 0 }, { gravityScale = 1, linearDamping = 1, angularDamping = 1 } )
	local rope1 = physics.newJoint( "rope", balloon, basket, -30, 30, -10, -10 )
	local rope2 = physics.newJoint( "rope", balloon, basket, 30, 30, 10, -10 )


	function	balloon.enterFrame( self )
		display.remove(self.rope)
		self.rope = display.newLine( group, self.x, self.y, basket.x, basket.y )
		self.rope.strokeWidth = 2 
		--rope.maxLength = rope.maxLength + 1
	end;listen("enterFrame",balloon)

	function balloon.key( self, event )
		table.dump(event)
		if( event.phase ~= "up" ) then return end
		if( event.keyName == "up" ) then 
			self.gravityScale = self.gravityScale - 0.05
			print(self.gravityScale)
		end
		if( event.keyName == "down" ) then 
			self.gravityScale = self.gravityScale + 0.05
			print(self.gravityScale)
		end
	end;listen("key", balloon)

	function	basket.enterFrame( self )
		if( self.forceX ~= 0 ) then
			self:applyForce(  10 * self.forceX * self.mass, 1, self.x, self.y )
		end
	
	end;listen("enterFrame",basket)


	function basket.key( self, event )
		table.dump(event)
		if( event.phase ~= "up" ) then return end
		if( event.keyName == "right" ) then 
			self.forceX = self.forceX + 0.1
			print(self.forceX)
		end
		if( event.keyName == "left" ) then 
			self.forceX = self.forceX - 0.1 
			print(self.forceX)
		end
	end;listen("key", basket)


end


-- ==
--    B. This code will clean up the mechanic.  You would typically do this before deleting 
--       a game scene, or just as you delete it. 
-- == 
function example.stop()
	physics.pause()
	ignoreList( { "enterFrame", "key" }, balloon )
	ignoreList( { "enterFrame", "key" }, basket )
end


return example
