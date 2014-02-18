-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
-- Zela-like Page Scrolling
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
local swipeVelocity = moveVelocity * 2
local lastTimer = -1
local swiping = false


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

local createPlayer
local createSky

local onShowHide

local startRight
local moveRight
local startLeft
local moveLeft
local startUp
local moveUp
local startDown
local moveDown
local endMove
local swipeRight
local swipeLeft
local swipeUp
local swipeDown
local delayedSwipeEnd
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
	-- Create Ground blocks
	local width = screenWidth/ 10
	local size = 80
	for i = -24, 24 do
		for j = -18, 18 do
		
			local tmpBlock
			local tmpBlock = ssk.display.imageRect( layers.scroller, 
			   screenLeft - size/2 + i * size, screenTop-size/2 + j * size,
			   imagesDir .. "mudground.png", 
				{ size = size, myName = "aGroundBlock", } ) 
			--tmpBlock.alpha = 0.75 
			tmpBlock:toFront()
		end
	end

	-- create Player
	local playerSize = 36
	thePlayer  = ssk.display.imageRect( layers.content, 
	    centerX, centerY, 
		imagesDir .. "joker.png",
		{ size = playerSize, myName = "thePlayer" } ) 
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
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "upButton", screenLeft-30, screenBot-175, 42, 42, "", endMove, { onPress = startUp } )
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "downButton",  screenLeft-30, screenBot-125, 42, 42, "", endMove, { onPress = startDown } )
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
startRight = function ( event )
	if(swiping) then
		return true
	end

	moveRight()
	lastTimer = timer.performWithDelay(16, moveRight,0)

	return true
end

moveRight = function ( event )
	if(swiping) then
		return true
	end

	if(thePlayer.x <= screenRight - 20) then
		thePlayer.x = thePlayer.x + moveVelocity
	elseif(layers.scroller.x > -(4 * screenWidth)) then
		swiping = true
		swipeLeft()
	else
		print("Reached edge")
	end
end


startLeft = function ( event )
	if(swiping) then
		return true
	end

	moveLeft()
	lastTimer = timer.performWithDelay(16, moveLeft,0)

	return true
end

moveLeft = function ( event )
	if(swiping) then
		return true
	end

	if(thePlayer.x >= screenLeft + 20) then
		thePlayer.x = thePlayer.x - moveVelocity
	elseif(layers.scroller.x < (4 * screenWidth)) then
		swiping = true
		swipeRight()
	else
		print("Reached edge")
	end
end


startUp = function ( event )
	if(swiping) then
		return true
	end

	moveUp()
	lastTimer = timer.performWithDelay(16, moveUp,0)

	return true
end

moveUp = function ( event )
	if(swiping) then
		return true
	end

	if(thePlayer.y >= screenTop + 20) then
		thePlayer.y = thePlayer.y - moveVelocity
	elseif(layers.scroller.y < (4 * screenHeight)) then
		swiping = true
		swipeDown()
	else
		print("Reached edge")
	end
end

startDown = function ( event )
	if(swiping) then
		return true
	end

	moveDown()
	lastTimer = timer.performWithDelay(16, moveDown,0)

	return true
end

moveDown = function ( event )
	if(swiping) then
		return true
	end

	if(thePlayer.y <= screenBot - 20) then
		thePlayer.y = thePlayer.y + moveVelocity
	elseif(layers.scroller.y > -(4 * screenHeight)) then
		swiping = true
		swipeUp()
	else
		print("Reached edge")
	end
end


endMove = function ( event )
	if(lastTimer ~= -1) then
		timer.cancel( lastTimer )
		lastTimer = -1
	end
end

swipeRight = function()
	if(thePlayer.x <= screenRight - 20) then
		thePlayer.x = thePlayer.x + swipeVelocity
		layers.scroller.x = layers.scroller.x + swipeVelocity
		timer.performWithDelay(16, swipeRight)
	else
		timer.performWithDelay(500, delayedSwipeEnd)
	end
end

swipeLeft = function()
	if(thePlayer.x >= screenLeft + 20) then
		thePlayer.x = thePlayer.x - swipeVelocity
		layers.scroller.x = layers.scroller.x - swipeVelocity
		timer.performWithDelay(16, swipeLeft)
	else
		timer.performWithDelay(500, delayedSwipeEnd)
	end
end

swipeUp = function()
	if(thePlayer.y >= screenTop + 20) then
		thePlayer.y = thePlayer.y - swipeVelocity
		layers.scroller.y = layers.scroller.y - swipeVelocity
		timer.performWithDelay(16, swipeUp)
	else
		timer.performWithDelay(500, delayedSwipeEnd)
	end
end

swipeDown = function()
	if(thePlayer.y <= screenBot - 20) then
		thePlayer.y = thePlayer.y + swipeVelocity
		layers.scroller.y = layers.scroller.y + swipeVelocity
		timer.performWithDelay(16, swipeDown)
	else
		timer.performWithDelay(250, delayedSwipeEnd)
	end
end

delayedSwipeEnd = function()
	swiping = false
end

return gameLogic