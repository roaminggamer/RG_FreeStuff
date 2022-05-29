-- =============================================================
-- main.lua
-- =============================================================
_G.gameFont = "Abierta"
require "ssk.loadSSK"
display.setDefault( "background", unpack( hexcolor("#80caf6") ) )
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar
io.output():setvbuf("no") -- Don't use buffer for console messages
system.activate("multitouch") 

local physics = require "physics"
physics.start()
physics.setGravity(0,0)
--physics.setDrawMode("hybrid")

----------------------------------------------------------------------
----------------------------------------------------------------------
local common = require "common"
common.layers = ssk.display.quickLayers( sceneGroup, "underlay", "content", "overlay" )
local game = require "game4"
game.run()
