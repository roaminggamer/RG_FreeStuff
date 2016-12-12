-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
--  main.lua (comments/code)
-- =============================================================
-- Kernel: EFM
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
-- KERNEL CODE BEGINS BELOW
-- =============================================================

-- =============================================================
-- Localizations
-- =============================================================
local newRect 			= ssk.display.newRect
local newImageRect 	= ssk.display.newImageRect
local oneStick 		= ssk.easyInputs.oneStick
local face 				= ssk.actions.face
local thrustForward	= ssk.actions.movep.thrustForward
local limitV			= ssk.actions.movep.limitV
local rectWrap 		= ssk.actions.scene.rectWrap

