-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
-- Push Button Validation
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
local createLayers
local addInterfaceElements

local createButtons

local gameLogic = {}


-- =======================
-- ====================== Initialization
-- =======================
function gameLogic:createScene( screenGroup )

	-- 1. Set up any rendering layers we need
	createLayers( screenGroup )

	-- 2. Add Interface Elements to this demo (buttons, etc.)
	addInterfaceElements()

	-- 3. Set up gravity and physics debug (if wanted)
	physics.setGravity(0,0)
	--physics.setDrawMode( "hybrid" )
	screenGroup.isVisible=true
	
	-- 4. Add demo/sample content
	createButtons()


end

-- =======================
-- ====================== Cleanup
-- =======================
function gameLogic:destroyScene( screenGroup )
	-- 1. Clear all references to objects we (may have) created in 'createScene()'	
	layers:destroy()
	layers = nil

	-- 2. Clean up gravity and physics debug
	physics.setDrawMode( "normal" )
	physics.setGravity(0,0)
	screenGroup.isVisible=false

--	ssk.gem:remove("myHorizSnapEvent", joystickListener)
end


-- =======================
-- ====================== Local Function & Callback Definitions
-- =======================
createLayers = function( group )
	layers = ssk.display.quickLayers( group, 
		"background", 
		"scrollers", 
			{ "scroll3", "scroll2", "scroll1" },
		"content",
		"interfaces" )
end

addInterfaceElements = function()
	-- Add background 
	backImage = ssk.display.backImage( layers.background, "backImage.jpg")
end	

createButtons = function ( )

	local tmpButton
	local buttonWidth = 200
	local buttonHeight = 40
	
	local buttonX
	local buttonY

	local function pbCB( event )
		local target = event.target
		local phase  = event.phase
		local myText = target:getText()

		print(myText .. " ==> " .. phase)
	end

	local presetNames = { "default", "blueGradient", "blueGreenGradient",
	 "greenGradient", "redGradient", "orangeGradient", "yellowGradient", "whiteGradient" }

	-- Push Button Test
	local row = 0
	for i = 0, #presetNames-1 do
		local presetNum = i+1
		if( i % 2 == 0 ) then
			row = row + 1
		end

		buttonX = centerX - buttonWidth / 2 + 10 + (i % 2) * buttonWidth  + (i % 2) * 8 - 4
		buttonY = buttonHeight / 2 + 10 + row * buttonHeight + row * 4
		tmpButton = ssk.buttons:presetPush( layers.content, presetNames[presetNum], buttonX, buttonY, buttonWidth, buttonHeight, 
		   presetNames[presetNum], pbCB )	
	end

	-- SP/MP Button
	buttonX = centerX - 40
	buttonY = screenBot - 50
	tmpButton = ssk.buttons:presetPush( layers.content, "mpButton", buttonX, buttonY, 50, 50, "", pbCB )	

	-- Options
	buttonX = centerX + 40
	buttonY = screenBot - 50
	tmpButton = ssk.buttons:presetPush( layers.content, "optionsButton", buttonX, buttonY, 50, 50, "", pbCB )	

end

return gameLogic