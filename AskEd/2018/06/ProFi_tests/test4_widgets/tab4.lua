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
	local statusBox = display.newRect( 80, 0, 210, 70 )
	statusBox.anchorX = 0
	statusBox:setFillColor( 0, 0, 0 )
	statusBox.alpha = 0.32
	sceneGroup:insert( statusBox )
	
	-- Status text
	local statusText = display.newText( "Interact with a Widget...\n", 0, 385, 190, 0, native.systemFont, 14 )
	statusText:setFillColor( unpack(labelColor) )
	statusText.anchorX = 0
	statusText.x = 100
	sceneGroup:insert( statusText )
	
	statusBox.height = statusText.height+16
	statusBox.y = statusText.y
	
	---------------------------------------------------------------------------------------------
	-- widget.newSegmentedControl()
	---------------------------------------------------------------------------------------------

	local function segmentedControlListener( event )
		local target = event.target
		statusText.text = "Segmented Control\nself.segmentNumber = " .. target.segmentNumber
	end
	
	-- Create a default segmented control (using widget.setTheme)
	local segmentedControl = widget.newSegmentedControl {
	    left = 10,
	    top = 0,
	    segments = { "Corona", "Widget", "Demo" },
	    defaultSegment = 1,
		 segmentWidth = 88,
	    onPress = segmentedControlListener
	}
	sceneGroup:insert( segmentedControl )
	segmentedControl.x = display.contentCenterX
	segmentedControl.y = 70
	
	---------------------------------------------------------------------------------------------
	-- widget.newSlider()
	---------------------------------------------------------------------------------------------
	
	local function sliderListener( event )
		statusText.text = event.target.id .. "\nslider.value = " .. event.value .. " (%)"
	end
	
	-- Create a horizontal slider
	local horizontalSlider = widget.newSlider {
		left = 80,
		top = 285,
		width = 140,
		id = "Horizontal Slider",
		listener = sliderListener
	}
	sceneGroup:insert( horizontalSlider )

	-- Create a vertical slider
	local verticalSlider = widget.newSlider {
		left = 20,
		top = 275,
		height = 140,
		value = 80,
		id = "Vertical Slider",
		orientation = "vertical",
		listener = sliderListener,
	}
	sceneGroup:insert( verticalSlider )
	
	---------------------------------------------------------------------------------------------
	-- widget.newSpinner()
	---------------------------------------------------------------------------------------------
	
	-- Create a spinner widget
	local spinner = widget.newSpinner {
		left = 250,
		top = 0,
	}
	sceneGroup:insert( spinner )
	spinner.y = horizontalSlider.y

	spinner:start()
	
	---------------------------------------------------------------------------------------------
	-- widget.newStepper()
	---------------------------------------------------------------------------------------------
	
	local function stepperListener( event )
		statusText.text = "Stepper\nevent.value = " .. string.format( "%02d", event.value )
	end
	
	local newStepper = widget.newStepper {
	    left = 24,
	    top = 112,
	    initialValue = 0,
	    minimumValue = 0,
	    maximumValue = 80,
		 timerIncrementSpeed = 500,
		 changeSpeedAtIncrement = 4,
	    onPress = stepperListener
	}
	sceneGroup:insert( newStepper )
	newStepper.x = display.contentCenterX
	
	---------------------------------------------------------------------------------------------
	-- widget.newProgressView()
	---------------------------------------------------------------------------------------------
	
	local newProgressView = widget.newProgressView {
		left = 30,
		top = 240,
		width = 260,
		isAnimated = true,
	}
	sceneGroup:insert( newProgressView )

	local currentProgress = 0.0
	local function increaseProgressView()
		currentProgress = currentProgress + 0.02
		newProgressView:setProgress( currentProgress )
	end
	timer.performWithDelay( 100, increaseProgressView, 50 )

	---------------------------------------------------------------------------------------------
	-- widget.newSwitch() "radio"
	---------------------------------------------------------------------------------------------

	local radioButtonText = display.newText( "Radio", 64, 160, native.systemFont, 14 )
	radioButtonText.anchorY = 0
	radioButtonText:setFillColor( unpack(labelColor) )
	sceneGroup:insert( radioButtonText )

	local function radioSwitchListener( event )
		statusText.text = event.target.id .. "\nswitch.isOn = " .. tostring( event.target.isOn )
	end
	
	local radioButton1 = widget.newSwitch {
	    left = 25,
	    top = 180,
	    style = "radio",
	    id = "Radio Switch 1",
	    initialSwitchState = true,
	    onPress = radioSwitchListener,
	}
	sceneGroup:insert( radioButton1 )
	radioButton1.x = radioButtonText.x-18
	radioButton1.y = 200
	
	local radioButton2 = widget.newSwitch {
	    left = 55,
	    top = 180,
	    style = "radio",
	    id = "Radio Switch 2",
	    onPress = radioSwitchListener,
	}
	sceneGroup:insert( radioButton2 )
	radioButton2.x = radioButtonText.x+18
	radioButton2.y = 200
	
	---------------------------------------------------------------------------------------------
	-- widget.newSwitch() "checkbox"
	---------------------------------------------------------------------------------------------

	local checkboxText = display.newText( "Checkbox", 150, 160, native.systemFont, 14 )
	checkboxText.anchorY = 0
	checkboxText:setFillColor( unpack(labelColor) )
	sceneGroup:insert( checkboxText )

	local function checkboxSwitchListener( event )
		statusText.text = "Checkbox Switch\nswitch.isOn = " .. tostring( event.target.isOn )
	end
	
	-- Create a default checkbox button (using widget.setTheme)
	local checkboxSwitch = widget.newSwitch {
	    left = 120,
	    top = 180,
	    style = "checkbox",
	    id = "Checkbox button",
	    onPress = checkboxSwitchListener,
	}
	sceneGroup:insert( checkboxSwitch )
	checkboxSwitch.x = checkboxText.x
	checkboxSwitch.y = 200
	
	---------------------------------------------------------------------------------------------
	-- widget.newSwitch() "onOff"
	---------------------------------------------------------------------------------------------

	local switchText = display.newText( "On/Off", 250, 160, native.systemFont, 14 )
	switchText.anchorY = 0
	switchText:setFillColor( unpack(labelColor) )
	sceneGroup:insert( switchText )

	local function onOffSwitchListener( event )
		statusText.text = "On/Off Switch\nswitch.isOn = " .. tostring( event.target.isOn )
	end

	-- Create a default on/off switch (using widget.setTheme)
	local onOffSwitch = widget.newSwitch
	{
	    left = 190,
	    top = 180,
	    --onPress = onOffSwitchListener,
	    onRelease = onOffSwitchListener,
	}
	sceneGroup:insert( onOffSwitch )
	onOffSwitch.x = switchText.x
	onOffSwitch.y = 200
end

scene:addEventListener( "create" )

return scene
