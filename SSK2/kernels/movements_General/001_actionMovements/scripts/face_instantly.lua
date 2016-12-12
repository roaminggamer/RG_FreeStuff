-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016
-- =============================================================
-- Recipe: Face Instantly (34/40)
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
local oneTouch 		= ssk.easyInputs.oneTouch

-- Forward Declarations

-- Locals
local player

local example = {}
function example.stop()
	physics.pause()
	ignoreList( { "oneTouch", "enterFrame" }, player )	
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
	oneTouch.create( group, { debugEn = false, keyboardEn = true } )

	-- Create an 'arrow' as our player
	--
	player = newImageRect( group, centerX, centerY, "images/arrow.png", { size = 40 }, { radius = 20 } )

	-- Create a 'target' to face
	--
	local target = newImageRect( group, centerX, centerY - 150, "images/rg.png", { size = 40 } )


	-- Start listening for enterFrame event
	--
	player.enterFrame = function( self )
		actions.face( self, { target = target } )
	end; listen( "enterFrame", player )


	-- Start listening for one touch event and move the 'target' to the touch
	player.onOneTouch = function( self, event )
		target.x = event.x
		target.y = event.y
		return false
	end; listen( "onOneTouch", player )	

end


return example
