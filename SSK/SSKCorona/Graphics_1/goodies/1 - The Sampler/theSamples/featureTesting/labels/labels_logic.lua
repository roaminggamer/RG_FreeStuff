-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
-- Labels Validation
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
-- 
-- =============================================================

--local debugLevel = 1 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugPrinter.newPrinter( debugLevel )
local dprint = dp.print

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------

-- Variables
local myCC   -- Local reference to collisions Calculator
local layers -- Local reference to display layers 
local backImage

-- Fake Screen Parameters (used to create visually uniform demos)
local screenWidth  = w
local screenHeight = h
local screenLeft   = centerX - screenWidth/2
local screenRight  = centerX + screenWidth/2
local screenTop    = centerY - screenHeight/2
local screenBot    = centerY + screenHeight/2

-- Local Function & Callback Declarations
local createCollisionCalculator
local createLayers
local addInterfaceElements

local createLabels


local gameLogic = {}

-- =======================
-- ====================== Initialization
-- =======================
function gameLogic:createScene( screenGroup )

	-- 1. Create collisions calculator and set up collision matrix
	createCollisionCalculator()

	-- 2. Set up any rendering layers we need
	createLayers( screenGroup )

	-- 3. Add Interface Elements to this demo (buttons, etc.)
	addInterfaceElements()

	-- 4. Set up gravity and physics debug (if wanted)
	physics.setGravity(0,0)
	--physics.setDrawMode( "hybrid" )
	screenGroup.isVisible=true
	
	-- 5. Add demo/sample content
	createLabels( )
end

-- =======================
-- ====================== Cleanup
-- =======================
function gameLogic:destroyScene( screenGroup )
	-- 1. Clear all references to objects we (may have) created in 'createScene()'	
	layers:destroy()
	layers = nil
	myCC = nil

	-- 2. Clean up gravity and physics debug
	physics.setDrawMode( "normal" )
	physics.setGravity(0,0)
	screenGroup.isVisible=false

--	ssk.gem:remove("myHorizSnapEvent", joystickListener)
end


-- =======================
-- ====================== Local Function & Callback Definitions
-- =======================
createCollisionCalculator = function()
	myCC = ssk.ccmgr:newCalculator()
	myCC:addName("player")
	myCC:addName("wrapTrigger")
	myCC:collidesWith("player", "wrapTrigger")
	myCC:dump()
end


createLayers = function( group )
	layers = ssk.display.quickLayers( group, 
		"background", 
		"content",
		"interfaces" )
end

addInterfaceElements = function()
	-- Add background 
	backImage = ssk.display.backImage( layers.background, "backImage2.jpg")
end	

createLabels = function ( )
	local tmpLabel

	local yOffset = 20

	tmpLabel = ssk.labels:presetLabel( layers.content, "default", "preset label", centerX, yOffset + 20 )

	tmpLabel = ssk.labels:presetLabel( layers.content, "default", "preset label - default + mods #1", centerX, yOffset + 45, 
									   { fontSize = 32, textColor = _ORANGE_ } )

	tmpLabel = ssk.labels:presetLabel( layers.content, "default", "preset label - default + mods #2", centerX, yOffset + 90, 
									   { font = gameFont, fontSize = 28, emboss = true,
									     embossShadowColor = _RED_,  embossTextColor = _BLUE_, embossHighlightColor = _WHITE_, } )


	tmpLabel = ssk.labels:quickLabel( layers.content, "quick label #1", centerX, yOffset + 135 )
	tmpLabel = ssk.labels:quickLabel( layers.content, "quick label #2 ( width:000  height:00 )", centerX, yOffset + 170, gameFont, 20, _BRIGHTORANGE_ )
	tmpLabel:setText( "quick label #2" .. " ( width: " .. tmpLabel.width .. "  height: " .. tmpLabel.height .. " )")

	tmpLabel = ssk.labels:quickEmbossedLabel( layers.content, "quick embossed label #1", centerX, yOffset + 215, nil, nil, _PINK_ )
	tmpLabel = ssk.labels:quickEmbossedLabel( layers.content, "quick embossed label #2", centerX, yOffset + 250, gameFont, 40 )


	tmpLabel = nil
end

return gameLogic