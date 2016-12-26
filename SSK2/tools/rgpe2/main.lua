-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Roaming Gamer Particle Editor 2 (a free SSK2 co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
--   Last Updated: 26 DEC 2016
-- =============================================================
_G.RGPEVer 		= "2.1"
_G.lastUpdate 	= "26 DEC 2016"
--[[

Dear Developers,

	This is a tool that I put many hours into and then later decided 
	to release (to the community) for free.  You can read all about this
	in the README.md file which also includes the license for this too.

	This note however is (mostly) about the code you will find herein.

	This code was never meant for public consumption and is in some
	ways incomplete.  While I believe it is functional and I will 
	do my best to fix and support major issues... 

	1. This does not represent my typical level of client coding.

	2. This code may very well have errors, mistakes, and be generally
	   messy.

   So, with that in mind, I hope you will find the tool helpful, but
   if you don't like it or you find the code to be 'messy' or 'ugly'
   please don't judge me too harshly.


   Cheers,

   Ed Maurina (aka The Roaming Gamer)
   http://roaminggamer.com/


--]]
-- =============================================================
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
-- =============================================================
_G.normalFont		= "Lato-Regular.ttf"
_G.boldFont			= "Lato-Black.ttf"
-- =============================================================
-- LOAD & INITIALIZE - SSK 2
-- =============================================================
require "ssk2.loadSSK"
_G.ssk.init( { launchArgs 				= ..., 
	            enableAutoListeners 	= true,
	            exportCore 				= true,
	            exportColors 			= true,
	            exportSystem 			= true,
	            gameFont 				= boldFont,
	            debugLevel 				= 0 } )
-- =============================================================
-- =============================================================

-- Useful Localizations
local getTimer          = system.getTimer
local mRand					= math.random
local tpd 					= timer.performWithDelay

require "presets.rgpe.presets"

local common 	= require "scripts.common"
local init 		= require "scripts.init" 

init.run()


-- =============================================================
-- Interface Construction
-- =============================================================
local layersMgr 		= require "scripts.layersMgr"
local skel 				= require "scripts.skel"
local rightPane		= require "scripts.rightPane"
local menuBar 			= require "scripts.menuBar"
local leftPane 		= require "scripts.leftPane"
local mainPane 		= require "scripts.mainPane"
local slider 			= require "scripts.slider"

local layers = layersMgr.create()
layers.skel.alpha = 0

-- Create a 'skeleton' that is used to position all other elements.
skel.create()

-- Add slider to bottom of screen (context senstive visibility)
slider.create()

-- Initialize the panes
leftPane.init()
mainPane.init()
rightPane.init()

-- Create the menu bar
menuBar.create()

-- =============================================================
-- Re-load last project if any
-- =============================================================

local function onKey( event )
	if(event.phase == "up") then 
		--if( event.keyName == "e" ) then post( "onExportProject" ) end
		--if( event.keyName == "z" ) then post( "onZoom" ) end
	end
end; nextFrame( function() listen( "key", onKey) end, 500 )


-- =============================================================
-- Custom Events List (internal 'docs' to help my memory) -RG
-- =============================================================
--[[
	"onCreateNewEmitter", { details, toLayer }
	"onCreateNewImageLayer", { details, toLayer }
	"onSelectedObject"
 	"onRefresh" 
	"onRefreshLeftPane", { layerNum }
	"onSelectedMainPaneLayer", { layerNum, isType }
 	"onSliderTouch", { value }
 	"onRestoreProject"
--]]

local copymsg = 
"****************************************************************************\n" ..
" Roaming Gamer Particle Editor 2 - Copyright (C) 2016 Roaming Gamer, LLC.\n" ..
"****************************************************************************\n" ..
"   This program comes with ABSOLUTELY NO WARRANTY.\n" ..
"   This is free software, and you are welcome to redistribute it\n" ..
"   under certain conditions.\n" ..
"****************************************************************************\n" ..
"   This tool requires a paid copy of SSK 2 PRO to run.\n\n" ..
"   DO NOT DISTRIBUTE THE SSK2 SOURCE CODE!\n" ..
"****************************************************************************\n" 
print( copymsg )