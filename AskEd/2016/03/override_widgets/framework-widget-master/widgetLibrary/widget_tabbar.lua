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
	_widgetName = "widget.newTabBar",
}


-- Require needed widget files
local _widget = require( "widget" )

local isGraphicsV1 = ( 1 == display.getDefault( "graphicsCompatibility" ) )
local isByteColorRange = display.getDefault( "isByteColorRange" )

-- define a default color set for both graphics modes
local labelDefault
if isByteColorRange then
    labelDefault = { default = { 220, 220, 220 }, over = { 255, 255, 255 } }
    if _widget.isSeven() then
    	labelDefault = { default = { 146 }, over = { 21, 125, 251, 255 } }
	end
else
    labelDefault = { default = { 0.86, 0.86, 0.86 }, over = { 1, 1, 1 } }
    if _widget.isSeven() then
    	labelDefault = { default = { 0.57 }, over = { 0.08, 0.49, 0.98, 1 } }
	end
end

------------------------------------------------------------------------
-- Image Files TabBar
------------------------------------------------------------------------

-- Creates a new tabBar from image files
local function initWithImageFiles( tabBar, options )
	-- Create a local reference to our options table
	local opt = options
	
	
	local backgroundBaseDir = opt.backgroundFile.baseDir or system.ResourceDirectory
	
	-- Return errors if any image file is missing
	if not _widget._fileExists( opt.backgroundFile, backgroundBaseDir ) then
		error( "ERROR: " .. M._widgetName .. ": The backgroundFile passed does not exist", 3 )
	end

	if not _widget._fileExists( opt.tabSelectedLeftFile ) then
		error( "ERROR: " .. M._widgetName .. ": The tabSelectedLeftFile passed does not exist", 3 )
	end
	
	if not _widget._fileExists( opt.tabSelectedMiddleFile ) then
		error( "ERROR: " .. M._widgetName .. ": The tabSelectedMiddleFile passed does not exist", 3 )
	end
	
	if not _widget._fileExists( opt.tabSelectedRightFile ) then
		error( "ERROR: " .. M._widgetName .. ": The tabSelectedRightFile passed does not exist", 3 )
	end
		
	-- Forward references
	local view, viewSelected, viewSelectedLeft, viewSelectedRight, viewSelectedMiddle, viewButtons

	-- Create the tab bar's background
	view = display.newImageRect( tabBar, opt.backgroundFile, opt.baseDir, opt.width, opt.height )
	
	-- We need to assign the view some properties here.
	view._defaultTab = 1
	view._totalTabWidth = 0
	
	-- Create the tab selected group
	viewSelected = display.newGroup()
	tabBar:insert( viewSelected )
	
	-- Create the tab selected's left frame
	viewSelectedLeft = display.newImageRect( viewSelected, opt.tabSelectedLeftFile, opt.baseDir, opt.tabSelectedFrameWidth, opt.tabSelectedFrameHeight )
	
	-- Create the tab selected's middle frame
	viewSelectedMiddle = display.newImageRect( viewSelected, opt.tabSelectedMiddleFile, opt.baseDir, opt.tabSelectedFrameWidth, opt.tabSelectedFrameHeight )
		
	-- Create the tab selected's right frame
	viewSelectedRight = display.newImageRect( viewSelected, opt.tabSelectedRightFile, opt.baseDir, opt.tabSelectedFrameWidth, opt.tabSelectedFrameHeight )
	
	-- Create the viewButtons table
	viewButtons = {}
	
	-- Create the tab buttons
	for i = 1, #opt.tabButtons do
		local defaultFile = opt.tabButtons[i].defaultFile or error( "ERROR: " .. M._widgetName .. ": defaultFile expected, got nil", 3 )
		local overFile = opt.tabButtons[i].overFile or error( "ERROR: " .. M._widgetName .. ": overFile expected, got nil", 3 )
		local width = opt.tabButtons[i].width or error( "ERROR: " .. M._widgetName .. ": width expected, got nil", 3 )
		local height = opt.tabButtons[i].height or error( "ERROR: " .. M._widgetName .. ": height expected, got nil", 3 )
		
		-- also check that the images exist physically
		if not _widget._fileExists( opt.tabButtons[i].defaultFile ) then
			error( "ERROR: " .. M._widgetName .. ": The defaultFile passed for tab " .. i .. " does not exist", 3 )
		end

		if not _widget._fileExists( opt.tabButtons[i].overFile ) then
			error( "ERROR: " .. M._widgetName .. ": The overFile passed for tab " .. i .. " does not exist", 3 )
		end
		
		-- Get the baseDir
		local baseDir = opt.tabButtons[i].baseDir or system.ResourceDirectory
		
		-- Create the tab button
		viewButtons[i] = display.newImageRect( tabBar, defaultFile, baseDir, width, height )
		viewButtons[i]._over = display.newImageRect( tabBar, overFile, baseDir, width, height )
		
		viewButtons[i]._over.isVisible = false
		
		-- Get the passed in properties if any
		local label = opt.tabButtons[i].label or ""
		local labelFont = opt.tabButtons[i].font or opt.defaultLabelFont
		local labelSize = opt.tabButtons[i].size or opt.defaultLabelSize
		local labelColor = opt.tabButtons[i].labelColor or opt.defaultLabelColor
		local labelXOffset = opt.tabButtons[i].labelXOffset or 0
		local labelYOffset = opt.tabButtons[i].labelYOffset or 0
		
		-- Create the tab button's label
		viewButtons[i].label = display.newText( tabBar, label, 0, 0, labelFont, labelSize )
		viewButtons[i].label.text = label
		viewButtons[i].label:setFillColor( unpack( labelColor.default ) )
		
		-- Set the label offsets
		viewButtons[i].label._xOffset = labelXOffset
		viewButtons[i].label._yOffset = labelYOffset
		
		-- Set the default tab
		if opt.tabButtons[i].selected then
			view._defaultTab = i
			
			-- Set the selected tab's label to the over color
			viewButtons[i].label:setFillColor( unpack( labelColor.over ) )
		end	
		
		-- Keep a reference to the label's colors
		viewButtons[i].label._color = labelColor
	end
		
		
	----------------------------------
	-- Positioning
	----------------------------------
	
	-- Set the tabBar's background width & position	
	view.width = opt.width
	view.height = opt.height
	view.x = tabBar.x + ( view.contentWidth * 0.5 )
	view.y = tabBar.y + ( view.contentHeight * 0.5 )
	
	-- Set the tab selected's left frame position
	viewSelectedLeft.x = tabBar.x + ( viewSelectedLeft.contentWidth * 0.5 )
	viewSelectedLeft.y = tabBar.y + ( viewSelectedLeft.contentHeight * 0.5 )
		
	-- Set the tab selected's middle frame width & position
	viewSelectedMiddle.width = ( opt.width / #opt.tabButtons ) - ( viewSelectedLeft.contentWidth + viewSelectedRight.contentWidth )
	viewSelectedMiddle.x = viewSelectedLeft.x + ( viewSelectedLeft.contentWidth * 0.5 ) + ( viewSelectedMiddle.contentWidth * 0.5 )
	viewSelectedMiddle.y = viewSelectedLeft.y
	
	-- Set the tab selected's right frame position
	viewSelectedRight.x = viewSelectedMiddle.x + ( viewSelectedLeft.contentWidth * 0.5 ) + ( viewSelectedMiddle.contentWidth * 0.5 )
	viewSelectedRight.y = viewSelectedLeft.y

	-- Loop through the view's buttons and set their positions
	for i = 1, #viewButtons do
		-- Set the buttons position
		viewButtons[i].x = tabBar.x + ( ( opt.width / #viewButtons ) * i ) - ( opt.width / #viewButtons ) / 2
		viewButtons[i].y = tabBar.y + ( view.contentHeight * 0.5 ) 
		
		-- if no label, center the images
		if nil ~= viewButtons[i].label then
		    if "" == viewButtons[i].label.text then
	            viewButtons[i].y = tabBar.y + ( view.contentHeight * 0.5 )
	        end
		end
		
		viewButtons[i]._over.x = viewButtons[i].x
		viewButtons[i]._over.y = viewButtons[i].y
		
		-- Set the button label position
		viewButtons[i].label.x = viewButtons[i].x + viewButtons[i].label._xOffset
		viewButtons[i].label.y = tabBar.y + view.contentHeight - ( viewButtons[i].label.contentHeight * 0.5 ) - 1 + viewButtons[i].label._yOffset
		
		-- Set the buttons id
		viewButtons[i]._id = opt.tabButtons[i].id or "button" .. i
		
		-- Assign the onPress listener to the button
		viewButtons[i]._onPress = opt.tabButtons[i].onPress
		
		-- By default the button isn't pressed
		viewButtons[i]._isPressed = false
		
		-- Set the view's total width
		view._totalTabWidth = view._totalTabWidth + viewButtons[i].width
	end
	
	-- Set the default tab to active
	viewButtons[view._defaultTab]._over.isVisible = true
	-- hide the default image on the default tab
	viewButtons[view._defaultTab].isVisible = false
	
	-- Position the tab selected group
	viewSelected.x = viewButtons[view._defaultTab].x - ( viewSelected.contentWidth * 0.5 ) - tabBar.x
	
	-- Throw error if tabBar width is too small to hold all passed in tab items
	if ( view._totalTabWidth + 4 ) > opt.width then
		error( "ERROR: " .. M._widgetName .. ": width passed is too small to fit the tab items inside, you need a width of at least " .. ( view._totalTabWidth + 4 ) .. " to fit your tab items inside", 3 )
	end
	
	-------------------------------------------------------
	-- Assign properties to the view
	-------------------------------------------------------
	
	-- We need to assign these properties to the object
	view._width = opt.width
	view._selected = viewSelected
	view._tabs = viewButtons
	view._onPress = opt.onPress
	
	-------------------------------------------------------
	-- Assign properties/objects to the tabBar
	-------------------------------------------------------
	
	-- Assign objects to the tabBar
	tabBar._imageSheet = imageSheet
	tabBar._view = view
	tabBar._viewSelected = view._selected
	tabBar._viewButtons = view._tabs
	tabBar._left = opt.left or 0
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	-- Touch listener for our tabBar
	function view:touch( event )
		local phase = event.phase
		local tabSize = ( self._width / #self._tabs ) 

		if "began" == phase then
			-- Loop through the tabs
			for i = 1, #self._tabs do
				local currentTab = self._tabs[i]
				
				-- Have we pressed within the current tab?
				local pressedWithinRange = event.x >= ( ( tabBar._left + currentTab.x ) - tabSize * 0.5 ) and event.x <= ( ( tabBar._left + currentTab.x ) + tabSize * 0.5 )
				
				-- If we have pressed a tab
				if pressedWithinRange then
					-- Activate the tab
					if not currentTab._isPressed then
						self:_setSelected( i, true )
					end
					
					break
				end
			end
		end
		
		return true
	end
	
    -- Tap listener for the tabBar
	local function _handleTapEvent( event )
		local phase = event.phase
		local tabSize = ( view._width / #view._tabs ) 

		if "tap" == phase then
			-- Loop through the tabs
			for i = 1, #view._tabs do
				local currentTab = view._tabs[i]
				
				-- Have we pressed within the current tab?
				local pressedWithinRange = event.x >= ( ( tabBar._left + currentTab.x ) - tabSize * 0.5 ) and event.x <= ( ( tabBar._left + currentTab.x ) + tabSize * 0.5 )
				
				-- If we have pressed a tab
				if pressedWithinRange then
					-- Activate the tab
					if not currentTab._isPressed then
						view:_setSelected( i, true )
					end
					
					break
				end
			end
		end
		
		return true
	end
	
	view:addEventListener( "touch" )
	view:addEventListener( "tap", _handleTapEvent )
	
	-- Function to programatically set a tab button as active
	function tabBar:setSelected( selectedTab, simulatePress )
		return self._view:_setSelected( selectedTab, simulatePress )
	end
		
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Function to set a tab as active
	function view:_setSelected( selectedTab, invokeListener )
		for i = 1, #self._tabs do
			-- The pressed tab
			if selectedTab == i then
				-- Move the tab selected group to the newly selected tab
				self._selected.x = self._tabs[i].x - ( self._selected.contentWidth * 0.5 ) - self.x + ( self.contentWidth * 0.5 )
				
				-- Execute the tab buttons onPress method if it has one
				if self._tabs[i]._onPress then
					local newEvent = 
					{
						phase = "press",
						target = self._tabs[i],
					}
					
					-- Execute the onPress method, if it exists
					if self._tabs[i]._onPress then
						if invokeListener then
							self._tabs[i]._onPress( newEvent )
						end
					end
				end
				
				-- Set the tab to it's over state
				self._tabs[i].isVisible = false
				self._tabs[i]._over.isVisible = true
				
				-- Set the tab as pressed
				self._tabs[i]._isPressed = true

				-- Set the label's color to 'over'
				self._tabs[i].label:setFillColor( unpack( self._tabs[i].label._color.over ) )

			-- Turn off all other tabs
			else
				-- Set the tab to it's default state
				self._tabs[i].isVisible = true
				self._tabs[i]._over.isVisible = false
				
				-- Set the label's color to 'default'
				self._tabs[i].label:setFillColor( unpack( self._tabs[i].label._color.default ) )
				
				-- Set the tab as not pressed
				self._tabs[i]._isPressed = false
			end
		end
	end
	
	-- Finalize function for the tabBar
	function tabBar:_finalize()
	end
			
	return tabBar
end


------------------------------------------------------------------------
-- Image Sheet TabBar
------------------------------------------------------------------------

-- Creates a new tabBar from an imageSheet
local function initWithImageSheet( tabBar, options )

	-- Create a local reference to our options table
	local opt = options
		
	-- Forward references
	local imageSheet, view, viewSelected, viewSelectedLeft, viewSelectedRight, viewSelectedMiddle, viewButtons
	
	-- Create the imageSheet
	if opt.sheet then
		imageSheet = opt.sheet
	else
		local themeData = require( opt.themeData )
		imageSheet = graphics.newImageSheet( opt.themeSheetFile, themeData:getSheet() )
	end
			
	-- Create the tab bar's background
	view = display.newImageRect( tabBar, imageSheet, opt.backgroundFrame, opt.width, opt.height )
		
	-- We need to assign the view some properties here.
	view._defaultTab = 1
	view._totalTabWidth = 0
	
	-- Create the tab selected group
	viewSelected = display.newGroup()
	tabBar:insert( viewSelected )
			
	-- Create the tab selected's left frame
	viewSelectedLeft = display.newImageRect( viewSelected, imageSheet, opt.tabSelectedLeftFrame, opt.tabSelectedFrameWidth, opt.tabSelectedFrameHeight )
		
	-- Create the tab selected's middle frame
	viewSelectedMiddle = display.newImageRect( viewSelected, imageSheet, opt.tabSelectedMiddleFrame, opt.tabSelectedFrameWidth, opt.tabSelectedFrameHeight )
		
	-- Create the tab selected's right frame
	viewSelectedRight = display.newImageRect( viewSelected, imageSheet, opt.tabSelectedRightFrame, opt.tabSelectedFrameWidth, opt.tabSelectedFrameHeight )
	
	-- Create the viewButtons table
	viewButtons = {}
	
	-- Create the tab buttons
	for i = 1, #opt.tabButtons do		
		local defaultFrame = opt.tabButtons[i].defaultFrame --or error( "ERROR: " .. M._widgetName .. ": defaultFrame expected, got nil", 3 )
		local overFrame = opt.tabButtons[i].overFrame --or error( "ERROR: " .. M._widgetName .. ": overFrame expected, got nil", 3 )
		local defaultFile = opt.tabButtons[i].defaultFile
		local overFile = opt.tabButtons[i].overFile
				
		local spriteOptions = 
		{
			{
				name = "default",
				start = defaultFrame,
				count = 1,
			},
			{
				name = "over",
				start = overFrame,
				count = 1,
			},	
		}
		
		-- Create the tab button
		if opt.tabButtons[i].defaultFrame then
			viewButtons[i] = display.newSprite( tabBar, imageSheet, spriteOptions )
		else
			-- If there isn't a default frame, look for default/over files
			if not opt.tabButtons[i].defaultFile then
			    viewButtons[i] = display.newImageRect( tabBar, imageSheet, 7, 15, 15 )
				--error( "ERROR: " .. M._widgetName .. ": tab button default file expected, got nil" )
			else
			    viewButtons[i] = display.newImageRect( tabBar, opt.tabButtons[i].defaultFile, opt.tabButtons[i].width, opt.tabButtons[i].height )
			end
			
			if not opt.tabButtons[i].overFile then
			    viewButtons[i].over = display.newImageRect( tabBar, imageSheet, 10, 15, 15 )
				--error( "ERROR: " .. M._widgetName .. ": tab button default file expected, got nil" )
            else
                viewButtons[i].over = display.newImageRect( tabBar, opt.tabButtons[i].overFile, opt.tabButtons[i].width, opt.tabButtons[i].height )
			end
			viewButtons[i].over.isVisible = false
		end
		
		-- If an Android Holo theme is present AND the user hasn't defined button images in their instantiation, then make them invisible
		if ( not opt.tabButtons[i].defaultFrame and not opt.tabButtons[i].defaultFile and not opt.tabButtons[i].overFile and _widget.isHolo() ) then
			if ( viewButtons[i] ) then viewButtons[i].alpha = 0 end
			if ( viewButtons[i].over ) then viewButtons[i].over.alpha = 0 end
		end
		
		-- Get the passed in properties if any
		local label = opt.tabButtons[i].label or ""
		local labelFont = opt.tabButtons[i].font or opt.defaultLabelFont
		local labelSize = opt.tabButtons[i].size or opt.defaultLabelSize
		local labelColor = opt.tabButtons[i].labelColor or opt.defaultLabelColor
		local labelXOffset = opt.tabButtons[i].labelXOffset or 0
		local labelYOffset = opt.tabButtons[i].labelYOffset or 0
		
		-- If an Android Holo theme, raise the label up
		if ( _widget.isHolo() ) then labelYOffset = labelYOffset - 11 end

		-- Create the tab button's label
		viewButtons[i].label = display.newText( tabBar, label, 0, 0, labelFont, labelSize )
		viewButtons[i].label:setFillColor( unpack( labelColor.default ) )
		
		-- Set the label offsets
		viewButtons[i].label._xOffset = labelXOffset
		viewButtons[i].label._yOffset = labelYOffset
		
		-- Set the default tab
		if opt.tabButtons[i].selected then
			view._defaultTab = i
			
			-- Set the selected tab's label to the over color
			viewButtons[i].label:setFillColor( unpack( labelColor.over ) )
		end	
		
		-- Keep a reference to the label's colors
		viewButtons[i].label._color = labelColor
	end
		
		
	----------------------------------
	-- Positioning
	----------------------------------
	
	-- Set the tabBar's background width & position	
	view.width = opt.width
	view.height = opt.height
	view.x = tabBar.x + ( view.contentWidth * 0.5 )
	view.y = tabBar.y + ( view.contentHeight * 0.5 )
	
	-- Set the tab selected's left frame position
	viewSelectedLeft.x = tabBar.x + ( viewSelectedLeft.contentWidth * 0.5 )
	viewSelectedLeft.y = tabBar.y + ( viewSelectedLeft.contentHeight * 0.5 )
		
	-- Set the tab selected's middle frame width & position
	viewSelectedMiddle.width = ( opt.width / #opt.tabButtons ) - ( viewSelectedLeft.contentWidth + viewSelectedRight.contentWidth )
	viewSelectedMiddle.x = viewSelectedLeft.x + ( viewSelectedLeft.contentWidth * 0.5 ) + ( viewSelectedMiddle.contentWidth * 0.5 ) 
	viewSelectedMiddle.y = viewSelectedLeft.y
	
	-- Set the tab selected's right frame position
	viewSelectedRight.x = viewSelectedMiddle.x + ( viewSelectedLeft.contentWidth * 0.5 ) + ( viewSelectedMiddle.contentWidth * 0.5 )
	viewSelectedRight.y = viewSelectedLeft.y

	-- Loop through the view's buttons and set their positions
	for i = 1, #viewButtons do
		-- Set the buttons position
		viewButtons[i].x = tabBar.x + ( ( opt.width / #viewButtons ) * i ) - ( opt.width / #viewButtons ) / 2
		viewButtons[i].y = tabBar.y + ( view.contentHeight * 0.5 ) - ( view.contentHeight * 0.1 )
		
		if viewButtons[i].over then
			viewButtons[i].over.x = viewButtons[i].x
			viewButtons[i].over.y = viewButtons[i].y
		end
		
		-- Set the button label position
		viewButtons[i].label.x = viewButtons[i].x + viewButtons[i].label._xOffset
		viewButtons[i].label.y = tabBar.y + view.contentHeight - ( viewButtons[i].label.contentHeight * 0.5 ) - 1 + viewButtons[i].label._yOffset
		
		-- Set the buttons id
		viewButtons[i]._id = opt.tabButtons[i].id or "button" .. i
		
		-- Assign the onPress listener to the button
		viewButtons[i]._onPress = opt.tabButtons[i].onPress
		
		-- By default the button isn't pressed
		viewButtons[i]._isPressed = false
		
		-- Set the view's total width
		view._totalTabWidth = view._totalTabWidth + viewButtons[i].width
	end
	
	-- Set the default tab to active
	if viewButtons[view._defaultTab].over then
		viewButtons[view._defaultTab].isVisible = false
		viewButtons[view._defaultTab].over.isVisible = true
	else
		viewButtons[view._defaultTab]:setSequence( "over" )
	end
	
	-- remove the touch event on the default tab
	viewButtons[view._defaultTab]._onPressOriginal = viewButtons[view._defaultTab]._onPress
	viewButtons[view._defaultTab]._onPress = nil
	
	-- Position the tab selected group
	viewSelected.x = viewButtons[view._defaultTab].x - ( viewSelected.contentWidth * 0.5 ) - tabBar.x
	--viewSelected.y = tabBar.y - viewSelected.contentHeight * 0.5
	
	-- Throw error if tabBar width is too small to hold all passed in tab items
	if ( view._totalTabWidth + 4 ) > view.width then
		error( "ERROR: " .. M._widgetName .. ": width passed is too small to fit the tab items inside, you need a width of at least " .. ( view._totalTabWidth + 4 ) .. " to fit your tab items inside", 3 )
	end
	
	-------------------------------------------------------
	-- Assign properties to the view
	-------------------------------------------------------
	
	-- We need to assign these properties to the object
	view._width = opt.width
	view._selected = viewSelected
	view._tabs = viewButtons
	view._onPress = opt.onPress
	
	-------------------------------------------------------
	-- Assign properties/objects to the tabBar
	-------------------------------------------------------
	
	-- Assign objects to the tabBar
	tabBar._imageSheet = imageSheet
	tabBar._view = view
	tabBar._viewSelected = view._selected
	tabBar._viewButtons = view._tabs
	tabBar._left = opt.left or 0
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	-- Touch listener for our tabBar
	function view:touch( event )
		local phase = event.phase
		local tabSize = ( self._width / #self._tabs ) 

		if "began" == phase then
		
			-- Loop through the tabs and set back the touch listener
			for i =1, #self._tabs do
				local currentTab = self._tabs[i]
				if currentTab._onPressOriginal then
					currentTab._onPress = currentTab._onPressOriginal
				end
			end
			
			-- Loop through the tabs
			for i = 1, #self._tabs do
				local currentTab = self._tabs[i]
				
				-- Have we pressed within the current tab?
				local pressedWithinRange = event.x >= ( ( tabBar._left + currentTab.x ) - tabSize * 0.5 ) and event.x <= ( ( tabBar._left + currentTab.x ) + tabSize * 0.5 )
				
				-- If we have pressed a tab
				if pressedWithinRange then
					-- Activate the tab
					if not currentTab._isPressed then
						self:_setSelected( i, true )
					end
					
					break
				end
			end
		end
		
		return true
	end
	
    -- Tap listener for the tabBar
	local function _handleTapEvent( event )
		local phase = event.phase
		local tabSize = ( view._width / #view._tabs ) 

		if "tap" == phase then
			-- Loop through the tabs and set back the touch listener
			for i =1, #view._tabs do
				local currentTab = view._tabs[i]
				if currentTab._onPressOriginal then
					currentTab._onPress = currentTab._onPressOriginal
				end
			end
			
			-- Loop through the tabs
			for i = 1, #view._tabs do
				local currentTab = view._tabs[i]
				
				-- Have we pressed within the current tab?
				local pressedWithinRange = event.x >= ( ( tabBar._left + currentTab.x ) - tabSize * 0.5 ) and event.x <= ( ( tabBar._left + currentTab.x ) + tabSize * 0.5 )
				
				-- If we have pressed a tab
				if pressedWithinRange then
					-- Activate the tab
					if not currentTab._isPressed then
						view:_setSelected( i, true )
					end
					
					break
				end
			end
		end
		
		return true
	end
	
	view:addEventListener( "touch" )
	view:addEventListener( "tap", _handleTapEvent )
	
	-- Function to programatically set a tab button as active
	function tabBar:setSelected( selectedTab, simulatePress )
		return self._view:_setSelected( selectedTab, simulatePress )
	end
		
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------
	
	-- Function to set a tab as active
	function view:_setSelected( selectedTab, invokeListener )
		for i = 1, #self._tabs do
			-- The pressed tab
			if selectedTab == i then
				-- Move the tab selected group to the newly selected tab
				self._selected.x = self._tabs[i].x - ( self._selected.contentWidth * 0.5 ) - self.x + ( self.contentWidth * 0.5 )
				
				-- Execute the tab buttons onPress method if it has one
				if self._tabs[i]._onPress then
					local newEvent = 
					{
						phase = "press",
						target = self._tabs[i],
					}
					
					-- Execute the onPress method, if it exists
					if self._tabs[i]._onPress then
						if invokeListener then
							self._tabs[i]._onPress( newEvent )
						end
					end
				end
				
				-- Set the tab to it's over state
				if self._tabs[i].over then
					self._tabs[i].isVisible = false
					self._tabs[i].over.isVisible = true
				else
					self._tabs[i]:setSequence( "over" )
				end
				
				-- Set the tab as pressed
				self._tabs[i]._isPressed = true

				-- Set the label's color to 'over'
				self._tabs[i].label:setFillColor( unpack( self._tabs[i].label._color.over ) )

			-- Turn off all other tabs
			else
				-- Set the tab to it's default state
				if self._tabs[i].over then
					self._tabs[i].isVisible = true
					self._tabs[i].over.isVisible = false
				else
					self._tabs[i]:setSequence( "default" )
				end
				
				-- Set the label's color to 'default'
				self._tabs[i].label:setFillColor( unpack( self._tabs[i].label._color.default ) )
				
				-- Set the tab as not pressed
				self._tabs[i]._isPressed = false
			end
		end
	end
	
	-- Finalize function for the tabBar
	function tabBar:_finalize()
		-- Set the ImageSheet to nil
		self._imageSheet = nil
	end
			
	return tabBar
end

-- Function to create a new tabBar object ( widget.newTabBar)
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
	opt.width = customOptions.width or themeOptions.width or display.contentWidth
	opt.height = customOptions.height or themeOptions.height or 52
	opt.id = customOptions.id
	opt.baseDir = opt.baseDir or system.ResourceDirectory
	opt.tabButtons = customOptions.buttons
	opt.defaultLabelFont = themeOptions.defaultLabelFont or native.systemFont
	opt.defaultLabelSize = themeOptions.defaultLabelSize or 10
	opt.defaultLabelColor = themeOptions.defaultLabelColor or labelDefault
	opt.onPress = customOptions.onPress

	-- Frames & Images
	opt.sheet = customOptions.sheet
	opt.themeSheetFile = themeOptions.sheet
	opt.themeData = themeOptions.data
		
	-- Using single images
	opt.backgroundFile = customOptions.backgroundFile
	opt.tabSelectedLeftFile = customOptions.tabSelectedLeftFile
	opt.tabSelectedRightFile = customOptions.tabSelectedRightFile
	opt.tabSelectedMiddleFile = customOptions.tabSelectedMiddleFile
	opt.tabSelectedFrameWidth = customOptions.tabSelectedFrameWidth
	
	-- if we get passed a height parameter in the initializer, set the selected frame height to that value
	if nil ~= customOptions.height and type( customOptions.height ) == "number" then
		opt.tabSelectedFrameHeight = customOptions.height
	else
		opt.tabSelectedFrameHeight = customOptions.tabSelectedFrameHeight
	end
	
	
	-- If we are using a sheet
	if not opt.backgroundFile and opt.sheet or not opt.backgroundFile and opt.themeSheetFile then
		opt.backgroundFrame = customOptions.backgroundFrame or _widget._getFrameIndex( themeOptions, themeOptions.backgroundFrame )
		opt.backgroundFrameWidth = customOptions.backgroundFrameWidth or themeOptions.backgroundFrameWidth
		opt.backgroundFrameHeight = customOptions.backgroundFrameHeight or themeOptions.backgroundFrameHeight
		opt.tabSelectedLeftFrame = customOptions.tabSelectedLeftFrame or _widget._getFrameIndex( themeOptions, themeOptions.tabSelectedLeftFrame )
		opt.tabSelectedRightFrame = customOptions.tabSelectedRightFrame or _widget._getFrameIndex( themeOptions, themeOptions.tabSelectedRightFrame )
		opt.tabSelectedMiddleFrame = customOptions.tabSelectedMiddleFrame or _widget._getFrameIndex( themeOptions, themeOptions.tabSelectedMiddleFrame )
		opt.tabSelectedFrameWidth = customOptions.tabSelectedFrameWidth or themeOptions.tabSelectedFrameWidth
		
		-- if we get passed a height parameter in the initializer, set the selected frame height to that value
		if nil ~= customOptions.height and type( customOptions.height ) == "number" then
			opt.tabSelectedFrameHeight = customOptions.height
		else
			opt.tabSelectedFrameHeight = customOptions.tabSelectedFrameHeight or themeOptions.tabSelectedFrameHeight
		end
		
	end
	
	if opt.backgroundFile then
		if not opt.tabSelectedLeftFile then
			error( "ERROR: " .. M._widgetName .. ": tabSelectedLeftFile expected, got nil", 3 ) 
		end
		
		if not opt.tabSelectedRightFile then
			error( "ERROR: " .. M._widgetName .. ": tabSelectedRightFile expected, got nil", 3 )
		end
		
		if not opt.tabSelectedMiddleFile then
			error( "ERROR: " .. M._widgetName .. ": tabSelectedMiddleFile expected, got nil", 3 ) 
		end
	end
		
	-------------------------------------------------------
	-- Create the tabBar
	-------------------------------------------------------
		
	-- Create the tabBar object
	local tabBar = _widget._new
	{
		left = opt.left,
		top = opt.top,
		id = opt.id or "widget_tabBar",
		baseDir = opt.baseDir,
	}

	-- Create the tabBar
	if opt.sheet and not opt.backgroundFile or opt.themeSheetFile and not opt.backgroundFile then
		initWithImageSheet( tabBar, opt )
	else
		initWithImageFiles( tabBar, opt )
	end
	
	-- Set the tabBar's position ( set the reference point to center, just to be sure )
	if ( isGraphicsV1 ) then
		tabBar:setReferencePoint( display.CenterReferencePoint )
	end

	local x, y = _widget._calculatePosition( tabBar, opt )
	tabBar.x, tabBar.y = x, y

	return tabBar
end

return M
