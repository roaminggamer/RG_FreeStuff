-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- game.lua - Game Module
-- =============================================================
local common 		= require "scripts.common"
local factoryMgr 	= require "scripts.factories.factoryMgr"
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
local normRot = ssk.misc.normRot;local easyAlert = ssk.misc.easyAlert

-- =============================================================
-- Locals
-- =============================================================
local layers
local lastGemTimer
local lastEnemyTimer

-- =============================================================
-- Module Begins
-- =============================================================
local game = {}

-- ==
--    init() - One-time initialization only.
-- ==
function game.init()

	--
	-- Mark game as not running
	--
	common.gameIsRunning = false

	--
	-- Initialize all factories
	--
	factoryMgr.init()

	--
	-- Trick: Start physics, then immediately pause it.
	-- Now it is ready for future interactions/settings.
	physics.start()
	physics.pause()

	-- Clear Score, Coins, Distance Counters
	common.score 		= 0
	common.coins 		= 0
	
	common.bulletType = 1

	common.enemies = {}
end


-- ==
--    stop() - Stop game if it is running.
-- ==
function game.stop()

	if( lastGemTimer ) then
		timer.cancel( lastGemTimer )
	end
	lastGemTimer = nil
 
	if( lastEnemyTimer ) then
		timer.cancel( lastEnemyTimer )
	end
	lastEnemyTimer = nil

	--
	-- Mark game as not running
	--
	common.gameIsRunning = false

	--
	-- Pause Physics
	physics.setDrawMode("normal")	
	physics.pause()

	common.enemies = {}
end

-- ==
--    destroy() - Remove all game content.
-- ==
function game.destroy() 
	--
	-- Reset all of the factories
	--
	factoryMgr.reset( )

	-- Destroy Existing Layers
	if( layers ) then
		ignoreList( { "onDied" }, layers )
		display.remove( layers )
		layers = nil
	end

	-- Clear Score, Coins, Distance Counters
	common.score 		= 0
	common.coins 		= 0

	common.bulletType = 1

	common.enemies = {}
end


-- ==
--    start() - Start game actually running.
-- ==
function game.start( group, params )
	params = params or { debugEn = false }

	game.destroy() 

	--
	-- Mark game as running
	--
	common.gameIsRunning = true

	--
	-- Configure Physics
	--
	physics.start()
	physics.setGravity( common.gravityX, common.gravityY )
	if( params.debugEn ) then
		physics.setDrawMode("hybrid")	
	end

	--
	-- Create Layers
	--
	layers = ssk.display.quickLayers( group, 
		"underlay", 
		"world", 
			{ "ground", "content", "player" },
		"interfaces" )

	--
	-- Create a background color	
	--
	newRect( layers.underlay, centerX, centerY, 
		      { w = fullw, h = fullh, fill = hexcolor("#2FBAB4") })

	--
	-- Create One Touch Easy Input
	--
	ssk.easyInputs.twoTouch.create( layers.content , 
		{ debugEn = params.debugEn, keyboardEn = true } )

	--
	-- Create HUDs
	--
	factoryMgr.new( "coinsHUD", layers.interfaces, left + 10, top + 25, { iconSize = 32, fontSize = 32} )	
	factoryMgr.new( "timeHUD", layers.interfaces, right - 10, top + 25, { fontSize = 32 } )	
	factoryMgr.new( "weaponHUD", layers.interfaces, centerX - 50, top + 25, { iconScale = 1, fontSize = 32 } )	
	--
	--
	-- Add player died listener to layers to allow it to do work if we need it
	function layers.onDied( self, event  )
		ignore( "onDied", self )
		game.stop()	

		--
		-- Blur the whole screen
		--
		local function startOver()
			game.start( group, params )  
		end
		ssk.misc.easyBlur( layers.interfaces, 250, _R_, 
			                { touchEn = true, onComplete = startOver } )


		-- 
		-- Show 'You Died' Message
		--
		local msg1 = easyIFC:quickLabel( layers.interfaces, "Game Over!", centerX, centerY - 50, "AdelonSerial.ttf", 50 )
		local msg2 = easyIFC:quickLabel( layers.interfaces, "Tap or Click To Play Again", centerX, centerY + 50, "AdelonSerial.ttf", 50 )
		easyIFC.easyFlyIn( msg1, { sox = -fullw, delay = 500, time = 750, myEasing = easing.outElastic } )
		easyIFC.easyFlyIn( msg2, { sox = fullw, delay = 500, time = 750, myEasing = easing.outElastic } )


	end; listen( "onDied", layers )


	--
	-- Attach a finalize event to layers so it cleans it self up when removed.
	--	
	layers.finalize = function( self )
		ignoreList( { "onNewSegment", "onDied" }, self )
	end; layers:addEventListener( "finalize" )

	--
	-- Create the `room`
	--
	factoryMgr.new( "room", nil, nil, nil, { debugEn = params.debugEn, layers = layers } )

	--
	-- Create Player
	--
	factoryMgr.new( "player", layers.player,  centerX - common.cellSize/2, centerY + common.cellSize * 2 )	


	-- 
	-- Drop Random Gems
	--	
	local function dropGem()
		if( common.isRunning == false ) then return end
		local x = (common.cellSize * (common.cols-2))/2
		x = centerX + mRand( -x, x )
		local y = (common.cellSize * (common.rows-2))/2 
		y = centerY + mRand( -y, y ) + common.cellSize/2

		factoryMgr.new( "gem", layers.content, x, y, 
			             { debugEn = params.debugEn, gemType = mRand(1,3) } )

		lastGemTimer = timer.performWithDelay( common.gemTime, dropGem )
	end
	dropGem()

	-- 
	-- Spawn Random Enemies
	--	
	local function spawnEnemy()

		if( common.isRunning == false ) then return end
		local x = (common.cellSize * (common.cols-3))/2
		x = centerX + mRand( -x, x )
		local y = (common.cellSize * (common.rows-3))/2 
		y = centerY + mRand( -y, y ) + common.cellSize/2

		local enemyType = mRand(1,2)

		factoryMgr.new( "enemy" .. enemyType, layers.content, centerX, centerY - fullh,
							 { target = { x = x, y = y } } )

		lastEnemyTimer = timer.performWithDelay( common.enemyTime, spawnEnemy )
	end
	spawnEnemy()


end


return game
