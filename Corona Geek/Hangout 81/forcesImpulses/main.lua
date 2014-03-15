-- =============================================================
-- main.lua
-- =============================================================
io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar

require "ssk.RGGlobals"
require "ssk.RGExtensions"
require "ssk.RGCC"


local physics = require("physics")
physics.start()
physics.setGravity( 0, 10 )
--physics.setDrawMode( "hybrid" )


-- Load one or the other, not both
require "forces"
--require "impulses"