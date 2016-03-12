-- Copyright (C) 2013 Corona Inc. All Rights Reserved.
-- File: newSpinner unit test.

local widget = require( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local isGraphicsV1 = ( 1 == display.getDefault( "graphicsCompatibility" ) )

--Forward reference for test function timer
local testTimer = nil


function scene:createScene( event )
	local group = self.view
	
	local xAnchor, yAnchor
	
	if not isGraphicsV1 then
		xAnchor = display.contentCenterX
		yAnchor = display.contentCenterY
	else
		xAnchor = 0
		yAnchor = 0
	end

	local fontColor = 0
	local background = display.newRect( xAnchor, yAnchor, display.contentWidth, display.contentHeight )
	
	if widget.USE_IOS_THEME then
		if isGraphicsV1 then background:setFillColor( 197, 204, 212, 255 )
		else background:setFillColor( 197/255, 204/255, 212/255, 1 ) end
	elseif widget.USE_ANDROID_HOLO_LIGHT_THEME then
		if isGraphicsV1 then background:setFillColor( 255, 255, 255, 255 )
		else background:setFillColor( 1, 1, 1, 1 ) end
	elseif widget.USE_ANDROID_HOLO_DARK_THEME then
		if isGraphicsV1 then background:setFillColor( 34, 34, 34, 255 )
		else background:setFillColor( 34/255, 34/255, 34/255, 1 ) end
		fontColor = 0.5
	else
		if isGraphicsV1 then background:setFillColor( 255, 255, 255, 255 )
		else background:setFillColor( 1, 1, 1, 1 ) end
	end
	group:insert( background )
	
	local backButtonPosition = 5
	local backButtonSize = 34
	local fontUsed = native.systemFont
	
	--Button to return to unit test listing
	local returnToListing = widget.newButton{
	    id = "returnToListing",
	    left = display.contentWidth * 0.5,
	    top = backButtonPosition,
	    label = "Exit",
	    width = 200, height = backButtonSize,
	    cornerRadius = 8,
	    onRelease = function() storyboard.gotoScene( "unitTestListing" ) end;
	}
	returnToListing.x = display.contentCenterX
	group:insert( returnToListing )

	----------------------------------------------------------------------------------------------------------------
	--										START OF UNIT TEST
	----------------------------------------------------------------------------------------------------------------	
	--Toggle these defines to execute automated tests.
	local TEST_START_SPINNER = true
	local TEST_PAUSE_SPINNER = false
	local TEST_MOVE_SPINNER = false
	local TEST_TRANSLATE_SPINNER = false
	local TEST_REMOVE_SPINNER = false
	local TEST_DELAY = 1000

	-- Create a default spinner (created using theme file) - (Single Rotating Image)
	local spinnerDefault = widget.newSpinner
	{
		left = 0,
		top = 80,
	}
	spinnerDefault.x = display.contentCenterX
	group:insert( spinnerDefault )
	
	
	local spinnerText = display.newText( "Default spinner (From theme)\nSingle Rotating Image from imagesheet", 0, 0, display.contentWidth, 0, fontUsed, 14 )
	spinnerText:setFillColor( fontColor )
	spinnerText.x = display.contentCenterX + 20
	spinnerText.y = spinnerDefault.y + ( spinnerDefault.contentWidth * 0.5 ) + 20
	group:insert( spinnerText )
	
	
	local sheetOptions = require( "unitTestAssets.customSpinner" )
	local imageSheet = graphics.newImageSheet( "unitTestAssets/customSpinner.png", sheetOptions:getSheet() )


	-- Create a custom spinner (Animating sprite from imagesheet)
	local spinnerCustom = widget.newSpinner
	{
		left = 100,
		top = 180,
		width = 35, 
		height = 35,
		sheet = imageSheet,
		startFrame = 1,
		count = 30,
		time = 1000,
	}
	spinnerCustom.x = display.contentCenterX
	group:insert( spinnerCustom )
	
	
	local spinnerCustomText = display.newText( "Custom spinner (Custom graphics)\nAnimating sprite from imagesheet", 0, 0, display.contentWidth, 0, fontUsed, 14 )
	spinnerCustomText:setFillColor( fontColor )
	spinnerCustomText.x = display.contentCenterX + 20
	spinnerCustomText.y = spinnerCustom.y + ( spinnerCustom.contentWidth * 0.5 ) + 20
	group:insert( spinnerCustomText )
	
	
	-- Create a custom spinner that isn't animated and just rotates - (Single Rotating Image from imagesheet)
	local spinnerCustomJustRotates = widget.newSpinner
	{
		left = 60,
		top = 280,
		width = 35,
		height = 35,
		sheet = imageSheet,
		startFrame = sheetOptions:getFrameIndex( "spinner_spinner" ),
		count = 1,
		deltaAngle = -1,
	}
	spinnerCustomJustRotates.x = display.contentCenterX
	group:insert( spinnerCustomJustRotates )
	
	local spinnerCustomJustRotatesText = display.newText( "Custom spinner (Custom graphics)\nSingle Rotating Image from imagesheet", 0, 0, display.contentWidth, 0, fontUsed, 14 )
	spinnerCustomJustRotatesText:setFillColor( fontColor )
	spinnerCustomJustRotatesText.x = display.contentCenterX + 20
	spinnerCustomJustRotatesText.y = spinnerCustomJustRotates.y + ( spinnerCustomJustRotates.contentWidth * 0.5 ) + 20
	group:insert( spinnerCustomJustRotatesText )

	----------------------------------------------------------------------------------------------------------------
	--											TESTS
	----------------------------------------------------------------------------------------------------------------
	
	-- Test starting the spinners animation
	if TEST_START_SPINNER then
		testTimer = timer.performWithDelay( 100, function()
			spinnerDefault:start()
			spinnerCustom:start()
			spinnerCustomJustRotates:start()
		end )
	end
	
	-- Test pausing the spinners animation
	if TEST_PAUSE_SPINNER then
		testTimer = timer.performWithDelay( TEST_DELAY, function()
			spinnerDefault:stop()
			spinnerCustom:stop()
			spinnerCustomJustRotates:stop()
		end )
		TEST_DELAY = TEST_DELAY + TEST_DELAY
	end
	
	-- Test moving the spinners animation
	if TEST_MOVE_SPINNER then
		testTimer = timer.performWithDelay( TEST_DELAY, function()
			spinnerDefault:translate( 20, 20 )
			spinnerCustom:translate( 20, 20 )
			spinnerCustomJustRotates:translate( 20, 20 )
		end )
		TEST_DELAY = TEST_DELAY + TEST_DELAY
	end
	
	-- Test moving the spinners animation
	if TEST_TRANSLATE_SPINNER then
		testTimer = timer.performWithDelay( TEST_DELAY, function()
			transition.to( spinnerDefault, { x = 100, y = 100 } )
			transition.to( spinnerCustom, { x = 100, y = 100 } )
			transition.to( spinnerCustomJustRotates, { x = 100, y = 100 } )
			transition.to( spinnerCustomJustRotatesFromImageSheet, { x = 100, y = 100 } )
		end )
		TEST_DELAY = TEST_DELAY + TEST_DELAY
	end
	
	-- Test removing the spinner
	if TEST_REMOVE_SPINNER then
		testTimer = timer.performWithDelay( TEST_DELAY, function()
			spinnerDefault:removeSelf()
			spinnerDefault = nil
			spinnerCustom:removeSelf()
			spinnerCustom = nil
			spinnerCustomJustRotates:removeSelf()
			spinnerCustomJustRotates = nil
			spinnerCustomJustRotatesFromImageSheet:removeSelf()
			spinnerCustomJustRotatesFromImageSheet = nil
		end )
		TEST_DELAY = TEST_DELAY + TEST_DELAY
	end
	
end

function scene:exitScene( event )
	--Cancel test timer if active
	if testTimer ~= nil then
		timer.cancel( testTimer )
		testTimer = nil
	end
	
	--storyboard.purgeAll()
end

function scene:didExitScene( event )
	--Cancel test timer if active
	if testTimer ~= nil then
		timer.cancel( testTimer )
		testTimer = nil
	end
	
	storyboard.removeAll()
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "didExitScene", scene )

return scene
