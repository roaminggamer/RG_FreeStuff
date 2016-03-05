-- =============================================================
-- Your Copyright Statement Goes Here
-- =============================================================
--  main.lua
-- =============================================================

io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)

local composer = require "composer"
require "scripts.pushButtonClass"
require "scripts.toggleButtonClass"
require "scripts.imgPushButtonClass"

system.activate("multitouch")
local physics = require "physics"
physics.start( )
physics.setGravity( 0, 10 )
--physics.setDrawMode( "hybrid" )

print(display.contentWidth, display.contentHeight)

-- Composer Stuff
--composer.gotoScene( "ifc.splash" )
composer.gotoScene( "ifc.mainMenu" )