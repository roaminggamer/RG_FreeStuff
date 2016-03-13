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
	_widgetName = "widget.newProgressView",
}


-- Require needed widget files
local _widget = require( "widget" )

local isGraphicsV1 = ( 1 == display.getDefault( "graphicsCompatibility" ) )

-- Localize math functions
local mFloor = math.floor


-- Creates a new progress bar from an image
local function initWithImage( progressView, options )
	-- Create a local reference to our options table
	local opt = options
	
	local view = progressView
	
	-- Forward references
	local imageSheet, view, viewBorderLeft, viewBorderMiddle, viewBorderRight, viewFillLeft, viewFillMiddle, viewFillRight
	
	-- Create the imageSheet
	if opt.sheet then
		imageSheet = opt.sheet
	else
		local themeData = require( opt.themeData )
		imageSheet = graphics.newImageSheet( opt.themeSheetFile, themeData:getSheet() )
	end
	
	-- The view is the segmentedControl (group)
	view = progressView
	
	-- Create the view
	local viewOuterLeft = display.newImageRect( progressView, imageSheet, opt.fillOuterLeftFrame, opt.fillOuterWidth, opt.fillOuterHeight )
	local viewOuterMiddle = display.newImageRect( progressView, imageSheet, opt.fillOuterMiddleFrame, opt.fillOuterWidth, opt.fillOuterHeight )
	local viewOuterRight = display.newImageRect( progressView, imageSheet, opt.fillOuterRightFrame, opt.fillOuterWidth, opt.fillOuterHeight )
	
	-- The left rounded edge of the progress fill
	viewFillLeft = display.newImageRect( progressView, imageSheet, opt.fillInnerLeftFrame, opt.fillWidth, opt.fillHeight )
	
	-- The middle progress fill image
	viewFillMiddle = display.newImageRect( progressView, imageSheet, opt.fillInnerMiddleFrame, opt.fillWidth, opt.fillHeight )
	
	-- The right rounded edge of the progress fill
	viewFillRight = display.newImageRect( progressView, imageSheet, opt.fillInnerRightFrame, opt.fillWidth, opt.fillHeight )
	
	-- Properties
	local rangeFactor = 100
	local availableMoveSpace = ( opt.width - ( opt.fillOuterWidth * 2) ) - ( opt.fillXOffset * 2 )
	local moveFactor = availableMoveSpace / rangeFactor
	local currentPercent = ( availableMoveSpace / rangeFactor ) * ( rangeFactor )
	
	-------------------------------------------------------
	-- Assign properties to the view
	-------------------------------------------------------
	
	-- Properties
	view._isAnimated = opt.isAnimated
	view._currentProgress = 0.00
	view._currentPercent = currentPercent
	
	-- Set the left fills position
	viewFillLeft.x = progressView.x + ( viewFillLeft.contentWidth * 0.5 ) + opt.fillXOffset
	viewFillLeft.y = progressView.y + ( viewFillLeft.contentHeight * 0.5 ) + opt.fillYOffset

	-- OUTER LEFT
	viewOuterLeft.x = progressView.x + ( viewOuterLeft.contentWidth * 0.5 )
	viewOuterLeft.y = progressView.y + ( viewOuterLeft.contentHeight * 0.5 )

	-- Set the fill's initial width
	viewFillMiddle.width = 1
	viewFillMiddle.x = viewFillLeft.x + viewFillLeft.contentWidth * 0.5 + viewFillMiddle.width * 0.5
	viewFillMiddle.y = progressView.y + ( viewFillMiddle.contentHeight * 0.5 ) + opt.fillYOffset
	
	-- OUTER MIDDLE
	viewOuterMiddle.width =  availableMoveSpace
	viewOuterMiddle.x = viewOuterLeft.x + ( ( viewOuterLeft.contentWidth * 0.5 ) + ( viewOuterMiddle.width * 0.5 ) )
	viewOuterMiddle.y = progressView.y + ( viewOuterMiddle.contentHeight * 0.5 )
	
	-- Set the right fills position
	viewFillRight.x = viewFillLeft.x + viewFillMiddle.width + viewFillRight.contentWidth
	viewFillRight.y = progressView.y + ( viewFillRight.contentHeight * 0.5 ) + opt.fillYOffset
	
	-- OUTER RIGHT
	viewOuterRight.x = viewOuterMiddle.x + ( viewOuterMiddle.contentWidth * 0.5 ) + ( viewOuterRight.contentWidth * 0.5 )
	viewOuterRight.y = progressView.y + ( viewOuterRight.contentHeight * 0.5 )
	
	-------------------------------------------------------
	-- Assign objects to the view
	-------------------------------------------------------
	
	-- Outer frame
	view._outerLeft = viewOuterLeft
	view._outerMiddle = viewOuterMiddle
	view._outerRight = viewOuterRight
	
	-- Inner fill
	view._fillLeft = viewFillLeft
	view._fillMiddle = viewFillMiddle
	view._fillRight = viewFillRight
	
	-- Offsets
	view._fillXOffset = opt.fillXOffset
	view._fillYOffset = opt.fillYOffset
	view._fillOuterWidth = opt.fillOuterWidth
	
	-------------------------------------------------------
	-- Assign properties/objects to the progressView
	-------------------------------------------------------
	
	-- Assign objects to the progressView
	progressView._imageSheet = imageSheet
	progressView._view = view
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------

	-- Function to set the progressView's current progress (ie fill)
	function progressView:setProgress( progress )
		-- Create a local reference to the view
		local view = self._view
		
		-- If the progress is more than 100% then clamp the value
		if progress > 1.0 then
			progress = 1.0
		end
		
		-- Only execute this if the progressView's view hasn't been removed
		if "table" == type( view ) then
			-- Reset the bar if requested
			if progress <= 0 then
				view._fillLeft.isVisible = false
				view._fillMiddle.isVisible = false
				view._fillRight.isVisible = false
				view._currentProgress = 0

				-- If the view is animated, reset the current percent
				if view._isAnimated then
					view._currentPercent = 0
				end
				return
			elseif progress < 0.01 then
				view._fillMiddle.width = 1
				view._fillMiddle.isVisible = false
				view._fillMiddle.x = view._fillLeft.x + view._fillMiddle.width * 0.5
				view._fillRight.x = view._fillLeft.x + view._fillMiddle.width + ( view._fillRight.contentWidth * 0.5 )
				return
			elseif progress >= 0.01 then
				view._fillLeft.isVisible = true
				view._fillMiddle.isVisible = true
				view._fillRight.isVisible = true
			end
			
			-- If the current percent is 0 or less, reset the bar
			if view._currentPercent <= 0 then
				view._fillLeft.isVisible = false
				view._fillMiddle.isVisible = false
				view._fillRight.isVisible = false
				view._fillMiddle.width = 1
				view._fillMiddle.x = view._fillLeft.x + viewFillLeft.contentWidth * 0.5 + view._fillMiddle.width * 0.5
				view._fillRight.x = view._fillLeft.x + view._fillMiddle.width + ( view._fillRight.contentWidth * 0.5 )
			end

			view._currentProgress = progress
			view._currentPercent = ( availableMoveSpace / rangeFactor ) * ( view._currentProgress * rangeFactor )
			-- If the fill is animated
			if view._isAnimated then
				transition.to( view._fillMiddle, { width = view._currentPercent, x = view._fillLeft.x + view._fillLeft.contentWidth * 0.5 + view._currentPercent * 0.5 } )
				transition.to( view._fillRight, { x = mFloor( view._fillLeft.x + view._currentPercent + view._fillRight.contentWidth  ) } )
			else
			-- The fill isn't animated
				view._fillMiddle.width = view._currentPercent
				view._fillMiddle.x = view._fillLeft.x + view._currentPercent * 0.5 + view._fillLeft.contentWidth * 0.5
				view._fillRight.x = mFloor( view._fillLeft.x + view._currentPercent + view._fillRight.contentWidth )
			end
		end
		
 	end

	-- Function to get the progressView's current progress
	function progressView:getProgress()
		return self._currentProgress
	end
	
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Finalize function for the progressView
	function progressView:_finalize()
		self._view._fillMiddle = nil
		self._view._fillLeft = nil
		self._view._fillRight = nil
		self._view = nil
		
		-- Set the ImageSheet to nil
		self._imageSheet = nil
	end

	-- Resizes a existing progressView
	function progressView:resizeView( newWidth )
	
		local view = self
	
		-- OUTER MIDDLE
		view._outerMiddle.width = ( newWidth - ( view._fillOuterWidth * 2 ) )
		view._outerMiddle.x = view._outerLeft.x + ( ( view._outerLeft.contentWidth * 0.5 ) + ( view._outerMiddle.width * 0.5 ) )
	
		-- Set the right fills position
		view._fillRight.x = view._fillLeft.x + view._fillMiddle.width + ( view._fillRight.contentWidth * 0.5 )
	
		-- OUTER RIGHT
		view._outerRight.x = view._outerMiddle.x + ( view._outerMiddle.contentWidth * 0.5 ) + ( view._outerRight.contentWidth * 0.5 )

		-- recalculate the properties
		rangeFactor = 100
		availableMoveSpace = ( newWidth - ( view._fillOuterWidth ) ) - ( view._fillXOffset * 2 )
		moveFactor = availableMoveSpace / rangeFactor
		currentPercent = ( availableMoveSpace / rangeFactor ) * ( rangeFactor )

	end
			
	return progressView
end

-- Function to create a new progressView object ( widget.newProgressView )
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
	opt.width = customOptions.width or error( "ERROR: " .. M._widgetName .. ": width expected, got nil", 3 )
	opt.height = 6 -- from the theme file
	opt.id = customOptions.id
	opt.baseDir = customOptions.baseDir or system.ResourceDirectory
	opt.isAnimated = customOptions.isAnimated or false
	if customOptions.sheet then
		opt.fillXOffset = customOptions.fillXOffset or 0
		opt.fillYOffset = customOptions.fillYOffset or 0
	else
		opt.fillXOffset = themeOptions.fillXOffset or 0
		opt.fillYOffset = themeOptions.fillYOffset or 0
	end
	opt.padding = customOptions.padding or themeOptions.fillOuterWidth or 0
	
	-- Frames & Images
	opt.sheet = customOptions.sheet
	opt.themeSheetFile = themeOptions.sheet
	opt.themeData = themeOptions.data
	
	opt.fillWidth = customOptions.fillWidth or themeOptions.fillWidth or error( "ERROR: " .. M._widgetName .. ": fillWidth expected, got nil", 3 )
	opt.fillHeight = customOptions.fillHeight or themeOptions.fillHeight or error( "ERROR: " .. M._widgetName .. ": fillHeight expected, got nil", 3 )
	
	opt.fillOuterWidth = customOptions.fillOuterWidth or themeOptions.fillOuterWidth or error( "ERROR: " .. M._widgetName .. ": outerWidth expected, got nil", 3 )
	opt.fillOuterHeight = customOptions.fillOuterHeight or themeOptions.fillOuterHeight or error( "ERROR: " .. M._widgetName .. ": outerHeight expected, got nil", 3 )
	
	opt.fillOuterLeftFrame = customOptions.fillOuterLeftFrame or _widget._getFrameIndex( themeOptions, themeOptions.fillOuterLeftFrame )
	opt.fillOuterMiddleFrame = customOptions.fillOuterMiddleFrame or _widget._getFrameIndex( themeOptions, themeOptions.fillOuterMiddleFrame )
	opt.fillOuterRightFrame = customOptions.fillOuterRightFrame or _widget._getFrameIndex( themeOptions, themeOptions.fillOuterRightFrame )
	
	opt.fillInnerLeftFrame = customOptions.fillInnerLeftFrame or _widget._getFrameIndex( themeOptions, themeOptions.fillInnerLeftFrame )
	opt.fillInnerMiddleFrame = customOptions.fillInnerMiddleFrame or _widget._getFrameIndex( themeOptions, themeOptions.fillInnerMiddleFrame )
	opt.fillInnerRightFrame = customOptions.fillInnerRightFrame or _widget._getFrameIndex( themeOptions, themeOptions.fillInnerRightFrame )
	
	-------------------------------------------------------
	-- Create the progressView
	-------------------------------------------------------
		
	-- Create the progressView object
	local progressView = _widget._new
	{
		left = opt.left,
		top = opt.top,
		id = opt.id or "widget_progressView",
		baseDir = opt.baseDir,
	}
		
	-- Create the progressView
	initWithImage( progressView, opt )
	
	-- Set the progressView's position ( set the reference point to center, just to be sure )
	
	if ( isGraphicsV1 ) then
		progressView:setReferencePoint( display.CenterReferencePoint )
	end
	
	local x, y = _widget._calculatePosition( progressView, opt )
	progressView.x, progressView.y = x, y	
	
	return progressView
end

return M
