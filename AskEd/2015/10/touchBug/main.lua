display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar
io.output():setvbuf("no") -- Don't use buffer for console messages

local count = 0

local createButton

local function onTouch( self, event )
	if( event.phase == "ended" ) then
		print("---------------- " , system.getTimer())
		display.remove( self )
		--createButton()
	end
end	

createButton = function()
	local button = display.newRect( 100, 100, 200, 200)
	button.touch = onTouch
	button:addEventListener( "touch" )
end

createButton()