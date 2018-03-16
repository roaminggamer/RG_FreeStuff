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
	layers = display.newGroup()
	layers.underlay = display.newGroup()
	layers.content = display.newGroup()
	layers.interfaces = display.newGroup()
	--
	group:insert( layers )
	layers:insert( layers.underlay )
	layers:insert( layers.content )
	layers:insert( layers.interfaces )
	

	-- Create a background image	
	local tmp = display.newImageRect( layers.underlay, "images/protoBackX.png", 720, 1386 )
	tmp.x = display.contentCenterX
	tmp.y = display.contentCenterY


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



