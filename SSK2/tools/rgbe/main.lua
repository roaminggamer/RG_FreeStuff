-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2016 (All Rights Reserved)
-- =============================================================
-- Roaming Gamer Button (Presets) Editor (a free SSK2 co-product)
-- =============================================================
-- See README.md for full license details.
-- =============================================================
--   Last Updated: 06 JAN 2017
-- =============================================================
_G.RGBEVer 					= "1.0"
_G.lastUpdate 				= "06 JAN 2017"
local minSSK2Ver 			= 2017.005
local bestAspectRatio 	= 1280/720
local skipAspectCheck   = false

_G.edoMode = false -- For Ed ONLY


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
-- Check for proper version of SSK 2 and for prefered aspect ratio.
-- =============================================================
if( tonumber(ssk.getVersion()) < minSSK2Ver ) then
	ssk.misc.easyAlert( 	"SSK2 Version Too Old", 
								"This tool requires SSK 2 PRO version: " .. ssk.getVersion() .. " (or higher) to run.\n\n"..
								"Please download the latest version of SSK 2.",
								{{ "OK" } } )
elseif( not _G.ssk.__isPro ) then
	ssk.misc.easyAlert( 	"SSK2 PRO Required", 
								"This tool requires SSK 2 PRO version: " .. ssk.getVersion() .. " (or higher) to run.\n\n"..
								"Please download the latest version of SSK 2.",
								{{ "OK" } } )

elseif( not skipAspectCheck and fullw/fullh ~= bestAspectRatio ) then
	ssk.misc.easyAlert( 	"Wrong Resolution", 
								"For the best experience you should run this tool in:\n\n" ..
								"'Custom Device' view with a resolution of: 720 x 1280.",
								{{ "OK" } } )
end
-- =============================================================
-- =============================================================
----[[
-- Useful Localizations
local getTimer          = system.getTimer
local mRand					= math.random
local tpd 					= timer.performWithDelay

require "presets.rgpe.presets"

local common 	= require "scripts.common"
local export 	= require "scripts.export" 

display.setDefault( "background", unpack(common.backgroundColor))

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
	--table.dump(event)
	if(event.phase == "up") then 
		if( event.keyName == "escape" ) then post("onClearSelection") end
		if( event.keyName == "s" ) then post("onSave") end
		--if( event.keyName == "g" ) then post("onExportCurrentCatalog") end
		if( event.isCtrlDown and event.keyName == "g" ) then post("onExportCurrentCatalog") end
	end
end; nextFrame( function() listen( "key", onKey) end, 500 )

--]]
-- =============================================================
-- Custom Events List (internal 'docs' to help my memory) -RG
-- =============================================================
--[[
	"onCreateNewEmitter", { details, toLayer }
	"onCreateNewImageLayer", { details, toLayer }
	"onSelectedObject"
 	"onRefresh" 
	"onSelectedMainPaneLayer", { layerNum, isType }
 	"onSliderTouch", { value }
--]]

local copymsg = 
"****************************************************************************\n" ..
" Roaming Gamer Generic (Tool) Frame - Copyright (C) 2016 Roaming Gamer, LLC.\n" ..
"****************************************************************************\n" ..
"   This program comes with ABSOLUTELY NO WARRANTY.\n" ..
"   This is free software, and you are welcome to redistribute it\n" ..
"   under certain conditions.\n" ..
"****************************************************************************\n" ..
"   This tool requires a paid copy of SSK 2 PRO to run.\n\n" ..
"   DO NOT DISTRIBUTE THE SSK2 SOURCE CODE!\n" ..
"****************************************************************************\n" 
print( copymsg )

