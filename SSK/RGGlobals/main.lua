-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2014 
-- =============================================================
-- SSK Tester
-- =============================================================
-- This is a quick test of the current library.
--
-- Warning: Not all features are tested here!
-- =============================================================

require "ssk.RGGlobals"



local myCustomListener = function( event )

	local url = event.url

	local connected = isConnectedToWWW( url )

	local msg  = "Connected to web? ==> "

	if(connected) then
		msg = msg .. "YES!"
	else 
		msg = msg .. "NO!"
	end


	local tmp = display.newText( msg, centerX, centerY, native.systemFontBold, 24 )

	if(connected) then
		tmp:setFillColor( unpack( _GREEN_ ) )
	else 
		tmp:setFillColor( unpack( _RED_ ) )
	end

end


listen( "WEB_CHECK", myCustomListener )

post( "WEB_CHECK", { url = 'www.roaminggamer.com' } )

ignore( "WEB_CHECK", myCustomListener )

post( "WEB_CHECK", { url = 'www.roaminggamer.com' } )



