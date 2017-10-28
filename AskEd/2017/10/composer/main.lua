-- =============================================================
display.setStatusBar(display.HiddenStatusBar)  
io.output():setvbuf("no") 
-- =============================================================

local composer = require("composer")
composer.gotoScene( 'menu' )