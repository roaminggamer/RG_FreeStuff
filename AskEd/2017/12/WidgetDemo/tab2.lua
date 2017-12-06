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
	
	-- Adjust background color for some themes
	local backgroundColor = { 240/255 }
	if ( themeID == "widget_theme_android_holo_dark" ) then
		backgroundColor = { 48/255 }
	end
	
	-- scrollView listener
	local function scrollListener( event )
		local phase = event.phase
		local direction = event.direction
		
		if "began" == phase then
			--print( "Began" )
		elseif "moved" == phase then
			--print( "Moved" )
		elseif "ended" == phase then
			--print( "Ended" )
		end
		
		-- If the scrollView has reached its scroll limit
		if event.limitReached then
			if "up" == direction then
				--print( "Reached Top Limit" )
			elseif "down" == direction then
				--print( "Reached Bottom Limit" )
			elseif "left" == direction then
				--print( "Reached Left Limit" )
			elseif "right" == direction then
				--print( "Reached Right Limit" )
			end
		end

		return true
	end

	-- Create a scrollView
	local scrollView = widget.newScrollView {
		left = 20-ox,
		top = 62,
		width = display.contentWidth+ox+ox-60,
		height = display.contentHeight-32-tabBarHeight-120,
		hideBackground = false,
		backgroundColor = backgroundColor,
		--isBounceEnabled = false,
		horizontalScrollDisabled = false,
		verticalScrollDisabled = false,
		listener = scrollListener
	}
	sceneGroup:insert( scrollView )
	
	-- Insert an image into the scrollView
	local background = display.newImageRect( "assets/scrollimage.png", 460, 512 )
	background.x = background.contentWidth * 0.5
	background.y = background.contentHeight * 0.5
	scrollView:insert( background )

	-------------------------------------------------------------------------
	-- Insert various other widgets into scrollView to exhibit functionality
	-------------------------------------------------------------------------
	
	-- Radio button set
	local radioGroup = display.newGroup()
	local radioButton = widget.newSwitch {
		left = 20,
		style = "radio",
		initialSwitchState = true
	}
	radioGroup:insert( radioButton )
	radioButton.y = 50

	local radioButton2 = widget.newSwitch {
		style = "radio"
	}
	radioGroup:insert( radioButton2 )
	radioButton2.x = radioButton.x+radioButton.width
	radioButton2.y = 50
	scrollView:insert( radioGroup )
	
	-- Checkbox
	local checkboxButton = widget.newSwitch {
		style = "checkbox"
	}
	checkboxButton.x = radioButton2.x+radioButton2.width+20
	checkboxButton.y = 50
	scrollView:insert( checkboxButton )
	
	-- On/off switch
	local onOffSwitch = widget.newSwitch {
		style = "onOff",
		initialSwitchState = false
	}
	onOffSwitch.y = 50
	scrollView:insert( onOffSwitch )
	
	-- Stepper
	local stepper = widget.newStepper {
		left = 20,
		top = 80,
		initialValue = 4,
		minimumValue = 0,
		maximumValue = 25
	}
	scrollView:insert( stepper )
	
	-- Progress view
	local progressView = widget.newProgressView {
		left = 130,
		width = 125,
		isAnimated = true,
	}
	scrollView:insert( progressView )
	progressView.y = stepper.y
	local currentProgress = 0.0
	testTimer = timer.performWithDelay( 100, function( event )
		currentProgress = currentProgress + 0.01
		progressView:setProgress( currentProgress )
	end, 50 )
	
	onOffSwitch.x = progressView.x+12
	
end

scene:addEventListener( "create" )

return scene
