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
	layers = ssk.display.quickLayers( group, "background", "pushButtons","toggleButtons", "radioButtons", "sliders" )
end

addInterfaceElements = function()
	-- Add background 
	backImage = ssk.display.backImage( layers.background, "backImage.jpg")
end	

createButtons = function ( )

	-- == PUSH BUTTONS
	ssk.buttons:presetPush( layers.pushButtons, "bluegel", centerX, centerY - 100, 100, 40, "Test" )

	-- == TOGGLE BUTTONS
	local tmp = ssk.buttons:presetToggle( layers.toggleButtons, "bluegelcheck", centerX - 90, centerY - 50, 40, 40, "" )
	ssk.buttons:presetToggle( layers.toggleButtons, "bluegelcheck", centerX - 45, centerY - 50, 40, 40, "" )
	ssk.buttons:presetToggle( layers.toggleButtons, "bluegelcheck", centerX, centerY - 50, 40, 40, "" )
	ssk.buttons:presetToggle( layers.toggleButtons, "bluegelcheck", centerX + 45, centerY - 50, 40, 40, "" )
	ssk.buttons:presetToggle( layers.toggleButtons, "bluegelcheck", centerX + 90, centerY - 50, 40, 40, "" )
	tmp:toggle()

	-- == RADIO BUTTONS
	local tmp = ssk.buttons:presetRadio( layers.radioButtons, "bluegelradio", centerX - 90, centerY, 40, 40, "" )
	ssk.buttons:presetRadio( layers.radioButtons, "bluegelradio", centerX - 45, centerY, 40, 40, "" )
	ssk.buttons:presetRadio( layers.radioButtons, "bluegelradio", centerX, centerY, 40, 40, "" )
	ssk.buttons:presetRadio( layers.radioButtons, "bluegelradio", centerX + 45, centerY, 40, 40, "" )
	ssk.buttons:presetRadio( layers.radioButtons, "bluegelradio", centerX + 90, centerY, 40, 40, "" )
	tmp:toggle()

	-- == SLIDERS
	local function pbCB( event )
		local target = event.target
		local phase  = event.phase
		local myValue = target:getValue()

		print(myValue .. " ==> " .. phase)
	end

	local dummyTable = { testValue = 0.25, testValue2 = 0.25, testValue3 = 0.25, testValue4 = 0.25 }
	local tmp,knob = ssk.buttons:presetSlider( layers.sliders, "bluegelslider", 
										  centerX, centerY + 50, 200, 16, 
										  ssk.sbc.horizSlider2Table_CB, nil, { rotation = 0 } )
	ssk.sbc.prep_horizSlider2Table( tmp, dummyTable, "testValue", pbCB )

	local tmp,knob = ssk.buttons:presetSlider( layers.sliders, "bluegelslider", 
										  centerX, centerY + 100, 200, 16, 
										  ssk.sbc.horizSlider2Table_CB, nil, { rotation = -180 } )
	ssk.sbc.prep_horizSlider2Table( tmp, dummyTable, "testValue", pbCB )

	local tmp,knob = ssk.buttons:presetSlider( layers.sliders, "bluegelslider", 
										  75, centerY, h - 50, 16, 
										  ssk.sbc.horizSlider2Table_CB, nil, { rotation = 90 } )
	ssk.sbc.prep_horizSlider2Table( tmp, dummyTable, "testValue2", pbCB )

	local tmp,knob = ssk.buttons:presetSlider( layers.sliders, "bluegelslider", 
										  w-75, centerY, h - 50, 16, 
										  ssk.sbc.horizSlider2Table_CB, nil, { rotation = -90 } )
	ssk.sbc.prep_horizSlider2Table( tmp, dummyTable, "testValue2", pbCB )


end

return gameLogic