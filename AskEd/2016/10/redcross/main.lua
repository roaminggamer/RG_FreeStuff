-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================

require "ssk2.loadSSK"
_G.ssk.init()
_G.ssk.init( { launchArgs           = ..., 
               enableAutoListeners  = true,
               exportCore           = true,
               exportColors         = true,
               exportSystem         = true,
               exportSystem         = true,
               debugLevel           = 0 } )

-- =============================================================
-- Above adds variables and functions I often use in answers.
-- =============================================================

local physics = require "physics"
physics.start()
physics.setGravity(0,10)
physics.setDrawMode( "hybrid" )

local composer = require "composer"
composer.gotoScene( "scenes.scene1" )
