
local function sendEmail( to, subject, msg )

	local closeMyKeyboard
	closeMyKeyboard = function ( event )
	    if event.type == "applicationResume" then        
	        print("Application resumed from suspension")
	        Runtime:removeEventListener( "system", closeMyKeyboard )
	        native.setKeyboardFocus(nil) -- Closes keyboard
	    end
	end
	Runtime:addEventListener( "system", closeMyKeyboard )

	local options = { to = to, subject = subject, body = msg }
	native.showPopup( "mail", options )
end

sendEmail( "john.doe@somewhere.com", "Problem Solved",  "Got keyboard closing problems?" )



