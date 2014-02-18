-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
-- Template #2
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
local thePlayer

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

local createVibroids

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
	thePlayer = createVibroids( layers.content, centerX, centerY )


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

createVibroids = function ( parentGroup, x, y )
	local parentGroup = parentGroup or display.getCurrentStage()

	local vibrateGroup = display.newGroup()

	parentGroup:insert(vibrateGroup)

	local vibrate1
	local vibrate2

	vibrate1 = function( obj )
		if not (obj and type(obj.removeSelf) == "function") then
			return
		end

		transition.to( obj, { xScale = obj.amplitude, yScale = obj.amplitude, time = 1000/obj.frequency, onComplete=vibrate2 } )
	end

	vibrate2 = function( obj )
		if not (obj and type(obj.removeSelf) == "function") then
			return
		end

		transition.to( obj, {xScale = 1/obj.amplitude, yScale = 1/obj.amplitude, time = 1000/obj.frequency, onComplete=vibrate1 } )
	end

	local block = display.newRect(vibrateGroup, 0, 0, 50, 50 )
	block.amplitude = 1.25
	block.frequency = 2
	vibrate1(block)

	block = display.newRect(vibrateGroup, 150, 0, 50, 50 )
	block.amplitude = 2
	block.frequency = 1
	vibrate1(block)

	block = display.newRect(vibrateGroup, 300, 0, 50, 50 )
	block.amplitude = 2
	block.frequency = 10
	vibrate1(block)

--EFM G2	vibrateGroup:setReferencePoint(display.CenterReferencePoint)
	vibrateGroup.x,vibrateGroup.y = x,y

	return vibrateGroup	

end

createSky = function ( x, y, width, height  )
	local sky  = ssk.display.imageRect( layers.background, x, y, imagesDir .. "starBack_320_240.png",
		{ w = width, h = height, myName = "theSky" } )
	return sky
end


return gameLogic