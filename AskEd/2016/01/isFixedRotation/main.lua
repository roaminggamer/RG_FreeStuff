-- =============================================================
-- Ask Ed 2016
-- =============================================================
-- by Roaming Gamer, LLC. 2009-2015 (http://roaminggamer.com/)
-- =============================================================

display.setStatusBar(display.HiddenStatusBar) 


-- True edges of screen (regardless of scaling mode in config.lua)
local left    = 0-(display.actualContentWidth - display.contentWidth)/2
local top     = 0-(display.actualContentHeight - display.contentHeight)/2
local right   = display.contentWidth + (display.actualContentWidth - display.contentWidth)/2
local bottom  = display.contentHeight + (display.actualContentHeight - display.contentHeight)/2
local centerX = display.contentCenterX
local centerY = display.contentCenterY

--
-- Load SSK
--require "ssk.loadSSK"

--
-- Set up physcis
local physics = require("physics")
physics.start()
physics.setGravity(0,9.8)
physics.setDrawMode( "hybrid" )

local mRand 		= math.random

--
-- The parts
local group = display.newGroup()

-- A 'floor'
--
local tmp = display.newRect( group, centerX, bottom - 10, 260, 20 )
tmp:setFillColor( 0, 1, 0, 0.5 )
physics.addBody( tmp, "static", {} )

-- A fulcrum
--
local fulcrum = display.newCircle( group, centerX, bottom - 60, 10 )
fulcrum:setFillColor( 1, 1, 0, 0.5 )
physics.addBody( fulcrum, "static", { radius = 10 } )

-- A beam (the lever)
--
local beam = display.newRect( group, centerX, bottom - 80, 200, 20 )
beam:setFillColor( 0, 1, 1, 0.5 )
physics.addBody( beam, "dynamic", { friction = 1 } )


-- The Pivot
--
local pivotJoint = physics.newJoint( "pivot", beam, fulcrum, fulcrum.x, fulcrum.y )
pivotJoint.isLimitEnabled = true
pivotJoint:setRotationLimits( -10, 10 )

-- Drop a 'box' on the beam
--
local tmp = display.newRect( group, centerX + 60, bottom - 120, 20, 20 )
tmp:setFillColor( 1, 0, 0, 0.5 )
physics.addBody( tmp, "dynamic", { friction = 1 } )
tmp.isFixedRotation = true

--
-- Over time, drop smaller boxes on the other side
local function onTimer()

	local tmp = display.newRect( group, centerX - mRand(60, 90), bottom - 160, 20, 20 )

	if( mRand( 1, 100 ) > 50  ) then
		tmp:setFillColor( 1, 0, 0, 0.5 )
		physics.addBody( tmp, "dynamic", { friction = 1 } )
		tmp.isFixedRotation =  true
	else
		tmp:setFillColor( 0, 1, 0, 0.5 )
		physics.addBody( tmp, "dynamic", { friction = 1 } )
		tmp.isFixedRotation =  false
	end

	tmp.timer = display.remove
	timer.performWithDelay( 8000, tmp )



	timer.performWithDelay( 1500, onTimer )

end
timer.performWithDelay( 1500, onTimer )
