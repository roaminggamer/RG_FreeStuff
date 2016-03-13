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
	_widgetName = "widget.newScrollView",
}


-- Require needed widget files
local _widget = require( "widget" )

local isGraphicsV1 = ( 1 == display.getDefault( "graphicsCompatibility" ) )

-- Localize math functions
local mAbs = math.abs

-- Creates a new scrollView
local function createScrollView( scrollView, options )
	-- Create a local reference to our options table
	local opt = options
	
	-- Forward references
	local view, viewFixed, viewBackground, viewMask
	
	-- Create the view
	view = display.newGroup()
	--

	if isGraphicsV1 then
		view.x = - scrollView.width * 0.5
		view.y = - scrollView.height * 0.5
	end

	-- TODO: this has to be replaced by correct behavior. Right now, it's a temporary group in which we place objects inserted in the scrollview
	-- in graphics2.0
	local collectorGroup = display.newGroup()
	collectorGroup.x = - opt.width * 0.5
	collectorGroup.y = - opt.height * 0.5
	view:insert( collectorGroup )
	scrollView._collectorGroup = collectorGroup


	viewFixed = display.newGroup()
		
	-- Create the view's background
	viewBackground = display.newRect( scrollView, 0, 0, opt.width, opt.height )
	viewBackground.x = 0
	viewBackground.y = 0


	
	----------------------------------
	-- Properties
	----------------------------------
	
	-- Background
	viewBackground.isVisible = not opt.shouldHideBackground
	viewBackground.isHitTestable = true
	viewBackground:setFillColor( unpack( opt.backgroundColor ) )
	
	-- Set the view's initial position ( to account for top padding )
	view.y = view.y + opt.topPadding
	-- Set the platform
	view._isPlatformAndroid = "Android" == system.getInfo( "platformName" )
	
	-------------------------------------------------------
	-- Assign properties to the view
	-------------------------------------------------------
	
	-- We need to assign these properties to the object
	view._background = viewBackground
	view._mask = viewMask
	view._startXPos = 0
	view._startYPos = 0
	view._prevXPos = 0
	view._prevYPos = 0
	view._prevX = 0
	view._prevY = 0
	view._delta = 0
	view._velocity = 0
	view._prevTime = 0
	view._lastTime = 0
	view._tween = nil
	view._left = opt.left
	view._top = opt.top
	view._width = opt.width
	view._height = opt.height
	view._topPadding = opt.topPadding
	view._bottomPadding = opt.bottomPadding
	view._leftPadding = opt.leftPadding
	view._rightPadding = opt.rightPadding
	view._moveDirection = nil
	view._isHorizontalScrollingDisabled = opt.isHorizontalScrollingDisabled
	view._isVerticalScrollingDisabled = opt.isVerticalScrollingDisabled
	view._listener = opt.listener
	view._friction = opt.friction or 0.972
	view._maxVelocity = opt.maxVelocity or 2
	view._timeHeld = 0
	view._isLocked = opt.isLocked
	view._scrollWidth = opt.scrollWidth
	view._scrollHeight = opt.scrollHeight
	view._trackVelocity = false	
	view._updateRuntime = false
	
	-- assign the threshold values to the momentum
	view.scrollStopThreshold = opt.scrollStopThreshold
	view.isBounceEnabled = opt.isBounceEnabled
	view.autoHideScrollBar = opt.autoHideScrollBar
	view._widgetType = "scrollView"

	-------------------------------------------------------
	-- Assign properties/objects to the scrollView
	-------------------------------------------------------

	-- Assign objects to the view
	view._fixedGroup = viewFixed

	-- Assign objects to the scrollView
	scrollView._view = view	
	scrollView:insert( view )
	scrollView:insert( viewFixed )
	
	-- assign the momentum variable to the scrollview
	scrollView._momentumScrolling = require( "widget_momentumScrolling" ):new()
	-- TODO: this is temporary, because the tableview view height is calculated wrong. we need to pass in the widget type to know how to position the scrollbar
	scrollView._momentumScrolling.widgetType = "scrollView"
	
	----------------------------------------------------------
	--	PUBLIC METHODS	
	----------------------------------------------------------
	
	-- Function to retrieve the x/y position of the scrollView's content
	function scrollView:getContentPosition()
		return self._view:_getContentPosition()
	end
	
	-- Function to set the frame of the widget post creation
	function scrollView:setSize( newWidth, newHeight )
		-- resize the widget
		self.width = newWidth
		self.height = newHeight
		--resize the widget's view
		self._view._width = newWidth
		self._view._height = newHeight
		--resize the widget's background
		self._view._background.width = newWidth
		self._view._background.height = newHeight
		-- reposition the collector group if graphics 2.0
		if not isGraphicsV1 then
			self._collectorGroup.x = - newWidth * 0.5
			self._collectorGroup.y = - newHeight * 0.5
		end
		-- Update the scrollWidth
		self._view._scrollWidth = self._view.width

		-- Update the scrollHeight
		self._view._scrollHeight = self._view.height
				
		-- after the contentWidth / Height updates are complete, scroll the view to the position it was at before inserting the new object
		self:scrollToPosition( { x = self._view.x, y = self._view.y, time = 0 } )
		
		-- Create the scrollBar
		if not opt.hideScrollBar then
			if not self._view._isLocked then
				-- Need a delay here also..
				timer.performWithDelay( 2, function()
					-- because this is performed with a delay, we have to check if we still have the scrollHeight property. This prevents
					-- issues when removing the scrollview after creation in the same frame.
					if self._view._scrollHeight then	
						if not self._view._isVerticalScrollingDisabled and self._view._scrollHeight > self._view._height then							
							display.remove( self._view._scrollBar )
							self._view._scrollBar = nil
							self._view._scrollBar = self._momentumScrolling.createScrollBar( self._view, opt.scrollBarOptions )
						end
					end
				end)
			end
		end	
	end
	
	-- Function to scroll the view to a specific position
	function scrollView:scrollToPosition( options )
		local newX = options.x or self._view.x
		local newY = options.y or self._view.y
		local transitionTime = options.time or 400
		local onTransitionComplete = options.onComplete
		
		-- Stop updating Runtime & tracking velocity
		self._view._updateRuntime = false
		self._view._trackVelocity = false
		-- Reset velocity back to 0
		self._view._velocity = 0		
	
		-- Transition the view to the new position
		transition.to( self._view, { x = newX, y = newY, time = transitionTime, transition = easing.inOutQuad, onComplete = onTransitionComplete } )
	end
	
	-- Function to scroll the view to a specified position from a list of constants ( i.e. top/bottom/left/right )
	function scrollView:scrollTo( position, options )
		
		-- check if any scrolling is going on, and cancel the transition
		transition.cancel( "_widgetScrollTransition" )
	
		local newPosition = position or "top"
		local newX = self._view.x
		local newY = self._view.y
		local transitionTime = options.time or 400
		local onTransitionComplete = options.onComplete
		
		-- Set the target x/y positions
		if "top" == newPosition then
			newY = self._view._topPadding
		elseif "bottom" == newPosition then
			--newY = self._view._background.y - ( self._view.contentHeight ) + ( self._view._background.contentHeight * 0.5 ) - self._view._bottomPadding
			-- bottom is the scrollHeight ( the view's content height ) minus padding and the actual widget height
			newY = - self._view.contentHeight + self._view._bottomPadding + self.contentHeight
		elseif "left" == newPosition then
			newX = self._view._leftPadding
		elseif "right" == newPosition then
			--newX = self._view._background.x - ( self._view.contentWidth ) + ( self._view._background.contentWidth * 0.5 ) - self._view._rightPadding
			-- right is the scrollWidth ( the view's content width ) minus padding and the actual widget width
			newX = - self._view.contentWidth + self._view._rightPadding + self.contentWidth
		end
		
		-- Transition the view to the new position
		transition.to( self._view, { tag = "_widgetScrollTransition", x = newX, y = newY, time = transitionTime, transition = easing.inOutQuad, onComplete = function()
		
			if "function" == type( onTransitionComplete ) then
				onTransitionComplete()
			end
			-- Stop updating Runtime & tracking velocity
			self._view._updateRuntime = false
			self._view._trackVelocity = false
			-- Reset velocity back to 0
			self._view._velocity = 0
		
		end
		 } )
	end
	
	function scrollView:takeFocus( event )
		local target = event.target
		
		-- Remove focus from the object
		display.getCurrentStage():setFocus( target, nil )
		
		-- Handle turning widget buttons back to their default state (visually, ie their default button images & labels)
		if "table" == type( target ) then
			if "string" == type( target._widgetType ) then
				-- Remove focus from the widget. From parent if the scrollview is in another scrollview, from self otherwise
				if "scrollView" == target.parent._widgetType then
					target.parent:_loseFocus()
				else
					target:_loseFocus()
				end
			end
		end
		
		-- Create our new event table
		local newEvent = {}
		
		-- Copy the event table's keys/values into our newEvent table
		for k, v in pairs( event ) do
			newEvent[k] = v
		end

		-- Set our new event's phase to began, and it's target to the view
		newEvent.phase = "began"
		newEvent.target = self._view
		
		-- Send a touch event to the view
		self._view:touch( newEvent )
	end
		
	function scrollView:setScrollWidth( newValue )
		
		-- adjust the scrollview scroll width
		timer.performWithDelay( 2, function()
			self._view._scrollWidth = newValue or self._view._scrollWidth
		end )
				
	end

	function scrollView:setScrollHeight( newValue )
		
		-- adjust the scrollview scroll height
		timer.performWithDelay( 2, function()
			self._view._scrollHeight = newValue or self._view._scrollHeight
		end )
				
		-- Recreate the scrollBar
		if not opt.hideScrollBar then
			if self._view._scrollBar then
				display.remove( self._view._scrollBar )
				self._view._scrollBar = nil
			end
			
			if not self._view._isLocked then
				-- Need a delay here also..
				timer.performWithDelay( 2, function()
					--[[
					Currently only vertical scrollBar's are provided, so don't show it if they can't scroll vertically
					--]]								
					if not self._view._scrollBar and not self._view._isVerticalScrollingDisabled and self._view._scrollHeight > self._view._height then
						self._view._scrollBar = self._momentumScrolling.createScrollBar( self._view, opt.scrollBarOptions )
					end
				end)
			end
		end	
	end
	
	-- getter for the widget's view
	function scrollView:getView()
		return self._view
	end
	
	----------------------------------------------------------
	--	PRIVATE METHODS	
	----------------------------------------------------------	

	-- Handle touch events on any inserted widget buttons
	local function _handleButtonTouch( event )
		local _targetButton = event.target
		
		-- If the target exists and is not active
		if _targetButton then
			if not _targetButton._isActive then
				local phase = event.phase
				
				view:touch( event )

				return true
			end
		end
	end

	-- Override scale function as scrollView's don't support it
	function scrollView:scale()
		print( M._widgetName, "Does not support scaling" )
	end

	-- Override the insert method for scrollView to insert into the view instead
    scrollView._cachedInsert = scrollView.insert

    function scrollView:insert( arg1, arg2 )
        local index, obj
        
        if arg1 and type( arg1 ) == "number" then
            index = arg1
        elseif arg1 and type( arg1 ) == "table" then
            obj = arg1
        end
        
        if arg2 and type( arg2 ) == "table" then
            obj = arg2
        end
        
        if index then
        	if isGraphicsV1 then
            	self._view:insert( index, obj )
            else
            	self._collectorGroup:insert( index, obj )
            end
        else
        	if isGraphicsV1 then
            	self._view:insert( obj )
        	else
        		self._collectorGroup:insert( obj )
        	end
        end

		local function updateScrollAreaSize()
				
			-- we store the original coordinates		
			local origY = self._view.y
			local origX = self._view.x
		
			-- Update the scroll content area size (NOTE: Seems to need a 1ms delay for the group to reflect it's new content size? ) odd ...
			timer.performWithDelay( 1, function()
				-- Update the scrollWidth
				self._view._scrollWidth = self._view.width

				-- Update the scrollHeight
				self._view._scrollHeight = self._view.height
				
				-- Override the scroll height if it is less than the height of the window
				if "number" == type( self._view._scrollHeight ) and "number" == type( self._view._height ) then
					if self._view._scrollHeight < self._view._height then
						self._view._scrollHeight = self._view._height
					end
				end

				-- Override the scroll width if it is less than the width of the window
				if "number" == type( self._view._scrollWidth ) and "number" == type( self._view._width ) then
					if self._view._scrollWidth < self._view._width then
						self._view._scrollWidth = self._view._width
					end
				end
				
				-- override also if the values are nil
				if not self._view._scrollWidth then
					self._view._scrollWidth = self._view._width
				end
				
				if not self._view._scrollHeight then
					self._view._scrollHeight = self._view._height
				end
				
			end)
			
			-- after the contentWidth / Height updates are complete, scroll the view to the position it was at before inserting the new object
			self:scrollToPosition( { x = origX, y = origY, time = 0 } )
		end

		-- Override the removeself method for this object (so we can recalculate the content size after it is removed)
		-- If we haven't already over-ridden it
		if nil == obj._cachedRemoveSelf then
			obj._cachedRemoveSelf = obj.removeSelf
			
			local function removeSelf( self )
				self:_cachedRemoveSelf()
				
				-- Update the scroll area size
				updateScrollAreaSize()
			end
			
			obj.removeSelf = removeSelf
		end

		-- Update the scroll area size
		updateScrollAreaSize()
		
		-- Create the scrollBar
		if not opt.hideScrollBar then
			if self._view._scrollBar then
				display.remove( self._view._scrollBar )
				self._view._scrollBar = nil
			end
			
			if not self._view._isLocked then
				-- Need a delay here also..
				timer.performWithDelay( 2, function()
					--[[
					Currently only vertical scrollBar's are provided, so don't show it if they can't scroll vertically
					--]]
					
					-- because this is performed with a delay, we have to check if we still have the scrollHeight property. This prevents
					-- issues when removing the scrollview after creation in the same frame.
					if self._view._scrollHeight then										
						if not self._view._scrollBar and not self._view._isVerticalScrollingDisabled and self._view._scrollHeight > self._view._height then
							self._view._scrollBar = self._momentumScrolling.createScrollBar( self._view, opt.scrollBarOptions )
						end
					end
				end)
			end
		end	
    end
    
    -- isLocked setter function
	function scrollView:setIsLocked( lockedState, direction )
		return self._view:_setIsLocked( lockedState, direction )
	end

	-- Transfer touch from the view's background to the view's content
	function viewBackground:touch( event )		
		view:touch( event )
		
		return true
	end
	
	viewBackground:addEventListener( "touch" )
	
	-- Handle touches on the scrollview
	function view:touch( event )
		local phase = event.phase 
		local time = event.time
		
		-- Set the time held
		if "began" == phase then
			self._timeHeld = event.time
		end	
		
		-- Android fix for objects inserted into scrollView's
		if self._isPlatformAndroid then
			-- Distance moved
	        local dy = mAbs( event.y - event.yStart )
			local dx = mAbs( event.x - event.xStart )
			local moveThresh = 20

			-- If the finger has moved less than the desired range, set the phase back to began	(Android only fix, iOS doesn't exhibit this touch behavior..)
			if dy < moveThresh then
				if dx < moveThresh then
					if phase ~= "ended" and phase ~= "cancelled" then
						event.phase = "began"
					end
				end
			end
		end
						
		-- Handle momentum scrolling (and the view isn't locked)
		if not self._isLocked then
			self.parent._momentumScrolling._touch( self, event )
		end
		
		-- Execute the listener if one is specified
		if self._listener then
			local newEvent = {}
			
			for k, v in pairs( event ) do
				newEvent[k] = v
			end
			
			-- check if the momentum scrolling module has a non-nil direction variable
			if self.parent._momentumScrolling._direction then
				newEvent.direction = self.parent._momentumScrolling._direction
			end
			
			-- Set event.target to the scrollView object, not the view
			newEvent.target = self.parent
			
			-- Execute the listener
			self._listener( newEvent )
		end
				
		-- Set the view's phase so we can access it in the enterFrame listener below
		self._phase = event.phase
		
		-- Set the view's target object (the object we touched) so we can access it in the enterFrame listener below
		self._target = event.target
		
		return true
	end
	
	view:addEventListener( "touch" )
	
	
  	-- EnterFrame listener for our scrollView
	function view:enterFrame( event )
		local _scrollView = self.parent

		-- Handle momentum @ runtime
		_scrollView._momentumScrolling._runtime( self, event )		
		
		-- Constrain x/y scale values to 1.0
		if _scrollView and _scrollView.xScale ~= 1.0 then
			_scrollView.xScale = 1.0
			print( M._widgetName, "Does not support scaling" )
		end
		
		if _scrollView and _scrollView.yScale ~= 1.0 then
			_scrollView.yScale = 1.0
			print( M._widgetName, "Does not support scaling" )
		end

		-- Update the top position of the scrollView (if moved)
		if _scrollView and _scrollView.y ~= self._top then
			self._top = _scrollView.y
		end

		return true
	end
	
	Runtime:addEventListener( "enterFrame", view )
	
	-- _getContentPosition
	-- returns the x,y coordinates of the scrollview
	function view:getContentPosition()
		return self:_getContentPosition()
	end
	
	function view:_getContentPosition()
		local returnX = self.x
		local returnY = self.y
		
		-- if we are above the top limit
		if ( returnY > 0 ) then
			-- Do nothing in this case. People still use the pull to refresh functionality.
			--returnY = 0
		-- and the bottom limit
		elseif returnY < - self._scrollHeight + self.parent.contentHeight then
			returnY = - self._scrollHeight + self.parent.contentHeight
		end
		
		-- if we are above the left limit
		if ( returnX > 0 ) then
			returnX = 0
		-- and the right limit
		elseif returnX < - self._scrollWidth + self.parent.contentWidth then
			returnX = - self._scrollWidth + self.parent.contentWidth
		end
		
		return returnX, returnY
	end
	
	-- isLocked variable setter function
	function view:_setIsLocked( lockedState, direction )
		if type( lockedState ) ~= "boolean" then
			return
		end
		
		if direction and type ( direction ) ~= "string" then
			return
		end
		
		-- if we received a direction to set a lockstate on, proceed
		if direction then
			if "horizontal" == direction then
				self._isHorizontalScrollingDisabled = lockedState
			elseif "vertical" == direction then
				self._isVerticalScrollingDisabled = lockedState
			end
		-- otherwise set both directions to the received lockstate
		else
			self._isVerticalScrollingDisabled = lockedState
			self._isHorizontalScrollingDisabled = lockedState
		end
		
		-- if both scroll axis variables are disabled, then the scrollview is locked
		if self._isHorizontalScrollingDisabled and self._isVerticalScrollingDisabled then
			self._isLocked = true
		else
			self._isLocked = false
		end
		
		-- if we unlock the scrollview and the scrollview's content is bigger than the widget bounds, init the scrollbar.
		if not opt.hideScrollBar then
			if self._scrollBar then
				display.remove( self._scrollBar )
				self._scrollBar = nil
			end
			
			if not self._isLocked then
				-- Need a delay here also..
				timer.performWithDelay( 2, function()
					--[[
					Currently only vertical scrollBar's are provided, so don't show it if they can't scroll vertically
					--]]								
					if not self._scrollBar and not self._isVerticalScrollingDisabled and self._scrollHeight > self._height then
						self._scrollBar = self.parent._momentumScrolling.createScrollBar( self, opt.scrollBarOptions )
					end
				end)
			end
		end			
	end
		
	-- Finalize function for the scrollView
	function scrollView:_finalize()		
		-- Remove the runtime listener
		Runtime:removeEventListener( "enterFrame", self._view )
				
		-- Remove scrollBar if it exists
		if self._view._scrollBar then
			display.remove( self._view._scrollBar )
			self._view._scrollBar = nil
		end
	end
			
	return scrollView
end


-- Function to create a new scrollView object ( widget.newScrollView )
function M.new( options )	
	local customOptions = options or {}
	
	-- Create a local reference to our options table
	local opt = {}
	
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
	opt.width = customOptions.width or display.contentWidth
	opt.height = customOptions.height or display.contentHeight
	opt.id = customOptions.id
	opt.baseDir = customOptions.baseDir or system.ResourceDirectory
	opt.maskFile = customOptions.maskFile
	opt.listener = customOptions.listener
		
	-- Properties
	opt.shouldHideBackground = customOptions.hideBackground or false
	opt.backgroundColor = customOptions.backgroundColor or { 255, 255, 255, 255 }
	opt.topPadding = customOptions.topPadding or 0
	opt.bottomPadding = customOptions.bottomPadding or 0
	opt.leftPadding = customOptions.leftPadding or 0
	opt.rightPadding = customOptions.rightPadding or 0
	opt.isHorizontalScrollingDisabled = customOptions.horizontalScrollDisabled or false
	opt.isVerticalScrollingDisabled = customOptions.verticalScrollDisabled or false
	opt.friction = customOptions.friction
	opt.maxVelocity = customOptions.maxVelocity or 1.5
	opt.scrollWidth = customOptions.scrollWidth or opt.width
	opt.scrollHeight = customOptions.scrollHeight or opt.height
	opt.hideScrollBar = customOptions.hideScrollBar or false
	opt.isLocked = customOptions.isLocked or false
	opt.scrollStopThreshold = customOptions.scrollStopThreshold or 250
	opt.isBounceEnabled = true
	if nil ~= customOptions.isBounceEnabled and customOptions.isBounceEnabled == false then 
	    opt.isBounceEnabled = false
	end
	opt.autoHideScrollBar = true
	if nil ~= customOptions.autoHideScrollBar and customOptions.autoHideScrollBar == false then
		opt.autoHideScrollBar = false
	end
	
	-- Set the scrollView to locked if both horizontal and vertical scrolling are disabled
	if opt.isHorizontalScrollingDisabled and opt.isVerticalScrollingDisabled then
		opt.isLocked = true
	end
	
	-- Ensure scroll width/height values are at a minimum, equal to the scroll window width/height
	if opt.scrollHeight then
		if opt.scrollHeight < opt.height then
			opt.scrollHeight = opt.height
		end
	end
	
	if opt.scrollWidth then
		if opt.scrollWidth < opt.width then
			opt.scrollWidth = opt.width
		end
	end
	
	-- ScrollBar options
	if nil ~= customOptions.scrollBarOptions then
	    opt.scrollBarOptions =
	    {
		    sheet = customOptions.scrollBarOptions.sheet,
		    topFrame = customOptions.scrollBarOptions.topFrame,
		    middleFrame = customOptions.scrollBarOptions.middleFrame,
		    bottomFrame = customOptions.scrollBarOptions.bottomFrame,
	    }
	else
	    opt.scrollBarOptions = {}
	end

			
	-------------------------------------------------------
	-- Create the scrollView
	-------------------------------------------------------
		
	-- Create the scrollView object
	local scrollView = _widget._newContainer
	{
		left = opt.left,
		top = opt.top,
		id = opt.id or "widget_scrollView",
		baseDir = opt.baseDir,
		widgetType = "scrollView",
	}

	-- Create the scrollView
	createScrollView( scrollView, opt )	
	
	scrollView.width = opt.width
	scrollView.height = opt.height
	
	local x, y = _widget._calculatePosition( scrollView, opt )
	scrollView.x, scrollView.y = x, y	
	
	return scrollView
end

return M
