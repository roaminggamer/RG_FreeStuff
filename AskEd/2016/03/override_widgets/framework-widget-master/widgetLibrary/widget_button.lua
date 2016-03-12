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
	_widgetName = "widget.newButton",
}


-- Require needed widget files
local _widget = require( "widget" )

local isGraphicsV1 = ( 1 == display.getDefault( "graphicsCompatibility" ) )
local isByteColorRange = display.getDefault( "isByteColorRange" )

-- Function to handle touches on a widget button, function is common to all widget button creation types (ie image files, imagesheet, and 9 slice button creation)
local function manageButtonTouch( view, event )
	local phase = event.phase

	-- If the button isn't active, just return
	if not view._isEnabled then
		return
	end
		
	if "began" == phase then		
		-- Set the button to it's over image state
		view:_setState( "over" )
		
		-- Create the alpha fade if the theme has it
		if view._hasAlphaFade and view._labelColor == nil then
			if view._label then
				transition.to( view._label, { time = 50, alpha = 0.5 } )
			else
				transition.to( view, { time = 50, alpha = 0.5 } )
			end
		end

		-- If there is a onPress method ( and not a onEvent method )
		if view._onPress and not view._onEvent then
			view._onPress( event )
		end
		
		-- If the parent group still exists
		if "table" == type( view.parent ) then
			-- Set focus on the button
			view._isFocus = true
			display.getCurrentStage():setFocus( view, event.id )
			
		end
		
	elseif view._isFocus then
		if "moved" == phase then
			if not _widget._isWithinBounds( view.parent, event ) then
				-- Set the button to it's default image state
				view:_setState( "default" )
				
				-- Create the alpha fade if the theme has it
				if view._hasAlphaFade and view._labelColor == nil then
					if view._label then
						transition.to( view._label, { time = 50, alpha = 1.0 } )
					else
						transition.to( view, { time = 50, alpha = 1.0 } )
					end
				end
				
			else
				if view:_getState() ~= "over" then
					-- Set the button to it's over image state
					view:_setState( "over" )
					
					-- Create the alpha fade if the theme has it
					if view._hasAlphaFade and view._labelColor == nil then
						if view._label then
							transition.to( view._label, { time = 50, alpha = 0.5 } )
						else
							transition.to( view, { time = 50, alpha = 0.5 } )
						end
					end
					
				end
			end
		
		elseif "ended" == phase or "cancelled" == phase then
			if _widget._isWithinBounds( view.parent, event ) then
				-- If there is a onRelease method ( and not a onEvent method )
				if view._onRelease and not view._onEvent then
					view._onRelease( event )
				end
			end
			
			-- Set the button to it's default image state
			view:_setState( "default" )

			-- Create the alpha fade if the theme has it
			if view._hasAlphaFade and view._labelColor == nil then
				if view._label then
					transition.to( view._label, { time = 50, alpha = 1.0 } )
				else
					transition.to( view, { time = 50, alpha = 1.0 } )
				end
			end
			
			-- Remove focus from the button
			view._isFocus = false
			display.getCurrentStage():setFocus( nil )
		end
	end
	
	-- If there is a onEvent method ( and not a onPress or onRelease method )
	if view._onEvent and not view._onPress and not view._onRelease then
		-- corrected: phase becomes cancelled if outside the bounds of the widget, not the view's.
		if not _widget._isWithinBounds( view.parent, event ) and "ended" == phase then
			event.phase = "cancelled"
			
		end
		
		view._onEvent( event )
	end
end


------------------------------------------------------------------------
-- Text Button
------------------------------------------------------------------------
local function createUsingText( button, options )
	-- Create a local reference to our options table
	local opt = options
	
	-- Forward references
	local view
	
	-- Create the label (either embossed or standard)
	if opt.embossedLabel then
		view = display.newEmbossedText( button, opt.label, 0, 0, opt.font, opt.fontSize )
	else
		view = display.newText( button, opt.label, 0, 0, opt.font, opt.fontSize )
	end
	
	-- Set the view's color
	view:setFillColor( unpack( opt.labelColor.default ) )
	view._labelColor = opt.labelColor
	
	----------------------------------
	-- Positioning
	----------------------------------
	
	-- The view
	view.x = button.x + ( view.contentWidth * 0.5 )
	view.y = button.y + ( view.contentHeight * 0.5 )

	-------------------------------------------------------
	-- Assign properties/objects to the view
	-------------------------------------------------------
	
	view._isEnabled = opt.isEnabled
	view._pressedState = "default"
	view._fontSize = opt.fontSize
	view._labelColor = view._labelColor
	view._hasAlphaFade = opt.hasAlphaFade
	
	-- Methods
	view._onPress = opt.onPress
	view._onRelease = opt.onRelease
	view._onEvent = opt.onEvent
	
	-------------------------------------------------------
	-- Assign properties/objects to the button
	-------------------------------------------------------
	
	-- Assign objects to the button
	button._view = view
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	-- Function to set the buttons text color
	function button:setFillColor( ... )
		self._view:setFillColor( ... )
	end
	
	-- Function to set the button's label
	function button:setLabel( newLabel )
		return self._view:_setLabel( newLabel )
	end
	
	-- Function to get the button's label
	function button:getLabel()
		return self._view:_getLabel()
	end
	
	-- Function to set a button as active
	function button:setEnabled( isEnabled )
		self._view._isEnabled = isEnabled
	end
	
	-- Touch listener for our button
	function button:touch( event )
		-- Set the target to the view's parent group (the button object)
		event.target = self
		
		-- Manage touch events on the button
		manageButtonTouch( self._view, event )
		return true
	end
	
	button:addEventListener( "touch", button )
	
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Function to set the button's label
	function view:_setLabel( newLabel )
		-- Update the label's text
		if "function" == type( self.setText ) then
			self:setText( newLabel )
		else
			self.text = newLabel
		end
	end
	
	-- Function to get the button's label
	function view:_getLabel()
		return self.text
	end
	
	-- Function to set the buttons current state
	function view:_setState( state )
		local newState = state
		
		if "over" == newState then
			-- Set the label to it's over color
			if "table" == type( self ) then
				self:setFillColor( unpack( self._labelColor.over ) )
			end
			
			-- The pressedState is now "over"
			self._pressedState = "over"
		
		elseif "default" == newState then
			-- Set the label back to it's default color
			if "table" == type( self ) then
				self:setFillColor( unpack( self._labelColor.default ) )
			end
			
			-- The pressedState is now "default"
			self._pressedState = "default"
		end
	end
	
	-- Function to get the buttons current state
	function view:_getState()
		return self._pressedState
	end
	
	-- Lose focus function
	function button:_loseFocus()
		self._view:_setState( "default" )
		-- Create the alpha fade if the theme has it
		if self._view._hasAlphaFade and self._view._labelColor == nil then
			if self._view._label then
				transition.to( self._view._label, { time = 50, alpha = 1.0 } )
			else
				transition.to( self._view, { time = 50, alpha = 1.0 } )
			end
		end
	end
	
	-- Finalize function
	function button:_finalize()
	end
	
	return button
end
	

------------------------------------------------------------------------
-- Vector Button
------------------------------------------------------------------------

-- Creates a new button using a vector object
local function createUsingVectorObject( button, options )
	-- Create a local reference to our options table
	local opt = options
	
	-- Forward references
	local view, viewLabel

	-- Create the view
	local vectType = string.lower( opt.shape )

	-- rect
	if ( vectType == "rect" or vectType == "rectangle" ) then
		local w = opt.width or 150
		local h = opt.height or 50
		view = display.newRect( button, 0, 0, w, h )
	-- roundedRect
	elseif ( vectType == "roundedrect" or vectType == "roundedrectangle" ) then
		local w = opt.width or 150
		local h = opt.height or 50
		local rad = opt.cornerRadius or 4
		view = display.newRoundedRect( button, 0, 0, w, h, rad )
	-- circle
	elseif ( vectType == "circle" ) then
		local rad = opt.radius or 50
		view = display.newCircle( button, 0, 0, rad )
	-- polygon
	elseif ( vectType == "polygon" ) then
		local vertices
		if ( opt.vertices and type(opt.vertices) == "table" ) then vertices = opt.vertices else vertices = { -20,-25,20,0,-20,25 } end
		view = display.newPolygon( button, 0, 0, vertices )
	-- else, fall back to a rectangle of 150x50
	else
		view = display.newRect( button, 0, 0, 150, 50 )
	end
	
	--Style the view
	if ( opt.fillColor ) then
		view:setFillColor( unpack( opt.fillColor.default ) )
	end
	if ( opt.strokeColor and tonumber(opt.strokeWidth) and tonumber(opt.strokeWidth) > 0 ) then
		view:setStrokeColor( unpack( opt.strokeColor.default ) )
		view.strokeWidth = opt.strokeWidth
		view._hasStroke = true
	end

	-- Create the label (either embossed or standard)
	if opt.embossedLabel then
		viewLabel = display.newEmbossedText( button, opt.label, 0, 0, opt.font, opt.fontSize )
	else
		viewLabel = display.newText( button, opt.label, 0, 0, opt.font, opt.fontSize )
	end
	
	----------------------------------
	-- Positioning
	----------------------------------
	
	-- The view
	view.x = button.x + ( view.contentWidth * 0.5 )
	view.y = button.y + ( view.contentHeight * 0.5 )
	
	-- Setup the label
	viewLabel:setFillColor( unpack( opt.labelColor.default ) )
	viewLabel._isLabel = true
	viewLabel._labelColor = opt.labelColor
	
	-- If there isn't an over color defined, fall back to default label color
	if not viewLabel._labelColor.over then
		viewLabel._labelColor.over = viewLabel._labelColor.default
	end
	
	-- Labels position
	if "center" == opt.labelAlign then
		viewLabel.x = view.x + opt.labelXOffset
	elseif "left" == opt.labelAlign then
		viewLabel.x = button.x + ( viewLabel.contentWidth * 0.5 ) + 10 + opt.labelXOffset
	elseif "right" == opt.labelAlign then
		viewLabel.x = view.x + ( view.contentWidth * 0.5 ) - ( viewLabel.contentWidth * 0.5 ) - 10 + opt.labelXOffset
	end
		
	-- Set the labels y position
	viewLabel.y = button.y + ( view.contentHeight * 0.5 ) + opt.labelYOffset
	
	-------------------------------------------------------
	-- Assign properties/objects to the view
	-------------------------------------------------------
	
	view._isEnabled = opt.isEnabled
	view._pressedState = "default"
	view._fontSize = opt.fontSize
	view._fillColor = opt.fillColor or nil
	view._strokeColor = opt.strokeColor or nil
	view._label = viewLabel
	view._labelColor = viewLabel._labelColor
	view._labelAlign = opt.labelAlign
	view._labelXOffset = opt.labelXOffset
	view._labelYOffset = opt.labelYOffset
	view._hasAlphaFade = opt.hasAlphaFade

	-- Methods
	view._onPress = opt.onPress
	view._onRelease = opt.onRelease
	view._onEvent = opt.onEvent
	
	-------------------------------------------------------
	-- Assign properties/objects to the button
	-------------------------------------------------------
	
	-- Assign objects to the button
	button._view = view
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	-- Function to set the buttons fill color
	function button:setFillColor( ... )
		self._view:setFillColor( ... )
	end

	-- Function to set the buttons stroke color
	function button:setStrokeColor( ... )
		self._view:setStrokeColor( ... )
	end

	-- Function to set the button's label
	function button:setLabel( newLabel )
		return self._view:_setLabel( newLabel )
	end
	
	-- Function to get the button's label
	function button:getLabel()
		return self._view:_getLabel()
	end
	
	-- Function to set a button as active
	function button:setEnabled( isEnabled )
		self._view._isEnabled = isEnabled
	end
	
	-- Touch listener for our button
	function button:touch( event )
		-- Set the target to the view's parent group (the button object)
		event.target = self
		-- Manage touch events on the button
		manageButtonTouch( self._view, event )
		
		return true
	end
	
	button:addEventListener( "touch", button )
		
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Function to set the button's label
	function view:_setLabel( newLabel )
		-- Update the label's text
		if "function" == type( self._label.setText ) then
			self._label:setText( newLabel )
		else
			self._label.text = newLabel
		end
		
		-- Labels position
		if "center" == self._labelAlign then
			self._label.x = self.x + self._labelXOffset
		elseif "left" == self._labelAlign then
			self._label.x = self.x - ( self.contentWidth * 0.5 ) + ( self._label.contentWidth * 0.5 ) + 10 + self._labelXOffset
		elseif "right" == self._labelAlign then
			self._label.x = self.x + ( self.contentWidth * 0.5 ) - ( self._label.contentWidth * 0.5 ) - 10 + self._labelXOffset
		end		
			
		-- Update the label's y position
		self._label.y = self._label.y
	end
	
	-- Function to get the button's label
	function view:_getLabel()
		return self._label.text
	end
	
	-- Function to set the buttons current state
	function view:_setState( state )
		local newState = state
		
		if "over" == newState then
			-- Set the view to its over color
			if "table" == type( self._fillColor ) then
				self:setFillColor( unpack( self._fillColor.over ) )
			end
			if ( self._strokeColor and self._hasStroke == true and "table" == type(self._strokeColor) ) then
				self:setStrokeColor( unpack( self._strokeColor.over ) )
			end
			
			-- Set the label to its over color
			if "table" == type( self._label ) then
				self._label:setFillColor( unpack( self._label._labelColor.over ) )
			end
			
			-- The pressedState is now "over"
			self._pressedState = "over"
		
		elseif "default" == newState then
			-- Set the view back to its default color
			if "table" == type( self._fillColor ) then
				self:setFillColor( unpack( self._fillColor.default ) )
			end
			if ( self._strokeColor and self._hasStroke == true and "table" == type(self._strokeColor) ) then
				self:setStrokeColor( unpack( self._strokeColor.default ) )
			end
			
			-- Set the label back to its default color
			if "table" == type( self._label ) then
				self._label:setFillColor( unpack( self._label._labelColor.default ) )
			end
			
			-- The pressedState is now "default"
			self._pressedState = "default"
		end
	end
	
	-- Function to get the buttons current state
	function view:_getState()
		return self._pressedState
	end
	
	-- Lose focus function
	function button:_loseFocus()
		self._view:_setState( "default" )
		-- Create the alpha fade if the theme has it
		if self._view._hasAlphaFade and self._view._labelColor == nil then
			if self._view._label then
				transition.to( self._view._label, { time = 50, alpha = 1.0 } )
			else
				transition.to( self._view, { time = 50, alpha = 1.0 } )
			end
		end
	end
	
	-- Finalize function
	function button:_finalize()
	end
	
	return button
end


------------------------------------------------------------------------
-- Image Files Button
------------------------------------------------------------------------

-- Creates a new button from single png images
local function createUsingImageFiles( button, options )
	-- Create a local reference to our options table
	local opt = options
	
	-- Forward references
	local view, viewOver, viewLabel
	
	-- Create the view
	if opt.width and opt.height then
		view = display.newImageRect( button, opt.defaultFile, opt.baseDir, opt.width, opt.height )
	else
		view = display.newImage( button, opt.defaultFile, opt.baseDir )
	end
		
	-- Create the view 'over' object
	if opt.width and opt.height then
		viewOver = display.newImageRect( button, opt.overFile, opt.baseDir, opt.width, opt.height )
	else
		viewOver = display.newImage( button, opt.overFile, opt.baseDir )
	end

	-- Create the label (either embossed or standard)
	if opt.embossedLabel then
		viewLabel = display.newEmbossedText( button, opt.label, 0, 0, opt.font, opt.fontSize )
	else
		viewLabel = display.newText( button, opt.label, 0, 0, opt.font, opt.fontSize )
	end
	
	----------------------------------
	-- Positioning
	----------------------------------
	
	-- The view
	view.x = button.x + ( view.contentWidth * 0.5 )
	view.y = button.y + ( view.contentHeight * 0.5 )
	
	viewOver.x = view.x
	viewOver.y = view.y
	viewOver.isVisible = false
	
	-- Setup the label
	viewLabel:setFillColor( unpack( opt.labelColor.default ) )
	viewLabel._isLabel = true
	viewLabel._labelColor = opt.labelColor
	
	-- If there isn't an over color defined, fall back to default label color
	if not viewLabel._labelColor.over then
		viewLabel._labelColor.over = viewLabel._labelColor.default
	end
	
	-- Labels position
	if "center" == opt.labelAlign then
		viewLabel.x = view.x + opt.labelXOffset
	elseif "left" == opt.labelAlign then
		viewLabel.x = button.x + ( viewLabel.contentWidth * 0.5 ) + 10 + opt.labelXOffset
	elseif "right" == opt.labelAlign then
		viewLabel.x = view.x + ( view.contentWidth * 0.5 ) - ( viewLabel.contentWidth * 0.5 ) - 10 + opt.labelXOffset
	end
		
	-- Set the labels y position
	viewLabel.y = button.y + ( view.contentHeight * 0.5 ) + opt.labelYOffset
	
	-------------------------------------------------------
	-- Assign properties/objects to the view
	-------------------------------------------------------
	
	view._isEnabled = opt.isEnabled
	view._pressedState = "default"
	view._fontSize = opt.fontSize
	view._label = viewLabel
	view._labelColor = viewLabel._labelColor
	view._labelAlign = opt.labelAlign
	view._labelXOffset = opt.labelXOffset
	view._labelYOffset = opt.labelYOffset
	view._over = viewOver
	view._hasAlphaFade = opt.hasAlphaFade
	
	-- Methods
	view._onPress = opt.onPress
	view._onRelease = opt.onRelease
	view._onEvent = opt.onEvent
	
	-------------------------------------------------------
	-- Assign properties/objects to the button
	-------------------------------------------------------
	
	-- Assign objects to the button
	button._view = view
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	-- Function to set the buttons fill color
	function button:setFillColor( ... )
		self._view:setFillColor( ... )
		self._view._over:setFillColor( ... )
	end
	
	-- Function to set the button's label
	function button:setLabel( newLabel )
		return self._view:_setLabel( newLabel )
	end
	
	-- Function to get the button's label
	function button:getLabel()
		return self._view:_getLabel()
	end
	
	-- Function to set a button as active
	function button:setEnabled( isEnabled )
		self._view._isEnabled = isEnabled
	end
	
	-- Touch listener for our button
	function button:touch( event )
		-- Set the target to the view's parent group (the button object)
		event.target = self
		-- Manage touch events on the button
		manageButtonTouch( self._view, event )
		
		return true
	end
	
	button:addEventListener( "touch", button )
		
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Function to set the button's label
	function view:_setLabel( newLabel )
		-- Update the label's text
		if "function" == type( self._label.setText ) then
			self._label:setText( newLabel )
		else
			self._label.text = newLabel
		end
		
		-- Labels position
		if "center" == self._labelAlign then
			self._label.x = self.x + self._labelXOffset
		elseif "left" == self._labelAlign then
			self._label.x = self.x - ( self.contentWidth * 0.5 ) + ( self._label.contentWidth * 0.5 ) + 10 + self._labelXOffset
		elseif "right" == self._labelAlign then
			self._label.x = self.x + ( self.contentWidth * 0.5 ) - ( self._label.contentWidth * 0.5 ) - 10 + self._labelXOffset
		end		
			
		-- Update the label's y position
		self._label.y = self._label.y
	end
	
	-- Function to get the button's label
	function view:_getLabel()
		return self._label.text
	end
	
	-- Function to set the buttons current state
	function view:_setState( state )
		local newState = state
		
		if "over" == newState then
			-- Set the button to the over image state
			self.isVisible = false
			self._over.isVisible = true
			
			-- Set the label to it's over color
			if "table" == type( self._label ) then
				self._label:setFillColor( unpack( self._label._labelColor.over ) )
			end
			
			-- The pressedState is now "over"
			self._pressedState = "over"
		
		elseif "default" == newState then
			-- Set the piece to the default image state
			self.isVisible = true
			self._over.isVisible = false
			
			-- Set the label back to it's default color
			if "table" == type( self._label ) then
				self._label:setFillColor( unpack( self._label._labelColor.default ) )
			end
			
			-- The pressedState is now "default"
			self._pressedState = "default"
		end
	end
	
	-- Function to get the buttons current state
	function view:_getState()
		return self._pressedState
	end
	
	-- Lose focus function
	function button:_loseFocus()
		self._view:_setState( "default" )
		-- Create the alpha fade if the theme has it
		if self._view._hasAlphaFade and self._view._labelColor == nil then
			if self._view._label then
				transition.to( self._view._label, { time = 50, alpha = 1.0 } )
			else
				transition.to( self._view, { time = 50, alpha = 1.0 } )
			end
		end
	end
	
	-- Finalize function
	function button:_finalize()
	end
	
	return button
end
 

------------------------------------------------------------------------
-- Image Sheet (2 Frame) Button
------------------------------------------------------------------------

-- Creates a new button from a sprite (imageSheet)
local function createUsingImageSheet( button, options )
	-- Create a local reference to our options table
	local opt = options
	
	-- Animation options
	local sheetOptions = 
	{
		{
			name = "default", 
			start = opt.defaultFrame, 
			count = 1,
		},
		{
			name = "over", 
			start = opt.overFrame, 
			count = 1,
		},
	}
	
	-- Forward references
	local view, viewLabel
	
	-- Create a reference to the imageSheet
	local imageSheet = opt.sheet
		
	-- Create the view
	view = display.newSprite( button, imageSheet, sheetOptions )

	-- Create the label (either embossed or standard)
	if opt.embossedLabel then
		viewLabel = display.newEmbossedText( button, opt.label, 0, 0, opt.font, opt.fontSize )
	else
		viewLabel = display.newText( button, opt.label, 0, 0, opt.font, opt.fontSize )
	end
	
	----------------------------------
	-- Positioning
	----------------------------------
	
	-- The view
	view.x = button.x + ( view.contentWidth * 0.5 )
	view.y = button.y + ( view.contentHeight * 0.5 )
	
	-- Setup the label
	viewLabel:setFillColor( unpack( opt.labelColor.default ) )
	viewLabel._isLabel = true
	viewLabel._labelColor = opt.labelColor
	
	-- If there isn't an over color defined, fall back to default label color
	if not viewLabel._labelColor.over then
		viewLabel._labelColor.over = viewLabel._labelColor.default
	end
	
	-- Labels position
	if "center" == opt.labelAlign then
		viewLabel.x = view.x + opt.labelXOffset
	elseif "left" == opt.labelAlign then
		viewLabel.x = view.x - ( view.contentWidth * 0.5 ) + ( viewLabel.contentWidth * 0.5 ) + 10 + opt.labelXOffset
	elseif "right" == opt.labelAlign then
		viewLabel.x = view.x + ( view.contentWidth * 0.5 ) - ( viewLabel.contentWidth * 0.5 ) - 10 + opt.labelXOffset
	end
	
	-- Set the labels y position
	viewLabel.y = button.y + ( view.contentHeight * 0.5 ) + opt.labelYOffset
	
	-------------------------------------------------------
	-- Assign properties/objects to the view
	-------------------------------------------------------
	
	view._isEnabled = opt.isEnabled
	view._pressedState = "default"
	view._fontSize = opt.fontSize
	view._label = viewLabel
	view._labelColor = viewLabel._labelColor
	view._labelAlign = opt.labelAlign
	view._labelXOffset = opt.labelXOffset
	view._labelYOffset = opt.labelYOffset
	view._hasAlphaFade = opt.hasAlphaFade
	
	-- Methods
	view._onPress = opt.onPress
	view._onRelease = opt.onRelease
	view._onEvent = opt.onEvent
	
	-------------------------------------------------------
	-- Assign properties/objects to the button
	-------------------------------------------------------
	
	-- Assign objects to the button
	button._imageSheet = imageSheet
	button._view = view
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	-- Function to set the buttons fill color
	function button:setFillColor( ... )
		self._view:setFillColor( ... )
	end
	
	-- Function to set the button's label
	function button:setLabel( newLabel )
		return self._view:_setLabel( newLabel )
	end
	
	-- Function to get the button's label
	function button:getLabel()
		return self._view:_getLabel()
	end
	
	-- Function to set a button as active
	function button:setEnabled( isEnabled )
		self._view._isEnabled = isEnabled
	end

	-- Touch listener for our button
	function button:touch( event )
		-- Set the target to the view's parent group (the button object)
		event.target = self
		
		-- Manage touch events on the button
		manageButtonTouch( self._view, event )
		return true
	end
	
	button:addEventListener( "touch", button )
	
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Function to set the button's label
	function view:_setLabel( newLabel )
		-- Update the label's text
		if "function" == type( self._label.setText ) then
			self._label:setText( newLabel )
		else
			self._label.text = newLabel
		end
		
		-- Labels position
		if "center" == self._labelAlign then
			self._label.x = view.x + self._labelXOffset
		elseif "left" == self._labelAlign then
			self._label.x = view.x - ( self.contentWidth * 0.5 ) + ( self._label.contentWidth * 0.5 ) + 10 + self._labelXOffset
		elseif "right" == self._labelAlign then
			self._label.x = self.x + ( self.contentWidth * 0.5 ) - ( self._label.contentWidth * 0.5 ) - 10 + self._labelXOffset
		end
				
		-- Update the label's y position
		self._label.y = self._label.y
	end
	
	-- Function to get the button's label
	function view:_getLabel()
		return self._label.text
	end
	
	-- Function to set the buttons current state
	function view:_setState( state )
		local newState = state
		
		if "over" == newState then
			-- Set the button to the over image state
			self:setSequence( "over" )
			
			-- Set the label to it's over color
			if "table" == type( self._label ) then
				self._label:setFillColor( unpack( self._label._labelColor.over ) )
			end
			
			-- The pressedState is now "over"
			self._pressedState = "over"
		
		elseif "default" == newState then
			-- Set the piece to the default image state
			self:setSequence( "default" )
			
			-- Set the label back to it's default color
			if "table" == type( self._label ) then
				self._label:setFillColor( unpack( self._label._labelColor.default ) )
			end
			
			-- The pressedState is now "default"
			self._pressedState = "default"
		end
	end
	
	-- Function to get the buttons current state
	function view:_getState()
		return self._pressedState
	end
	
	-- Lose focus function
	function button:_loseFocus()
		self._view:_setState( "default" )
		-- Create the alpha fade if the theme has it
		if self._view._hasAlphaFade and self._view._labelColor == nil then
			if self._view._label then
				transition.to( self._view._label, { time = 50, alpha = 1.0 } )
			else
				transition.to( self._view, { time = 50, alpha = 1.0 } )
			end
		end
	end
	
	-- Finalize function
	function button:_finalize()
		-- Set the ImageSheet to nil
		self._imageSheet = nil
		if imageSheet then imageSheet = nil; end
		if ( opt and opt.sheet ) then opt.sheet = nil; end
	end
	
	return button
end


------------------------------------------------------------------------
-- Image Sheet (9 piece/slice) Button
------------------------------------------------------------------------

-- Creates a new button from a 9 piece sprite
local function createUsing9Slice( button, options )
	-- Create a local reference to our options table
	local opt = options
	
	-- Forward references
	local imageSheet, view, viewLabel
	
	local viewTopLeft, viewMiddleLeft, viewBottomLeft
	local viewTopMiddle, viewMiddle, viewBottomMiddle
	local viewTopRight, viewMiddleRight, viewBottomRight

	-- Create the imageSheet
	if opt.sheet then
		imageSheet = opt.sheet
	else
		local themeData = require( opt.themeData )
		imageSheet = graphics.newImageSheet( opt.themeSheetFile, themeData:getSheet() )
	end
	
	-- The view is the button (group)
	view = display.newGroup()
	button:insert( view )
	
	-- Imagesheet options
	local sheetOptions =
	{
		-- Top Left 
		viewTopLeft =
		{
			{
				name = "default",
				start = opt.topLeftFrame,
				count = 1,
			},

			{
				name = "over",
				start = opt.topLeftOverFrame,
				count = 1,
			}
		},
		
		-- Middle Left
		viewMiddleLeft =
		{
			{
				name = "default",
				start = opt.middleLeftFrame,
				count = 1,
			},

			{
				name = "over",
				start = opt.middleLeftOverFrame,
				count = 1,
			}
		},
		
		-- Bottom Left
		viewBottomLeft =
		{
			{
				name = "default",
				start = opt.bottomLeftFrame,
				count = 1,
			},

			{
				name = "over",
				start = opt.bottomLeftOverFrame,
				count = 1,
			}
		},
		
		-- Top Middle
		viewTopMiddle =
		{
			{
				name = "default",
				start = opt.topMiddleFrame,
				count = 1,
			},

			{
				name = "over",
				start = opt.topMiddleOverFrame,
				count = 1,
			}
		},
		
		-- Middle
		viewMiddle =
		{
			{
				name = "default",
				start = opt.middleFrame,
				count = 1,
			},

			{
				name = "over",
				start = opt.middleOverFrame,
				count = 1,
			}
		},
		
		-- Bottom Middle
		viewBottomMiddle =
		{
			{
				name = "default",
				start = opt.bottomMiddleFrame,
				count = 1,
			},

			{
				name = "over",
				start = opt.bottomMiddleOverFrame,
				count = 1,
			}
		},
		
		
		-- Top Right
		viewTopRight =
		{
			{
				name = "default",
				start = opt.topRightFrame,
				count = 1,
			},

			{
				name = "over",
				start = opt.topRightOverFrame,
				count = 1,
			}
		},
		
		-- Middle Right
		viewMiddleRight =
		{
			{
				name = "default",
				start = opt.middleRightFrame,
				count = 1,
			},

			{
				name = "over",
				start = opt.middleRightOverFrame,
				count = 1,
			}
		},
		
		-- Bottom Right
		viewBottomRight =
		{
			{
				name = "default",
				start = opt.bottomRightFrame,
				count = 1,
			},

			{
				name = "over",
				start = opt.bottomRightOverFrame,
				count = 1,
			}
		},
	}
	
	
	-- Create the left portion of the button
	viewTopLeft = display.newSprite( view, imageSheet, sheetOptions.viewTopLeft )
	viewMiddleLeft = display.newSprite( view, imageSheet, sheetOptions.viewMiddleLeft )
	viewBottomLeft = display.newSprite( view, imageSheet, sheetOptions.viewBottomLeft )

	-- Create the right portion of the button
	viewTopRight = display.newSprite( view, imageSheet, sheetOptions.viewTopRight )
	viewMiddleRight = display.newSprite( view, imageSheet, sheetOptions.viewMiddleRight )
	viewBottomRight = display.newSprite( view, imageSheet, sheetOptions.viewBottomRight )
	
	-- Create the middle portion of the button
	viewTopMiddle = display.newSprite( view, imageSheet, sheetOptions.viewTopMiddle )
	viewMiddle = display.newSprite( view, imageSheet, sheetOptions.viewMiddle )
	viewBottomMiddle = display.newSprite( view, imageSheet, sheetOptions.viewBottomMiddle )

	-- Create the label (either embossed or standard)
	if opt.embossedLabel then
		viewLabel = display.newEmbossedText( view, opt.label, 0, 0, opt.font, opt.fontSize )
	else
		viewLabel = display.newText( view, opt.label, 0, 0, opt.font, opt.fontSize )
	end
	
	----------------------------------
	-- Positioning
	----------------------------------
	
	-- Top
	viewTopLeft.x = button.x + ( viewTopLeft.contentWidth * 0.5 )
	viewTopLeft.y = button.y + ( viewTopLeft.contentHeight * 0.5 )
	
	viewTopMiddle.width = opt.width - ( viewTopLeft.contentWidth + viewTopRight.contentWidth )
	viewTopMiddle.x = viewTopLeft.x + ( viewTopLeft.contentWidth * 0.5 ) + ( viewTopMiddle.contentWidth * 0.5 )
	viewTopMiddle.y = viewTopLeft.y
	viewTopMiddle._width = viewTopMiddle.width
	
	viewTopRight.x = viewTopMiddle.x + ( viewTopMiddle.contentWidth * 0.5 ) + ( viewTopRight.contentWidth * 0.5 )
	viewTopRight.y = viewTopLeft.y
	
	-- Middle
	viewMiddleLeft.height = opt.height - ( viewTopLeft.contentHeight + viewTopRight.contentHeight )
	viewMiddleLeft.x = viewTopLeft.x
	viewMiddleLeft.y = viewTopLeft.y + ( viewMiddleLeft.contentHeight * 0.5 ) + ( viewBottomLeft.contentHeight * 0.5 )
	viewMiddleLeft._height = viewMiddleLeft.height
	
	viewMiddle.width = viewTopMiddle.width
	viewMiddle.height = opt.height - ( viewTopLeft.contentHeight + ( viewTopRight.contentHeight ) )
	viewMiddle.x = viewTopMiddle.x
	viewMiddle.y = viewTopMiddle.y + ( viewTopMiddle.contentHeight * 0.5 ) + ( viewMiddle.contentHeight * 0.5 )
	viewMiddle._width = viewMiddle.width
	viewMiddle._height = viewMiddle.height
	
	viewMiddleRight.height = opt.height - ( viewTopLeft.contentHeight + viewTopRight.contentHeight )
	viewMiddleRight.x = viewTopRight.x
	viewMiddleRight.y = viewTopRight.y + ( viewMiddleRight.contentHeight * 0.5 ) + ( viewBottomRight.contentHeight * 0.5 )
	viewMiddleRight._height = viewMiddleRight.height
	
	-- Bottom
	viewBottomLeft.x = viewTopLeft.x
	viewBottomLeft.y = viewMiddle.y + ( viewMiddle.contentHeight * 0.5 ) + ( viewBottomLeft.contentHeight * 0.5 )
	
	viewBottomMiddle.width = viewTopMiddle.width
	viewBottomMiddle.x = viewTopMiddle.x
	viewBottomMiddle.y = viewMiddle.y + ( viewMiddle.contentHeight * 0.5 ) + ( viewBottomMiddle.contentHeight * 0.5 )
	viewBottomMiddle._width = viewBottomMiddle.width
	
	viewBottomRight.x = viewTopRight.x
	viewBottomRight.y = viewMiddle.y + ( viewMiddle.contentHeight * 0.5 ) + ( viewBottomRight.contentHeight * 0.5 )

	-- If the passed width is less than the topLeft & top right width then don't use the middle pieces
	if opt.width <= ( viewTopLeft.contentWidth + viewTopRight.contentWidth ) then
		-- Hide the middle slices
		viewTopMiddle.isVisible = false
		viewMiddle.isVisible = false
		viewBottomMiddle.isVisible = false
		
		-- Re-position slices
		viewTopRight.x = viewTopLeft.x + ( viewTopLeft.contentWidth * 0.5 ) + ( viewBottomRight.contentWidth * 0.5 )
		viewMiddleRight.x = viewTopLeft.x + ( viewTopLeft.contentWidth * 0.5 ) + ( viewBottomRight.contentWidth * 0.5 )
		viewBottomRight.x = viewTopLeft.x + ( viewTopLeft.contentWidth * 0.5 ) + ( viewBottomRight.contentWidth * 0.5 )
	end
	
	-- If the passed height is less than the topLeft & top right height then don't use the middle pieces
	if opt.height <= ( viewTopLeft.contentHeight + viewTopRight.contentHeight ) then
		if opt.width <= ( viewTopLeft.contentWidth + viewTopRight.contentWidth )  then
			-- Hide the middle slices
			viewMiddleRight.isVisible = false
			viewMiddleLeft.isVisible = false
			viewMiddle.isVisible = false
			viewTopMiddle.isVisible = false
			viewBottomMiddle.isVisible = false
			
			-- Re-position slices
			viewTopRight.x = viewTopLeft.x + ( viewTopLeft.contentWidth * 0.5 ) + ( viewTopRight.contentWidth * 0.5 )
			viewBottomLeft.y = viewTopLeft.y + ( viewTopLeft.contentHeight * 0.5 ) + ( viewBottomLeft.contentHeight * 0.5 )		
			viewBottomRight.x = viewTopLeft.x + ( viewTopLeft.contentWidth * 0.5 ) + ( viewTopRight.contentWidth * 0.5 )
			viewBottomRight.y = viewTopLeft.y + ( viewTopLeft.contentHeight * 0.5 ) + ( viewBottomRight.contentHeight * 0.5 )
			
		else
			-- Hide the middle slices
			viewMiddle.isVisible = false
			viewMiddleRight.isVisible = false
			viewMiddleLeft.isVisible = false
			
			-- Re-position slices
			viewBottomLeft.y = viewTopLeft.y + ( viewTopLeft.contentHeight * 0.5 ) + ( viewBottomLeft.contentHeight * 0.5 )
			viewBottomMiddle.y = viewTopLeft.y + ( viewTopLeft.contentHeight * 0.5 ) + ( viewBottomLeft.contentHeight * 0.5 )			
			viewBottomRight.y = viewTopLeft.y + ( viewTopLeft.contentHeight * 0.5 ) + ( viewBottomRight.contentHeight * 0.5 )
			
		end
	end

	-- Setup the Label
	viewLabel:setFillColor( unpack( opt.labelColor.default ) )
	viewLabel._isLabel = true
	viewLabel._labelColor = opt.labelColor
	
	-- If there isn't an over color defined, fall back to default label color
	if not viewLabel._labelColor.over then
		viewLabel._labelColor.over = viewLabel._labelColor.default
	end
	
	-- Label's position
	if "center" == opt.labelAlign then
		viewLabel.x = button.x + ( opt.width * 0.5 ) + opt.labelXOffset   
	elseif "left" == opt.labelAlign then
		viewLabel.x = viewTopLeft.x + ( viewLabel.contentWidth * 0.5 ) + opt.labelXOffset
	elseif "right" == opt.labelAlign then
		viewLabel.x = viewTopRight.x - ( viewLabel.contentWidth * 0.5 ) + opt.labelXOffset
	end
	
	-- The label's y position
	local minHeight = opt.height
	if opt.height < 30 then
	    minHeight = 30
	end
	viewLabel.y = button.y + ( minHeight * 0.5 ) + opt.labelYOffset
	
	-------------------------------------------------------
	-- Assign properties/objects to the view
	-------------------------------------------------------
	
	view._isEnabled = opt.isEnabled
	view._pressedState = "default"
	view._width = opt.width
	view._fontSize = opt.fontSize
	view._labelAlign = opt.labelAlign
	view._labelXOffset = opt.labelXOffset
	view._labelYOffset = opt.labelYOffset
	view._label = viewLabel
	view._topLeft = viewTopLeft
	view._middleLeft = viewMiddleLeft
	view._bottomLeft = viewBottomLeft
	view._topMiddle = viewTopMiddle
	view._middle = viewMiddle
	view._bottomMiddle = viewBottomMiddle
	view._topRight = viewTopRight
	view._middleRight = viewMiddleRight
	view._bottomRight = viewBottomRight
	view._hasAlphaFade = opt.hasAlphaFade
	
	-- Methods
	view._onPress = opt.onPress
	view._onRelease = opt.onRelease
	view._onEvent = opt.onEvent
	
	-------------------------------------------------------
	-- Assign properties/objects to the button
	-------------------------------------------------------
	
	-- Assign objects to the button
	button._imageSheet = imageSheet
	button._view = view
		
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------

	-- Function to set the buttons fill color
	function button:setFillColor( ... )
		for i = self._view.numChildren, 1, -1 do
			if ( not self._view[i]._isLabel and "function" == type( self._view[i].setFillColor ) ) then
				self._view[i]:setFillColor( ... )
			end
		end
	end

	-- Function to set the button's label
	function button:setLabel( newLabel )
		return self._view:_setLabel( newLabel )
	end
	
	-- Function to get the button's label
	function button:getLabel()
		return self._view:_getLabel()
	end
	
	-- Function to set a button as active
	function button:setEnabled( isEnabled )
		self._view._isEnabled = isEnabled
	end

	-- Touch listener for our button
	function button:touch( event )
		-- Manage touch events on the button
		manageButtonTouch( self._view, event )
		return true
	end
	
	button:addEventListener( "touch", button )
	
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Function to set the button's label
	function view:_setLabel( newLabel )
		if "function" == type( self._label.setText ) then
			self._label:setText( newLabel )
		else
			self._label.text = newLabel
		end
		
		-- Labels position
		if "left" == self._labelAlign then
			self._label.x = self._topLeft.x + ( self._label.contentWidth * 0.5 ) + self._labelXOffset			
		elseif "right" == self._labelAlign then
			self._label.x = self._topRight.x - ( self._label.contentWidth * 0.5 ) - self._labelXOffset
		end

		-- Update the label's y position
		self._label.y = self._label.y
	end
	
	-- Function to get the button's label
	function view:_getLabel()
		return self._label.text
	end
	
	-- Function to set the buttons current state
	function view:_setState( state )
		local newState = state
		
		if "over" == newState then
			-- Loop through the pieces and set them to the over image state
			for i = self.numChildren, 1, - 1 do
				local child = self[i]
				
				-- If the child is a label then set it's color
				if child._isLabel then
					child:setFillColor( unpack( child._labelColor.over ) )
				
				-- The child is a button piece 
				else
					-- Set the piece to the over image state
					child:setSequence( "over" )
				
					-- Set the width again. ( should i have to do this, a possible Corona bug? )
					if child._width then
						child.width = child._width
					end
				
					-- Set the height again. ( should i have to do this, a possible Corona bug? )
					if child._height then
						child.height = child._height
					end
				end
			end
			
			-- The pressedState is now "over"
			self._pressedState = "over"
		
		elseif "default" == newState then
			-- Loop through the pieces and set them to the default image state
			for i = self.numChildren, 1, - 1 do
				local child = self[i]
				
				-- If the child is a label then set it's color
				if child._isLabel then
					child:setFillColor( unpack( child._labelColor.default ) )
					
				-- The child is a button piece 
				else
					-- Set the piece to the default image state
					child:setSequence( "default" )
				
					-- Set the width again. ( should i have to do this, a possible Corona bug? )
					if child._width then
						child.width = child._width
					end
				
					-- Set the height again. ( should i have to do this, a possible Corona bug? )
					if child._height then
						child.height = child._height
					end
				end
			end
			
			-- The pressedState is now "default"
			self._pressedState = "default"
		end
	end
	
	-- Function to get the buttons current state
	function view:_getState()
		return self._pressedState
	end
	
	-- Lose focus function
	function button:_loseFocus()
		self._view:_setState( "default" )
		-- Create the alpha fade if the theme has it
		if self._view._hasAlphaFade and self._view._labelColor == nil then
			if self._view._label then
				transition.to( self._view._label, { time = 50, alpha = 1.0 } )
			else
				transition.to( self._view, { time = 50, alpha = 1.0 } )
			end
		end
	end
		
	-- Finalize function
	function button:_finalize()
		-- Set the ImageSheet to nil
		self._imageSheet = nil
		if imageSheet then imageSheet = nil; end
		if ( opt and opt.sheet ) then opt.sheet = nil; end
	end
		
	return button
end


-- Function to create a new button object ( widget.newButton )
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
	opt.width = customOptions.width or themeOptions.width
	opt.height = customOptions.height or themeOptions.height
	opt.id = customOptions.id
	opt.baseDir = customOptions.baseDir or system.ResourceDirectory
	opt.label = customOptions.label or ""
	opt.labelColor = customOptions.labelColor or themeOptions.labelColor
	opt.font = customOptions.font or themeOptions.font or native.systemFont
	opt.fontSize = customOptions.fontSize or themeOptions.fontSize or 14
	
	opt.labelAlign = customOptions.labelAlign or "center"
	opt.labelXOffset = customOptions.labelXOffset or 0
	opt.labelYOffset = customOptions.labelYOffset or 0
	opt.embossedLabel = customOptions.emboss or themeOptions.emboss or false
	opt.isEnabled = customOptions.isEnabled
	
	opt.shape = customOptions.shape or nil
	opt.cornerRadius = customOptions.cornerRadius or nil
	opt.radius = customOptions.radius or nil
	opt.vertices = customOptions.vertices or nil
	opt.fillColor = customOptions.fillColor or nil
	opt.strokeColor = customOptions.strokeColor or nil
	opt.strokeWidth = customOptions.strokeWidth or nil
	
	opt.textOnlyButton = customOptions.textOnly or false

	-- set the alpha fade param if the theme declares it
	opt.hasAlphaFade = themeOptions.alphaFade or false
	
	-- If the user didn't pass in a isEnabled flag, set it to true
	if nil == opt.isEnabled then
		opt.isEnabled = true
	end
	
	opt.onPress = customOptions.onPress
	opt.onRelease = customOptions.onRelease
	opt.onEvent = customOptions.onEvent
	
	-- Frames & Images
	opt.sheet = customOptions.sheet
	opt.themeSheetFile = themeOptions.sheet
	opt.themeData = themeOptions.data
	
	-- Single image files
	opt.defaultFile = customOptions.defaultFile
	opt.overFile = customOptions.overFile
	
	if opt.defaultFile or opt.overFile then
		opt.width = customOptions.width
		opt.height = customOptions.height
	end 
	
	-- ImageSheet ( 2 frame button )
	opt.defaultFrame = customOptions.defaultFrame or _widget._getFrameIndex( themeOptions, themeOptions.defaultFrame )
	opt.overFrame = customOptions.overFrame or _widget._getFrameIndex( themeOptions, themeOptions.overFrame )
	
	-- Left ( 9 piece set )
	opt.topLeftFrame = customOptions.topLeftFrame or _widget._getFrameIndex( themeOptions, themeOptions.topLeftFrame )
	opt.topLeftOverFrame = customOptions.topLeftOverFrame or _widget._getFrameIndex( themeOptions, themeOptions.topLeftOverFrame )
	opt.middleLeftFrame = customOptions.middleLeftFrame or _widget._getFrameIndex( themeOptions, themeOptions.middleLeftFrame )
	opt.middleLeftOverFrame = customOptions.middleLeftOverFrame or _widget._getFrameIndex( themeOptions, themeOptions.middleLeftOverFrame )
	opt.bottomLeftFrame = customOptions.bottomLeftFrame or _widget._getFrameIndex( themeOptions, themeOptions.bottomLeftFrame )
	opt.bottomLeftOverFrame = customOptions.bottomLeftOverFrame or _widget._getFrameIndex( themeOptions, themeOptions.bottomLeftOverFrame )
	
	-- Right ( 9 piece set )
	opt.topRightFrame = customOptions.topRightFrame or _widget._getFrameIndex( themeOptions, themeOptions.topRightFrame )
	opt.topRightOverFrame = customOptions.topRightOverFrame or _widget._getFrameIndex( themeOptions, themeOptions.topRightOverFrame )
	opt.middleRightFrame = customOptions.middleRightFrame or _widget._getFrameIndex( themeOptions, themeOptions.middleRightFrame )
	opt.middleRightOverFrame = customOptions.middleRightOverFrame or _widget._getFrameIndex( themeOptions, themeOptions.middleRightOverFrame )
	opt.bottomRightFrame = customOptions.bottomRightFrame or _widget._getFrameIndex( themeOptions, themeOptions.bottomRightFrame )
	opt.bottomRightOverFrame = customOptions.bottomRightOverFrame or _widget._getFrameIndex( themeOptions, themeOptions.bottomRightOverFrame )
	
	-- Middle ( 9 piece set )
	opt.topMiddleFrame = customOptions.topMiddleFrame or _widget._getFrameIndex( themeOptions, themeOptions.topMiddleFrame )
	opt.topMiddleOverFrame = customOptions.topMiddleOverFrame or _widget._getFrameIndex( themeOptions, themeOptions.topMiddleOverFrame )
	opt.middleFrame = customOptions.middleFrame or _widget._getFrameIndex( themeOptions, themeOptions.middleFrame )
	opt.middleOverFrame = customOptions.middleOverFrame or _widget._getFrameIndex( themeOptions, themeOptions.middleOverFrame )
	opt.bottomMiddleFrame = customOptions.bottomMiddleFrame or _widget._getFrameIndex( themeOptions, themeOptions.bottomMiddleFrame )
	opt.bottomMiddleOverFrame = customOptions.bottomMiddleOverFrame or _widget._getFrameIndex( themeOptions, themeOptions.bottomMiddleOverFrame )

	-- Are we using a nine piece button?
	local using9PieceButton = not opt.defaultFrame and not opt.overFrame and not opt.defaultFile and not opt.overFile and not opt.textOnlyButton and not opt.shape and opt.topLeftFrame and opt.topLeftOverFrame and opt.middleLeftFrame and opt.middleLeftOverFrame and opt.bottomLeftFrame and opt.bottomLeftOverFrame and opt.topRightFrame and opt.topRightOverFrame and opt.middleRightFrame and opt.middleRightOverFrame and opt.bottomRightFrame and opt.bottomRightOverFrame and opt.topMiddleFrame and opt.topMiddleOverFrame and opt.middleFrame and opt.middleOverFrame and opt.bottomMiddleFrame and opt.bottomMiddleOverFrame

	-- If we are using a 9-piece button and have not passed in an imageSheet, throw an error
	local isUsingSheet = opt.sheet or opt.themeSheetFile
	
	-- If were using a 9 piece/slice button and have not passed a width/height
	if using9PieceButton and not opt.width then
		error( "ERROR: " .. M._widgetName .. ": width expected, got nil", 3 )
	elseif using9PieceButton and not opt.height then
		error( "ERROR: " .. M._widgetName .. ": height expected, got nil", 3 )
	end
	
	if using9PieceButton and not isUsingSheet then
		error( "ERROR: " .. M._widgetName .. ": 9 piece frame or default/over frame definition expected, got nil", 3 )
	end
	
	-- Are we using a 2 frame button?
	local using2FrameButton = not using9PieceButton and opt.defaultFrame and not opt.shape
	
	-- If we are using a 2 frame button and have not passed in an imageSheet, throw an error
	if using2FrameButton and not opt.sheet then
		error( "ERROR: " .. M._widgetName .. ": sheet definition expected, got nil", 3 )
	end
	
	-- Ensure the user passed in both a default and over frame index.
	if not using9PieceButton and opt.defaultFrame and not opt.overFrame then
		opt.overFrame = opt.defaultFrame -- Fall back to defaultFrame if overFile is not specified
	elseif not using9PieceButton and opt.overFrame and not opt.defaultFrame then
		error( "ERROR: " .. M._widgetName .. ": defaultFrame definition expected, got nil", 3 )
	end
	
	-- If we are using single images, ensure BOTH files are specified
	if not using9PieceButton and not using2FrameButton and opt.defaultFile and not opt.overFile then
		opt.overFile = opt.defaultFile -- Fall back to defaultFile if overFile is not specified
	end
	if not using9PieceButton and not using2FrameButton and opt.overFile and not opt.defaultFile then
		error( "ERROR: " .. M._widgetName .. ": defaultFile definition expected, got nil", 3 )
	end
	
	-- Are we using a vector button?
	local usingVectorButton = opt.shape and not using9PieceButton and not using2FrameButton and not opt.textOnlyButton
	
	-- Turn off theme setting for text emboss if the user isn't using a theme
	if "boolean" == type( customOptions.emboss ) then
		opt.embossedLabel = customOptions.emboss
	end
		
	--[[
	Notes: 
		*) A 9-piece/slice button is favored over a 2 frame button.
		*) A 2 frame button is favored over a 2 file button.
	--]]
		
	-- Favor nine piece button over single image button
	if using9PieceButton then
		opt.defaultFrame = nil
		opt.overFrame = nil
	end
	
	-- Favor 2 frame button over 2 file button
	if using2FrameButton then
		opt.defaultFile = nil
		opt.overFile = nil
	end

	-------------------------------------------------------
	-- Create the button
	-------------------------------------------------------
		
	-- Create the button object
	local button = _widget._new
	{
		left = opt.left,
		top = opt.top,
		id = opt.id or "widget_button",
		baseDir = opt.baseDir,
		widgetType = "button",
	}

	-- Create the button
	if using9PieceButton then
		-- If using a 9-slice button
		createUsing9Slice( button, opt )

	else
		-- If using a 2-frame button
		if using2FrameButton then
			createUsingImageSheet( button, opt )
		end
		
		-- If using a 2-image button
		if opt.defaultFile and opt.overFile and not usingVectorButton then
			createUsingImageFiles( button, opt )
		end

		-- If using a vector button
		if usingVectorButton then
			createUsingVectorObject( button, opt )
		end
		
		-- If using a text-only button
		if opt.textOnlyButton then
			createUsingText( button, opt )
		end
	end
	
	-- Set the button's position ( set the reference point to center, just to be sure )
	if ( isGraphicsV1 ) then
		button:setReferencePoint( display.CenterReferencePoint )
	end
	
	local x, y = _widget._calculatePosition( button, opt )
	button.x, button.y = x, y

	return button
end

return M
