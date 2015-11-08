-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"The person who asked this wanted to make a spinning arrow that slows down. ",
	"Here is a simple example showing how to make one."
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end



--
-- Require and start physics
local physics 		= require "physics"
physics.start()
physics.setGravity( 0, 0 )
--physics.setDrawMode( "hybrid" )


--
-- Require a helper library for physics dragging
local helpers = require "helpers"

-- 
-- Create an 'anchor' to mount the wheel to
local anchor = display.newRect( 0, 0, 5, 5 )
anchor.x = display.contentCenterX
anchor.y = display.contentCenterY + 50
physics.addBody( anchor , "static" )


-- 
-- Create the wheel, mount it to the anchor, and attach a dragger touch hander.
local wheel = display.newImageRect( "arrow.png", 220, 400 )
wheel.x = anchor.x
wheel.y = anchor.y
physics.addBody( wheel, "dynamic" )

wheel.angularDamping 		= 1.2  -- Wheel slows down if you're not applying a force
wheel.maxAngularVelocity 	= 720 -- Used to cap angular velocity below

physics.newJoint( "pivot", wheel, anchor, anchor.x, anchor.y )
helpers.addDragger( wheel )


--
-- Limit the wheels's angular velocity
function wheel.enterFrame( self )
	if( self.angularVelocity < 0 ) then
		if( math.abs(self.angularVelocity) > self.maxAngularVelocity ) then 
			self.angularVelocity = -self.maxAngularVelocity
		end
	else
		if( self.angularVelocity > self.maxAngularVelocity ) then 
			self.angularVelocity = self.maxAngularVelocity
		end
	end
end
Runtime:addEventListener( "enterFrame", wheel )

