-- =============================================================
-- main.lua
-- =============================================================

----------------------------------------------------------------------
--	1. Requires
----------------------------------------------------------------------
-- http://docs.coronalabs.com/daily/api/library/composer/index.html
local composer 	= require "composer" 

require "scripts.pushButtonClass"
require "scripts.toggleButtonClass"


----------------------------------------------------------------------
--	2. Initialization
----------------------------------------------------------------------
-- Turn on debug output for composer + Various other settings
--
composer.isDebug = true
--composer.recycleOnLowMemory = false
--composer.recycleOnSceneChange = true

-- Print to console immediately.
--
io.output():setvbuf("no") 

-- Hide that pesky bar
--
display.setStatusBar(display.HiddenStatusBar)  

-- Need multi-touch?  Enable it now.
--
--system.activate("multitouch") 

--local physics = require "physics"
--physics.setGravity( 0, 10 )
--physics.setDrawMode( "hybrid" )


----------------------------------------------------------------------
-- 3. Execution
----------------------------------------------------------------------
composer.gotoScene( "ifc.splash" )
--composer.gotoScene( "ifc.mainMenu" )
