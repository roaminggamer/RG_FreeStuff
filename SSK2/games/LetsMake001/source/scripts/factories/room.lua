-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Hallway Segment Factory
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
local initialized 	= false

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
	params = params or {}
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
	local layers = params.layers

	local border = {}

	-- Gradient back (for multiply of tiles)
	-- https://roaminggamer.github.io/RGDocs/pages/SSK2/libraries/display_standard/
	newImageRect( layers.ground, centerX, centerY, "images/backmult.png",
	              { w = 1280, h = 1280 }  )

	-- Randomly colored grid of 'dirt' cells
	--
	local startX = centerX - common.cols/2 * common.cellSize + common.cellSize/2
	local startY = centerY - common.rows/2 * common.cellSize + common.cellSize
	local curX = startX
	local curY = startY
	for i = 1, common.rows do
		for j = 1, common.cols do
				newImageRect( layers.ground, curX, curY, "images/dirt.png", 
					{ blendMode = "multiply", size = common.cellSize,
					  fill =  ssk.colors.pastelRGB( hexcolor("FFDEAD") ) } )

			if( i == 1 or j == 1 or i == common.rows or j == common.cols ) then
				local tmp = newImageRect( layers.ground, curX, curY, 
					           (mRand(1,2) == 1) and "images/treeLarge.png" or "images/treeSmall.png",
					           { blendMode = "multiply", size = common.cellSize,
					             rotation = mRand(0,360) },
					           { bodyType = "static", radius = common.cellSize/4,
					             calculator = myCC, colliderName = "wall", isSensor = true  } )
				border[tmp] = tmp
			end
			curX = curX + common.cellSize
		end
		curX = startX
		curY = curY + common.cellSize
	end
	newRect( layers.ground, centerX, centerY + common.cellSize/2, 
	              { w = common.cellSize * common.cols, h = common.cellSize * common.rows, 
	                fill = _T_, stroke = _K_, strokeWidth = 8 }  )
	newRect( layers.ground, centerX, centerY + common.cellSize/2, 
	              { w = common.cellSize * common.cols, h = common.cellSize * common.rows, 
	                fill = _T_, stroke = _R_, alpha = 0.25, strokeWidth = 2 }  )


	return border
end

return factory