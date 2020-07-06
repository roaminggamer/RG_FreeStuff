-- =============================================================
-- main.lua
-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init( )

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
io.output():setvbuf("no") 
display.setStatusBar(display.HiddenStatusBar)  

----------------------------------------------------------------------
-- 3. Execution
----------------------------------------------------------------------
composer.gotoScene( "ifc.startup" )
-- composer.gotoScene( "ifc.blockingTest" )
--composer.gotoScene( "ifc.nonBlockingTest" )
