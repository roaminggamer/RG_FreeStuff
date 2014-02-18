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

local line1
local line2
local lineN = 1
local lineP = 0
local buildLine1
local buildLine2
local clearLines

local theMessage = {
	"SSKCorona - Weekly Update for",
	"the week of 23 NOV 2012",
	"I'm sorry to say, I have made",
	"few updates this week.",
	"I would like to blame the holiday.",
	"But... I've just been busy.",  
	"Busy making games, contracting,",
	"helping some folks, and eating turkey.",
	"I will get back on it this week.", 
	"So, please stay tuned, and...",
	"Please subscribe to",
	"www.youtube.com/RoamingGamer",
	"Awesome Cakes!",
	"www.youtube.com/RoamingGamer",
}

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


	local txt = "All your bases are belong to ..."

	print(txt, #txt)

	for i=1, #txt do
		print( i, string.sub( txt, i,i) ) 
	end


	timer.performWithDelay( 2000, buildLine1 )

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
		"scrollers", 
			{ "scroll3", "scroll2", "scroll1" },
		"content",
		"interfaces" )
end

buildLine1 = function()
	local curTxt = theMessage[lineN]

	if( lineP < #curTxt ) then
		lineP = lineP + 1
		line1:setText( string.sub( curTxt, 1,lineP) )
		timer.performWithDelay( 20, buildLine1 )
	else
		lineP = 0
		lineN = lineN + 1
		timer.performWithDelay( 200, buildLine2 )
	end

	return
end

buildLine2 = function()
	local curTxt = theMessage[lineN]

	if( lineP < #curTxt ) then
		lineP = lineP + 1
		line2:setText( string.sub( curTxt, 1,lineP) )
		timer.performWithDelay( 20, buildLine2 )
	else
		lineP = 0
		lineN = lineN + 1
		if(lineN < #theMessage) then
			timer.performWithDelay( 4000, clearLines )
		end
	end

	return
end

clearLines = function()
	line1:setText( "" )
	line2:setText( "" )
	buildLine1()
end




addInterfaceElements = function()
	-- Add background 
	line1 = ssk.labels:quickLabel( layers.content, "                                ", centerX, centerY- 20, "Consolas", 22 )
	line2 = ssk.labels:quickLabel( layers.content, "                                ", centerX, centerY+ 20, "Consolas", 22 )

end	

createPlayer = function ( x, y, size )
	local player  = ssk.display.imageRect( layers.content, x, y,imagesDir .. "DaveToulouse_ships/drone3.png",
		{ size = size, myName = "thePlayer" },
		{ isFixedRotation = false,  colliderName = "player", calculator= myCC } ) 
	return player
end

createSky = function ( x, y, width, height  )
	local sky  = ssk.display.imageRect( layers.background, x, y, imagesDir .. "starBack_320_240.png",
		{ w = width, h = height, myName = "theSky" } )
	return sky
end


return gameLogic