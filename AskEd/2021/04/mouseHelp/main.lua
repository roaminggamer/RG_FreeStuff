io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)

-- Called when a mouse event has been received.
local function onMouseEvent( event )
	-- Following code prints all event data
	-- for k,v in pairs(event) do
	-- 	print(k,v)
	-- end

    if event.type == "down" then
        if event.isPrimaryButtonDown then
            print( "Left mouse button clicked." )
        elseif event.isSecondaryButtonDown then
            print( "Right mouse button clicked." )        
        end
    end
end
                              
-- Add the mouse event listener.
Runtime:addEventListener( "mouse", onMouseEvent )
