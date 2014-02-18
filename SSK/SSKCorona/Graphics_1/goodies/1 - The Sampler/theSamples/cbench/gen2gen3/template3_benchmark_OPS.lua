-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
-- Template #3 - For Benchmarks
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
-- 
-- =============================================================

local debugLevel = 2 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugPrinter.newPrinter( debugLevel )
local dprint = dp.print

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
local storyboard = require( "storyboard" )
-- Variables
local layers -- Local reference to display layers 
local overlayImage 
local backImage

-- Local Function & Callback Declarations
local createLayers
local addInterfaceElements

local gameLogic = {}

local startTime
local endTime

local oneTimePrep -- preTest for all tests
local oneTimeGather -- postTest for all tests; includes cleanup work

local preTest -- preTest for single theBenchmark
local theBenchmark -- run single theBenchmark (pass ops_per_iter)
local postTest -- postTest results for theBenchmark and return durationMS for the single theBenchmark
local iterate -- runs preTest,theBenchmark, postTest; pass iterations (times to run theBenchmark); returns table {durationMS, durationMS, ...}
local accumulate -- takes table from iterate and calculates final result; updates messages etc.

-- =======================
-- ====================== Initialization
-- =======================
function gameLogic:createScene( screenGroup )
	-- 1. Set up any rendering layers we need
	createLayers( screenGroup )

	-- 2. Add Interface Elements to this demo (buttons, etc.)
	addInterfaceElements()

	-- 3. Run the theBenchmark

	local closure = function ()
		oneTimePrep()
		local results = iterate( 50, 100000 )
		accumulate( results )
		oneTimeGather()
		timer.performWithDelay( 34, function() storyboard.gotoScene( "s_MainMenu" , "slideRight", 400  )	end )
	end

	timer.performWithDelay( 1000, closure )

end

-- =======================
-- ====================== Cleanup
-- =======================
function gameLogic:destroyScene( screenGroup )
	-- 1. Clear all references to objects we (may have) created in 'createScene()'	
	layers:destroy()
	layers = nil

	-- 2. Clean up gravity and physics debug
	physics.setDrawMode( "normal" )
	physics.setGravity(0,0)
	screenGroup.isVisible=false

	-- 3. EFM - add code to catch cancelled tests here


end

-- =======================
-- ====================== Local Function & Callback Definitions
-- =======================
createLayers = function( group )
	layers = ssk.display.quickLayers( group, 
		"background", 
		"content",
		"interfaces" )
end

addInterfaceElements = function()
	-- Add background and overlay
	--backImage = ssk.display.backImage( layers.background, "protoBack.png") 
	--overlayImage = ssk.display.backImage( layers.interfaces, "protoOverlay.png") 
	--overlayImage.isVisible = true

end	

oneTimePrep = function()
end

preTest = function()
	startTime = system.getTimer()
end

postTest = function()
	endTime = system.getTimer()
	return endTime-startTime
end

oneTimeGather = function()
end

iterate = function( iterations, numOps )
	local results = {}
	local iterations = iterations or 1 -- Default to 1 iteration
	local numOps     = numOps or 100000 -- Default to 100K ops

	results.iterations = iterations
	results.numOps = numOps

	for i = 1, iterations do
		preTest()
		theBenchmark( numOps )
		local durationMS = postTest()
		results[#results+1] = durationMS
	end
	return results
end

accumulate = function( results )
	local totalDurationMS = 0
	local totalOperations = results.iterations * results.numOps
	
	for i = 1, #results do
		totalDurationMS = totalDurationMS + results[i]
	end

	if( totalDurationMS > 0) then
		local OPS = round( (totalOperations / totalDurationMS) * 1000, 2 )

		local suffix = ""

		if(OPS > 1000000000) then
			OPS = round(OPS/1000000000,2)
			suffix = " G"
		elseif(OPS > 1000000) then
			OPS = round(OPS/1000000,2)
			suffix = " M"
		elseif(OPS > 1000) then
			OPS = round(OPS/1000,2)
			suffix = " K"
		end


		_G.lastResultMessage = totalOperations .. " operations @ " .. OPS .. suffix .. " ops/s"
	else
		_G.lastResultMessage = totalOperations .. SPC .. " operations in less than 1 ms" 
	end

	dprint(2, _G.lastResultMessage)

	return OPS	
end

theBenchmark = function( numOps )
	local sqrt = math.sqrt
	local dummy
	for i = 1, numOps do
		sqrt( i )
		--math.sqrt( i )
		--dummy = 1 * i
	end
end




return gameLogic