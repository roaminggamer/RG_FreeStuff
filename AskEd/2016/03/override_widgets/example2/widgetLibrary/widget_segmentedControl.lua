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
	_widgetName = "widget.newSegmentedControl",
}


-- Require needed widget files
local _widget = require( "widget" )

local isGraphicsV1 = ( 1 == display.getDefault( "graphicsCompatibility" ) )
local isByteColorRange = display.getDefault( "isByteColorRange" )

-- define a default color set for both graphics modes
local labelDefault
local whiteColor
if isByteColorRange then
    labelDefault = { default = { 0, 0, 0 }, over = { 255, 255, 255 } }
    whiteColor = { 255 }
else
    labelDefault = { default = { 0, 0, 0 }, over = { 1, 1, 1 } }
    whiteColor = { 1 }
end

-- Creates a new segmentedControl from an image
local function initWithImage( segmentedControl, options )
	-- Create a local reference to our options table
	local opt = options
	
	-- Forward references
	local imageSheet, view, segmentLabels, segmentDividers
	
	-- Create the imageSheet
	if opt.sheet then
		imageSheet = opt.sheet
	else
		local themeData = require( opt.themeData )
		imageSheet = graphics.newImageSheet( opt.themeSheetFile, themeData:getSheet() )
	end
	
	-- The view is the segmentedControl (group)
	view = segmentedControl
	view._segmentWidth = M.segmentWidth
	view._labelColor = opt.labelColor
	
	-- Create the sequenceData table
	local leftSegmentOptions = 
	{ 
		{
			name = "leftSegmentOff",
			start = opt.leftSegmentFrame,
			count = 1,
			time = 1,
		},
		
		{
			name = "leftSegmentOn",
			start = opt.leftSegmentSelectedFrame,
			count = 1,
			time = 1,
		},
	}
	
	local rightSegmentOptions = 
	{ 
		{
			name = "rightSegmentOff",
			start = opt.rightSegmentFrame,
			count = 1,
			time = 1,
		},
		
		{
			name = "rightSegmentOn",
			start = opt.rightSegmentSelectedFrame,
			count = 1,
			time = 1,
		},
	}
	
	local middleSegmentOptions = 
	{ 
		{
			name = "middleSegmentOff",
			start = opt.middleSegmentFrame,
			count = 1,
			time = 1,
		},
		
		{
			name = "middleSegmentOn",
			start = opt.middleSegmentSelectedFrame,
			count = 1,
			time = 1,
		},
	}
	
	local dividerSegmentOptions = 
	{ 
		{
			name = "middleSegmentOff",
			start = opt.middleSegmentFrame,
			count = 1,
			time = 1,
		},
		
		{
			name = "middleSegmentOn",
			start = opt.middleSegmentSelectedFrame,
			count = 1,
			time = 1,
		},
	}
	
	-- Reference the passed in segments
	local segments = opt.segments
	
	-- Create the view's segments
	segmentLabels = {}
	segmentDividers = {}
	
	local overallControlWidth = ( view._segmentWidth * #segments )
	local segmentWidth = overallControlWidth / #segments
	
	-- The left segment edge
	local leftSegment = display.newSprite( segmentedControl, imageSheet, leftSegmentOptions )
	leftSegment.x = segmentedControl.x + ( opt.width * 0.5 )
	leftSegment.y = segmentedControl.y + ( leftSegment.contentHeight * 0.5 )
	leftSegment:setSequence( "leftSegmentOff" )
	leftSegment.width = opt.width
	-- The segment fill
	local middleSegment = display.newSprite( segmentedControl, imageSheet, middleSegmentOptions )
	middleSegment:setSequence( "middleSegmentOff" )
		
	middleSegment.width = ( overallControlWidth ) - ( opt.width * 2 )
	middleSegment.x = leftSegment.x + leftSegment.contentWidth * 0.5 + ( middleSegment.width * 0.5 )
	middleSegment.y = segmentedControl.y + ( middleSegment.contentHeight * 0.5 )
	
	-- The right segment edge
	local rightSegment = display.newSprite( segmentedControl, imageSheet, rightSegmentOptions )
	rightSegment:setSequence( "rightSegmentOff" )
	rightSegment.width = opt.width	
	rightSegment.x = middleSegment.x + ( middleSegment.width * 0.5 ) + opt.width * 0.5
	rightSegment.y = segmentedControl.y + ( rightSegment.contentHeight * 0.5 )
	
	-- Create the segment labels & dividers
	for i = 1, #segments do
		-- Create the labels
		local label
		if _widget.isSeven() then
			label = display.newText( segmentedControl, segments[i], 0, 0, opt.labelFont, opt.labelSize )
			if view._segmentNumber == i or opt.defaultSegment == i then
				label:setFillColor( unpack( view._labelColor.over ) )
			else
				label:setFillColor( unpack( view._labelColor.default ) )
			end
		else
			-- Use embossed text (or not) depending on theme definition
			if ( opt.emboss ) then
				label = display.newEmbossedText( segmentedControl, segments[i], 0, 0, opt.labelFont, opt.labelSize )
			else
				label = display.newText( segmentedControl, segments[i], 0, 0, opt.labelFont, opt.labelSize )
			end
			-- Use label "default" and "over" colors (else default to white)
			if ( view._labelColor and view._labelColor.over and view._labelColor.default ) then
				if view._segmentNumber == i or opt.defaultSegment == i then
					label:setFillColor( unpack( view._labelColor.over ) )
				else
					label:setFillColor( unpack( view._labelColor.default ) )
				end
			else
				label:setFillColor( unpack( whiteColor ) )
			end
		end
		
		label.x = leftSegment.x + opt.labelXOffset + ( segmentWidth * 0.5 + segmentWidth * ( i - 1 ) ) - leftSegment.width * 0.5
		label.y = leftSegment.y + opt.labelYOffset
		label.segmentName = segments[i] 
		segmentLabels[i] = label

		-- Create the dividers
		if ( i < #segments ) then
			local divider
			if ( opt.dividerFrame and opt.dividerFrameWidth and opt.dividerFrameHeight ) then
				divider = display.newImageRect( segmentedControl, imageSheet, opt.dividerFrame, opt.dividerFrameWidth, opt.dividerFrameHeight )
			else
				divider = display.newRect( segmentedControl, 0, 0, 1, 2 )
				divider.isVisible = false
			end
			divider.x = leftSegment.x + ( segmentWidth * i ) - ( leftSegment.width * 0.5 )
			divider.y = leftSegment.y
			segmentDividers[i] = divider
		end
	end

	-- The "over" frame
	local segmentOver = display.newSprite( segmentedControl, imageSheet, middleSegmentOptions )	
	segmentOver:setSequence( "middleSegmentOn" )
	
	segmentOver.width = opt.width
	segmentOver.y = leftSegment.y
	
	-------------------------------------------------------
	-- Assign properties to the view
	-------------------------------------------------------
	
	-- Segment properties
	view._segmentWidth = segmentWidth
	view._edgeWidth = opt.width
	view._totalSegments = #segments
	
	-- Create a reference to the segments
	view._leftSegment = leftSegment
	view._middleSegment = middleSegment
	view._rightSegment = rightSegment
	view._segmentOver = segmentOver
	view._segmentLabels = segmentLabels
	view._segmentDividers = segmentDividers
	view._segmentNumber = opt.defaultSegment
	view._onPress = opt.onPress
	
	-- Insert the segment labels into the view
	for i = 1, #view._segmentLabels do
		view:insert( view._segmentLabels[i] )
	end
	
	-- Insert the segment dividers into the view
	for i = 1, #segmentDividers do
		view:insert( view._segmentDividers[i] )
	end
	
	-------------------------------------------------------
	-- Assign properties/objects to the segmentedControl
	-------------------------------------------------------
	
	-- Assign objects to the segmentedControl
	segmentedControl._imageSheet = imageSheet
	segmentedControl._view = view
	segmentedControl._onPress = opt.onPress
	
	-- Public properties
	segmentedControl.segmentLabel = view._segmentLabels[1].text
	segmentedControl.segmentNumber = view._segmentNumber
		
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	-- Touch listener for our segmented control
	function view:touch( event )
		local phase = event.phase
		local _segmentedControl = self.parent
		event.target = _segmentedControl
		local firstSegment = 1
		local lastSegment = self._totalSegments

		if "began" == phase then
			-- Loop through the segments
			for i = 1, self._totalSegments do
				local segmentedControlXPosition = self.x - ( self.contentWidth * 0.5 )
				-- for g2, we have to take into account the current anchorX for this position 
				if not isGraphicsV1 then
					local oldAnchorX = self.anchorX
					segmentedControlXPosition = segmentedControlXPosition + ( 0.5 - oldAnchorX ) * self.contentWidth
				end
				
				local currentSegment = i
				local segmentWidth = self._segmentWidth
				
				-- Work out the current segments position

				--local parentOffsetX = 0
				-- First, we check if the widget is in a group
				--[[if nil ~= self.parent and nil ~= self.parent.x then
				    parentOffsetX = self.parent.x
			    end--]]

				--OLD VERSION (DID NOT WORK INSIDE SCROLLVIEW)
                --local currentSegmentLeftEdge = segmentedControlXPosition + ( segmentWidth * currentSegment ) - segmentWidth + parentOffsetX
                --local currentSegmentRightEdge = segmentedControlXPosition + ( segmentWidth * currentSegment ) + parentOffsetX	
				
				local currentSegmentLeftEdge = self.contentBounds.xMin + ( segmentWidth * currentSegment ) - segmentWidth
				local currentSegmentRightEdge = self.contentBounds.xMin + ( segmentWidth * currentSegment )
				
				-- If the touch is within the segments range
				if event.x >= currentSegmentLeftEdge and event.x <= currentSegmentRightEdge then
					-- First segment (Near left)
					if firstSegment == i then
						self:setLeftSegmentActive()
					-- Last segment (Far right)
					elseif lastSegment == i then
						self:setRightSegmentActive()
					-- Any other segment
					else
						self:setMiddleSegmentActive( i )
					end
					
					-- Set the segment name					
					_segmentedControl.segmentLabel = self._segmentLabels[i].segmentName
					
					-- Set the segment number
					_segmentedControl.segmentNumber = self._segmentNumber
					
					-- Execute onPress listener
					if self._onPress and "function" == type( self._onPress ) then
						self._onPress( event )
					end
					
					break
				end
			end
		end
		
		return true
	end
	
	view:addEventListener( "touch" )

	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Function to set the left segment active
	function view:setLeftSegmentActive()
		-- Turn off the right segment
		self._rightSegment:setSequence( "rightSegmentOff" )
		-- Turn on the left segment
		self._leftSegment:setSequence( "leftSegmentOn" )
		-- Set the over segment's width
		segmentOver.width = view._segmentWidth - self._leftSegment.width - 0.5
		-- Set the over segment's position
		
		segmentOver.x = self._leftSegment.x + self._leftSegment.width * 0.5 + segmentOver.width * 0.5
		
		if isGraphicsV1 then
			segmentOver:setReferencePoint( display.CenterReferencePoint )
		end
		
		-- Set the segment's name
		self._segmentLabel = self._segmentLabels[1].text
		self.segmentLabel = self._segmentLabel
		
		-- Set the segment number
		self._segmentNumber = 1
		self.segmentNumber = self._segmentNumber
		
		-- Reset the label colors
		if _widget.isSeven() then
			for i = 1, #view._segmentLabels do
				local currentSegment = view._segmentLabels[ i ]
				currentSegment:setFillColor( unpack( view._labelColor.default ) )
			end
			view._segmentLabels[1]:setFillColor( unpack( whiteColor ) )
		elseif ( view._labelColor and view._labelColor.default and view._labelColor.over ) then
			for i = 1, #view._segmentLabels do
				local currentSegment = view._segmentLabels[ i ]
				currentSegment:setFillColor( unpack( view._labelColor.default ) )
			end
			view._segmentLabels[1]:setFillColor( unpack( view._labelColor.over ) )
		else
			for i = 1, #view._segmentLabels do
				view._segmentLabels[1]:setFillColor( unpack( whiteColor ) )
			end
		end
	end
	
	-- Function to set the right segment active
	function view:setRightSegmentActive()
		-- Turn off the left segment
		self._leftSegment:setSequence( "leftSegmentOff" )
		-- Turn on the right segment
		self._rightSegment:setSequence( "rightSegmentOn" )
		-- Set the over segment's width
		segmentOver.width = view._segmentWidth - self._rightSegment.width
		-- Set the over segment's position
		segmentOver.x = self._rightSegment.x - self._rightSegment.width * 0.5 - segmentOver.width * 0.5
	
		-- Set the segment's name
		self._segmentLabel = self._segmentLabels[self._totalSegments].text
		self.segmentLabel = self._segmentLabel
		
		-- Set the segment number
		self._segmentNumber = self._totalSegments
		self.segmentNumber = self._segmentNumber
		
		-- Reset the label colors
		if _widget.isSeven() then
			for i = 1, #view._segmentLabels do
				local currentSegment = view._segmentLabels[ i ]
				currentSegment:setFillColor( unpack( view._labelColor.default ) )
			end
			view._segmentLabels[ #view._segmentLabels ]:setFillColor( unpack( whiteColor ) )
		elseif ( view._labelColor and view._labelColor.default and view._labelColor.over ) then
			for i = 1, #view._segmentLabels do
				local currentSegment = view._segmentLabels[ i ]
				currentSegment:setFillColor( unpack( view._labelColor.default ) )
			end
			view._segmentLabels[ #view._segmentLabels ]:setFillColor( unpack( view._labelColor.over ) )
		else
			for i = 1, #view._segmentLabels do
				view._segmentLabels[1]:setFillColor( unpack( whiteColor ) )
			end
		end
		
	end
	
	-- Function to set the middle segment active
	function view:setMiddleSegmentActive( segmentNum )
		-- Turn off the left segment
		self._leftSegment:setSequence( "leftSegmentOff" )
		-- Turn off the right segment
		self._rightSegment:setSequence( "rightSegmentOff" )
		-- Set the over segment's width
		segmentOver.width = self._segmentWidth
		-- Set the over segment's position
		segmentOver.x = self._segmentDividers[segmentNum - 1].x + segmentOver.width * 0.5
		
		-- Set the segment's name
		self._segmentLabel = self._segmentLabels[segmentNum].text
		self.segmentLabel = self._segmentLabel
		
		-- Set the segment number
		self._segmentNumber = segmentNum
		self.segmentNumber = self._segmentNumber
		
		-- Reset the label colors
		if _widget.isSeven() then
			for i = 1, #view._segmentLabels do
				local currentSegment = view._segmentLabels[ i ]
				currentSegment:setFillColor( unpack( view._labelColor.default ) )
			end
			view._segmentLabels[ segmentNum ]:setFillColor( unpack( whiteColor ) )
		elseif ( view._labelColor and view._labelColor.default and view._labelColor.over ) then
			for i = 1, #view._segmentLabels do
				local currentSegment = view._segmentLabels[ i ]
				currentSegment:setFillColor( unpack( view._labelColor.default ) )
			end
			view._segmentLabels[ segmentNum ]:setFillColor( unpack( view._labelColor.over ) )
		else
			for i = 1, #view._segmentLabels do
				view._segmentLabels[1]:setFillColor( unpack( whiteColor ) )
			end
		end
	end
	
	-- Set the intial segment to active
	local function setDefaultSegment( segmentNum )
		if 1 == segmentNum then
			view:setLeftSegmentActive()
		elseif #segments == segmentNum then
			view:setRightSegmentActive()
		else
			view:setMiddleSegmentActive( segmentNum )
		end
	end

	-- Setter for the current segment
	function segmentedControl:setActiveSegment(segmentNum)
		setDefaultSegment(segmentNum)
	end
	
	-- Getter for the current segment
	function segmentedControl:getActiveSegment()
	  return self._view._segmentNumber
	end
	
	-- Finalize function for the segmentedControl
	function segmentedControl:_finalize()
		self._view._segments = nil
		self._view = nil
		
		-- Set the ImageSheet to nil
		self._imageSheet = nil
	end
	
	-- Set the default segment
	setDefaultSegment( view._segmentNumber )
	
	return segmentedControl
end


-- Function to create a new segmentedControl object ( widget.newSegmentedControl )
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
	
	opt.id = customOptions.id
	opt.baseDir = customOptions.baseDir or system.ResourceDirectory
	opt.segments = customOptions.segments or { "One", "Two" }
	M.segmentWidth = customOptions.segmentWidth or 50
	opt.defaultSegment = customOptions.defaultSegment or 1
	opt.labelSize = customOptions.labelSize or themeOptions.labelSize or 12
	opt.labelFont = customOptions.labelFont or themeOptions.labelFont or native.systemFont
	opt.labelColor = customOptions.labelColor or themeOptions.labelColor or nil
	opt.emboss = customOptions.emboss or themeOptions.emboss or nil

	if _widget.isSeven() then
		opt.labelFont = customOptions.labelFont or "HelveticaNeue"
		opt.labelSize = customOptions.labelSize or 13
	end
	
	opt.labelXOffset = customOptions.labelXOffset or themeOptions.labelXOffset or 0
	opt.labelYOffset = customOptions.labelYOffset or themeOptions.labelYOffset or 0
	opt.onPress = customOptions.onPress
	
	-- Frames & Images
	opt.sheet = customOptions.sheet
	opt.themeSheetFile = themeOptions.sheet
	opt.themeData = themeOptions.data
	
	if ( customOptions.segmentFrameWidth or themeOptions.segmentFrameWidth ) then
		opt.width = customOptions.segmentFrameWidth or themeOptions.segmentFrameWidth
	else
		opt.width = customOptions.width or themeOptions.width or error( "ERROR:" .. M._widgetName .. ": width or segmentFrameWidth expected, got nil", 3 )
	end

	if ( customOptions.segmentFrameHeight or themeOptions.segmentFrameHeight ) then
		opt.height = customOptions.segmentFrameHeight or themeOptions.segmentFrameHeight
	else
		opt.height = customOptions.height or themeOptions.height or error( "ERROR:" .. M._widgetName .. ": height or segmentFrameHeight expected, got nil", 3 )
	end

	opt.leftSegmentFrame = customOptions.leftSegmentFrame or _widget._getFrameIndex( themeOptions, themeOptions.leftSegmentFrame )
	opt.leftSegmentSelectedFrame = customOptions.leftSegmentSelectedFrame or _widget._getFrameIndex( themeOptions, themeOptions.leftSegmentSelectedFrame )
	opt.rightSegmentFrame = customOptions.rightSegmentFrame or _widget._getFrameIndex( themeOptions, themeOptions.rightSegmentFrame )
	opt.rightSegmentSelectedFrame = customOptions.rightSegmentSelectedFrame or _widget._getFrameIndex( themeOptions,themeOptions.rightSegmentSelectedFrame )
	opt.middleSegmentFrame = customOptions.middleSegmentFrame or _widget._getFrameIndex( themeOptions, themeOptions.middleSegmentFrame )
	opt.middleSegmentSelectedFrame = customOptions.middleSegmentSelectedFrame or _widget._getFrameIndex( themeOptions, themeOptions.middleSegmentSelectedFrame)

	if ( opt.dividerFrame and opt.dividerFrameWidth and opt.dividerFrameHeight ) then
		-- User has defined divider frame info, use it...
		opt.dividerFrame = customOptions.dividerFrame
		opt.dividerFrameWidth = customOptions.dividerFrameWidth
		opt.dividerFrameHeight = customOptions.dividerFrameHeight
	else
		-- Else, default to theme frame info
		opt.dividerFrame = _widget._getFrameIndex( themeOptions, themeOptions.dividerFrame )
		opt.dividerFrameWidth = themeOptions.dividerFrameWidth
		opt.dividerFrameHeight = themeOptions.dividerFrameHeight
	end
	
	-------------------------------------------------------
	-- Create the segmentedControl
	-------------------------------------------------------
		
	-- Create the segmentedControl object
	local segmentedControl = _widget._new
	{
		left = opt.left,
		top = opt.top,
		id = opt.id or "widget_segmentedControl",
		baseDir = opt.baseDir,
	}
		
	-- Create the segmentedControl
	initWithImage( segmentedControl, opt )
	
	-- Set the segmentedControl's position ( set the reference point to center, just to be sure )
	if ( isGraphicsV1 ) then
		segmentedControl:setReferencePoint( display.CenterReferencePoint )
	end
	
	local x, y = _widget._calculatePosition( segmentedControl, opt )
	segmentedControl.x, segmentedControl.y = x, y	
	
	return segmentedControl
end

return M
