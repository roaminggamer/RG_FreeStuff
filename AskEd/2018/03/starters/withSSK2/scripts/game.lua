-- =============================================================
-- Minimalistic 'starter' game.lua
-- =============================================================
local common 		= require "scripts.common"
local physics 		= require "physics"

-- =============================================================
-- Localizations
-- =============================================================
-- Commonly used Lua Functions
local getTimer          = system.getTimer
local mRand					= math.random
local mAbs					= math.abs
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
-- Locals
-- =============================================================
local layers
local lastTimer

-- =============================================================
-- Module Begins
-- =============================================================
local game = {}


-- ==
--    create() - Create game content.
-- ==
function game.create( group )
	group = group or display.currentStage
	--
	game.destroy() 
	--
	physics.start()
	physics.setGravity( 0, 10 )
	--physics.setDrawMode("hybrid")	

	-- Rendering layers for our 'game'
	-- https://roaminggamer.github.io/RGDocs/pages/SSK2/libraries/display_layers/
	layers = ssk.display.quickLayers( group,  "underlay",  "content",  "interfaces" )

	-- Create a background image	
	-- https://roaminggamer.github.io/RGDocs/pages/SSK2/libraries/display_standard/#newimagerect
	newImageRect( layers.underlay, centerX, centerY, "images/protoBackX.png", { w = 720, h = 1386 } )

   -- GAME CONTENT HERE
   -- GAME CONTENT HERE
   -- GAME CONTENT HERE

	-- Mark game as running
	common.gameIsRunning = true
end


-- ==
--    destroy() - Remove all game content and clean up.
-- ==
function game.destroy() 
	-- Mark game as not running
	common.gameIsRunning = false

	-- GAME CLEANUP CODE HERE
   -- GAME CLEANUP CODE HERE
   -- GAME CLEANUP CODE HERE

	-- Destroy Existing Layers
	if( layers ) then
		display.remove( layers )
		layers = nil
	end

end

return game



