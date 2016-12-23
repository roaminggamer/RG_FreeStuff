-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Gate Factory
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

	local topPipe = newRect( group, x, y - common.gateHeight/2,
		{ w = common.gateWidth, h = fullh, anchorY = 1 },
		{ bodyType = "static", calculator = myCC, colliderName = "wall" }  )


	local botPipe = newRect( group, x, y + common.gateHeight/2,
		{ w = common.gateWidth, h = fullh, anchorY = 0 },
		{ bodyType = "static", calculator = myCC, colliderName = "wall" }  )

	local gate = newRect( group, x, y, 
		                   { w = common.gateWidth, h = common.gateHeight,
		                     alpha = params.debugEn and 0.5 or 0 },
		                   { bodyType = "static", isSensor = true,
		                     calculator = myCC, colliderName = "gate" }  )


	return gate
end

return factory