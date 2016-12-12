-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
--  main.lua
-- =============================================================
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
_G.fontN 	= "Raleway-Light.ttf" 
_G.fontB 	= "Raleway-Black.ttf" 
-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init( { launchArgs = ..., 
	            gameFont = "Raleway-Light.ttf", 
	            math2DPlugin = true,
	            debugLevel = 0 } )
-- =============================================================
-- SummaryOfRecipe
-- =============================================================
--local composer = require "composer"
--composer.gotoScene( "scenes.splash" )

local game = require "scripts.game"
game.run()

