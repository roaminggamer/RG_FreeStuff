--*********************************************************************************************
--
-- ====================================================================
-- Corona "Widget" Sample Code
-- ====================================================================
--
-- File: main.lua
--
-- Version 2.0
--
-- Copyright (C) 2014 Corona Labs Inc. All Rights Reserved.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of 
-- this software and associated documentation files (the "Software"), to deal in the 
-- Software without restriction, including without limitation the rights to use, copy, 
-- modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
-- and to permit persons to whom the Software is furnished to do so, subject to the 
-- following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all copies 
-- or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.
--
-- Published changes made to this software and associated documentation and module files (the
-- "Software") may be used and distributed by Corona Labs, Inc. without notification. Modifications
-- made to this software and associated documentation and module files may or may not become
-- part of an official software release. All modifications made to the software will be
-- licensed under these same terms and conditions.
--
-- Supports Graphics 2.0
--*********************************************************************************************

local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene()

-- Create scene
function scene:create( event )
	local sceneGroup = self.view
	local ox, oy = math.abs(display.screenOriginX), math.abs(display.screenOriginY)
	local tabBarHeight = composer.getVariable( "tabBarHeight" )
	local themeID = composer.getVariable( "themeID" )
	
	-- Adjust label color for some themes
	local labelColor = { 0 }
	if ( themeID == "widget_theme_android_holo_dark" ) then
		labelColor = { 1 }
	end
	
	-- Status text box
	local statusBox = display.newRect( 40, 60, display.contentWidth-80, 70 )
	statusBox.anchorX = 0
	statusBox:setFillColor( 0, 0, 0, 0.32 )
	sceneGroup:insert( statusBox )
	
	-- Status text
	local statusText = display.newText( "Column 1 Value: May\nColumn 2 Value: 18\nColumn 3 Value: 1990", 80, 350, 200, 0, native.systemFont, 14 )
	statusText:setFillColor( unpack(labelColor) )
	statusText.anchorX = 0
	statusText.x = 60
	statusText.y = 95
	sceneGroup:insert( statusText )

	statusBox.height = statusText.height+16
	statusBox.y = statusText.y


	-- Set up the picker column data
	local days = {}
	local years = {}
	for i = 1,31 do days[i] = i end
	for j = 1,47 do years[j] = 1969+j end

	local columnData = { 
		{
			align = "right",
			width = 125,
			startIndex = 5,
			labels = {
				"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" 
			},
		},
		{
			align = "center",
			width = 70,
			startIndex = 18,
			labels = days,
		},
		{
			align = "center",
			width = 65,
			startIndex = 21,
			labels = years,
		},
	}
		
	-- Create a new Picker Wheel
	local pickerWheel = widget.newPickerWheel {
		top = display.contentHeight-222-tabBarHeight-20+oy,
		columns = columnData
	}
	pickerWheel.x = display.contentCenterX
	sceneGroup:insert( pickerWheel )

	
	local function showValues( event )
		-- Retrieve the current values from the picker
		local values = pickerWheel:getValues()
		
		-- Update the status box text
		statusText.text = "Column 1 Value: " .. values[1].value .. "\nColumn 2 Value: " .. values[2].value .. "\nColumn 3 Value: " .. values[3].value
		--[[
		for i = 1, #values do
			print( "Column", i, "value is:", values[i].value )
			print( "Column", i, "index is:", values[i].index )
		end
		--]]
		
		return true
	end
	
	local getValuesButton = widget.newButton {
		left = 10,
		top = 135,
		width = 192,
		height = 32,
		id = "getValues",
		label = "update values",
		onRelease = showValues,
	}
	sceneGroup:insert( getValuesButton )
	getValuesButton.x = display.contentCenterX

end

scene:addEventListener( "create" )

return scene
