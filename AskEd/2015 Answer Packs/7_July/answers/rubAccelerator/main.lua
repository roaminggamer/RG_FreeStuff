-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"From what I could tell, the person who asked this question wanted to use 'rubbing'",
	"as a kind of unique input to accelerate (or select a velocity) for a game object.", 
	"",
	"This is my attempt to achieve that goal. ",
	"1. Click and swipe left-right-left anywhere on the screen ... to cause the arrow to rotate.",
	"2. The faster you swipe back and forth the faster the arrow spins.",
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end


--
-- 1. Use physics for easy spinning
local physics = require "physics"
physics.start()
physics.setGravity(0,0)

--
-- 1. Create the arrow.
local arrow = display.newImageRect( "up.png", 80, 80 )
arrow.x = display.contentCenterX
arrow.y = display.contentCenterY + 100
physics.addBody( arrow )

arrow.angularDamping 		= 1 -- Arrow slows down if you're not applying a force
arrow.maxAngularVelocity 	= 1080 -- Used to cap angular velocity below


--
-- 2. Limit the arrow's angular velocity
function arrow.enterFrame( self )
	if( self.angularVelocity > self.maxAngularVelocity ) then 
		self.angularVelocity = self.maxAngularVelocity
	end
end
Runtime:addEventListener( "enterFrame", arrow )


-- 3. The 'rubbing' detector & logic
--
local lastTime
local lastX
local rubSpeedModifier = 5

local function onRub( event )
	local phase 	= event.phase
	local curTime 	= system.getTimer()
	local curX 		= event.x
	
	if( phase == "began" ) then
		lastTime = curTime
		local lastX = event.x
	elseif( phase == "moved" ) then
		local dt = curTime - lastTime
		if( dt > 0 ) then
			lastTime = curTime
			arrow.angularVelocity = arrow.angularVelocity + rubSpeedModifier/dt
		end
	end
	return true
end
Runtime:addEventListener( "touch", onRub )


