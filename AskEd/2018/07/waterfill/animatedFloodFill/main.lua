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

local options = { width = 32, height = 32, numFrames = 2 }
local sheet = graphics.newImageSheet( "wateranim.png", options )
local seqData = { name = "waves", frames = {1,2}, time = 1000 }

local group = display.newGroup()

local options =
{
	width 		= 500,
	height		= 400,
	rateX    	= 1,
	rateY    	= -1,
	sheet   		= sheet,
	seqData 		= seqData,
	baseWidth 	= 32,
	baseHeight 	= 32,
}
-- Place some water by the center
local water = mod.create( group, display.contentCenterX, display.contentCenterY, options )

-- Just for fun
--water:scale(2,2)

-- Frame area to show that fill is correct
local tmp = display.newRect( group, display.contentCenterX, display.contentCenterY, options.width, options.height )
tmp:setFillColor(0,0,0,0)
tmp.strokeWidth = 2


