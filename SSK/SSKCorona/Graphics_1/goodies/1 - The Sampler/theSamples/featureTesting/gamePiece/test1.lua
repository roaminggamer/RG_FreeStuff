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

	local function onBegan ( self, event )
		print( self, "onBegan" )
		local base = self.base
		if(base) then
			base:setFillColor( 0, 0, 255, 255 )			
		end
	end

	local function onMoved ( self, event )
		print( self, "onMoved" )
		local base = self.base
		if(base) then
			base:setFillColor( 0, 255, 0, 255 )
		end
	end

	local function onEnded ( self, event )
		print( self, "onEnded" )
		local base = self.base
		if(base) then
			base:setFillColor( 255, 255, 255, 255 )
		end
	end

	local imagePaths = {}
	imagePaths[1]  = imagesDir .. "pBoy.png"
	imagePaths[2]  = imagesDir .. "pGirl.png"
	imagePaths[3]  = imagesDir .. "pHeart.png"
	imagePaths[4]  = imagesDir .. "pStar.png"

	local sheetData = { 
		width = 80,   --the width of each frame
		height = 90,  --the height of each frame
		numFrames = 4, --the total number of frames on the sheet
	}

	local mySheet = graphics.newImageSheet( imagesDir .. "lostgarden.png", sheetData )

	local mysequenceData = {
		{ 
			name = "all", start = 1, count = 4, time = 4000,  loopCount = 0, loopDirection = "forward"
		}, 
	}

	local params = 	{
		w = 80, 
		h = 90,
		y = 200,
		onBegan = onBegan,
		onMoved = onMoved,
		onEnded = onEnded,
		dragEnabled = true,
		baseEn = false,
		imagePaths = imagePaths,
		spriteSheet = mySheet,
		sequenceData = mysequenceData,
		maskImage = imagesDir .. "circlemask.png",
		maskWidth = 128,
		maskHeight = 128,
		--maskScaleX = 80/128 - 0.1,
		--maskScaleY = 90/128 - 0.1,
	}
	local aPiece
	aPiece = ssk.gamepiece:new( layers.interfaces, centerX-80, centerY, params )
	aPiece.sprite.isVisible = true
	aPiece.sprite:play()

	aPiece = ssk.gamepiece:new( layers.interfaces, centerX, centerY, params )
	aPiece.images[1].isVisible = true
	aPiece = ssk.gamepiece:new( layers.interfaces, centerX+80, centerY, params )
	aPiece.sprite.isVisible = true
	aPiece.sprite:setFrame(2)

	--aPiece:setBaseAlpha(0.25)
	--aPiece:showImage(1)
	--aPiece:setImageAlpha(2, 0.5)

	--print(centerX, centerY)
	--table.dump(aPiece)

	--print(aPiece:getImageCount())


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



return gameLogic