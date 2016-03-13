-- Copyright (C) 2013 Corona Inc. All Rights Reserved.
-- File: newProgressView unit test.

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
	local TEST_REMOVE_PROGRESS_VIEW = false
	local TEST_RESET_PROGRESS_VIEW = false
	local TEST_RESIZE_PROGRESS_VIEW = false
	local TEST_DELAY = 1000
		
	-- Create a new progress view object
	local newProgressView = widget.newProgressView
	{
		left = 0,
		top = 20,
		width = 150,
		isAnimated = true,
	}
	newProgressView.x = display.contentWidth * 0.5 
	newProgressView.y = display.contentCenterY
	
	if TEST_RESIZE_PROGRESS_VIEW then
		newProgressView:resizeView( 250 )
	end
	
	group:insert( newProgressView )
		
	local currentProgress = 0.0

	testTimer = timer.performWithDelay( 100, function( event )
		currentProgress = currentProgress + 0.01
		newProgressView:setProgress( currentProgress )
		
		if TEST_RESET_PROGRESS_VIEW then
			if newProgressView:getProgress() >= 0.5 then
				newProgressView:setProgress( 0 )
				currentProgress = 0.0
			end
		end
		
		--print( newProgressView:getProgress() )
	end, 0 )


	----------------------------------------------------------------------------------------------------------------
	--											TESTS
	----------------------------------------------------------------------------------------------------------------
	-- Test removing the progress view
	if TEST_REMOVE_PROGRESS_VIEW then
		testTimer = timer.performWithDelay( 100, function()
			display.remove( newProgressView )
			
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
