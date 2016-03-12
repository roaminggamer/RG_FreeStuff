-- Copyright (C) 2013 Corona Inc. All Rights Reserved.
-- File: newSlider unit test.

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

	-- Button to return to unit test listing
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
	
	--Toggle these defines to execute tests. NOTE: It is recommended to only enable one of these tests at a time
	local TEST_SET_VALUE = false
	
	--Create some text to show the sliders output
	local sliderResult = display.newText( "Slider at 50%", 0, 0, fontUsed, 18 )
	sliderResult:setFillColor( fontColor )
	
	if isGraphicsV1 then
		sliderResult:setReferencePoint( display.CenterReferencePoint )
	end
	
	sliderResult.x = 160
	sliderResult.y = 250
	group:insert( sliderResult )
	
	-- Slider listener function
	local function sliderListener( event )
		--print( "phase is:", event.phase )
		sliderResult.text = "Slider at " .. event.value .. "%"
	end

	-- Create a horizontal slider
	local sliderHorizontal = widget.newSlider
	{
		width = 200,
		left = 80,
		top = 300,
		value = 50,
		listener = sliderListener,
	}
	sliderHorizontal.x = display.contentCenterX
	group:insert( sliderHorizontal )
			
	-- Create a vertical slider
	local sliderVertical = widget.newSlider
	{
		height = 150,
		top = 130,
		left = 50,
		value = 80,
		orientation = "vertical",
		listener = sliderListener,
	}
	group:insert( sliderVertical )
	

	----------------------------------------------------------------------------------------------------------------
	--											TESTS
	----------------------------------------------------------------------------------------------------------------
	
	--Test setValue()
	if TEST_SET_VALUE then
		testTimer = timer.performWithDelay( 1000, function()
			sliderHorizontal:setValue( 0 )
			sliderVertical:setValue( 0 )
			sliderResult:setText( "Slider at " .. sliderHorizontal.value .. "%" )
		end, 1 )
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
