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
	_widgetName = "widget.newSearchField",
}


-- Require needed widget files
local _widget = require( "widget" )

local isGraphicsV1 = ( 1 == display.getDefault( "graphicsCompatibility" ) )

-- Creates a new search field from an image
local function initWithImage( searchField, options )
	local opt = options
	
	-- If there is an image, don't attempt to use a sheet
	if opt.imageDefault then
		opt.sheet = nil
	end
	
	-- Forward references
	local imageSheet, view, viewLeft, viewRight, viewMiddle, magnifyingGlass, cancelButton, viewTextField
	
	-- Create the imageSheet
	if opt.sheet then
		imageSheet = opt.sheet
	else
		local themeData = require( opt.themeData )
		imageSheet = graphics.newImageSheet( opt.themeSheetFile, themeData:getSheet() )
	end
	
	-- Create the view
	view = searchField
	
	-- The left edge
	viewLeft = display.newImageRect( searchField, imageSheet, opt.leftFrame, opt.edgeWidth, opt.edgeHeight )
	
	-- The right edge
	viewRight = display.newImageRect( searchField, imageSheet, opt.rightFrame, opt.edgeWidth, opt.edgeHeight )
	
	-- The middle fill
	viewMiddle = display.newImageRect( searchField, imageSheet, opt.middleFrame, opt.edgeWidth, opt.edgeHeight )
	
	-- The magnifying glass
	magnifyingGlass = display.newImageRect( searchField, imageSheet, opt.magnifyingGlassFrame, opt.magnifyingGlassFrameWidth, opt.magnifyingGlassFrameHeight )
	
	-- The SearchFields cancel button
	cancelButton = display.newImageRect( searchField, imageSheet, opt.cancelFrame, opt.magnifyingGlassFrameWidth, opt.magnifyingGlassFrameHeight )
	
	-- Create the textbox (that is contained within the searchField)
	viewTextField = native.newTextField( 0, 0, opt.textFieldWidth, opt.textFieldHeight )
	
	----------------------------------
	-- Positioning
	----------------------------------
	
	-- Position the searchField graphic and assign properties (if any)
	viewLeft.x = searchField.x + ( view.contentWidth * 0.5 )
	viewLeft.y = searchField.y + ( view.contentHeight * 0.5 )
	
	viewMiddle.width = opt.width
	viewMiddle.x = viewLeft.x + ( viewMiddle.width * 0.5 ) + ( viewLeft.contentWidth * 0.5 )
	viewMiddle.y = viewLeft.y
	
	viewRight.x = viewMiddle.x + ( viewMiddle.width * 0.5 ) + ( viewRight.contentWidth * 0.5 )
	viewRight.y = viewLeft.y
	
	magnifyingGlass.x = viewLeft.x + ( viewLeft.contentWidth * 0.5 )
	if _widget.isSeven() then
		magnifyingGlass.x = magnifyingGlass.x + 10
	end
	magnifyingGlass.y = viewLeft.y
	
	-- Set the cancel buttons position and assign properties (if any)
	cancelButton.x = viewRight.x - ( cancelButton.contentWidth * 0.5 ) + opt.cancelButtonXOffset
	if _widget.isSeven() then
		cancelButton.x = cancelButton.x - 6
	end
	cancelButton.y = viewLeft.y + opt.cancelButtonYOffset
	cancelButton.isVisible = false
	
	-- Position the searchField's textField and assign properties (if any)
	--viewTextField:setReferencePoint( display.CenterReferencePoint )
	viewTextField.x = viewLeft.x - magnifyingGlass.contentWidth + opt.textFieldXOffset
	viewTextField.y = viewLeft.y + opt.textFieldYOffset
	viewTextField.isEditable = true
	viewTextField.hasBackground = false
	viewTextField.align = "left"
	viewTextField.placeholder = opt.placeholder
	viewTextField._xOffset = opt.textFieldXOffset
	viewTextField._yOffset = opt.textFieldYOffset
	viewTextField._listener = opt.listener
		
	-- Objects
	view._originalX = viewLeft.x
	view._originalY = viewLeft.y
	view._textFieldTimer = nil
	view._textField = viewTextField
	view._magnifyingGlass = magnifyingGlass
	view._cancelButton = cancelButton
	
	-------------------------------------------------------
	-- Assign properties/objects to the searchField
	-------------------------------------------------------
	
	searchField._imageSheet = imageSheet
	searchField._view = view
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	-- Handle touch events on the Cancel button
	function cancelButton:touch( event )
		local phase = event.phase
		
		if "ended" == phase then
			-- Clear any text in the textField
			view._textField.text = ""
			
			-- Hide the cancel button
			view._cancelButton.isVisible = false
		end
		
		return true
	end
	
	cancelButton:addEventListener( "touch" )
	
	-- Handle tap events on the Cancel button
	function cancelButton:tap( event )
		-- Clear any text in the textField
		view._textField.text = ""
		
		-- Hide the cancel button
		view._cancelButton.isVisible = false
		
		return true
	end
	
	cancelButton:addEventListener( "tap" )
	
	-- Function to listen for textbox events
	function viewTextField:_inputListener( event )
		local phase = event.phase
		
		if "editing" == phase then
			-- If there is one or more characters in the textField show the cancel button, if not hide it
			if string.len( event.text ) >= 1 then
				view._cancelButton.isVisible = true
			else
				view._cancelButton.isVisible = false
			end
		
		elseif "submitted" == phase then
			-- Hide keyboard
			native.setKeyboardFocus( nil )
		end
		
		-- If there is a listener defined, execute it
		if self._listener then
			self._listener( event )
		end
	end
	
	viewTextField.userInput = viewTextField._inputListener
	viewTextField:addEventListener( "userInput" )
	
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Workaround for the searchField's textField not moving when a user moves the searchField
	function searchField:_textFieldPosition()
		return function()
			if self.x ~= self._view._originalX then
				self._view._textField.x = self.x - self._view._magnifyingGlass.contentWidth + self._view._textField._xOffset
				self._view._originalX = self.x
			end
			
			if self.y ~= self._view._originalY then
				self._view._textField.y = self.y + self._view._textField._yOffset
				self._view._originalY = self.y
			end
		end
	end
	
	view._textFieldTimer = timer.performWithDelay( 0.01, searchField:_textFieldPosition(), 0 )
	
	
	-- Finalize function
	function searchField:_finalize()
		if self._textFieldTimer then
			timer.cancel( self._textFieldTimer )
		end
		
		-- Remove the textField
		display.remove( self._view._textField )
		
		self._view._textField = nil
		self._view._cancelButton = nil
		self._view = nil
		
		-- Set the ImageSheet to nil
		self._imageSheet = nil
	end
			
	return searchField
end


-- Function to create a new searchField object ( widget.newSearchField)
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
	opt.width = customOptions.width or 150
	opt.height = customOptions.height or 60
	opt.id = customOptions.id
	opt.baseDir = customOptions.baseDir or system.ResourceDirectory
	opt.placeholder = customOptions.placeholder or ""
	opt.textFieldXOffset = customOptions.textFieldXOffset or 0
	opt.textFieldYOffset = customOptions.textFieldYOffset or 0
	opt.textFieldWidth = customOptions.textFieldWidth or themeOptions.textFieldWidth
	opt.textFieldHeight = customOptions.textFieldHeight or themeOptions.textFieldHeight
	opt.cancelButtonXOffset = customOptions.cancelButtonXOffset or 0
	opt.cancelButtonYOffset = customOptions.cancelButtonYOffset or 0
	opt.listener = customOptions.listener
	
	-- Frames & Images
	opt.sheet = customOptions.sheet
	opt.themeSheetFile = themeOptions.sheet
	opt.themeData = themeOptions.data
	
	opt.leftFrame = customOptions.leftFrame or _widget._getFrameIndex( themeOptions, themeOptions.leftFrame )
	opt.rightFrame = customOptions.rightFrame or _widget._getFrameIndex( themeOptions, themeOptions.rightFrame )
	opt.middleFrame = customOptions.middleFrame or _widget._getFrameIndex( themeOptions, themeOptions.middleFrame )
	opt.magnifyingGlassFrame = customOptions.magnifyingGlassFrame or _widget._getFrameIndex( themeOptions, themeOptions.magnifyingGlassFrame )
	opt.cancelFrame = customOptions.cancelFrame or _widget._getFrameIndex( themeOptions, themeOptions.cancelFrame )
	opt.edgeWidth = customOptions.edgeWidth or themeOptions.edgeWidth or error( "ERROR: " .. M._widgetName .. ": edgeFrameWidth expected, got nil", 3 )
	opt.edgeHeight = customOptions.edgeHeight or themeOptions.edgeHeight or error( "ERROR: " .. M._widgetName .. ": edgeFrameHeight expected, got nil", 3 )
	opt.magnifyingGlassFrameWidth = customOptions.magnifyingGlassFrameWidth or themeOptions.magnifyingGlassFrameWidth or error( "ERROR: " .. M._widgetName .. ": magnifyingGlassFrameWidth expected, got nil", 3 )
	opt.magnifyingGlassFrameHeight = customOptions.magnifyingGlassFrameHeight or themeOptions.magnifyingGlassFrameHeight or error( "ERROR: " .. M._widgetName .. ": magnifyingGlassFrameHeight expected, got nil", 3 )
	opt.cancelFrameWidth = customOptions.cancelFrameWidth or themeOptions.cancelFrameWidth or error( "ERROR: " .. M._widgetName .. ": cancelFrameWidth expected, got nil", 3 )
	opt.cancelFrameHeight = customOptions.cancelFrameHeight or themeOptions.cancelFrameHeight or error( "ERROR: " .. M._widgetName .. ": cancelFrameHeight expected, got nil", 3 )

	-------------------------------------------------------
	-- Create the searchField
	-------------------------------------------------------
		
	-- Create the searchField object
	local searchField = _widget._new
	{
		left = opt.left,
		top = opt.top,
		id = opt.id or "widget_searchField",
		baseDir = opt.baseDir,
	}

	-- Create the searchField
	initWithImage( searchField, opt )
	
	-- Set the searchField's position ( set the reference point to center, just to be sure )
	
	if ( isGraphicsV1 ) then
		searchField:setReferencePoint( display.CenterReferencePoint )
	end
	
	local x, y = _widget._calculatePosition( searchField, opt )
	searchField.x, searchField.y = x, y	
	
	return searchField
end

return M
