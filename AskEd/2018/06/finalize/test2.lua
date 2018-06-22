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
	print(obj ~= nil and type(obj.removeSelf) == "function") 
	return(obj ~= nil and type(obj.removeSelf) == "function") 
end
local curFrame = 1
local function enterFrame()
	curFrame = curFrame + 1
end; Runtime:addEventListener( "enterFrame", enterFrame )
-- =====================================================
local test = {}

--
-- Example from yvandotet, but cleaned up a little
-- 

function test.run()
	print("RUNNING TEST 2 @ ", getTimer())
	print("Frame: ", curFrame)
	print("-----------\n")
	
	local r = display.newRect( 0, 0, 100, 100)

	function r:first(event)
		print( "first() - Frame: ", curFrame)
		print( "first() @ ", getTimer())
		print( "Object is valid? ", isValid(self), getTimer() )
		print("-----------\n")
	end; r:addEventListener( "first" )

	function r:second(event)
		print( "second() - Frame: ", curFrame)
		print( "second() @ ", getTimer())
		print("Object is valid? ", isValid(self), getTimer() )
		print("-----------\n")
	end; r:addEventListener( "second" )

	function r:finalize() -- does not get event argument
		print( "finalize() - Frame: ", curFrame)
		print( "finalize() - Object is valid? ", isValid(self), " @ " , getTimer() )
		self:removeEventListener("first")
		self:removeEventListener("second")
		r = nil
		print("-----------\n")
	end; r:addEventListener( "finalize")

	print("Attempting to dispatch event 'first' @ " , getTimer() )
	print("Attempting to dispatch event 'first' @ frame ", curFrame )
	r:dispatchEvent( { name = "first" } )

	print("Removing object @ " , getTimer() )
	print("Removing object @ frame ", curFrame )
	display.remove( r )

	print("-----------\n")
	
	print("Attempting to dispatch event 'second' @ " , getTimer() )
	print("Attempting to dispatch event 'second' @ frame ", curFrame )
	if( r ) then
		r:dispatchEvent( { name = "second" } )
	else
		print("Object is valid? ", isValid(obj), getTimer() )
		print( "r == nil @ " , getTimer() )
	end

end

return test
