-- Copyright (C) 2013 Corona Inc. All Rights Reserved.
-- File: newPickerWheel unit test.

local widget = require( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

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
	local returnToListing = widget.newButton{
	    id = "returnToListing",
	    left = 60,
	    top = backButtonPosition,
	    label = "Exit",
	    width = 200, height = backButtonSize,
	    onRelease = function() storyboard.gotoScene( "unitTestListing" ) end;
	}
	returnToListing.x = display.contentCenterX
	group:insert( returnToListing )
	
	----------------------------------------------------------------------------------------------------------------
	--										START OF UNIT TEST
	----------------------------------------------------------------------------------------------------------------
	
	local days = {}
	local years = {}
	
	for i = 1, 31 do
		days[i] = i
	end
	
	for i = 1, 44 do
		years[i] = 1969 + i
	end
	
	-- Set up the Picker Wheel's columns
	local columnData = 
	{ 
		{ 
			align = "right",
			width = 140,
			startIndex = 1,
			labels = 
			{
				"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" 
			},
		},

		{
			align = "center",
			width = 60,
			startIndex = 18,
			labels = days,
		},
		
		{
			align = "right",
			width = 80,
			startIndex = 10,
			labels = years,
		},
	}
		
	-- Create a new Picker Wheel
	local pickerWheel = widget.newPickerWheel
	{
		top = display.contentHeight - 444,
		columns = columnData,
	}
	group:insert( pickerWheel )
	
	-- Scroll the second column to it's 8'th row
	--pickerWheel:scrollToIndex( 2, 8, 0 )
	
	
	
	local function showValues( event )		
		local values = pickerWheel:getValues()
		
		--print( values )
		
		---[[
		for i = 1, #values do
			print( "Column", i, "value is:", values[i].value )
			--print( "Column", i, "index is:", values[i].index )
		end
		--]]
		
		return true
	end
	
	
	local getValuesButton = widget.newButton{
	    id = "getValues",
	    --left = display.contentWidth * 0.5,
	    top = 300,
	    label = "print() values",
	    width = 200, height = backButtonSize,
	    onRelease = showValues;
	}
	getValuesButton.x = display.contentCenterX
	group:insert( getValuesButton )
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
