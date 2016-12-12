-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
--  main.lua
-- =============================================================
-- Recipe Pack #004 - Using ssk.easyInputs.* 
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
_G.fontN 	= "Raleway-Light.ttf" 
_G.fontB 	= "Raleway-Black.ttf" 
-- =============================================================
-- LOAD & INITIALIZE - SSK 2
-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init()
_G.ssk.init( { launchArgs 				= ..., 
	            enableAutoListeners 	= true,
	            exportCore 				= true,
	            exportColors 			= true,
	            exportSystem 			= true,
	            exportSystem 			= true,
	            gameFont 				= "Raleway-Light.ttf",
	            debugLevel 				= 0 } )
-- =============================================================

local composer = require "composer"
composer.gotoScene( "scenes.home" )
