-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
-- Template #1
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


local dogClass =  require("theSamples.experiments.classes.aClass")
local dogClass2 =  require("theSamples.experiments.classes.aClass2")
local dogClass3 =  require("theSamples.experiments.classes.aClass3")
local storyboard = require( "storyboard" )
----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------

-- Variables
local myCC   -- Local reference to collisions Calculator
local layers -- Local reference to display layers 
local overlayImage 
local backImage
local thePlayer

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

local onUp
local onDown
local onRight
local onLeft
local onA
local onB

local testClassSizes

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
	--addInterfaceElements()

	-- 4. Set up gravity and physics debug (if wanted)
	physics.setGravity(0,0)
	--physics.setDrawMode( "hybrid" )
	screenGroup.isVisible=true
	
	-- 5. Add demo/sample content
	testClassSizes()
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
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "upButton", screenLeft-30, screenBot-175, 42, 42, "", onUp )
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "downButton",  screenLeft-30, screenBot-125, 42, 42, "", onDown )
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "leftButton", screenLeft-30, screenBot-75, 42, 42, "", onLeft )
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "rightButton", screenLeft-30, screenBot-25, 42, 42, "", onRight )
	-- Universal Buttons
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "A_Button", screenRight+30, screenBot-75, 42, 42, "", onA )
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "B_Button", screenRight+30, screenBot-25, 42, 42, "", onB )

	-- Add the show/hide button for 'unveiling' hidden parts of scene/mechanics
	ssk.buttons:presetPush( layers.interfaces, "blueGradient", 64, 20 , 120, 30, "Show Details", onShowHide )
end	

createPlayer = function ( x, y, size )
	local player  = ssk.display.imageRect( layers.content, x, y,imagesDir .. "DaveToulouse_ships/drone2.png",
		{ size = size, myName = "thePlayer" },
		{ isFixedRotation = false,  colliderName = "player", calculator= myCC } ) 
	return player
end

createSky = function ( x, y, width, height  )
	local sky  = ssk.display.imageRect( layers.background, x, y, imagesDir .. "starBack_320_240.png",
		{ w = width, h = height, myName = "theSky" } )
	return sky
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
onUp = function ( event )
end

onDown = function ( event )
end

onRight = function ( event )
end

onLeft = function ( event )
end

onA = function ( event )
end

onB = function ( event )	
end

testClassSizes = function()
	local last
	local start
	local cur
	local cost1
	local cost2
	local cost3
	
	--EFM second (false) data collection method method is more accurate, no?

	if(false) then

		collectgarbage("stop")
		collectgarbage("collect")			
		start = collectgarbage("count")
		print("Start: ", start)
	
		local dogPile = {}

		-- ============= CLASS 1 (OOP)
		for i = 1, 100000 do
			dogPile[i]  = dogClass:new( "Rover", 1)
		end
		--storyboard.printMemUsage()
		cost1 = collectgarbage("count")
		dogPile = {}
		collectgarbage("collect")
		--storyboard.printMemUsage()

		-- ============= CLASS 2 (NON-OOP)
		for i = 1, 100000 do
			dogPile[i]  = dogClass2:new( "Rover", 1)
		end
		--storyboard.printMemUsage()
		cost2 = collectgarbage("count")
		dogPile = {}
		collectgarbage("collect")
		--storyboard.printMemUsage()

		-- ============= CLASS 3 (NON-OOP ALTERNATIVE)
		for i = 1, 100000 do
			dogPile[i]  = dogClass3:new( "Rover", 1)
		end
		--storyboard.printMemUsage()
		cost3 = collectgarbage("count")
		dogPile = {}
		collectgarbage("collect")
		--storyboard.printMemUsage()

		collectgarbage("restart")

	else
		collectgarbage("stop")
		collectgarbage("collect")
		last = collectgarbage("count")
		start = last
		print("Start: ", start)
	
		local dogPile = {}

		-- ============= CLASS 1 (OOP)
		for i = 1, 100000 do
			dogPile[i]  = dogClass:new( "Rover", 1)
		end
		--storyboard.printMemUsage()
		cur = collectgarbage("count")
		cost1 = cur - last
		last = cur
		--storyboard.printMemUsage()

		-- ============= CLASS 2 (NON-OOP)
		for i = 1, 100000 do
			dogPile[i]  = dogClass2:new( "Rover", 1)
		end
		--storyboard.printMemUsage()
		cur = collectgarbage("count")
		cost2 = cur - last
		last = cur
		--storyboard.printMemUsage()


		-- ============= CLASS 3 (NON-OOP ALTERNATIVE)
		for i = 1, 100000 do
			dogPile[i]  = dogClass3:new( "Rover", 1)
		end
		--storyboard.printMemUsage()
		cur = collectgarbage("count")
		cost3 = cur - last
		last = cur
		--storyboard.printMemUsage()

		collectgarbage("restart")
	end

	print("          OOP Cost: ", round(cost1/1024, 1) .. " MB")
	print("      NON-OOP Cost: ", round(cost2/1024, 1) .. " MB", "(" .. round(cost2/cost1, 1) .. "x)" )
	print("NON-OOP (Alt) Cost: ", round(cost3/1024, 1) .. " MB", "(" .. round(cost3/cost1, 1) .. "x)" )
end

return gameLogic