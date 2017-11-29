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

-- =============================================================
-- Configure loader
-- =============================================================
local measure 		= false

-- Create ssk as global (temporarily)
_G.ssk = {}

ssk.getVersion = function() return "2017.11.20" end

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

	-- Snag the debug level setting
	ssk.__debugLevel = params.debugLevel or 0

	--
	-- Track the font users asked for as their gameFont 
	--
	ssk.__gameFont = params.gameFont or native.systemFont
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
	local_require "ssk2.extensions.io"
	local_require "ssk2.extensions.math"
	local_require "ssk2.extensions.native"
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
-- =============================================================
	local_require "ssk2.android"
	local_require "ssk2.security"
	local_require "ssk2.persist"
	local_require "ssk2.points"
	local_require "ssk2.soundMgr"
	local_require "ssk2.easySocial"
	local_require "ssk2.shuffleBag"
	local_require "ssk2.meters"
	local_require "ssk2.files"
	local_require "ssk2.tiledLoader"
	local_require "ssk2.easyPositioner"
	local_require "ssk2.adHelpers.adHelpers"
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
	local_require("ssk2.external.global_lock") -- Portable random library
	local_require("ssk2.external.rle") -- Run Length Encoder


	-- =============================================================
	-- Finialize measurements and show report (if measuring enabled)
	-- =============================================================
	-- Meaure Final Cost of SSK (if enabled)
	if( params.measure ) then require("ssk2.measureSSK").summary() end

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
	-- Initialize The Core
	-- =============================================================
	ssk.core.init( params.launchArgs or {} )

	--  
	--	Export Core, Colors, System
	--
	ssk.core.export()
	ssk.colors.export()
	ssk.system.export()

	-- =============================================================
	-- FIN
	-- =============================================================
	initialized = true
end

return ssk