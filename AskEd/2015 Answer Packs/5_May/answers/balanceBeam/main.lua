-- =============================================================
-- Answers to interesting Corona Forums Questions
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 
-- Notes for this example ( not part of example )
--
local notes = {
	"The user wanted to implement a balance beam using physics.", 
	"",
	"Here you go!"
}
for i = 1, #notes do
	local tmp = display.newText( notes[i], 50, 20 + (i-1) * 30, native.systemFont, 22 )
	tmp.anchorX = 0
end


--
-- Load SSK
--require "ssk.loadSSK"

--
-- Set up physcis
local physics = require("physics")
physics.start()
physics.setGravity(0,9.8)
--physics.setDrawMode( "hybrid" )


--
-- Localizations
local newCircle 	= ssk.display.newCircle
local newRect 		= ssk.display.newRect
local newImageRect 	= ssk.display.newImageRect
local easyIFC   	= ssk.easyIFC
local mRand 		= math.random


--
-- The parts
local group display.newGroup()

-- A 'floor'
--
newRect( group, centerX, bottom - 10, 
	     { w = 260, h = 20, fill = _G_, alpha = 0.5},
	     { bodyType = "static" } )

-- A fulcrum
--
local fulcrum = newCircle( group, centerX, bottom - 60, 
	       { radius = 10, fill = _Y_, alpha = 0.5}, 
	       { bodyType = "static" } )

-- A beam (the lever)
--
local beam = newRect( group, centerX, bottom - 80, 
	     { w = 200, h = 20, fill = _C_, alpha = 0.5},
	     { bodyType = "dynamic", friction = 1 } )

-- The Pivot
--
local pivotJoint = physics.newJoint( "pivot", beam, fulcrum, fulcrum.x, fulcrum.y )

pivotJoint.isLimitEnabled = true
pivotJoint:setRotationLimits( -10, 10 )

-- Drop a 'box' on the beam
--
newRect( group, centerX + 60, bottom - 120, 
	     { size = 40, fill = _R_, alpha = 0.5},
	     { bodyType = "dynamic", friction = 1 } )

--
-- Over time, drop smaller boxes on the other side
local function onTimer()

	local tmp = newRect( group, centerX - mRand(60, 90), bottom - 160, 
		     { size = 20, fill = _O_, alpha = 0.5},
		     { bodyType = "dynamic", friction = 0.5 } )

	tmp.timer = display.remove
	timer.performWithDelay( 8000, tmp )



	timer.performWithDelay( 1500, onTimer )

end
timer.performWithDelay( 1500, onTimer )
