-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
-- Development Notes:
-- 1. In future, add extras/particleTrail.lua w/ CBE, prism, newEmitter, ++
-- 2. Add event reflector?
-- =============================================================
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

ssk.getVersion = function() return "2020.06.29" end

local initialized = false
ssk.init = function( params )
	if( initialized ) then return end
	params = params or
	{ 
		gameFont 				= native.systemFont,
		measure 				= false, -- Print out memory usage for SSK libraries.
		debugLevel 				= 0, -- Some modules use this to print extra debug messages
		                          -- Typical levels are 0, 1, 2 (where 2 is the most verbose)
	}

	-- Ensure there is a gameFont
	params.gameFont = params.gameFont or native.systemFont
	ssk.__gameFont = params.gameFont

	-- Extras
	params.extras = params.extras or 
	{
		"actions.face",
		"actions.move",
		"actions.movep",
		"actions.scene",
		"actions.target",
		"adHelpers.fakeAdsHelper",
		"adHelpers.adMobHelper",
		"adHelpers.appLovinHelper",
		"android",
		"behaviors",
		"composer_helpers",
		"dialogs.basic",
		"dialogs.custom",
		"easyBench",
		"easyCamera",
		"easyInputs.joystick",
		"easyInputs.oneTouch",
		"easyInputs.twoTouch",
		"easyInputs.oneStick",
		"easyInputs.twoStick",
		"easyInputs.oneStickOneTouch",
		"easyPositioner",
		"easySocial",
		"factoryMgr",
		"files",
		"logger",
		"meters",
		"misc",
		"persist",
		"pex",
		"points",
		"ripper",
		"security",
		"shuffleBag",
		"soundMgr",
		"tiledLoader",
		"vScroller",
	}

	-- Extras
	params.external = params.external or 
	{
		"30log",
		--"autolan",
		"global_lock",
		"ponyfont",
		"portableRandom",
		"proxy",
		"randomlua",
		"wait",
	}

	-- Game Logic (must be added manually to init list)
	params.logic = params.logic or {}


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
		print( "-- Initalizing SSK 2")
		print(string.rep("-",74))
	end	

	-- =============================================================
	-- Load SSK Lite Components
	-- =============================================================
	require("ssk2.core.load")(local_require)

	--
	-- Load Extras Alphabetically
	--
	local toLoad = {}
	for k,v in pairs(params.extras) do
		toLoad[#toLoad+1] = v		
	end
	table.sort( toLoad )
	for i = 1, #toLoad do		
		local_require("ssk2.extras." .. toLoad[i] )
	end

	--
	-- Load Externals Alphabetically
	--
	local toLoad = {}
	for k,v in pairs(params.external) do
		toLoad[#toLoad+1] = v		
	end
	table.sort( toLoad )
	for i = 1, #toLoad do		
		local_require("ssk2.external." .. toLoad[i] )
	end

	--
	-- Load (Game) Logic (Helpers) Alphabetically
	--
	local toLoad = {}
	for k,v in pairs(params.logic) do
		toLoad[#toLoad+1] = v		
	end
	table.sort( toLoad )
	for i = 1, #toLoad do		
		local_require("ssk2.logic." .. toLoad[i] )
	end


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
	if( ssk.__debugLevel > 0 ) then
		table.dump( launchArgs, "^-launchArgs\n" )
	end

	-- =============================================================
	-- Finialize measurements and show report (if measuring enabled)
	-- =============================================================
	-- Meaure Final Cost of SSK (if enabled)
	if( params.measure ) then 
		require("ssk2.measureSSK").summary() 
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