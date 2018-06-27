io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================

-- I made this to generate the 'fake' content for this example
-- You don't care about this now
--local gen = require "gen"
--gen.run(100) -- Must be at least 2


--1. See the files pages/page1.lua .. pages/page100.lua

--2.  This runs/draw the 'story'
local draw = require "draw"
draw.run(100)
