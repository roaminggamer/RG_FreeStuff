-- =====================================================
local cx     = display.contentCenterX
local cy     = display.contentCenterY
local fullw  = display.actualContentWidth
local fullh  = display.actualContentHeight
local left   = cx - fullw/2
local right  = cx + fullw/2
local top    = cy - fullh/2
local bottom = cy + fullh/2
local getTimer = system.getTimer
-- == Uncomment following lines if you need  physics
--local physics = require "physics"
--physics.start()
--physics.setGravity(0,10)
--physics.setDrawMode("hybrid")
-- =====================================================
local function isValid(obj)
	return( obj ~= nil and type(obj.removeSelf) == "function" ) 
end
local curFrame = 1
local function enterFrame()
	curFrame = curFrame + 1
end; Runtime:addEventListener( "enterFrame", enterFrame )
-- =====================================================
local test = {}

--
-- Tests auto-cancellation of transition and shows that onComplete is NOT called.
-- 

function test.run()
	print("RUNNING TEST 1 @ ", getTimer())
	print("Frame: ", curFrame)
	print("-----------\n")

	local obj = display.newCircle( cx, top + 50, 20)

	function obj:onComplete()
		print( "onComplete() - Frame: ", curFrame)
		print( "onComplete() - Transition ended @ ", getTimer())
		print("-----------\n")
	end

	function obj:finalize()
		print( "finalize() - Frame: ", curFrame)
		print( "finalize() - Object is valid? ", isValid(self), " @ " , getTimer() )
		print("-----------\n")
	end
	obj:addEventListener("finalize")

	transition.to( obj, { y = bottom, time = 1000 } )

	timer.performWithDelay( 500, 
		function() 
			print( "timer closure - Frame: ", curFrame)
			print("timer closure - Removing object @ ", getTimer())
			print("timer closure - Object is valid? ", isValid(self) )
			display.remove( obj )
			print("timer closure - Object is valid after deletion? ", isValid(self) )
			print("-----------\n")
		end )
end

return test
