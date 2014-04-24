require "RGEasyFTV"

--
-- Example 1 - Using a standard Runtime Event Listener
--

local label1 = display.newText( "-------", 190, 50, system.nativeFont, 18)

local function onFTVKey( event )
	label1.text = "1>> " .. event.name .. " : " .. event.nativeKeyCode .. " : " .. tostring(event.keyName) .. " : " .. event.phase
end
Runtime:addEventListener( "onFTVKey", onFTVKey )
--Alternately type this ==>  listen( "onFTVKey", onFTVKey )


--
-- Example 2 - Using a object Runtime Event Listener
--

local label2 = display.newText( "-------", 190, 100, system.nativeFont, 18)

label2.onFTVKey = function( self,  event )
	self.text = "2>> " .. event.name .. " : " .. event.nativeKeyCode .. " : " .. tostring(event.keyName) .. " : " .. event.phase
end
Runtime:addEventListener( "onFTVKey", label2 )
--Alternately type this ==>  listen( "onFTVKey", label2 )


--
-- Example 3 - Stop listening for object Runtime Event
--
local label3 = display.newText( "-------", 190, 150, system.nativeFont, 18)

label3.onFTVKey = function( self,  event )
	self.text = "3>> " .. event.name .. " : " .. event.nativeKeyCode .. " : " .. tostring(event.keyName) .. " : " .. event.phase
end
Runtime:addEventListener( "onFTVKey", label3 )
--Alternately type this ==>  listen( "onFTVKey", label3 )

--- .. later, to stop listening

Runtime:removeEventListener( "onFTVKey", label3 )
--Alternately type this ==>  ignore( "onFTVKey", label3 )

