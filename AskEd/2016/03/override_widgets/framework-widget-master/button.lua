-- Copyright (C) 2013 Corona Inc. All Rights Reserved.
-- File: newButton unit test.

local widget = require( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local isGraphicsV1 = ( 1 == display.getDefault( "graphicsCompatibility" ) )

-- Forward reference for test function timer
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
	
	-- Button to return to unit test listing
	local returnToListing = widget.newButton
	{
	    id = "returnToListing",
	    left = 0,
	    top = backButtonPosition,
	    label = "Exit",
		labelAlign = "center",
	    width = 200, height = backButtonSize,
	    cornerRadius = 8,
	    onRelease = function() storyboard.gotoScene( "unitTestListing" ) end;
	}
	returnToListing.x = display.contentCenterX
	group:insert( returnToListing )
	
	----------------------------------------------------------------------------------------------------------------
	--										START OF UNIT TEST
	----------------------------------------------------------------------------------------------------------------
	
	-- Toggle these defines to execute tests. NOTE: It is recommended to only enable one of these tests at a time
	local TEST_SET_LABEL = false
	local TEST_SET_ENABLED = true
		
	-- Handle widget button events
	local function onButtonEvent( event )
		local phase = event.phase
		local target = event.target
		
		if "began" == phase then
			print( target.id .. " pressed" )
						
			-- Set a new label
			target:setLabel( "Hello Corona!" )
    	elseif "ended" == phase then
        	print( target.id .. " released" )
						
			-- Reset the label
			target:setLabel( target.oldLabel )
			
		elseif "cancelled" == phase then
			print( target.id .. " cancelled" )
						
			-- Reset the label
			target:setLabel( target.oldLabel )
    	end
    	
    	return true
	end
	
		
	-- Standard button 
	local buttonUsingFiles = widget.newButton
	{
		width = 278,
		height = 46,
		defaultFile = "unitTestAssets/default.png",
		overFile = "unitTestAssets/over.png",
	    id = "Left Label Button",
	    left = 0,
	    top = 120,
	    label = "Files",
		labelAlign = "left",
		fontSize = 18,
		labelColor =
		{ 
			default = { 0, 0, 0 },
			over = { 255, 255, 255 },
		},
		emboss = false,
		isEnabled = false,
	    onEvent = onButtonEvent,
	}
	buttonUsingFiles.x = display.contentCenterX
	buttonUsingFiles.oldLabel = "Files"	
	group:insert( buttonUsingFiles )
	
	--buttonUsingFiles:setFillColor(255,0,0)
	
	
	-- Set up sheet parameters for imagesheet button
	local sheetInfo =
	{
		width = 200,
		height = 60,
		numFrames = 2,
		sheetContentWidth = 200,
		sheetContentHeight = 120,
	}
	
	-- Create the button sheet
	local buttonSheet = graphics.newImageSheet( "unitTestAssets/btnBlueSheet.png", sheetInfo )
	
	-- ImageSheet button 
	local buttonUsingImageSheet = widget.newButton
	{
		sheet = buttonSheet,
		defaultFrame = 1,
		--overFrame = 2,
	    id = "Centered Label Button",
	    left = 60,
	    top = 200,
	    label = "ImageSheet",
		labelAlign = "center",
		fontSize = 18,
		labelColor =
		{ 
			default = { 255, 255, 255 },
			over = { 255, 0, 0 },
		},
	    onEvent = onButtonEvent
	}
	buttonUsingImageSheet.x = display.contentCenterX
	buttonUsingImageSheet.oldLabel = "ImageSheet"	
	group:insert( buttonUsingImageSheet )
	
	--buttonUsingImageSheet:setFillColor(255,0,0)

	-- Theme button 
	local buttonUsingTheme = widget.newButton
	{
	    id = "Right Label Button",
	    left = 0,
	    top = 280,
	    label = "Theme",
		labelAlign = "center",
	    width = 140, 
		height = 44,
	    onEvent = onButtonEvent
	}
	buttonUsingTheme.oldLabel = "Theme"
	buttonUsingTheme.x = display.contentCenterX
	group:insert( buttonUsingTheme )
	
	-- Text only button
	local buttonUsingTextOnly = widget.newButton
	{
		id = "Text only button",
		left = 0,
		top = 340,
		label = "Text Only Button",
		labelColor = 
		{
			default = { 0, 0, 0 },
			over = { 255, 0, 0 },
		},
		textOnly = true,
		--emboss = false,
		onEvent = onButtonEvent
	}
	buttonUsingTextOnly.oldLabel = "Text only button"
	buttonUsingTextOnly.x = display.contentCenterX
	group:insert( buttonUsingTextOnly )

	-- Vector button
	local buttonUsingVector = widget.newButton
	{
		id = "Vector button",
		left = 0,
		top = 390,
		emboss= false,
		label = "Vector Button",
		labelColor = 
		{
			default = { 0, 0, 0 },
			over = { 0, 255, 0 },
		},
		shape="roundedRect",
		width = 200,
		height = 40,
		cornerRadius = 2,
		radius = 30,
		vertices = { -20,-25,40,0,-20,25 },
		fillColor = { default={ 1,0,0,1 }, over={ 1,40/255,160/255,100/255 } },
		strokeColor = { default={ 1,100/255,0,1 }, over={ 200/255,200/255,1,1 } },
		strokeWidth = 4,
		onEvent = onButtonEvent
	}
	buttonUsingVector.oldLabel = "Vector button"
	buttonUsingVector.x = display.contentCenterX
	group:insert( buttonUsingVector )
	
	--buttonUsingVector:setFillColor(0,0,255)
	--buttonUsingVector:setStrokeColor(0,255,0)

	local options9Slice = {
		frames =
		{
			{ x=0, y=0, width=21, height=21 },
			{ x=21, y=0, width=198, height=21 },
			{ x=219, y=0, width=21, height=21 },
			{ x=0, y=21, width=21, height=78 },
			{ x=21, y=21, width=198, height=78 },
			{ x=219, y=21, width=21, height=78 },
			{ x=0, y=99, width=21, height=21 },
			{ x=21, y=99, width=198, height=21 },
			{ x=219, y=99, width=21, height=21 },
			{ x=240, y=0, width=21, height=21 },
			{ x=261, y=0, width=198, height=21 },
			{ x=459, y=0, width=21, height=21 },
			{ x=240, y=21, width=21, height=78 },
			{ x=261, y=21, width=198, height=78 },
			{ x=459, y=21, width=21, height=78 },
			{ x=240, y=99, width=21, height=21 },
			{ x=261, y=99, width=198, height=21 },
			{ x=459, y=99, width=21, height=21 }
		},
		sheetContentWidth = 480,
		sheetContentHeight = 120
	}
	local sheet9Slice = graphics.newImageSheet( "unitTestAssets/buttonSheet.png", options9Slice )

	local buttonUsing9Slice = widget.newButton
	{
		left= 50,
		top = 40,
		width = 220,
		height = 70,
		sheet = sheet9Slice,
		topLeftFrame = 1,
		topMiddleFrame = 2,
		topRightFrame = 3,
		middleLeftFrame = 4,
		middleFrame = 5,
		middleRightFrame = 6,
		bottomLeftFrame = 7,
		bottomMiddleFrame = 8,
		bottomRightFrame = 9,
		topLeftOverFrame = 10,
		topMiddleOverFrame = 11,
		topRightOverFrame = 12,
		middleLeftOverFrame = 13,
		middleOverFrame = 14,
		middleRightOverFrame = 15,
		bottomLeftOverFrame = 16,
		bottomMiddleOverFrame = 17,
		bottomRightOverFrame = 18,
		label = "9-Slice"
	}

	group:insert( buttonUsing9Slice )

	--buttonUsing9Slice:setFillColor(0,255,0,100)

	----------------------------------------------------------------------------------------------------------------
	--											TESTS											 	  			  --
	----------------------------------------------------------------------------------------------------------------
	
	--Test setting label
	if TEST_SET_LABEL then
		testTimer = timer.performWithDelay( 2000, function()
			buttonUsingTheme:setLabel( "New Label" ) -- "New Label"
		end, 1 )		
	end
	
	-- Test setting a button as enabled
	if TEST_SET_ENABLED then
		testTimer =	timer.performWithDelay( 400, function()
			buttonUsingFiles:setEnabled( true )
		end, 1)
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
