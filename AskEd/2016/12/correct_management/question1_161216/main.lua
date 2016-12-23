-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
--  main.lua
-- =============================================================
-- Sample Showing Correct Scene Management when using:
--
-- Quick Layers (https://roaminggamer.github.io/RGDocs/pages/SSK2/libraries/display_layers/)
-- Tracking Camera (https://roaminggamer.github.io/RGDocs/pages/SSK2/libraries/camera/#tracking)
-- Easy Input - One Stick (https://roaminggamer.github.io/RGDocs/pages/SSK2/libraries/easy_inputs/#onestick)
--
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
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
	            gameFont 				= "Prime.ttf",
	            debugLevel 				= 0 } )
-- =============================================================
-- Optionally enable meters to check FPS and Memory usage.
-- https://roaminggamer.github.io/RGDocs/pages/SSK2/libraries/meters/
-- =============================================================
if( ssk.meters ) then
	ssk.meters.create_fps(true)
	ssk.meters.create_mem(true)
end
-- =============================================================
local composer = require "composer"
composer.gotoScene( "scenes.start" )
