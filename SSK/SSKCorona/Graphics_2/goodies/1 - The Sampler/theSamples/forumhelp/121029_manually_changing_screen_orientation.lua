-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
-- Movement - Step without Repeat
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
local wrapTrigger


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

local createTrigger
local triggerCallback

local onShowHide

local onUp
local onDown
local onRight
local onLeft

local onStopX
local onStopY

local onA
local onB

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
	--createSky(centerX, centerY, 320, 240, layers.background)
	createSky(centerX, centerY, w, h, layers.background)

	local shipSize = 25
	thePlayer = createPlayer( centerX, centerY, shipSize, layers.content )

	wrapTrigger = createTrigger( layers.content, centerX, centerY,  
		screenWidth + 1.0 * shipSize, screenHeight + 1.0 * shipSize, 
		"theWrapTrigger"  )
	wrapTrigger.isVisible = false
	

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
		"rotator", 
			{ "content" },		
		"interfaces" )
end

addInterfaceElements = function()
	-- Add background and overlay
	--backImage = ssk.display.backImage( layers.background, "protoBack.png") 
	--overlayImage = ssk.display.backImage( layers.interfaces, "protoOverlay.png") 
	--overlayImage.isVisible = true

	-- Add generic direction and input buttons
	local tmpButton
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "upButton", screenLeft-30, screenBot-175, 42, 42, "", onStop, {onPress=onUp} )
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "downButton",  screenLeft-30, screenBot-125, 42, 42, "", onStop, {onPress=onDown} )
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "leftButton", screenLeft-30, screenBot-75, 42, 42, "", onStop, {onPress=onLeft} )
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "rightButton", screenLeft-30, screenBot-25, 42, 42, "", onStop, {onPress=onRight} )
	-- Universal Button
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "A_Button", screenRight+30, screenBot-75, 42, 42, "",  onA )
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "B_Button", screenRight+30, screenBot-25, 42, 42, "",  onB )

	-- Add the show/hide button for 'unveiling' hidden parts of scene/mechanics
	ssk.buttons:presetPush( layers.interfaces, "blueGradient", 64, 20 , 120, 30, "Show Details", onShowHide )
end	

createPlayer = function ( x, y, size )
	local player  = ssk.display.imageRect( layers.content, x, y,imagesDir .. "DaveToulouse_ships/drone2.png",
		{ size = size, myName = "thePlayer" },
		{ isFixedRotation = false,  colliderName = "player", calculator= myCC } ) 

	function player:stepX( val )
		player.x = player.x + (player.width * val)
	end

	function player:stepY( val )
		player.y = player.y + (player.height * val)
	end

	return player
end

createSky = function ( x, y, width, height  )
	local sky  = ssk.display.imageRect( layers.content, x, y, imagesDir .. "starBack_320_240.png",
		{ w = width, h = height, myName = "theSky" } )
	return sky
end

createTrigger = function ( contentLayer, x, y, width, height, myName  )
	local fill = _GREEN_

	local aTrigger  = ssk.display.rect( contentLayer, x, y,
		{ fill = fill, width = width, height = height, myName = myName },
		{ isSensor=true, colliderName = "wrapTrigger", calculator= myCC  }, 
		{ 
			{"onCollisionEnded_ExecuteCallback", { callback = triggerCallback } },
		} )

	aTrigger.alpha = 0.25
	return aTrigger
end

triggerCallback = function( theTrigger, theCollider, event )
	local triggerName  = theTrigger.myName or "trigger"
	local colliderName = theCollider.myName or "collider"

	dprint(2, triggerName,colliderName)
	dprint(2, colliderName .. " exited wrapTrigger @ < " .. theCollider.x .. " , " .. theCollider.y .. " >" )
	
	local myclosure = function() ssk.component.calculateWrapPoint( theCollider, theTrigger ) end			
	timer.performWithDelay( 1, myclosure) 
end




onShowHide = function ( event )
	local target = event.target
	if(event.target:getText() == "Hide Details") then
		overlayImage.isVisible = true
		wrapTrigger.isVisible = false
		event.target:setText( "Show Details" )
	else
		overlayImage.isVisible = false
		wrapTrigger.isVisible = true
		event.target:setText( "Hide Details" )
	end	
end


-- Movement/General Button Handlers
onUp = function ( event )
	thePlayer:stepY(-1)
end

onDown = function ( event )
	thePlayer:stepY(1)
end

onRight = function ( event )
	thePlayer:stepX(1)
end

onLeft = function ( event )
	thePlayer:stepX(-1)
end

onStopX = function ( event )
	thePlayer:stepX(0)
end

onStopY = function ( event )
	thePlayer:stepY(0)
end



onA = function ( event )
	if(layers.rotator.rotation == 0 ) then
--EFM G2		layers.rotator:setReferencePoint( display.CenterReferencePoint )
		transition.to( layers.rotator, {rotation=90, time = 500} )

	else
--EFM G2		layers.rotator:setReferencePoint( display.CenterReferencePoint )
		transition.to( layers.rotator, {rotation=0, time = 500} )
	end
end

onB = function ( event )	
	thePlayer.x = centerX
	thePlayer.y = centerY
end



return gameLogic