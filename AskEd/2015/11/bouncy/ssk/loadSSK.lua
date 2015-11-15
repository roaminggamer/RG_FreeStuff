-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- SSKCorona Loader 
-- =============================================================
-- 								License
-- =============================================================
--[[
	> SSK is free to use.
	> SSK is free to edit.
	> SSK is free to use in a free or commercial game.
	> SSK is free to use in a free or commercial non-game app.
	> SSK is free to use without crediting the author (credits are still appreciated).
	> SSK is free to use without crediting the project (credits are still appreciated).
	> SSK is NOT free to sell for anything.
	> SSK is NOT free to credit yourself with.
]]
-- =============================================================
-- Create ssk global if needed
_G.ssk = _G.ssk or {}
ssk.getVersion = function() return "14 OCT 2015" end

ssk.__measureSSK			= false		-- Show how much memory is used by each module and all of SSK
ssk.__enableAutoListeners	= true 		-- Enables automatic attachment of event listeners in extended display library
ssk.enableExperimental		= false 		-- Enables experimental features (turn this off if you run into problems)
ssk.__desktopMode		 	= true 		-- Running in a 'desktop' app, not mobile.
ssk.__adjustMeasureOnResize	= true 		-- When resize even occurs adjust screen mesurements.

-- If measuring, get replacement 'require'
--
local local_require = ( ssk.__measureSSK ) and require("ssk.measureSSK").measure_require or _G.require

-- ==
-- Load SSK Modules (mostly packaged into SSK super-object)
-- ==
local_require "ssk.RGGlobals"
local_require "ssk.RGExtensions"
local_require "ssk.RGDisplay"
local_require "ssk.RGEasyInterfaces"
local_require "ssk.RGMath2D"

local_require "ssk.RGCamera"
local_require "ssk.RGCC"
local_require "ssk.RGEasyKeys"
local_require "ssk.RGEasyInputs.RGEasyInputs"

local_require "ssk.RGFiles"
local_require "ssk.actions.RGActions"
local_require "ssk.RGMisc"

local_require "ssk.RGAndroid"

local_require "ssk.RGPoints" 
local_require "ssk.RGPersist"
local_require "ssk.RGEasyBench"
local_require "ssk.RGMultiscroller"



--
if(ssk.__enableExperimental) then 
	local_require "ssk.extras.lazyRequire" 
end

--
-- External Libs/Modules (Written by others and used with credit.)
--
ssk.GGFile = local_require( "ssk.external.GGFile" ) -- Modified version of GlitchGames' GGFile (added binary copy and move) 
ssk.wait =  local_require( "ssk.external.wait" ) -- Adapted from Steven Johnson's work (ggcrunchy) https://github.com/ggcrunchy/samples
ssk.randomlua = local_require "ssk.external.randomlua" -- Various 'math.random' alternatives


-- Meaure Final Cost of SSK (if enabled)
if( ssk.__measureSSK ) then require("ssk.measureSSK").summary() end

-- Frame counter (used for touch coalescing)
ssk.__lfc = 0
ssk.enterFrame = function( self ) self.__lfc = self.__lfc + 1; end; listen("enterFrame",ssk)
return ssk