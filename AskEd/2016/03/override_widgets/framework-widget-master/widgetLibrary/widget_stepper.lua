-- Copyright © 2013 Corona Labs Inc. All Rights Reserved.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
--    * Redistributions of source code must retain the above copyright
--      notice, this list of conditions and the following disclaimer.
--    * Redistributions in binary form must reproduce the above copyright
--      notice, this list of conditions and the following disclaimer in the
--      documentation and/or other materials provided with the distribution.
--    * Neither the name of the company nor the names of its contributors
--      may be used to endorse or promote products derived from this software
--      without specific prior written permission.
--    * Redistributions in any form whatsoever must retain the following
--      acknowledgment visually in the program (e.g. the credits of the program): 
--      'This product includes software developed by Corona Labs Inc. (http://www.coronalabs.com).'
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL CORONA LABS INC. BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

local M = 
{
	_options = {},
	_widgetName = "widget.newStepper",
}


-- Require needed widget files
local _widget = require( "widget" )

local isGraphicsV1 = ( 1 == display.getDefault( "graphicsCompatibility" ) )

-- Localize math functions
local mHuge = math.huge

-- Creates a new stepper from a sprite
local function initWithSprite( stepper, options )
	-- Create a local reference to our options table
	local opt = options
	
	-- Animation options
	local sheetOptions = 
	{ 
		{
			name = "default", 
			start = opt.defaultFrame,
			count = 1,
			time = 1,
		},
		
		{
			name = "noMinus",
			start = opt.noMinusFrame,
			count = 1,
			time = 1,
		},
		
		{
			name = "noPlus",
			start = opt.noPlusFrame,
			count = 1,
			time = 1,
		},
		
		{
			name = "minusActive",
			start = opt.minusActiveFrame,
			count = 1,
			time = 1,
		},
		
		{
			name = "plusActive",
			start = opt.plusActiveFrame,
			count = 1,
			time = 1,
		},
		
	}
	
	-- Forward references
	local imageSheet, view, decrementOverlay, incrementOverlay
	
	-- Create the imageSheet
	if opt.sheet then
		imageSheet = opt.sheet
	else
		local themeData = require( opt.themeData )
		imageSheet = graphics.newImageSheet( opt.themeSheetFile, themeData:getSheet() )
	end
	
	-- Create the view
	view = display.newSprite( stepper, imageSheet, sheetOptions )
	view:setSequence( "default" )
	view.x = stepper.x + ( view.contentWidth * 0.5 )
	view.y = stepper.y + ( view.contentHeight * 0.5 )
	
	-- Create the decrement overlay rectangle
	decrementOverlay = display.newRect( stepper, 0, 0, ( view.contentWidth * 0.5 ) - 1, view.contentHeight )
	decrementOverlay.x = view.x - ( decrementOverlay.contentWidth * 0.5 ) - 1
	decrementOverlay.y = view.y
	decrementOverlay.isVisible = false
	decrementOverlay.isHitTestable = true
	
	-- Create the increment overlay rectangle
	incrementOverlay = display.newRect( stepper, 0, 0, ( view.contentWidth * 0.5 ) , view.contentHeight )
	incrementOverlay.x = view.x + ( incrementOverlay.contentWidth * 0.5 )
	incrementOverlay.y = view.y
	incrementOverlay.isVisible = false
	incrementOverlay.isHitTestable = true
	
	-------------------------------------------------------
	-- Assign properties to the view
	-------------------------------------------------------
	
	-- Assign to the view
	view._timerIncrementSpeed = opt.timerIncrementSpeed or 1000
	view._changeIncrementSpeedAtTime = view._timerIncrementSpeed
	view._increments = 0
	view._changeSpeedAtIncrement = opt.changeSpeedAtIncrement or 5
	view._timer = nil
	view._minimumValue = opt.minimumValue
	view._maximumValue = opt.maximumValue
	view._currentValue = opt.initialValue
	view._event = {} -- Our event table for the view
	view._previousX = 0
	view._onPress = opt.onPress
	
	-- Assign objects to the view
	view._decrementOverlay = decrementOverlay
	view._incrementOverlay = incrementOverlay
	
	-- If the startNumber is equal to/greater than the minimum or maxium values, set the steppers image sequence to reflect it
	if view._currentValue <= view._minimumValue then
		view:setSequence( "noMinus" )
	elseif view._currentValue >= view._maximumValue then
		view._currentValue = view._maximumValue
		view:setSequence( "noPlus" )
	end
	
	-------------------------------------------------------
	-- Assign properties/objects to the stepper
	-------------------------------------------------------
	
	-- Assign objects to the stepper
	stepper._imageSheet = imageSheet
	stepper._view = view
	
	-- 
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	-- Function to set the stepper's value programatically
	function stepper:setValue( newValue )
		return self._view:_setValue( newValue )
	end
	
	-- Getter for the stepper's value
	function stepper:getValue()
		return self._view:_getValue()
	end
	
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Handle touch events on the stepper
	function view:touch( event )
		local phase = event.phase
		local _stepper = self.parent
		event.target = _stepper
		
		-- The content bounds of our increment/decrement segments
		local decrementBounds = self._decrementOverlay.contentBounds
		local incrementBounds = self._incrementOverlay.contentBounds
		
		if "began" == phase then
			-- Set focus on the stepper (if focus isn't already on it)
			if not self._isFocus then
				display.getCurrentStage():setFocus( self, event.id )
       			self._isFocus = true
       		end
			
			-- If we have pressed the right side of the stepper (the plus)
			if event.x >= incrementBounds.xMin and event.x <= incrementBounds.xMax then
				self:_dispatchIncrement()
			elseif event.x >= decrementBounds.xMin and event.x <= decrementBounds.xMax then
				-- We have pressed the left side of the stepper (the minus)
				self:_dispatchDecrement()
			end
			
			-- Set the previous x position of the event
			self._previousX = event.x
			
			-- Manage the steppers pressed state ( & animation )
			self:_manageStepperPressState()
			
			-- Exectute the onPress method if there is one
			if self._onPress then
				self._onPress( self._event )
			end
	
		elseif self._isFocus then
			if "moved" == phase then
				-- Handle switching from one side of the stepper to the other whilst still holding your finger on the screen
				if event.x >= incrementBounds.xMin and event.x <= incrementBounds.xMax then
					if self._event.phase ~= "increment" then
						self:dispatchEvent( { name = "touch", phase = "began", x = event.x } )
					end
				elseif event.x >= decrementBounds.xMin and event.x <= decrementBounds.xMax then
            		-- Dispatch a touch event to self
            		if self._event.phase ~= "decrement" then
						self:dispatchEvent( { name = "touch", phase = "began", x = event.x } )
					end
				end
		
			elseif "ended" == phase or "cancelled" == phase then
				-- Manage the steppers released state
				view:_manageStepperReleaseState()
				
				-- Remove focus from stepper
            	display.getCurrentStage():setFocus( self, nil )
            	self._isFocus = false
			end
		end
		
		return true
	end
	
	view:addEventListener( "touch" )
	

	-- Function to dispatch a increment event for the stepper
	function view:_dispatchIncrement()
		local newPhase = nil
		
		-- If the currentNumber is less then the maxiumum value then set the phase to "increment"
		if self._currentValue < self._maximumValue then
			newPhase = "increment"
			self._currentValue = self._currentValue + 1
		else
			-- The currentNumber is more then the maxiumum value, set the phase to "maxLimit"
			newPhase = "maxLimit"
		end
		
		-- Set up the event to dispatch
		local eventToDispatch = 
		{
			phase = newPhase,
			target = stepper,
			value = self._currentValue,
			minimumValue = self._minimumValue,
			maximumValue = self._maximumValue,
		}
		
		-- Pass the event
		self._event = eventToDispatch
	end
	
	-- Function to dispatch a decrement event for the stepper
	function view:_dispatchDecrement()
		local newPhase = nil
		
		-- If the currentNumber is more then the minimum value then set the phase to "decrement"
		if self._currentValue > self._minimumValue then
			newPhase = "decrement"
			self._currentValue = self._currentValue - 1
		else
			-- The currentNumber is less then the minimum value, set the phase to "minLimit"
			newPhase = "minLimit"
		end
		
		-- Set up the event to dispatch
		local eventToDispatch = 
		{
			phase = newPhase,
			target = stepper,
			value = self._currentValue,
			minimumValue = self._minimumValue,
			maximumValue = self._maximumValue,
		}
		
		-- Pass the event
		self._event = eventToDispatch
	end
		
	-- Function to manage the steppers pressed/held touch state
	function view:_manageStepperPressState()
		local phase = self._event.phase
		
		-- Start the steppers timer		
		if not self._timer then
			self._timer = timer.performWithDelay( self._changeIncrementSpeedAtTime, self, 0 )
		end
		
		-- Set the steppers sequence according to the phase
		if "increment" == phase then
			self:setSequence( "plusActive" )
		elseif "decrement" == phase then
			self:setSequence( "minusActive" )
		elseif "maxLimit" == phase then
			self:setSequence( "noPlus" )
		elseif "minLimit" == phase then
			self:setSequence( "noMinus" )
		end
	end
	
	-- Function to manage the stepper's released touch state (released ie not being touched)
	function view:_manageStepperReleaseState()
		-- Set the steppers default sequence
		if self._currentValue > self._minimumValue and self._currentValue < self._maximumValue then
			self:setSequence( "default" )
		end
		
		-- Change the steppers sequence according to if it reaches it's max or min range
		if self._currentValue >= self._maximumValue then
			self:setSequence( "noPlus" )
		elseif self._currentValue <= self._minimumValue then
			self:setSequence( "noMinus" )
		end
		
		-- Cancel the timer and reset the changeTime
		if self._timer then
			self:_cancelTimer()
			self._changeIncrementSpeedAtTime = self._timerIncrementSpeed
		end
	end
	
	-- Function to increment/decrement the steppers values while touch on the stepper is held/active - Speed of the increment/decrement ramps up linearly
	function view:timer()
		-- Increase the increments
		self._increments = self._increments + 1
		
		-- If the current increment is more or equal to the requested change value
		if self._increments >= self._changeSpeedAtIncrement then
			-- Cancel any active timer
			self:_cancelTimer()
			
			-- Half the Increment speed
			self._changeIncrementSpeedAtTime = self._changeIncrementSpeedAtTime * 0.5
			
			-- Re-start the timer at the new incremental value
			if not self._timer then
				self._timer = timer.performWithDelay( self._changeIncrementSpeedAtTime, self, 0 )
			end
			
			-- Reset the increments back to 0
			self._increments = 0
		end
		
		-- Dispatch a touch event to self
		self:dispatchEvent( { name = "touch", phase = "began", x = self._previousX } )
	end
	
	-- Function to cancel the stepper's timer
	function view:_cancelTimer()
		if self._timer then
			timer.cancel( self._timer )
			self._timer = nil
		end
	end
	
	-- Function to set the stepper's value programatically
	function view:_setValue( newValue )
		local value = newValue or self._currentValue
		self._currentValue = newValue
	end

	-- Getter for the stepper's value
	function view:_getValue()
		return self._currentValue
	end
	
	-- Finalize function
	function stepper:_finalize()
		-- Nil out the stepper's event table
		self._view._event = nil
		
		-- Cancel the timer
		self._view:_cancelTimer()
		
		-- Set the ImageSheet to nil
		self._imageSheet = nil
	end
	
	-- Commented this out. There's obviously an error returning self from a method that has no return
	--return self
end


-- Function to create a new Stepper object ( widget.newStepper)
function M.new( options, theme )	
	local customOptions = options or {}
	local themeOptions = theme or {}
	
	-- Create a local reference to our options table
	local opt = M._options
	
	-- Check if the requirements for creating a widget has been met (throws an error if not)
	_widget._checkRequirements( customOptions, themeOptions, M._widgetName )
	
	-------------------------------------------------------
	-- Properties
	-------------------------------------------------------	
	-- Positioning & properties
	opt.left = customOptions.left or 0
	opt.top = customOptions.top or 0
	opt.x = customOptions.x or nil
	opt.y = customOptions.y or nil
	if customOptions.x and customOptions.y then
		opt.left = 0
		opt.top = 0
	end
	opt.width = customOptions.width or themeOptions.width or error( "ERROR: " .. M._widgetName .. ": width expected, got nil", 3 )
	opt.height = customOptions.height or themeOptions.height or error( "ERROR: " .. M._widgetName .. ": height expected, got nil", 3 )
	opt.id = customOptions.id
	opt.baseDir = customOptions.baseDir or system.ResourceDirectory
	opt.initialValue = customOptions.initialValue or 0
	opt.minimumValue = customOptions.minimumValue or 0
	opt.maximumValue = customOptions.maximumValue or mHuge
	opt.onPress = customOptions.onPress
	opt.onHold = customOptions.onHold
	opt.timerIncrementSpeed = customOptions.timerIncrementSpeed or 1000
	opt.changeSpeedAtIncrement = customOptions.changeSpeedAtIncrement or 5
	
	-- Frames & Images
	opt.sheet = customOptions.sheet
	opt.themeSheetFile = themeOptions.sheet
	opt.themeData = themeOptions.data
	
	opt.defaultFrame = customOptions.defaultFrame or _widget._getFrameIndex( themeOptions, themeOptions.defaultFrame )
	opt.noMinusFrame = customOptions.noMinusFrame or _widget._getFrameIndex( themeOptions, themeOptions.noMinusFrame )
	opt.noPlusFrame = customOptions.noPlusFrame or _widget._getFrameIndex( themeOptions, themeOptions.noPlusFrame )
	opt.minusActiveFrame = customOptions.minusActiveFrame or _widget._getFrameIndex( themeOptions, themeOptions.minusActiveFrame )
	opt.plusActiveFrame = customOptions.plusActiveFrame or _widget._getFrameIndex( themeOptions, themeOptions.plusActiveFrame )
	
	-------------------------------------------------------
	-- Create the Stepper
	-------------------------------------------------------
		
	-- Create the stepper object
	local stepper = _widget._new
	{
		left = opt.left,
		top = opt.top,
		id = opt.id or "widget_stepper",
		baseDir = opt.baseDir,
	}

	-- Create the stepper
	initWithSprite( stepper, opt )
	
	-- Set the stepper's position ( set the reference point to center, just to be sure )
	
	if ( isGraphicsV1 ) then
		stepper:setReferencePoint( display.CenterReferencePoint )
	end
	
	local x, y = _widget._calculatePosition( stepper, opt )
	stepper.x, stepper.y = x, y
	
	return stepper
end

return M
