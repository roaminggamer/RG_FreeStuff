-- Copyright (C) 2013 Corona Inc. All Rights Reserved.
-- File: newSearchField unit test.

local widget = require( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local USE_ANDROID_THEME = false
local USE_IOS7_THEME = true
local isGraphicsV1 = ( 1 == display.getDefault( "graphicsCompatibility" ) )

--Forward reference for test function timer
local testTimer = nil

function scene:createScene( event )
	local group = self.view
	
	-- Test android theme
	if USE_ANDROID_THEME then
		widget.setTheme( "widget_theme_android" )
	end
	
	--Display an iOS style background
	local background
	
	local xAnchor, yAnchor
	
	if not isGraphicsV1 then
		xAnchor = display.contentCenterX
		yAnchor = display.contentCenterY
	else
		xAnchor = 0
		yAnchor = 0
	end
	
	if USE_IOS7_THEME then
		background = display.newRect( xAnchor, yAnchor, display.contentWidth, display.contentHeight )
	else
		background = display.newImage( "unitTestAssets/background.png" )
		background.x, background.y = xAnchor, yAnchor
	end
	
	group:insert( background )
	
	if USE_IOS7_THEME then
		-- create a white background, 40px tall, to mask / hide the scrollView
		local topMask = display.newRect( 0, 0, display.contentWidth, 40 )
		topMask:setFillColor( 235, 235, 235, 255 )
		group:insert( topMask )
	end
	
	local backButtonPosition = 5
	local backButtonSize = 52
	local fontUsed = native.systemFont
	
	
	if USE_IOS7_THEME then
		backButtonPosition = 0
		backButtonSize = 40
		fontUsed = "HelveticaNeue-Light"
	end
	
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
	local TEST_REMOVE_SEARCH_FIELD = false
	local TEST_DELAY = 1000
	
	local function onEvent( event )
		local phase = event.phase
		
		--print( event.phase ) 
	end
		
	if USE_IOS7_THEME then
		-- create a gray background, 60px tall, to mask / hide the widget
		local topMask = display.newRect( 0, 50, display.contentWidth, 60 )
		topMask:setFillColor( 235, 235, 235, 255 )
		group:insert( topMask )
	end	
	
	local newSearchField = widget.newSearchField
	{
		left = 0,
		top = 65,
		width = 200,
		placeholder = "Search For ...",
		textFieldXOffset = 10,
		listener = onEvent,
	}
	newSearchField.x = display.contentCenterX
	group:insert( newSearchField )
	
	----------------------------------------------------------------------------------------------------------------
	--											TESTS
	----------------------------------------------------------------------------------------------------------------
	
	-- Test removing the search field
	if TEST_REMOVE_SEARCH_FIELD then
		timer.performWithDelay( 100, function()
			display.remove( newSearchField )
			
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
