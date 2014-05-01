

local onTouch = function( self, event )
	local phase = event.phase
	if( phase ~= "ended" ) then return false end


	self.callback()

	return true
end


local function newButton( group, x, y, w, h, text, callback )
	local group = group or display.currentStage

	local button = display.newRect( group, 0, 0, w, h )
	button:setFillColor( 0.2, 0.2, 0.2 )
	button:setStrokeColor( 1, 1, 0 )
	button.strokeWidth = 2

	button.x = x 
	button.y = y

	local label = display.newText( group, text, 0, 0, system.nativeFont, 14)
	label.x = x
	label.y = y

	button.label = label
	button.callback = callback

	button.touch = onTouch
	button:addEventListener( "touch" )

	return button
end


local public = {}

public.new = newButton

return public