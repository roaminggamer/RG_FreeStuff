-- Copyright (C) 2013 Corona Inc. All Rights Reserved.
-- File: newTabBar unit test.

local widget = require( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local USE_IOS7_THEME = false
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
	
	-- Toggle these defines to execute tests. NOTE: It is recommended to only enable one of these tests at a time
	local TEST_SET_BUTTON_ACTIVE = false
	local TEST_IMAGESHEET_TAB_BAR = false
	local TEST_THEME_TAB_BAR = true
	local tabBar = nil
	
	local labelColors = {
				default = { 255, 255, 255, 128 },
				over = { 255, 255, 255, 255 },
			}
			
	local tabLabelFont = native.systemFont
	local tabLabelFontSize = 10
	local normalTabImage = "unitTestAssets/tabIcon.png"
	local overTabImage = "unitTestAssets/tabIcon-down.png"
			
	if USE_IOS7_THEME then
		labelColors = {
				default = { 146 },
				over = { 21, 125, 251, 255 },
			}
		tabLabelFont = "HelveticaNeue"
		tabLabelFontSize = 10
		normalTabImage = "unitTestAssets/tabIcon-ios7.png"
		overTabImage = "unitTestAssets/tabIcon-down-ios7.png"
	end
	
	
	-- Create the tabBar's buttons
	local tabButtons = 
	{
		{
			width = 32, 
			height = 32,
			defaultFile = normalTabImage,
			overFile = overTabImage,
			label = "Tab1",
			--labelXOffset = - 20,
			--labelYOffset = - 20,
			labelColor = labelColors,
			font = tabLabelFont,
			size = tabLabelFontSize,
			onPress = function() print( "Tab 1 pressed" ) end,
			selected = false
		},
		{
			width = 32, 
			height = 32,
			defaultFile = normalTabImage,
			overFile = overTabImage,
			label = "Tab2",
			labelColor = labelColors,
			font = tabLabelFont,
			size = tabLabelFontSize,
			onPress = function( event ) print( "Tab 2 pressed" ) end,
			selected = true
		},
		{
			width = 32, 
			height = 32,
			defaultFile = normalTabImage,
			overFile = overTabImage,
			label = "Tab3",
			labelColor = labelColors,
			font = tabLabelFont,
			size = tabLabelFontSize,
			onPress = function() print( "Tab 3 pressed" ) end,
			selected = false
		},
		{
			width = 32, 
			height = 32,
			defaultFile = normalTabImage,
			overFile = overTabImage,
			label = "Tab4",
			labelColor = labelColors,
			font = tabLabelFont,
			size = tabLabelFontSize,
			onPress = function() print( "Tab 4 pressed" ) end,
			selected = false
		},
	}
	
	-- Create a tab bar
	if TEST_THEME_TAB_BAR then
		tabBar = widget.newTabBar
		{
			left = 0,
			top = display.contentHeight - 52,
			width = display.contentWidth,
			buttons = tabButtons,
		}
		group:insert( tabBar )
	end
	
	-- Create a tabBar
	if TEST_IMAGE_FILE_TAB_BAR then
		tabBar = widget.newTabBar
		{
			left = 0,
			top = display.contentHeight - 52,
			width = display.contentWidth,
			backgroundFile = "unitTestAssets/woodbg.png",
			tabSelectedLeftFile = "unitTestAssets/tabBar_tabSelectedLeftEdge.png",
			tabSelectedRightFile = "unitTestAssets/tabBar_tabSelectedRightEdge.png",
			tabSelectedMiddleFile = "unitTestAssets/tabBar_tabSelectedMiddle.png",
			tabSelectedFrameWidth = 20,
			tabSelectedFrameHeight = 100,
			buttons = tabButtons,
		}
		group:insert( tabBar )	
	end
	
	
	if TEST_IMAGESHEET_TAB_BAR then
		--- IMAGE SHEET TAB BAR
	
		local sheetOptions = require( "unitTestAssets.tabBar.tabBar" )
		local imageSheet = graphics.newImageSheet( "unitTestAssets/tabBar/tabBar.png", sheetOptions:getSheet() )
	
		-- Create the tabBar's buttons
		local tabButtonsImageSheet = 
		{
			{
				width = 32, 
				height = 32,
				defaultFrame = sheetOptions:getFrameIndex( "tabBar_iconInactive" ),
				overFrame = sheetOptions:getFrameIndex( "tabBar_iconActive" ),
				label = "Tab1",
				--labelXOffset = - 20,
				--labelYOffset = - 20,
				onPress = function() print( "Tab 1 pressed" ) end,
				selected = false
			},
			{
				width = 32, 
				height = 32,
				defaultFrame = sheetOptions:getFrameIndex( "tabBar_iconInactive" ),
				overFrame = sheetOptions:getFrameIndex( "tabBar_iconActive" ),
				label = "Tab2",
				onPress = function( event ) print( "Tab 2 pressed" ) end,
				selected = true
			},
			{
				width = 32, 
				height = 32,
				defaultFrame = sheetOptions:getFrameIndex( "tabBar_iconInactive" ),
				overFrame = sheetOptions:getFrameIndex( "tabBar_iconActive" ),
				label = "Tab3",
				onPress = function() print( "Tab 3 pressed" ) end,
				selected = false
			},
			{
				width = 32, 
				height = 32,
				defaultFrame = sheetOptions:getFrameIndex( "tabBar_iconInactive" ),
				overFrame = sheetOptions:getFrameIndex( "tabBar_iconActive" ),
				label = "Tab4",
				onPress = function() print( "Tab 4 pressed" ) end,
				selected = false
			},
		}
	
		-- Create a tabBar
		tabBar = widget.newTabBar
		{
			left = 0,
			top = display.contentHeight - 52,
			width = display.contentWidth,
			sheet = imageSheet,
			backgroundFrame = sheetOptions:getFrameIndex( "tabBar_background" ),
			tabSelectedLeftFrame = sheetOptions:getFrameIndex( "tabBar_tabSelectedLeftEdge" ),
			tabSelectedRightFrame = sheetOptions:getFrameIndex( "tabBar_tabSelectedRightEdge" ),
			tabSelectedMiddleFrame = sheetOptions:getFrameIndex( "tabBar_tabSelectedMiddle" ),
			tabSelectedFrameWidth = 5,
			tabSelectedFrameHeight = 49,
			buttons = tabButtonsImageSheet,
		}
		group:insert( tabBarImageSheet )
	end	
	
	
	
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

	-- Create the widget
	local tabBar2 = widget.newTabBar
	{
		top = display.contentHeight-120,
		width = display.contentWidth,
		buttons = tabButtons
	}
	group:insert( tabBar2 )

	----------------------------------------------------------------------------------------------------------------
	--											TESTS
	----------------------------------------------------------------------------------------------------------------
	
	if TEST_SET_BUTTON_ACTIVE then
		testTimer = timer.performWithDelay( 2000, function()
			tabBar:setSelected( 4, true )
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
