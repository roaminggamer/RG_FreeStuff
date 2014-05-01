-- =============================================================
-- main.lua
-- =============================================================
io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar



-- 1. Require the library module
--
require "RGEasyFTV"


-- 2. Write a Listener that does 'something' with the event(s)
--
local function myListener( event )
	local keyName = event.keyName
	local phase   = event.phase
	local time    = system.getTimer()

	if( event.phase == "began" ) then 
		print( "Fire TV Key '" .. keyName .. "' pressed at time " .. time )

	elseif( event.phase == "ended" ) then 
		print( "Fire TV Key '" .. keyName .. "' released at time " .. time )

    end

    return true
 end


-- 3. Start Listening
--
Runtime:addEventListener( 'onFTVKey', myListener )


