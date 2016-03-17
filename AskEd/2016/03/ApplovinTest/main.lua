io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)


local sdkKey = "YOUR_KEY_GOES_HERE"

local function adListener( event )
	for k,v in pairs( event ) do
		print( k, v)
	end
	print("----------------------------\n\n")
end

local applovin = require( "plugin.applovin" )
applovin.init( adListener, { sdkKey = sdkKey } )

timer.performWithDelay( 2000, function() applovin.load( false ) end )
timer.performWithDelay( 4000, function() applovin.show( false ) end )