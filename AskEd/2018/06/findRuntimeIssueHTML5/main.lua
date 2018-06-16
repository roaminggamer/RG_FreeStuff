io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================

require "runtimeDebug"

local function test1()
	local listener
	listener = function()
		print("success")
		Runtime:removeEventListener("enterFrame", listener )
   end
   Runtime:addEventListener( "enterFrame", listener )
end

local function test2()
   Runtime:addEventListener( "enterFrame", listener )
end

test2()