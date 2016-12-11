-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Coin HUD Factory
-- =============================================================
local common 	= require "scripts.common"
local myCC 		= require "scripts.myCC"
local physics 	= require "physics"

-- =============================================================
-- Localizations
-- =============================================================
-- Commonly used Lua Functions
local getTimer          = system.getTimer
local mRand					= math.random
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
local initialized = false

-- =============================================================
-- Forward Declarations
-- =============================================================

-- =============================================================
-- Factory Module Begins
-- =============================================================
local factory = {}

-- ==
--    init() - One-time initialization only.
-- ==
function factory.init( params )
	if(initialized) then return end
	initialized = true
end

-- ==
--    reset() - Reset any per-game logic/settings.
-- ==
function factory.reset( params )
end

-- ==
--    new() - Create new instance(s) of this factory's object(s).
-- ==
function factory.new( group, x, y, params )
	params = params or {}

	--
	-- Coin Icon + Label
	--
	local icon = newImageRect( group, x, y, "images/coin.png", 
										{ 	size = params.iconSize or 60, 
											anchorX = 0 } )

	local hud = easyIFC:quickLabel( group, common.coins, icon.x + icon.contentWidth + 15, y, 
		                             "AdelonSerial.ttf",
		                             params.fontSize or 48,
		                             params.color or _W_, 0 )
	hud.lastCoins = common.coins
	hud.icon = icon

	-- 
	-- Update coins text every frame 
	--
	function hud.enterFrame( self )
		--
		-- Skip if no change since last frame
		--
		if( hud.lastCoins == common.coins) then return end
		
		-- 
		-- Update the coins text
		--
		self.text = tostring(common.coins)

		--
		-- Track new coins
		--
		self.lastCoins = common.coins

	end; listen( "enterFrame", hud )

	--
	-- Attach a finalize event to the hud so it cleans it self up
	-- when removed.
	--	
	hud.finalize = function( self )
		ignoreList( { "enterFrame" }, self )
	end; hud:addEventListener( "finalize" )


	return hud
end

return factory