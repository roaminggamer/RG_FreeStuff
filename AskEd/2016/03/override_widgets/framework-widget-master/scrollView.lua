-- Copyright (C) 2013 Corona Inc. All Rights Reserved.
-- File: newScrollView unit test.

local widget = require( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

--Forward reference for test function timer
local testTimer = nil

local isGraphicsV1 = ( 1 == display.getDefault( "graphicsCompatibility" ) )

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
	
	--Toggle these defines to execute tests. NOTE: It is recommended to only enable one of these tests at a time
	local TEST_GET_CONTENT_POSITION = false
	local TEST_SCROLL_TO_POSITION = false
	local TEST_SCROLL_TO_TOP = false
	local TEST_SCROLL_TO_BOTTOM = false
	local TEST_SCROLL_TO_LEFT = false
	local TEST_SCROLL_TO_RIGHT = false
	local TEST_SCROLLVIEW_ON_TOP_OF_EACHOTHER = false
	local TEST_TABLEVIEW_INSIDE_SCROLLVIEW = false
	local TEST_REMOVE_SCROLLVIEW = false
	local TEST_RESIZE_SCROLLVIEW_VERTICALLY = false
	
	-- Our ScrollView listener
	local function scrollListener( event )
		local phase = event.phase
		local direction = event.direction
		
		if "began" == phase then			
			print( "Began" )
		elseif "moved" == phase then
			print( "Moved" )
		elseif "ended" == phase then
			print( "Ended" )
		end
		
		if event.limitReached then
			if "up" == direction then
				print( "Reached Top Limit" )
			elseif "down" == direction then
				print( "Reached Bottom Limit" )
			elseif "left" == direction then
				print( "Reached Left Limit" )
			elseif "right" == direction then
				print( "Reached Right Limit" )
			end
		end
				
		return true
	end

	-- Create a ScrollView
	local scrollView = widget.newScrollView
	{
		--top = 100,
		--left = 10,
		x = 160,
		y = 270,
		width = 300,
		height = 380,
		id = "onBottom",
	}
	group:insert( scrollView )
	
	-- insert image into scrollView widget
	local background = display.newImageRect( "unitTestAssets/scrollimage2.jpg", 768, 1024 )
	background.x = 240
	background.y = 340
	--background.alpha = 0.3
	scrollView:insert( background )
	
	--print( "sc coords: ", scrollView._view.x, scrollView._view.y )
	local vBounds = scrollView._view.contentBounds
	--print( vBounds.xMin, vBounds.xMax, vBounds.yMin, vBounds.yMax )
	
	local function test( event )
		local phase = event.phase
		
		if "began" == phase then
			print( "began" )
		elseif "moved" == phase then
			local dy = math.abs( event.y - event.yStart )
			
			if dy > 10 then
				scrollView:takeFocus( event )
			end
			
			print( "moved" )
		elseif "ended" == phase then
			print( "ended" )
		elseif "cancelled" == phase then
			print( "cancelled" )
		end
		
		return true
	end

	-- Segmented control
	local newSegmentedControl = widget.newSegmentedControl
	{
		left = 10,
		top = 5,
		segments = { "Item1", "Item2", "Item3", "Item4", "Item5" },
		defaultSegment = 1,
		segmentWidth = 56,
		--[[
		labelSize = 14,
		labelFont = native.systemFontBold,
		labelXOffset = 0,
		labelYOffset = - 2,
		--]]
		onPress = onPress,
	}
	scrollView:insert( newSegmentedControl )

	-- Radio button set
	local radioGroup = display.newGroup()
	local radioButton = widget.newSwitch
	{
		left = 15,
		top = 40,
		style = "radio",
		id = "Radio button1",
		initialSwitchState = true
	}
	radioGroup:insert( radioButton )

	local radioButton2 = widget.newSwitch
	{
		left = 40,
		top = 40,
		style = "radio",
		id = "Radio button2"
	}
	radioGroup:insert( radioButton2 )
	scrollView:insert( radioGroup )
	
	-- Checkbox
	local checkboxButton = widget.newSwitch
	{
		left = 80,
		top = 40,
		style = "checkbox",
		id = "Checkbox button"
	}
	scrollView:insert( checkboxButton )
	
	-- On/off switch
	local onOffSwitch = widget.newSwitch
	{
		left = 105,
		top = 45,
		style = "onOff",
		initialSwitchState = false
	}
	scrollView:insert( onOffSwitch )
	
	-- Stepper
	local newStepper = widget.newStepper
	{
		id = "dy",
		left = 20,
		top = 80,
		initialValue = 4,
		minimumValue = 0,
		maximumValue = 25
	}
	scrollView:insert( newStepper )
	
	-- Progress view
	local newProgressView = widget.newProgressView
	{
		left = 120,
		top = 92,
		width = 100,
		isAnimated = true,
	}
	scrollView:insert( newProgressView )
	local currentProgress = 0.0
	testTimer = timer.performWithDelay( 100, function( event )
		currentProgress = currentProgress + 0.01
		newProgressView:setProgress( currentProgress )
	end, 50 )
	
	local spinnerDefault = widget.newSpinner
	{
		left = 235,
		top = 50,
		deltaAngle = 20
	}
	scrollView:insert( spinnerDefault )
	spinnerDefault:start()
	


	local tabButtons = {
    {
        label = "Tab1",
        selected = true,
    },
    {
        label = "Tab2",
    },
    {
        label = "Tab3",
    }
	}
	local tabBar2 = widget.newTabBar
	{
		top = 320,
		width = 300,
		buttons = tabButtons
	}
	scrollView:insert( tabBar2 )
	
	-- Standard button 
	local buttonUsingFiles = widget.newButton
	{
		width = 278,
		height = 46,
		defaultFile = "unitTestAssets/default.png",
		overFile = "unitTestAssets/over.png",
	    id = "Left Label Button",
	    left = 0,
	    top = 115,
	    label = "Files",
		labelAlign = "left",
		fontSize = 18,
		labelColor =
		{ 
			default = { 0, 0, 0 },
			over = { 255, 255, 255 },
		},
		emboss = false,
		isEnabled = true,
	    onEvent = test,
	}
	buttonUsingFiles.x = display.contentCenterX-10
	buttonUsingFiles.oldLabel = "Files"	
	scrollView:insert( buttonUsingFiles )
	
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
		overFrame = 2,
	    id = "Centered Label Button",
	    left = 10,
	    top = 165,
	    label = "ImageSheet",
		labelAlign = "center",
		fontSize = 18,
		labelColor =
		{ 
			default = { 255, 255, 255 },
			over = { 255, 0, 0 },
		},
	    onEvent = test
	}
	buttonUsingImageSheet.oldLabel = "ImageSheet"	
	scrollView:insert( buttonUsingImageSheet )
		
	-- Theme button 
	local buttonUsingTheme = widget.newButton
	{
	    id = "Right Label Button",
	    left = 15,
	    top = 225,
	    label = "Theme",
		--labelAlign = "right",
	    width = 140, 
		height = 40,
	    onEvent = test
	}
	buttonUsingTheme.oldLabel = "Theme"
	scrollView:insert( buttonUsingTheme )

	-- Slider (horizontal)
	local sliderHorizontal = widget.newSlider
	{
		width = 200,
		left = 10,
		top = 275,
		value = 50
	}
	scrollView:insert( sliderHorizontal )

	local sliderVertical = widget.newSlider
	{
		height = 120,
		top = 180,
		left = 230,
		value = 80,
		orientation = "vertical"
	}
	scrollView:insert( sliderVertical )
	
	
	if TEST_RESIZE_SCROLLVIEW_VERTICALLY then
		scrollView:setScrollHeight( 400 )
	end

	----------------------------------------------------------------------------------------------------------------
	--											TESTS
	----------------------------------------------------------------------------------------------------------------
	if TEST_REMOVE_SCROLLVIEW then
		timer.performWithDelay( 1000, function()
			scrollView:removeSelf()
			scrollView = nil
		end)
	end
	
	
	if TEST_SCROLLVIEW_ON_TOP_OF_EACHOTHER then
		-- Create scrollView2
		local scrollView2 = widget.newScrollView
		{
			top = 250,
			left = 10,
			width = 300,
			height = 350,
			id = "onTop",
			maskFile = "unitTestAssets/scrollViewMask-350.png",
			listener = scrollListener,
		}
	
		-- insert image into scrollView widget
		local bg2 = display.newImageRect( "unitTestAssets/scrollimage2.jpg", 768, 1024 )
		if isGraphicsV1 then
			bg2:setReferencePoint( display.TopLeftReferencePoint )
		end
		bg2.x, bg2.y = xAnchor, yAnchor
		scrollView2:insert( bg2 )
		group:insert( scrollView2 )
	end
	
	
	if TEST_TABLEVIEW_INSIDE_SCROLLVIEW then
		-- Listen for tableView events
		local function tableViewListener( event )
			local phase = event.phase
			local direction = event.direction

			if "began" == phase then
				--print( "Began" )
			elseif "moved" == phase then
				--print( "Moved" )
			elseif "ended" == phase then
				--print( "Ended" )
			end

			if event.limitReached then
				if "up" == direction then
					print( "Reached Top Limit" )
				elseif "down" == direction then
					print( "Reached Bottom Limit" )
				elseif "left" == direction then
					print( "Reached Left Limit" )
				elseif "right" == direction then
					print( "Reached Right Limit" )
				end
			end

			return true
		end


		local noCategories = 0

		-- Handle row rendering
		local function onRowRender( event )
			local phase = event.phase
			local row = event.row

			--print( "Row id:", row.id )
			local rowTitle = "Row " .. row.index

			if row.isCategory then
				noCategories = noCategories + 1
				--rowTitle = "Category "  .. noCategories
			end

			local rowTitle = display.newText( row, rowTitle, 0, 0, nil, 14 )
			rowTitle.x = row.x - ( row.contentWidth * 0.5 ) + ( rowTitle.contentWidth * 0.5 )
			rowTitle.y = row.contentHeight * 0.5
			rowTitle:setFillColor( 0, 0, 0 )

			if not row.isCategory and row.index ~= 1 then
				--print( row.index )
				local spinner = widget.newSpinner{}
				spinner.x = row.x + ( row.contentWidth * 0.5 ) - ( spinner.contentWidth * 0.5 )
				spinner.y = row.contentHeight * 0.5
				spinner:scale( 0.5, 0.5 )
				row:insert( spinner ) 
				spinner:start()
			end
		end

		-- Handle row's becoming visible on screen
		local function onRowUpdate( event )
			local phase = event.phase
			local row = event.row

			--print( row.index, ": is now visible" )
		end

		-- Handle touches on the row
		local function onRowTouch( event )
			local phase = event.phase
			local row = event.target

			if "swipeRight" == phase then
				print( "Swiped right on row with index: ", row.index )
			elseif "swipeLeft" == phase then
				print( "Swiped left on row with id: ", row.id )
			elseif "tap" == phase then
				print( "Tapped on row with id:", row.id )
			elseif "press" == phase then
				print( "Pressed row with id: ", row.id )
			elseif "release" == phase then
				print( "Released row with index: ", row.index )		
			end
		end

		-- Create a tableView
		tableView = widget.newTableView
		{
			top = 150,
			width = 320, 
			--height = 300,
			height = 150,
			maskFile = "unitTestAssets/mask-320x366.png",
			--listener = tableViewListener,
			--isLocked = true,
			onRowRender = onRowRender,
			onRowUpdate = onRowUpdate,
			onRowTouch = onRowTouch,
		}
		scrollView:insert( tableView )


		-- Create 100 rows
		for i = 1, 50 do
			local isCategory = false
			local rowHeight = 40
			local rowColor = 
			{ 
				default = { 255, 255, 255 },
				over = { 255, 0, 255 },
			}
			local lineColor = { 220, 220, 220 }

			-- Make some rows categories
			if i == 1 or i == 4 or i == 8 or i == 18 or i == 28 or i == 35 or i == 45 then
				isCategory = true

				rowHeight = 24
				--rowHeight = 47

				rowColor = 
				{ 
					default = { 150, 160, 180, 200 },
				}
			end

			-- Insert the row into the tableView
			tableView:insertRow
			{
				id = "row:" .. i,
				isCategory = isCategory,
				rowHeight = rowHeight,
				rowColor = rowColor,
				lineColor = lineColor,
			}
		end
	end
	
	
	-- Test getContentPosition()
	if TEST_GET_CONTENT_POSITION then
		testTimer = timer.performWithDelay( 2000, function()
			local x, y = scrollView:getContentPosition()
			print( "ScrollView content position. ( x = ", x, " y = ", y, ")" ) 
			x, y = nil
		end, 1 )
	end
	
	-- Test scrollToPosition()
	if TEST_SCROLL_TO_POSITION then
		testTimer = timer.performWithDelay( 2000, function()
			scrollView:scrollToPosition( { x = - 0, y = - 600, time = 800, onComplete = function() print( "scrollToPosition test completed" ) end } )
		end, 1 )
	end	
	
	-- Test scrollToTop()
	if TEST_SCROLL_TO_TOP then		
		testTimer = timer.performWithDelay( 2000, function()
			scrollView:scrollTo( "top", { time = 800, onComplete = function() print( "scrollToTop test completed" ) end } )
		end, 1 )
	end
	
	-- Test scrollToBottom()
	if TEST_SCROLL_TO_BOTTOM then
		testTimer = timer.performWithDelay( 2000, function()
			scrollView:scrollTo( "bottom", { time = 800, onComplete = function() print( "scrollToBottom test completed" ) end } )
		end, 1 )
	end
	
	-- Test scrollToLeft()
	if TEST_SCROLL_TO_LEFT then		
		testTimer = timer.performWithDelay( 2000, function()
			scrollView:scrollTo( "left", { time = 800, onComplete =  function() print( "scrollToLeft test completed" ) end }  )
		end, 1 )
	end
	
	-- Test scrollToRight()
	if TEST_SCROLL_TO_RIGHT then
		testTimer = timer.performWithDelay( 2000, function()
			scrollView:scrollTo( "right", { time = 800, onComplete = function() print( "scrollToRight test completed" ) end } )
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
