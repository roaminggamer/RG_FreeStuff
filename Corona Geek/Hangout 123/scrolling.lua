-- =============================================================
-- main.lua
-- =============================================================

local textFieldWidth = display.contentWidth - 100


local function newTextField( group, x, y, fontSize, defaultText )

	local myInputField = native.newTextField( x, y, textFieldWidth, 30 )
	group:insert( myInputField )

	myInputField.size = fontSize
	myInputField:resizeHeightToFitFont()

	if( defaultText ) then
		myInputField.text = defaultText
	end

	return myInputField
end


--
-- Simple scrolling (dragging) example
--

-- Create object to catch 'drag' touches
local dragBack = display.newRect( display.contentCenterX,  display.contentCenterY, display.actualContentWidth, display.actualContentHeight )
dragBack:setFillColor( 0.1, 0.1, 0.1 )

-- Create group to contain text fields to be dragged
local dragGroup = display.newGroup()

-- Add touch listener to drag back
dragBack.touch = function( self, event )
	local phase = event.phase
	if( phase == "began" ) then
		-- Hide keyboard (de-select current native text field, if any.)
		native.setKeyboardFocus( nil )

		dragGroup.y0 = dragGroup.y
	else
		dragGroup.y = dragGroup.y0 + event.y - event.yStart
	end
	return true
end; dragBack:addEventListener( "touch" )

-- Add a bunch of text fields to the group
for i = 1, 100 do
	newTextField( dragGroup, display.contentCenterX, i * 30, 20, "Text field " .. i )
end


