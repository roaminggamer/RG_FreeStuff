-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
-- Left-Right Automatic Background Scroll
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
local overlayImage 
local backImage
local thePlayer

local moveVelocity = 4
local lastTimer = -1


-- Fake Screen Parameters (used to create visually uniform demos)
local screenWidth  = 320 -- smaller than actual to allow for overlay/frame
local screenHeight = 240 -- smaller than actual to allow for overlay/frame
local screenLeft   = centerX - screenWidth/2
local screenRight  = centerX + screenWidth/2
local screenTop    = centerY - screenHeight/2
local screenBot    = centerY + screenHeight/2

-- Local Function & Callback Declarations
local createCollisionCalculator
local createLayers
local addInterfaceElements

local onShowHide

local moveRight
local startRight
local endMove

local moveLeft
local startLeft

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
	-- Create sky
	local sky  = ssk.display.imageRect( layers.background, centerX, centerY, imagesDir .. "starBack_320_240.png",
		{ w = 320, h = 240, myName = "theSky" } )

	-- Create Ground blocks
	local width = screenWidth/ 10
	for i = -20, 20 do
		local tmpBlock
		local tmpBlock = ssk.display.rect( layers.scroller, screenLeft - width/2 + i * width, screenBot-10,
			{ w = width, h = 20, fill = _GREEN_, stroke = _WHITE_, strokeWidth = 2, size = size, } ) 
		--tmpBlock.alpha = 0.75 
		tmpBlock:toFront()
	end

	-- create Player
	local playerSize = 30
	thePlayer = ssk.display.rect( layers.content, centerX, screenBot-20-playerSize/2-2, 
		{ size = playerSize, myName = "thePlayer", fill = _BLUE_, stroke = _WHITE_, strokeWidth = 2, } ) 

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
		"scroller", 
		"content",
		"interfaces" )
end

addInterfaceElements = function()
	-- Add background and overlay
	backImage = ssk.display.backImage( layers.background, "protoBack.png") 
	overlayImage = ssk.display.backImage( layers.interfaces, "protoOverlay.png") 
	overlayImage.isVisible = true

	-- Add generic direction and input buttons
	local tmpButton
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "leftButton", screenLeft-30, screenBot-75, 42, 42, "", endMove, { onPress = startLeft } )
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "rightButton", screenLeft-30, screenBot-25, 42, 42, "", endMove, { onPress = startRight } )

	-- Add the show/hide button for 'unveiling' hidden parts of scene/mechanics
	ssk.buttons:presetPush( layers.interfaces, "blueGradient", 64, 20 , 120, 30, "Show Details", onShowHide )
end	


onShowHide = function ( event )
	local target = event.target
	if(event.target:getText() == "Hide Details") then
		overlayImage.isVisible = true
		event.target:setText( "Show Details" )
	else
		overlayImage.isVisible = false
		event.target:setText( "Hide Details" )
	end	
end

-- Movement/General Button Handlers
moveRight = function ( event )
	if(thePlayer.x <= screenRight - 50) then
		thePlayer.x = thePlayer.x + moveVelocity
	elseif(layers.scroller.x > -(1 * screenWidth)) then
		layers.scroller.x = layers.scroller.x - moveVelocity
	else
		print("Reached edge")
	end
end

startRight = function ( event )
	moveRight()
	lastTimer = timer.performWithDelay(16, moveRight,0)
end

endMove = function ( event )
	timer.cancel( lastTimer )
	lastTimer = -1
end

moveLeft = function ( event )
	if(thePlayer.x >= screenLeft + 50) then
		thePlayer.x = thePlayer.x - moveVelocity
	elseif(layers.scroller.x < (1 * screenWidth)) then
		layers.scroller.x = layers.scroller.x + moveVelocity
	else
		print("Reached edge")
	end
end

startLeft = function ( event )
	moveLeft()
	lastTimer = timer.performWithDelay(16, moveLeft,0)
end


return gameLogic