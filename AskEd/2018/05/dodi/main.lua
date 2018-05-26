io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =====================================================
-- =====================================================
--require "ssk2.loadSSK"
--_G.ssk.init( { } )
--ssk.misc.enableScreenshotHelper("s") 
-- =====================================================
_G.fontN 	= "Roboto-Regular.ttf" --native.systemFont
_G.fontB 	= "TitanOne-Regular.ttf" --native.systemFontBold

local composer = require "composer"
composer.gotoScene( "scene1" )
