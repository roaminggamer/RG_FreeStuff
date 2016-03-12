-- Copyright (C) 2013 Corona Inc. All Rights Reserved.

local widget = require( "widget" )

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local USE_IOS_THEME = false
local USE_IOS7_THEME = false
local USE_ANDROID_THEME = false
local USE_ANDROID_HOLO_LIGHT_THEME = false
local USE_ANDROID_HOLO_DARK_THEME = false



local isGraphicsV1 = ( 1 == display.getDefault( "graphicsCompatibility" ) )

local topGrayColor = { 0.92, 0.92, 0.92, 1 }
local separatorColor = { 0.77, 0.77, 0.77, 1 }
local headerTextColor = { 0, 0, 0, 1 }

if isGraphicsV1 then
	widget._convertColorToV1( topGrayColor )
	widget._convertColorToV1( separatorColor )	
	widget._convertColorToV1( headerTextColor )
end

function scene:createScene( event )	
	local group = self.view
	
	-- Set theme
	if USE_ANDROID_THEME then
		widget.setTheme( "widget_theme_android" )
	end
	
	if USE_IOS_THEME then
		widget.setTheme( "widget_theme_ios" )
	end
	
	if USE_IOS7_THEME then
		widget.setTheme( "widget_theme_ios7" )
	end

	if USE_ANDROID_HOLO_LIGHT_THEME then
		widget.setTheme( "widget_theme_android_holo_light" )
	end

	if USE_ANDROID_HOLO_DARK_THEME then
		widget.setTheme( "widget_theme_android_holo_dark" )
	end

	local xAnchor, yAnchor
	
	if not isGraphicsV1 then
		xAnchor = display.contentCenterX
		yAnchor = display.contentCenterY
	else
		xAnchor = 0
		yAnchor = 0
	end

	local background = display.newRect( xAnchor, yAnchor, display.contentWidth, display.contentHeight )

	if USE_IOS_THEME then
		if isGraphicsV1 then background:setFillColor( 197, 204, 212, 255 )
		else background:setFillColor( 197/255, 204/255, 212/255, 1 ) end
		widget.USE_IOS_THEME = true
	elseif USE_ANDROID_HOLO_LIGHT_THEME then
		if isGraphicsV1 then background:setFillColor( 255, 255, 255, 255 )
		else background:setFillColor( 1, 1, 1, 1 ) end
		widget.USE_ANDROID_HOLO_LIGHT_THEME = true
	elseif USE_ANDROID_HOLO_DARK_THEME then
		if isGraphicsV1 then background:setFillColor( 34, 34, 34, 255 )
		else background:setFillColor( 34/255, 34/255, 34/255, 1 ) end
		widget.USE_ANDROID_HOLO_DARK_THEME = true
		headerTextColor = { 0.5 }
	else
		if isGraphicsV1 then background:setFillColor( 255, 255, 255, 255 )
		else background:setFillColor( 1, 1, 1, 1 ) end
	end
	group:insert( background )
	
	-- create some skinning variables
	local fontUsed = native.systemFont
	local headerTextSize = 20
	local separatorColor = { unpack( separatorColor ) }
	
	local title = display.newText( group, "Select a unit test to view", 0, 0, fontUsed, headerTextSize )
	title:setFillColor( unpack( headerTextColor ) )
	title.x, title.y = display.contentCenterX, 20
	group:insert( title )
	
	if USE_IOS7_THEME then
		local separator = display.newRect( group, display.contentCenterX, title.contentHeight + title.y, display.contentWidth, 0.5 )
		separator:setFillColor( unpack ( separatorColor ) )
	end
	
	--Go to selected unit test
	local function gotoSelection( event )
		local phase = event.phase
		
		if "ended" == phase then
			local targetScene = event.target.id
			storyboard.gotoScene( targetScene )
		end
		
		return true
	end

	local buttonX = 160

	-- spinner unit test
	local spinnerButton = widget.newButton
	{
	    id = "spinner",
	    x = buttonX,
	    y = 75,
	    label = "Spinner",
	    width = 200, height = 34,
	    emboss = false,
	    onEvent = gotoSelection
	}
	group:insert( spinnerButton )
	
	-- switch unit test
	local switchButton = widget.newButton
	{
	    id = "switch",
	    x = buttonX,
	    y = spinnerButton.y + 36,
	    label = "Switch",
	    width = 200, height = 34,
	    emboss = false,
	    onEvent = gotoSelection
	}
	group:insert( switchButton )
	
	-- Stepper unit test
	local stepperButton = widget.newButton
	{
	    id = "stepper",
	    x = buttonX,
	    y = switchButton.y + 36,
	    label = "Stepper",
	    width = 200, height = 34,
	    emboss = false,
	    onEvent = gotoSelection
	}
	group:insert( stepperButton )
	
	
	-- Search field unit test
	--[[
	local searchFieldButton = widget.newButton
	{
	    id = "searchField",
	    x = buttonX,
	    y = stepperButton.y + 36,
	    label = "Search Field",
	    width = 200, height = 34,
	    emboss = false,
	    onEvent = gotoSelection
	}
	group:insert( searchFieldButton )
	--]]

	-- progressView unit test
	local progressViewButton = widget.newButton
	{
	    id = "progressView",
	    x = buttonX,
	    y = stepperButton.y + 36,
	    label = "ProgressView",
	    width = 200, height = 34,
	    emboss = false,
	    onEvent = gotoSelection
	}
	group:insert( progressViewButton )
	
	-- segmentedControl unit test
	local segmentedControlButton = widget.newButton
	{
	    id = "segmentedControl",
	    x = buttonX,
	    y = progressViewButton.y + 36,
	    label = "SegmentedControl",
	    width = 200, height = 34,
	    emboss = false,
	    onEvent = gotoSelection
	}
	group:insert( segmentedControlButton )
	
	-- button unit test
	local buttonButton = widget.newButton
	{
	    id = "button",
	    x = buttonX,
	    y = segmentedControlButton.y + 36,
	    label = "Button",
	    width = 200, height = 34,
	    emboss = false,
	    onEvent = gotoSelection
	}
	group:insert( buttonButton )
	
	-- tabBar unit test
	local tabBarButton = widget.newButton
	{
	    id = "tabBar",
	    x = buttonX,
	    y = buttonButton.y + 36,
	    label = "TabBar",
	    width = 200, height = 34,
	    emboss = false,
	    onEvent = gotoSelection
	}
	group:insert( tabBarButton )
	
	-- slider unit test
	local sliderButton = widget.newButton
	{
	    id = "slider",
	    x = buttonX,
	    y = tabBarButton.y + 36,
	    label = "Slider",
	    width = 200, height = 34,
	    emboss = false,
	    onEvent = gotoSelection
	}
	group:insert( sliderButton )
	
	-- picker unit test
	local pickerButton = widget.newButton
	{
	    id = "picker",
	    x = buttonX,
	    y = sliderButton.y + 36,
	    label = "PickerWheel",
	    width = 200, height = 34,
	    emboss = false,
	    onEvent = gotoSelection
	}
	group:insert( pickerButton )
	
	-- tableView unit test
	local tableViewButton = widget.newButton
	{
	    id = "tableView",
	    x = buttonX,
	    y = pickerButton.y + 36,
	    label = "TableView",
	    width = 200, height = 34,
	    emboss = false,
	    onEvent = gotoSelection
	}
	group:insert( tableViewButton )
	
	-- scrollView unit test
	local scrollViewButton = widget.newButton
	{
	    id = "scrollView",
	    x = buttonX,
	    y = tableViewButton.y + 36,
	    label = "ScrollView",
	    width = 200, height = 34,
	    emboss = false,
	    onEvent = gotoSelection
	}
	group:insert( scrollViewButton )

end

function scene:didExitScene( event )
	storyboard.removeAll()
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "didExitScene", scene )

return scene
