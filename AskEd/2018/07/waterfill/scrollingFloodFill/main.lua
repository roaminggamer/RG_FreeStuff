-- =============================================================
--  main.lua
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
-- LOAD & INITIALIZE - SSK 2
-- =============================================================
--require "ssk2.loadSSK"
--_G.ssk.init( )
-- =============================================================
-- Optionally enable meters to check FPS and Memory usage.
-- =============================================================
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
-- =============================================================

local mod = require "mod"


local group = display.newGroup()

local options =
{
	width 		= 500,
	height		= 400,
	rateX    	= 1,
	rateY    	= -1,
	image    	= "water.png",
	baseWidth 	= 32,
	baseHeight 	= 32,
}

-- Place some water by the upper-left corner
local water = mod.create( group, 100, 100, options )


local lastTimer = timer.performWithDelay(  500,
	function()
		water:setRateX( math.random( -20, 20 )/10 )
		water:setRateY( math.random( -20, 20 )/10 )
	end, -1 )


timer.performWithDelay( 15000,
	function()
		timer.cancel(lastTimer)
		display.remove( water )
	end )