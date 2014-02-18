-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
-- Standard Buttons and Sliders Callbacks Validation
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
	local curX
	local curY

	local yOffset = 30

	-- ==
	--    Table Roller Test (Push button that cylces text values from a table)
	-- ==
	local function printButtonText( event )
		local target = event.target
		local phase  = event.phase
		local myText = target:getText()

		print(myText .. " ==> " .. phase)
	end

	local rollerTable = { "Roaming", "Gamer", "SSK", "Rocks" }

	curX = centerX
	curY = yOffset + 1 * buttonHeight + buttonHeight/2 + 1 * 10

	tmpButton = ssk.buttons:presetPush( layers.content, "blueGradient", curX, curY, buttonWidth, buttonHeight, 
		rollerTable[1], ssk.sbc.tableRoller_CB, { fontSize = 24, textOffset = {0,1} } )	
	
	ssk.sbc.prep_tableRoller( tmpButton, rollerTable, printButtonText ) 

	-- ==
	--    Table 2 Table Roller Test (Same as Table Roller but value is stored to named setting in a table)
	-- ==
	local settingsTable = {}
	settingsTable.difficulty  = "EASY"
	settingsTable.multiPlayer = false
	settingsTable.volume      = 0.8

	local difficultyValues = { "EASY", "MEDIUM", "HARD", "INSANE" }

	local function dumpSettings()
		table.dump( settingsTable )
	end

	curX = centerX
	curY = yOffset + 2 * buttonHeight + buttonHeight/2 + 2 * 10

	tmpButton = ssk.buttons:presetPush( layers.content, "whiteGradient", curX, curY, buttonWidth, buttonHeight, 
		settingsTable.difficulty, ssk.sbc.table2TableRoller_CB, { fontSize = 24, textOffset = {0,1} } )	
	
	ssk.sbc.prep_table2TableRoller( tmpButton, settingsTable, "difficulty", difficultyValues, dumpSettings ) 

	-- ==
	--    Table Toggler Test (Toggle value stored to named setting in a table)
	-- ==
	curX = centerX
	curY = yOffset + 3 * buttonHeight + buttonHeight/2 + 3 * 10

	tmpButton = ssk.buttons:presetToggle( layers.content, "mpButton", curX, curY, buttonHeight, buttonHeight, "", ssk.sbc.tableToggler_CB )	
	ssk.sbc.prep_tableToggler( tmpButton, settingsTable, "multiPlayer", dumpSettings ) 

	-- ==
	--    Horizontal Slider 2 Table Test (Horiz Slider value [0,1] saves to named setting in a table)
	-- ==
	local function printVolume()
		print( settingsTable.volume )
	end

	curX = centerX
	curY = yOffset + 4 * buttonHeight + buttonHeight/2 + 3 * 10
	tmpButton = ssk.buttons:quickHorizSlider( layers.content, curX, curY, buttonWidth, 11, 
											  "images/interface/trackHoriz",
											  ssk.sbc.horizSlider2Table_CB, dumpSettings,
											  "images/interface/thumbHoriz", 40, 20)

	ssk.sbc.prep_horizSlider2Table( tmpButton, settingsTable, "volume", printVolume ) 


	tmpButton = nil

end

return gameLogic