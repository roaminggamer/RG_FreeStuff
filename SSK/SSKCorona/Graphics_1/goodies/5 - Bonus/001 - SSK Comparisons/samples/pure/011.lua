-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================

local group = display.newGroup()

-- Local Variables
local centerX		= display.contentCenterX
local centerY		= display.contentCenterY
local w				= display.contentWidth


local function onPush( event )
	local target = event.target 
	local phase  = event.phase

	print( "User pressed button: ", target.label.text)

	return true  
end

local function onTouch( self, event )
	local phase  = event.phase

	if( phase == "began" )  then
		-- Force all future events from this touch to go to this object
		display.getCurrentStage():setFocus( self, event.id )
		self.isFocus = true
		self:setFillColor( 192, 192, 192 )		

	elseif( self.isFocus ) then
		local bounds	= self.stageBounds
		local x,y		= event.x, event.y

		local isWithinBounds = 
			bounds.xMin <= x and bounds.xMax >= x and bounds.yMin <= y and bounds.yMax >= y
			
			-- If the touch has moved, be sure the button is properly highlighted
			if( phase == "moved" ) then
				-- If touch has moved off button, un-highlight it
				if( not isWithinBounds ) then
					self:setFillColor( 64, 64, 64 )
				-- If touch is still over button be sure it is highlighted
				else
					self:setFillColor( 192, 192, 192 )			
				end

				return true

			-- If the touch ended (or was cancelled), check to see if we need to call the user's callback or not
			elseif( phase == "ended" or phase == "cancelled" ) then

				local retVal = false

				-- Only call the user defined callback if the touch ended over the button.
				if( isWithinBounds ) then
					retVal = onPush( event )
				end

				self:setFillColor( 64, 64, 64 )
				display.getCurrentStage():setFocus( self, nil )
				self.isFocus = false

				return retVal
			end

	else
		return false
	end

	return true  
end

--
-- Label the sample and create buttons
--

-- Push Button 1
local button = display.newRect(group,0,0,180,40)
button.x = centerX
button.y = centerY - 45
button:setFillColor( 64, 64, 64 )

button.label	= display.newText( group, "Button 1", 0, 0, native.systemFontBold, 16 )
button.label.x	= button.x
button.label.y	= button.y

button.touch = onTouch
button:addEventListener( "touch", button )

-- Push Button 2
button = display.newRect(group,0,0,180,40)
button.x = centerX
button.y = centerY
button:setFillColor( 64, 64, 64 )

button.label	= display.newText( group, "Button 2", 0, 0, native.systemFontBold, 16 )
button.label.x	= button.x
button.label.y	= button.y

button.touch = onTouch
button:addEventListener( "touch", button )

-- Push Button 2
button = display.newRect(group,0,0,180,40)
button.x = centerX
button.y = centerY + 45
button:setFillColor( 64, 64, 64 )

button.label	= display.newText( group, "Button 3", 0, 0, native.systemFontBold, 16 )
button.label.x	= button.x
button.label.y	= button.y

button.touch = onTouch
button:addEventListener( "touch", button )

group.y = group.y + 10

return group
