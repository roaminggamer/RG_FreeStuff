-- Copyright (C) 2013 Corona Inc. All Rights Reserved.
-- File: newStepper unit test.

local widget = require( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local USE_IOS7_THEME = true
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
	    left = 60,
	    top = backButtonPosition,
	    label = "Exit",
	    width = 200, height = backButtonSize,
	    cornerRadius = 8,
	    onRelease = function() storyboard.gotoScene( "unitTestListing" ) end;
	}
	group:insert( returnToListing )
	
	----------------------------------------------------------------------------------------------------------------
	--										START OF UNIT TEST
	----------------------------------------------------------------------------------------------------------------	
	--Toggle these defines to execute automated tests.
	local TEST_REMOVE_STEPPER = false
	local TEST_DELAY = 1000
	
	local startAtNumber = 2
	
	local numberText = display.newText( "0000", 0, 0, fontUsed, 24 )
	numberText:setFillColor( fontColor )
	numberText.x = display.contentCenterX
	numberText.y = 150
	numberText.no = startAtNumber
	group:insert( numberText )
	
	local function onPress( event )
		local phase = event.phase

		if "increment" == phase then
			numberText.no = numberText.no + 1
		elseif "decrement" == phase then
			numberText.no = numberText.no - 1
		end
	
		print( "current value is:", event.value )
		print( "minimum value is:", event.minimumValue )
		print( "maximum value is:", event.maximumValue )

		numberText.text = string.format( "%04d", numberText.no )
	end
		
	
	local newStepper = widget.newStepper
	{
		id = "dy",
		left = 100,
		top = 100,
		x = 0,
		y = 200,
		initialValue = startAtNumber,
		minimumValue = 0,
		maximumValue = 25,
		onPress = onPress,
	}
	newStepper.x = display.contentCenterX
	group:insert( newStepper )
	
	-- Update the intial text
	numberText.text = string.format( "%04d", startAtNumber )
	
	----------------------------------------------------------------------------------------------------------------
	--											TESTS
	----------------------------------------------------------------------------------------------------------------
	
	-- Test removing stepper
	if TEST_REMOVE_STEPPER then
		timer.performWithDelay( 100, function()
			display.remove( newStepper )
			
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
