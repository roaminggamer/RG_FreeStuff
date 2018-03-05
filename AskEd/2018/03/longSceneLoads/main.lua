-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init( { } )
-- ========================================
_G.workloadIterations = 50
-- ========================================
local composer = require "composer"
composer.gotoScene( "home" )





