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

local preTest1
local preTest2
local theBenchmark1 
local theBenchmark2 
local postTest1 
local postTest2
local iterate 
local accumulate 

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
		local results1, results2 = iterate( 50, 100000 )
		accumulate( results1, results2 )
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

preTest1 = function()
	startTime = system.getTimer()
end

postTest1 = function()
	endTime = system.getTimer()
	return endTime-startTime
end

preTest2 = function()
	startTime = system.getTimer()
end

postTest2 = function()
	endTime = system.getTimer()
	return endTime-startTime
end

oneTimeGather = function()
end

iterate = function( iterations, numOps )
	local results1 = {}
	local results2 = {}
	local iterations = iterations or 1 -- Default to 1 iteration
	local numOps     = numOps or 100000 -- Default to 100K ops

	results1.iterations = iterations
	results1.numOps = numOps

	--results2.iterations = iterations -- SHOULD BE SAME AS #1 ANYWAYS
	--results2.numOps = numOps  -- SHOULD BE SAME AS #1 ANYWAYS

	for i = 1, iterations do
		preTest1()
		theBenchmark1( numOps )
		local durationMS = postTest1()
		results1[#results1+1] = durationMS
	end

	for i = 1, iterations do
		preTest2()
		theBenchmark2( numOps )
		local durationMS = postTest2()
		results2[#results2+1] = durationMS
	end

	return results1, results2 
end

accumulate = function( results1, results2 )
	local totalDurationMS1 = 0
	local totalDurationMS2 = 0
	local totalOperations = results1.iterations * results1.numOps
	
	for i = 1, #results1 do
		totalDurationMS1 = totalDurationMS1 + results1[i]
	end

	for i = 1, #results2 do
		totalDurationMS2 = totalDurationMS2 + results2[i]
	end

	if( totalDurationMS1 > 0 and totalDurationMS2 > 0) then
		local OPS1 = round( (totalOperations / totalDurationMS1) * 1000, 2 )
		local OPS2 = round( (totalOperations / totalDurationMS2) * 1000, 2 )

		local suffix1 = ""
		if(OPS1 > 1000000000) then
			OPS1 = round(OPS1/1000000000,2)
			suffix1 = " G"
		elseif(OPS1 > 1000000) then
			OPS1 = round(OPS1/1000000,2)
			suffix1 = " M"
		elseif(OPS1 > 1000) then
			OPS1 = round(OPS1/1000,2)
			suffix1 = " K"
		end

		local suffix2 = ""
		if(OPS2 > 1000000000) then
			OPS2 = round(OPS2/1000000000,2)
			suffix2 = " G"
		elseif(OPS2 > 1000000) then
			OPS2 = round(OPS2/1000000,2)
			suffix2 = " M"
		elseif(OPS2 > 1000) then
			OPS2 = round(OPS2/1000,2)
			suffix2 = " K"
		end

		_G.lastResultMessage = "math.sqrt() - local vs. remote: " ..
			                    OPS1 .. suffix1 .. " ops/s" .. " vs. " ..
								OPS2 .. suffix2 .. " ops/s " 

	else
		_G.lastResultMessage = "Benchmark failed.  Try increasing number of iterations." 
	end

	dprint(2, _G.lastResultMessage)

	return OPS	
end

theBenchmark1 = function( numOps )
	local sqrt = math.sqrt
	local dummy
	for i = 1, numOps do
		--local sqrt = math.sqrt
		sqrt( i )
	end
end

theBenchmark2 = function( numOps )
	local dummy
	for i = 1, numOps do
		math.sqrt( i )
	end
end




return gameLogic