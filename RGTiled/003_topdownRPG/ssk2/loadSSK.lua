-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- Development Notes:
-- 1. In future, add extras/particleTrail.lua w/ CBE, prism, newEmitter, ++
-- 2. Add event reflector?
-- =============================================================

-- ==
--    fnn( ... ) - Return first argument from list that is not nil.
--    ... - Any number of any type of arguments.
-- ==
local function fnn( ... ) 
	for i = 1, #arg do
		local theArg = arg[i]
		if(theArg ~= nil) then return theArg end
	end
	return nil
end
local function countGlobals()
	local count = 0
	for k,v in pairs(_G) do
		count = count+1
	end
	return count
end
-- =============================================================
-- Configure loader
-- =============================================================
local measure 		= false
local gCount1 = countGlobals()
local gCount2

-- Create ssk as global (temporarily)
_G.ssk = {}

ssk.getVersion = function() return "2018.07.23" end

local initialized = false
ssk.init = function( params )
	if( initialized ) then return end
	params = params or
	{ 
		gameFont 				= native.systemFont,
		measure 					= false, -- Print out memory usage for SSK libraries.
		debugLevel 				= 0, -- Some modules use this to print extra debug messages
		                          -- Typical levels are 0, 1, 2 (where 2 is the most verbose)
	}

	-- Ensure there is a gameFont
	params.gameFont = params.gameFont or native.systemFont
	ssk.__gameFont = params.gameFont


	-- WIP Featuer to support HTML5
	_G.HTML5_MODE = (params.html5 == true)

	-- Snag the debug level setting
	ssk.__debugLevel = params.debugLevel or 0

	-- LaunchArgs
	ssk.launchArgs = params.launchArgs or {} 

	--
	-- Track the font users asked for as their gameFont 
	--
	--
	function ssk.gameFont() return ssk.__gameFont end

	-- =============================================================
	-- If measuring, get replacement 'require'
	-- =============================================================
	local local_require = ( params.measure ) and require("ssk2.measureSSK").measure_require or _G.require
	if( params.measure ) then 
		print(string.rep("-",74))
		print( "-- Initalizing SSK")
		print(string.rep("-",74))
	end	

	-- =============================================================
	-- Load SSK Lite Components
	-- =============================================================
	local_require "ssk2.core"
	local_require "ssk2.extensions.display"
	if( not _G.HTML5_MODE ) then
		local_require "ssk2.extensions.io"
	end
	local_require "ssk2.extensions.math"
	local_require "ssk2.extensions.string"
	local_require "ssk2.extensions.table"
	local_require "ssk2.extensions.timer2"
	local_require "ssk2.extensions.transition"
	local_require "ssk2.system"
	local_require "ssk2.colors"
	local_require "ssk2.display"
	local_require "ssk2.math2d"
	local_require "ssk2.cc"
	local_require "ssk2.actions.actions"
	local_require "ssk2.easyIFC"
	local_require "ssk2.easyInputs"
	local_require "ssk2.easyCamera"
	local_require "ssk2.misc"
	local_require "ssk2.pex"
	local_require "ssk2.dialogs.basic"
	local_require "ssk2.dialogs.custom"
	local_require "ssk2.factoryMgr"
	local_require "ssk2.vScroller"
	local_require "ssk2.behaviors"
-- =============================================================
	local_require "ssk2.android"
	local_require "ssk2.security"
	local_require "ssk2.persist"
	local_require "ssk2.points"
	local_require "ssk2.soundMgr"
	local_require "ssk2.easySocial"
	local_require "ssk2.shuffleBag"
	local_require "ssk2.meters"
	if( not _G.HTML5_MODE ) then
		local_require "ssk2.files"
	end
	local_require "ssk2.tiledLoader"
	local_require "ssk2.easyPositioner"
	local_require "ssk2.easyBench" -- Easy Benchmarking Lib
	
	-- =============================================================
	-- External Libs/Modules (Written by others and used with credit.)
	-- =============================================================
	--_G.ssk.autolan = {}
	--_G.ssk.autolan.client = local_require( "ssk2.external.mydevelopers.autolan.Client" )
	--_G.ssk.autolan.server = local_require( "ssk2.external.mydevelopers.autolan.Server" )
	local_require( "ssk2.external.proxy" ) -- Adds "propertyUpdate" events to any Corona display object.; Source unknown
	local_require( "ssk2.external.wait" ) -- Adapted from Steven Johnson's work (ggcrunchy) https://github.com/ggcrunchy/samples
	local_require( "ssk2.external.randomlua" ) -- Various 'math.random' alternatives
	_G.ssk.class = local_require("ssk2.external.30log") -- http://yonaba.github.io/30log/
	local_require("ssk2.external.portableRandom") -- Portable random library
	local_require("ssk2.external.ponyfont") -- Pony Font - Bitmap Fonts Utility
	if( params.enableUTF8 ) then
		ssk.ponyFont.enableUTF8()
	end
	local_require("ssk2.external.global_lock") -- Globals locking utility


	-- =============================================================
	-- Frame counter 
	-- =============================================================
	ssk.__lfc = 0
	local getTimer = system.getTimer
	ssk.__lastTime = getTimer()
	ssk.__deltaTime = 0
	function ssk.getDT() return ssk.__deltaTime end 
	function ssk.getFrame() return ssk.__lfc end 
	ssk.enterFrame = function( self ) 
		self.__lfc = self.__lfc + 1; 
		local curTime = getTimer()
		ssk.__deltaTime = curTime - self.__lastTime
		self.__lastTime = curTime
	end; Runtime:addEventListener("enterFrame",ssk)

	-- =============================================================
	-- Current Orientation Detection
	-- =============================================================
	ssk.__currentOrientation = (display.contentWidth<display.contentHeight) and "portrait" or "landscapeRight"
	local function onOrientationChange( event )
    ssk.__currentOrientation = event.type
 	end  
	Runtime:addEventListener( "orientation", onOrientationChange )
	function ssk.orientation() return ssk.__currentOrientation end


	-- =============================================================
	-- Initialize The Core
	-- =============================================================
	ssk.core.init( params.launchArgs or {} )

	--  
	--	Export Core, Colors, System
	--
	local exportMessages = {}
	local function doExport( feature )
		local gCount1a = countGlobals()
		ssk[feature].export()
		local gCount2a = countGlobals()
		exportMessages[#exportMessages+1] = "Exporting the SSK 2 feature '" .. feature .. "' added " .. tostring(gCount2a-gCount1a) .. " globals."
	end
	doExport( "core" )
	doExport( "colors" )
	doExport( "system" )

	-- =============================================================
	-- Finialize measurements and show report (if measuring enabled)
	-- =============================================================
	-- Meaure Final Cost of SSK (if enabled)
	if( params.measure ) then 
		require("ssk2.measureSSK").summary() 
		for i = 1, #exportMessages do
			print(exportMessages[i])
		end
		print(string.rep("-",74))
		gCount2 = countGlobals()
		print("SSK 2 Added: " .. tostring( gCount2 - gCount1) .. " globals." )
		print(string.rep("-",74))
	end


	-- =============================================================
	-- FIN
	-- =============================================================
	initialized = true
end

return ssk