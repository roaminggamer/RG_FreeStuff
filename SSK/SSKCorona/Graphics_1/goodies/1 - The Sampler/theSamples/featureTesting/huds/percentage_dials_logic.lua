-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
-- Interface Elements - Numeric HUDs
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

local gameLogic = {}

local doDial

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
	local theHUD
	
	local theHUD = ssk.huds:createPercentageDial( layers.interfaces, centerX - 150, centerY )
	--theHUD:setPercent(35)

	local theHUD1 = ssk.huds:createPercentageDial( layers.interfaces, centerX,  centerY - 75,
		{ dialSrc = _RED_, backSrc = _GREEN_ , size = 100, textSize = 20, textColor = _GREY_ })

	local theHUD2 = ssk.huds:createPercentageDial( layers.interfaces, centerX + 150, centerY - 75, 
		{ dialSrc = _RED_, backSrc =  _GREEN_ , size = 100, textSize = 18, overlayPath = imagesDir .. "interface/huds/dialOverlay1.png", textPrefix = "Energy: ", textSuffix = ""})

	local theHUD3 = ssk.huds:createPercentageDial( layers.interfaces, centerX, centerY + 75, 
		{ dialSrc = _YELLOW_, backSrc =  _BLUE_ , size = 100, text=false, 
		maskPath = imagesDir .. "interface/huds/dialMask2.png", overlayPath = imagesDir .. "interface/huds/dialOverlay2.png"})

	local theHUD4 = ssk.huds:createPercentageDial( layers.interfaces, centerX + 150, centerY + 75, 
		{ dialSrc = _WHITE_, backSrc =  _BRIGHTORANGE_ , size = 100, text=false,
		maskPath = imagesDir .. "interface/huds/dialMask3.png", overlayPath = imagesDir .. "interface/huds/dialOverlay3.png"})


	local dir = "up"

	local function updateIt()
		local percent = tonumber(theHUD:getPercent())

		if( dir == "up" ) then
			percent = percent + 1

		else
			percent = percent - 1
		end

		if( percent > 100 ) then
			dir = "down"
			percent = 99

		elseif( percent < 0 ) then
			dir = "up"
			percent = 0
		end


		theHUD:setPercent( percent )
		theHUD1:setPercent( percent )
		theHUD2:setPercent( 100-percent )
		theHUD3:setPercent( 100-percent )
		theHUD4:setPercent( percent )

	end

	timer.performWithDelay(33, updateIt, 0 )

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
		"content",
		"interfaces" )
end

addInterfaceElements = function()
	-- Add background 
	backImage = ssk.display.backImage( layers.background, "starBack_380_570.png") 
end	

return gameLogic