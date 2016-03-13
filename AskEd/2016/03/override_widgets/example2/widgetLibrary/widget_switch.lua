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
	_widgetName = "widget.newSwitch",
}


-- Require needed widget files
local _widget = require( "widget" )

local isGraphicsV1 = ( 1 == display.getDefault( "graphicsCompatibility" ) )

-- Localize math functions
local mAbs = math.abs
local mRound = math.round


-- Initialize a switch with images
local function initWithImage( switch, options )
	-- Create a local reference to our options table
	local opt = options

	-- Forward references
	local imageSheet, viewOff, viewOn
	
	-- Create the imageSheet
	if opt.sheet then
		imageSheet = opt.sheet
	else
		local themeData = require( opt.themeData )
		imageSheet = graphics.newImageSheet( opt.themeSheetFile, themeData:getSheet() )
	end
	
	-- Create the view
	viewOff = display.newImageRect( imageSheet, opt.frameOff, opt.width, opt.height )
	viewOff.x = switch.x + ( viewOff.contentWidth * 0.5 )
	viewOff.y = switch.y + ( viewOff.contentHeight * 0.5 )
	
	viewOn = display.newImageRect( imageSheet, opt.frameOn, opt.width, opt.height )
	viewOn.x = switch.x + ( viewOn.contentWidth * 0.5 )
	viewOn.y = switch.y + ( viewOn.contentHeight * 0.5 )
	
	-------------------------------------------------------
	-- Assign properties to the view
	-------------------------------------------------------
	
	-- Set the view's on/off states initial visibility based on the default state
	viewOff.isVisible = not opt.initialSwitchState
	viewOn.isVisible = opt.initialSwitchState
	
	-------------------------------------------------------
	-- Assign properties/objects to the switch
	-------------------------------------------------------
	
	-- Assign properties to switch
	switch.isOn = opt.initialSwitchState
	
	-- Assign objects to the switch
	switch._imageSheet = imageSheet
	switch._viewOn = viewOn
	switch._viewOff = viewOff
	
	-- Insert the on/off view's into the switch (group)
	switch:insert( viewOn )
	switch:insert( viewOff )
	
	return switch
end

-- Initialize a switch with a sprite
local function initWithSprite( switch, options )
	-- Create a local reference to our options table
	local opt = options
	
	-- Forward references
	local imageSheet, view
	
	-- Create the sequenceData table
	local switchSheetOptions = 
	{ 
		{
			name = "on",
			start = opt.frameOn,
			count = 1,
			time = 1,
		},
		
		{
			name = "off",
			start = opt.frameOff,
			count = 1,
			time = 1,
		},
	}
	
	-- Create the image sheet
	if opt.sheet then
		imageSheet = opt.sheet
	else
		local themeData = require( opt.themeData )
		imageSheet = graphics.newImageSheet( opt.themeSheetFile, themeData:getSheet() )
	end
	
	-- Create the view
	view = display.newSprite( imageSheet, switchSheetOptions )
	view._animStates =
	{
		[1] = "on",
		[2] = "off",
	}
	view:setSequence( view._animStates[tonumber( opt.initialSwitchState )] )
	view.x = switch.x + ( view.contentWidth * 0.5 )
	view.y = switch.y + ( view.contentHeight * 0.5 )
	
	-------------------------------------------------------
	-- Assign properties/objects to the switch
	-------------------------------------------------------
	
	-- Assign properties to switch
	switch.isOn = opt.initialSwitchState
	
	-- Assign objects to the switch
	switch._view = view
		
	-- Insert the view into the switch (group)
	switch:insert( view )
	
	return switch
end



-- Create a on/off toggle switch
local function createOnOffSwitch( switch, options )
	-- Create a local reference to our options table
	local opt = options
		
	-- Forward references
	local imageSheet, view, viewOverlay, viewHandle, viewMask
	
	-- Frame references
	local onFrame, offFrame, backgroundFrame, overlayFrame
	local defaultBackground, interBackground, onBackground, handle, ios7theme, onView, interView, offView
	
	-- Setup which frames to use for the on/off images
	if opt.sheet then
		offFrame = opt.onOffHandleDefaultFrame
		onFrame = opt.onOffHandleOverFrame
		backgroundFrame = opt.onOffBackgroundFrame
		overlayFrame = opt.onOffOverlayFrame
	else
		local themeData = require( opt.themeData )
		offFrame = themeData:getFrameIndex( opt.onOffHandleDefaultFrame )
		onFrame = themeData:getFrameIndex( opt.onOffHandleOverFrame )
		backgroundFrame = themeData:getFrameIndex( opt.onOffBackgroundFrame )
		overlayFrame = themeData:getFrameIndex( opt.onOffOverlayFrame )
	end
	
	if _widget.isSeven() then
			defaultBackground = opt.backgroundFrame
			interBackground = opt.backgroundInterFrame
			onBackground = opt.backgroundOnFrame
			handle = opt.handle
			ios7theme = opt.ios7theme
	end
	
	
	-- Image sheet options for the on/off switch's handle sprite
	local handleSheetOptions = 
	{
		{ 
			name = "off", 
			start = offFrame, 
			count = 1, 
			time = 1,
		},
		
		{ 
			name = "on", 
			start = onFrame, 
			count = 1, 
			time = 1, 
		},
	}
	
	-- Create the imageSheet
	if opt.sheet then
		imageSheet = opt.sheet
		switch.isCustom = true
	else
		local themeData = require( opt.themeData )
		imageSheet = graphics.newImageSheet( opt.themeSheetFile, themeData:getSheet() )
	end
	
	if not _widget.isSeven() or switch.isCustom then
		-- The view is the switches background image
		view = display.newImageRect( switch, imageSheet, backgroundFrame, opt.onOffBackgroundWidth, opt.onOffBackgroundHeight )
	else
		view = display.newGroup()
		switch:insert( view )
		
		onView = display.newImageRect( view, imageSheet, 60, 51, 31 )
		interView = display.newImageRect( view, imageSheet, 58, 51, 31 )
		offView = display.newImageRect( view, imageSheet, 59, 51, 31 )
		
		if opt.initialSwitchState then
			offView.isVisible = false
			interView.isVisible = false
		else
			interView.isVisible = false
			onView.isVisible = false
		end
	end
	
	if not _widget.isSeven() or switch.isCustom then
		-- The view's overlay is the "shine" effect
		viewOverlay = display.newImageRect( switch, imageSheet, overlayFrame, opt.onOffOverlayWidth, opt.onOffOverlayHeight )
	end
	
	if not _widget.isSeven() or switch.isCustom then
		-- The view's handle
		viewHandle = display.newSprite( switch, imageSheet, handleSheetOptions )
		viewHandle:setSequence( "off" )
	else
		viewHandle = display.newImageRect( switch, imageSheet, 63, 40, 40 )	
	end
	
	if not _widget.isSeven() or switch.isCustom then
		-- The view's mask
		viewMask = graphics.newMask( opt.onOffMask, opt.baseDir )
		view:setMask( viewMask )
	end

	-------------------------------------------------------
	-- Assign properties to the view
	-------------------------------------------------------

	-- This is measured from the dimensions of the overlay and handle images
	local startRange 
	local endRange
	
	if not _widget.isSeven() or switch.isCustom then
		startRange = - mRound( viewOverlay.width - viewHandle.contentWidth ) / 2
		endRange = mAbs( startRange )
	end
	
	-- Properties
	view._transition = nil
	view._handleTransition = nil
	view._startRange = startRange
	view._endRange = endRange
	view._onPress = opt.onPress
	view._onRelease = opt.onRelease
	view._onEvent = opt.onEvent
	
	if _widget.isSeven() or not switch.isCustom then
		view._offView = offView
		view._onView = onView
		view._interView = interView
	end
	
	-- Objects
	view._overlay = viewOverlay
	view._handle = viewHandle
	view._mask = viewMask
	
	-------------------------------------------------------
	-- Assign properties/objects to the switch
	-------------------------------------------------------
	
	-- Assign properties to the switch	
	switch.isOn = opt.initialSwitchState
	
	-- For non-graphics v1 mode, the children have to be non-anchored
	if not isGraphicsV1 and not _widget.isSeven() then
		switch.anchorChildren = false
	end
	
	if not _widget.isSeven() or switch.isCustom then
		
		-- Set the switch position based on the chosen default value (ie on/off)
		local isOn = switch.isOn
		-- if it's the holo themes, flip the position
		if _widget.isHolo() then
			isOn = not isOn
		end
		if isOn then
			view.x = view._endRange
			view._handle.x = view._endRange
			view.maskX = view._handle.x - mAbs( view._startRange ) - view._endRange
		else
			view.x = view._startRange
			view._handle.x = view._startRange
			view.maskX = view._handle.x + mAbs( view._startRange ) + view._endRange
		end
	else
		-- Set the switch position based on the chosen default value (ie on/off)
		if switch.isOn then
			view._handle.x = view.x + view.contentWidth * 0.5 - view._handle.contentWidth * 0.5 + 4 
		else
			view._handle.x = view.x - view.contentWidth * 0.5 + view._handle.contentWidth * 0.5 - 4
		end
	end
	
	-- Assign objects to the switch
	switch._imageSheet = imageSheet
	switch._view = view

	switch.x = switch.x + ( view.contentWidth * 0.5 )
	switch.y = switch.y + ( view.contentHeight * 0.5 )

	if _widget.isSeven() then
	end

	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	-- Function to set the switches state (on/off) programatically
	function switch:setState( options )
		return self._view:_setState( options )
	end

	-- Handle touches for non-sliding switches
	local function nonSlidingSwitchHandler(self, event )
		local _switch = self.parent -- self.parent == switch
		-- Set the target to the switch
		event.target = _switch

		if event.phase == "began" then
			if self._onPress and not self._onEvent then
				self._onPress( event )
			end
		elseif event.phase == "ended" then
			-- Toggle the switch
			_switch.isOn = not _switch.isOn
				
			-- Cancel current view transition if there is one
			if self._transition then
				transition.cancel( self._transition )
				self._transition = nil
			end
			
			if self._handleTransition then
				transition.cancel( self._handleTransition )
				self._handleTransition = nil
			end
							
			-- If self has a _onPress method execute it
			local function executeOnRelease()
				if self._onRelease and not self._onEvent then
					self._onRelease( event )
				end
			end
					
			-- Set the switches transition time
			local switchTransitionTime = 200
			-- Modern Android switches have no apparent transition
			if _widget.isHolo() then
				switchTransitionTime = 2
			end

			if not _widget.isSeven() or switch.isCustom then
			
				-- Transition the switch from on>off and vice versa
				if (_switch.isOn and not _widget.isHolo()) or (not _switch.isOn and _widget.isHolo()) then
					self._transition = transition.to( self, { x = self._endRange, maskX = self._startRange, time = switchTransitionTime, onComplete = executeOnRelease } )
					self._handleTransition = transition.to( self._handle, { x = self._endRange, time = switchTransitionTime } )
				else
					self._transition = transition.to( self, { x = self._startRange, maskX = self._endRange, time = switchTransitionTime, onComplete = executeOnRelease } )
					self._handleTransition = transition.to( self._handle, { x = self._startRange, time = switchTransitionTime } )
				end
			
			else

				local originalScale = self._offView.xScale
			
				-- Transition the switch from on>off and vice versa
				if _switch.isOn then
					-- fade fast to gray, then show green
					self._interView.isVisible = true

					
					transition.to ( self._offView, { time = 250, xScale = 0.1, yScale = 0.1, onComplete = function() 
					
						self._offView.isVisible = false
						self._offView.xScale = originalScale
						self._offView.yScale = originalScale
						

						self._onView.isVisible = true

						transition.to ( self._interView, { time = 100, alpha = 0.0 , onComplete = function() 
							self._interView.isVisible = false
							self._interView.alpha = 1.0 
						end } )
						
					
					end } )
					self._handleTransition = transition.to( self._handle, { x = self.x + self.contentWidth * 0.5 - self._handle.contentWidth * 0.5 + 4, time = switchTransitionTime, onComplete = executeOnRelease } )
				else
				-- back to grey immediately, fade from grey to white
				
				self._interView.isVisible = true
				
				transition.to ( self._onView, { time = 100, alpha = 0.0 , onComplete = function() 
				
							self._onView.isVisible = false
							self._onView.alpha = 1.0 
							--self._interView:toFront()
							self._offView.isVisible = true
							transition.to ( self._interView, { time = 250, xScale = 0.1, yScale = 0.1, onComplete = function() 
						
								self._interView.isVisible = false
								self._interView.xScale = originalScale
								self._interView.yScale = originalScale
								self._onView.isVisible = true
								
			
							end } )
							
						end } )
				
					self._handleTransition = transition.to( self._handle, { x = self.x - self.contentWidth * 0.5 + self._handle.contentWidth * 0.5 - 4, time = switchTransitionTime, onComplete = executeOnRelease } )
				end
			
			end
		end		
		-- If self has a _onEvent method execute it
		if self._onEvent then
			self._onEvent( event )
		end
		return true
	end
	
	-- Handle touch/drag events on the switch
	local function slidingSwitchHandler(self, event )
		local phase = event.phase
		local _switch = self.parent -- self.parent == switch
		-- Set the target to the switch

		if "began" == phase then
			-- Cancel current view transition if there is one
			if self._transition then
				transition.cancel( self._transition )
				self._transition = nil
			end
			
			if self._handleTransition then
				transition.cancel( self._handleTransition )
				self._handleTransition = nil
			end
					
			-- Set focus
			display.getCurrentStage():setFocus( self ) 
			self._isFocus = true
			
			-- Store initial position of the handle
			self._handle.x0 = event.x - self._handle.x 
			-- Set the handle to it's 'over' frame
			self._handle:setSequence( "on" )
			-- handle an onPress event if it's setup
			event.target = _switch
			if self._onPress and not self._onEvent then
				self._onPress( event )
			end
		elseif self._isFocus then
			if "moved" == phase then
				self._handle.x = event.x - self._handle.x0 
				self.x = event.x - self._handle.x0
				self.maskX = - ( event.x - self._handle.x0 )
		
				-- limit movement to switch, left side
				if self._handle.x <= self._startRange then
					self._handle.x = self._startRange
					self.x = self._startRange
					self.maskX = self._endRange
				end
					
				--limit movement to switch, right side
				if self._handle.x >= self._endRange then
					self._handle.x = self._endRange
					self.x = self._endRange 
					self.maskX = self._startRange
				end
	
			elseif "ended" == phase or "cancelled" == phase then
				local _switch = self.parent
				-- Set the target to the switch
				event.target = _switch
				
				-- If self has a _onRelease method execute it
				local function executeOnRelease()
					if self._onRelease and not self._onEvent then
						self._onRelease( event )
					end
				end
				
				-- Set the switches transition time
				local switchTransitionTime = 200
				-- Modern Android switches have no apparent transition
				if _widget.isHolo() then
					switchTransitionTime = 2
				end

				-- check for a tap type behavior 
				if math.abs(event.x - event.xStart) < 5 then 
					if _switch.isOn then
						_switch.isOn = false
						self._transition = transition.to( self, { x = self._startRange, maskX = self._endRange, time = switchTransitionTime, onComplete = executeOnRelease } )
						self._handleTransition = transition.to( self._handle, { x = self._startRange, time = switchTransitionTime } )
					else
						_switch.isOn = true
						self._transition = transition.to( self, { x = self._endRange, maskX = self._startRange, time = switchTransitionTime, onComplete = executeOnRelease } )
						self._handleTransition = transition.to( self._handle, { x = self._endRange, time = switchTransitionTime } )
					end
				else -- the user actually tried to drag the switch
					-- Transition the switch from on>off and vice versa
					if self._handle.x < 0 then
						_switch.isOn = false
						self._transition = transition.to( self, { x = self._startRange, maskX = self._endRange, time = switchTransitionTime, onComplete = executeOnRelease } )
						self._handleTransition = transition.to( self._handle, { x = self._startRange, time = switchTransitionTime } )
					else
						_switch.isOn = true
						self._transition = transition.to( self, { x = self._endRange, maskX = self._startRange, time = switchTransitionTime, onComplete = executeOnRelease } )
						self._handleTransition = transition.to( self._handle, { x = self._endRange, time = switchTransitionTime } )
					end
				end
				-- Set the handle back to it's default frame
				self._handle:setSequence( "off" )
				
				-- Remove focus
				display.getCurrentStage():setFocus( nil )
				self._isFocus = false
			end
		end
		
		-- If self has a _onEvent method execute it
		if self._onEvent then
			self._onEvent( event )
		end
		
		return true
	end
	--
	-- because we don't support sliding of iOS 7 switches and the new Android holo themed
	-- switches are not supposed to slide, instead of shorting them in the touch handler
	-- lets program the touch handler to pick the right function. 
	-- This is to eliminate the "tap" handler so that all three expected events:
	-- onPress, onRelease, onEvent work as expected
	if (_widget.isSeven() or _widget.isHolo()) and not switch.isCustom then
		view.touch = nonSlidingSwitchHandler
	else
		view.touch = slidingSwitchHandler
	end
	view:addEventListener( "touch" )
	
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Function to set a switch on/off programatically
	function view:_setState( options )
		local _switch = self.parent
		local _isSwitchOn = options.isOn
		local _isAnimated = options.isAnimated
		local _listener = options.onComplete
		
		-- If the user hasn't passed the isOn property, throw an error
		if _isSwitchOn == nil then
			error( "ERROR: " .. M._widgetName .. ": setState - isOn (true/false) expected, got nil", 3 )
		end
		
		-- If there is a onComplete method
		local function executeOnComplete()
			-- Set the switch isOn property
			_switch.isOn = _isSwitchOn
			
			-- Create the event
			local event = 
			{
				target = _switch,
				phase = "ended",
			}
				
			-- Execute the user listener
			if _listener then
				_listener( event )
			end
		end
		
		-- Set the switches transition time
		local switchTransitionTime = 200
		-- Modern Android switches have no apparent transition
		if _widget.isHolo() then
			switchTransitionTime = 2
		end
		
		-- Temporary until we wrap up theme definition of ios7 
		
		if not _widget.isSeven() or switch.isCustom then
		
			-- Set the switch to on/off visually
			if _isSwitchOn then
				if _isAnimated then
					self._transition = transition.to( self, { x = self._endRange, maskX = self._startRange, time = switchTransitionTime, onComplete = executeOnComplete } )
					self._handleTransition = transition.to( self._handle, { x = self._endRange, time = switchTransitionTime } )
				else
					self.x = self._endRange
					self._handle.x = self._endRange
					self.maskX = self._startRange
				
					-- Execute the onComplete listener
					executeOnComplete()
				end
			else
				if _isAnimated then
					self._transition = transition.to( self, { x = self._startRange, maskX = self._endRange, time = switchTransitionTime, onComplete = executeOnComplete } )
					self._handleTransition = transition.to( self._handle, { x = self._startRange, time = switchTransitionTime } )
				else
					self.x = self._startRange
					self._handle.x = self._startRange
					self.maskX = self._endRange
				
					-- Execute the onComplete listener
					executeOnComplete()
				end
			end
		
		else
		
			if _isSwitchOn then
				view._handle.x = view.x + view.contentWidth * 0.5 - view._handle.contentWidth * 0.5 + 4 
				offView.isVisible = false
				interView.isVisible = false
				onView.isVisible = true
			else
				view._handle.x = view.x - view.contentWidth * 0.5 + view._handle.contentWidth * 0.5 - 4
				interView.isVisible = false
				onView.isVisible = false
				offView.isVisible = true
			end
			-- Execute the onComplete listener
			executeOnComplete()
		
		end
	end
	
	-- Finalize method for standard switch
	function switch:_finalize()
		-- Cancel current view transition if there is one
		if self._view._transition then
			transition.cancel( self._view._transition )
			self._view._transition = nil
		end
		
		if self._view._handleTransition then
			transition.cancel( self._view._handleTransition )
			self._view._handleTransition = nil
		end
		
		-- Remove the switch's mask
		self._view:setMask( nil )
				
		-- Set objects to nil
		self._view._overlay = nil
		self._view._handle = nil
		self._view._mask = nil
		self._view = nil
		
		-- Set the ImageSheet to nil
		self._imageSheet = nil
	end

	return switch
end


-- Initialize with a standard switch (ie radio/checkbox buttons)
local function createStandardSwitch( switch, options )
	-- Create a local reference to our options table
	local opt = options
	
	local imageSheet
	-- Check for a imageSheet
	if opt.sheet then
		imageSheet = opt.sheet
	else
		local themeData = require( opt.themeData )
		imageSheet = graphics.newImageSheet( opt.themeSheetFile, themeData:getSheet() )
	end
	
	-- Are we using a sprite (assume false)
	local usingSprite = false
	
	-- Forward references
	local view
	
	-- If there is a default frame & a selected frame then init with sprite
	if opt.defaultFrame and opt.selectedFrame then
		view = initWithSprite( switch, opt )
		usingSprite = true
	else
		-- There isn't so init with image
		view = initWithImage( switch, opt )
	end
	
	-- Create local reference to the view
	local view = switch._view or switch._viewOn
	view.isHitTestable = true
	view.x = switch.x + ( view.contentWidth * 0.5 )
	view.y = switch.y + ( view.contentHeight * 0.5 )
	view._switchType = opt.switchType
	
	-------------------------------------------------------
	-- Assign properties to the view
	-------------------------------------------------------

	-- Assign properties/methods to the view.
	view._onPress = opt.onPress
	view._onRelease = opt.onRelease
	view._onEvent = opt.onEvent
	
	-- Assign objects to the switch
	switch._imageSheet = imageSheet
	switch._view = view

	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	-- Function to set the switches state (on/off) programatically
	function switch:setState( options )
		-- If this is a radio button
		local _switch = self
		if "radio" == self._view._switchType then
			-- Loop through all objects contained in the switches parent group
			for i = 1, _switch.parent.numChildren do
				local child = _switch.parent[i]
				
				-- Turn off all radio buttons in this group
				if "table" == type( child._view ) then
					if "string" == type( child._view._switchType ) then
						if "radio" == child._view._switchType then
							child._view:_setState( { isOn = false } )
						end
					end
				end
			end
			
			-- Set the pressed/selected radio switch to on
			if options and options.isOn then
				return self._view:_setState( { isOn = true } )
			end
		else
			return self._view:_setState( options )
		end
	end

	-- Handle touches on the switch
	function view:touch( event )
		local phase = event.phase
		local _switch = self.parent -- self.parent == switch
		-- Set the target to the switch
		event.target = _switch
		
		if "began" == phase then
			-- Toggle the switch on/off
			_switch.isOn = not _switch.isOn
			
			-- If this is a radio button
			if "radio" == self._switchType then
				-- Loop through all objects contained in the switches parent group
				for i = 1, _switch.parent.numChildren do
					local child = _switch.parent[i]
					
					-- Turn off all radio buttons in this group
					if "table" == type( child._view ) then
						if "string" == type( child._view._switchType ) then
							if "radio" == child._view._switchType then
								child._view:_setState( { isOn = false } )
							end
						end
					end
				end
				
				-- Set the pressed/selected radio switch to on
				self:_setState( { isOn = true } )
			end
				
			-- Toggle the displayed sprite sequence
			if usingSprite then
				if _switch.isOn then
					self:setSequence( "on" )
				else
					self:setSequence( "off" )
				end
			else
				-- Toggle the view's visibility
				switch._viewOn.isVisible = _switch.isOn
				switch._viewOff.isVisible = not _switch.isOn
			end
			
			-- If self has a _onPress method execute it
			if self._onPress and not self._onEvent then
				self._onPress( event )
			end
			
		elseif "ended" == phase or "cancelled" == phase then
			-- If self has a _onRelease method execute it
			if self._onRelease and not self._onEvent then
				self._onRelease( event )
			end
		end

		-- If self has a _onEvent method execute it
		if self._onEvent then
			self._onEvent( event )
		end
		
		return true
	end
		
	view:addEventListener( "touch" )
	
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Function to set a switch on/off programatically
	function view:_setState( options )
		local _switch = self.parent
		local _isSwitchOn = options.isOn
		local _isAnimated = options.isAnimated
		local _listener = options.onComplete
		
		-- If the user hasn't passed the isOn property, throw an error
		if _isSwitchOn == nil then
			error( "ERROR: " .. M._widgetName .. ": setState - isOn (true/false) expected, got nil", 3 )
		end
		
		-- If there is a onComplete method
		local function executeOnComplete()
			-- Set the switch isOn property
			_switch.isOn = _isSwitchOn
						
			-- Create the event
			local event = 
			{
				target = _switch,
				phase = "ended",
			}
				
			-- Execute the user listener
			if _listener then
				_listener( event )
			end
		end
				
		-- Set the switch to on/off visually
		if _isSwitchOn then
			-- Toggle the view's visibility
			switch._viewOn.isVisible = true
			switch._viewOff.isVisible = false
		else
			-- Toggle the view's visibility
			switch._viewOn.isVisible = false
			switch._viewOff.isVisible = true
		end
		
		executeOnComplete()
	end
	
	-- Finalize method for standard switch
	function switch:_finalize()		
		-- Set objects to nil
		self._viewOff = nil
		self._viewOn = nil

		-- Set the ImageSheet to nil
		self._imageSheet = nil
	end
	
	return switch
end


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
	opt.width = customOptions.width or themeOptions.width or 20 -- from the sheet file
	opt.height = customOptions.height or themeOptions.height or 20 -- from the sheet file
	opt.id = customOptions.id
	opt.baseDir = customOptions.baseDir or system.ResourceDirectory
	opt.switchType = customOptions.style or "onOff"
	opt.initialSwitchState = customOptions.initialSwitchState or false
	opt.offDirection = customOptions.offDirection or themeOptions.offDirection or "right"
	opt.onPress = customOptions.onPress
	opt.onRelease = customOptions.onRelease
	opt.onEvent = customOptions.onEvent
	
	-- Frames & Images	
	opt.sheet = customOptions.sheet
	opt.themeSheetFile = themeOptions.sheet
	opt.themeData = themeOptions.data
	
	opt.frameOff = customOptions.frameOff
	opt.frameOn = customOptions.frameOn
		
	-- If the user hasn't set a on/off frame but a theme has been set and it includes a data property then grab the required start/end frames
	if not opt.frameOff and not opt.frameOn and theme and themeOptions.data then
		opt.frameOff = _widget._getFrameIndex( themeOptions, themeOptions.frameOff )
		opt.frameOn = _widget._getFrameIndex( themeOptions, themeOptions.frameOn )
	end	
			
	-- Options for the on/off switch only
	if "onOff" == opt.switchType then
		opt.onOffBackgroundFrame = customOptions.onOffBackgroundFrame or themeOptions.backgroundFrame
		opt.onOffBackgroundWidth = customOptions.onOffBackgroundWidth or themeOptions.backgroundWidth or error( "ERROR: " .. M._widgetName .. ": backgroundWidth expected, got nil", 3 )
		opt.onOffBackgroundHeight = customOptions.onOffBackgroundHeight or themeOptions.backgroundHeight or error( "ERROR: " .. M._widgetName .. ": backgroundHeight expected, got nil", 3 )
		opt.onOffOverlayFrame = customOptions.onOffOverlayFrame or themeOptions.overlayFrame
		opt.onOffOverlayWidth = customOptions.onOffOverlayWidth or themeOptions.overlayWidth or error( "ERROR: " .. M._widgetName .. ": overlayWidth expected, got nil", 3 )
		opt.onOffOverlayHeight = customOptions.onOffOverlayHeight or themeOptions.overlayHeight or error( "ERROR: " .. M._widgetName .. ": overlayHeight expected, got nil", 3 )
		opt.onOffHandleDefaultFrame = customOptions.onOffHandleDefaultFrame or themeOptions.handleDefaultFrame 
		opt.onOffHandleOverFrame = customOptions.onOffHandleOverFrame or themeOptions.handleOverFrame
		opt.onOffMask = customOptions.onOffMask or themeOptions.mask
		
		-- properties for the ios7 switch
		if _widget.isSeven() then
			opt.defaultBackground = themeOptions.backgroundFrame
			opt.interBackground = themeOptions.backgroundInterFrame
			opt.onBackground = themeOptions.backgroundOnFrame
			opt.handle = themeOptions.handleDefaultFrame
			opt.ios7theme = opt.themeSheetFile
		end
		
	else
		if not opt.width then 
			error( "ERROR: " .. M._widgetName .. ": width expected, got nil", 3 )
		end
		
		if not opt.height then
			error( "ERROR: " .. M._widgetName .. ": height expected, got nil", 3 )
		end
	end
	
	-------------------------------------------------------
	-- Create the switch
	-------------------------------------------------------
	
	-- The switch object is a group
	local switch = _widget._new
	{
		left = opt.left,
		top = opt.top,
		id = opt.id or "widget_switch",
		baseDirectory = opt.baseDir,
	}
		
	-- Create the switch based on the given type
 	if "onOff" == opt.switchType then
 		createOnOffSwitch( switch, opt )
 	else
 		createStandardSwitch( switch, opt )

		-- Set the switch's position ( set the reference point to center, just to be sure )
		if ( isGraphicsV1 ) then
			switch:setReferencePoint( display.CenterReferencePoint )
		end
	
	end
		
	local x, y = _widget._calculatePosition( switch, opt )
	switch.x, switch.y = x, y
	
	
	return switch
end

return M
