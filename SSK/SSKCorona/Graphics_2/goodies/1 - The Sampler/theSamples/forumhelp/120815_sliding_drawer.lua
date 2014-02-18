-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
-- Interface Elements - Sliding Drawer
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

local trayWidth = 110

-- Fake Screen Parameters (used to create visually uniform demos)
local screenWidth  = displayWidth
local screenHeight = displayHeight
local screenLeft   = centerX - screenWidth/2
local screenRight  = centerX + screenWidth/2
local screenTop    = centerY - screenHeight/2
local screenBot    = centerY + screenHeight/2

-- Local Function & Callback Declarations
local createCollisionCalculator
local createLayers
local addInterfaceElements

local onDrawerButton

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
	-- Create drawer
	local trayImage  = display.newImageRect( layers.theDrawer, imagesDir .. "felt.png", trayWidth, screenHeight) 
	trayImage.alpha = 0.3
	trayImage.x = screenLeft + trayWidth/2
	trayImage.y = centerY

	tmpButton = ssk.buttons:presetPush( layers.theDrawer, "blueGradient", screenLeft+100, centerY, 20, screenHeight, "", onDrawerButton )
	tmpButton.alpha = 0.25

	tmpButton = ssk.buttons:presetPush( layers.theDrawer, "yellowGradient", trayImage.x-10, 50, 60, 60, "A", nil, {fontSize = 36 } )
	tmpButton = ssk.buttons:presetPush( layers.theDrawer, "orangeGradient", trayImage.x-10, 120, 60, 60, "B", nil, {fontSize = 36 } )
	tmpButton = ssk.buttons:presetPush( layers.theDrawer, "redGradient", trayImage.x-10, 190, 60, 60, "C", nil, {fontSize = 36 } )

	--transition.to( layers.theDrawer, {x = -90 - unusedWidth/2, time = 200} )
	--layers.theDrawer.isOpen = false

	transition.to( layers.theDrawer, {x = layers.theDrawer.x - trayWidth + 20, time = 200} )
	layers.theDrawer.isOpen = false
end

-- =======================
-- ====================== Cleanup
-- =======================
function gameLogic:destroyScene( screenGroup )
	-- 1. Clear all references to objects we (may have) created in 'createScene()'	
	layers:destroy()
	layers = nil
	myCC = nil
	thePlayer = nil

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
		"theDrawer", 
		"content",
		"interfaces" )
end

addInterfaceElements = function()
	-- Add background 
	backImage = ssk.display.backImage( layers.background, "starBack_380_570.png") 
end	

onDrawerButton = function ( event )	
	if(layers.theDrawer.isOpen) then
		transition.to( layers.theDrawer, {x =  layers.theDrawer.x - trayWidth + 20, time = 200} )
		layers.theDrawer.isOpen = false
	else
		transition.to( layers.theDrawer, {x =  layers.theDrawer.x + trayWidth - 20, time = 200} )
		layers.theDrawer.isOpen = true
	end
	return true
end


return gameLogic