io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- =====================================================


--
-- This answer shows how to reverse the 'labels' list automatically (and to ensure the listener still works)
-- on a OS by OS basis. 
--
-- You can modify the 'detection code' to suit your needs, here are the valid platform names:
--
-- "iPhone OS", "Android", "Mac OS X", "tvOS", "Win"
--


-- 1. DO THIS ONCE BEFORE USING SHOW ALERT:
--
-- Tip: You can put this code in main.lua or in a module that you load from main.lua
--
local _oldShow = native.showAlert
local function overrideShowAlert( force )
	if( not force and system.getInfo("platformName") ~= "Mac OS X" ) then
		_oldShow  = nil
		-- Do nothing.  Just exit.
		return
	end

	native.showAlert = function( ... )
		local title, message, labels, listener = unpack( arg ) 		
		--
		local labelCount = #labels
		local function _listener( event )
			event.index = (labelCount - event.index) + 1
			return listener( event )
		end
		--
		local tmp = {}
		for i = #labels, 1, -1 do
			tmp[#tmp+1] = labels[i]
		end 
		labels = tmp
		tmp = nil
		return _oldShow( title, message, labels, _listener )
	end
end
--overrideShowAlert( )    -- Normal call
overrideShowAlert( true ) -- Debug call to test in simulator




-- 2. NOW USE SHOW ALERT ANYWHERE:
--
----[[
-- Handler that gets notified when the alert closes
local function onComplete( event )
	if ( event.action == "clicked" ) then
		local i = event.index
		print("pressed ", i)
	end
end
  
-- Show alert with two buttons
local alert = native.showAlert( "Corona", "Dream. Build. Ship.", { "1", "2", "3", "4" }, onComplete )
--]]