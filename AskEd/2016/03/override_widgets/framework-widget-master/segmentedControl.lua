-- Copyright (C) 2013 Corona Inc. All Rights Reserved.
-- File: newSegmentedControl unit test.

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
	local TEST_REMOVE_SEGMENTED_CONTROL = false
	local TEST_DELAY = 1000
	
	local currentSegment = display.newText( "You selected: ", 0, 0, fontUsed, 18 )
	currentSegment.x = display.contentWidth * 0.5
	currentSegment.y = display.contentHeight * 0.5 + 40
	group:insert( currentSegment )
	currentSegment:setFillColor( fontColor )
	
	local function onPress( event )
		--	print( "Segment no:", event.target.segmentNumber )
		--print( "Segment label:", event.target.segmentLabel )
		currentSegment.text = "You selected: " .. event.target.segmentLabel
	end
	
	-- Create a new segmented control object
	local newSegmentedControl = widget.newSegmentedControl
	{
		left = 35,
		top = 80,
		segments = { "Item 1", "Item 2", "Item 3", "Item 4", "Item 5" },
		defaultSegment = 1,
		--segmentWidth = 25,
		--[[
		labelSize = 14,
		labelFont = native.systemFontBold,
		labelXOffset = 0,
		labelYOffset = - 2,
		--]]
		onPress = onPress,
	}
	group:insert( newSegmentedControl )
	
	
	----------------------------------------------------------------------------------------------------------------
	--											TESTS
	----------------------------------------------------------------------------------------------------------------

	-- Test removing the segmentedControl
	if TEST_REMOVE_SEGMENTED_CONTROL then
		timer.performWithDelay( 100, function()
			display.remove( newSegmentedControl )
			
			TEST_DELAY = TEST_DELAY + TEST_DELAY
		end )
	end

	
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
