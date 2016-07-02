----------------------------------------------
-- Configure experiements (common variables to allow quick change of all experiments)
----------------------------------------------
_G.maxObjs   = 60  -- Max objects (not including player)
_G.maxSpeed  = 250 -- Player speed in 'pixels per second'

----------------------------------------------
-- Load (and run) experiment of choice below
----------------------------------------------
--require "experiment_01" -- Baseline
--require "experiment_02" -- Baseline + Garbage Collection OFF
--require "experiment_03" -- Re-use objects when 'limit' reached instead of making new ones.
--require "experiment_04" -- Translation movement (instead of setLinearVelocity)
--require "experiment_05" -- Experiment #4 + + Garbage Collection OFF
--require "experiment_06" -- Experiment #4 + Re-use 

require "experiment_06"










----------------------------------------------
-- IGNORE BELOW THIS LINE
----------------------------------------------
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
local meters = require "basic_meters"
local function onTap( event )
	if( event.numTaps == 2 ) then
		meters.create_fps()
		meters.create_mem()
		Runtime:removeEventListener( "tap", onTap )
	end
end
Runtime:addEventListener( "tap", onTap )