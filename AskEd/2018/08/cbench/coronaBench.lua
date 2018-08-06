-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
local runDelay = 250
local resumeDelay = 250

local debugLevel = 0
-- 0 - No printing
-- 1 - ...
-- 2 - ...
-- 3 - ...

local function dprint( level, ... )
	if( debugLevel >= level ) then
		print( unpack(arg) )
	end
end
if(debugLevel <= 0) then dprint = function() end end


function mean_and_stddev (values)
	local sum,n = 0,#values

	for i = 1,n do
		sum = sum + values[i]
	end

	local mean = sum/n
	sum = 0,0

	for i = 1,n do
		sum = sum + (mean - values[i])^2
	end

	return mean, math.sqrt(sum/n)
end

--- Removes all references to a module.
-- Do not call unrequire on a shared library based module unless you are 100% confidant that nothing uses the module anymore.
-- @param m Name of the module you want removed.
-- @return Returns true if all references were removed, false otherwise.
-- @return If returns false, then this is an error message describing why the references weren't removed.
local function unrequire(m)

	package.loaded[m] = nil
	_G[m] = nil

	-- Search for the shared library handle in the registry and erase it
	local registry = debug.getregistry()
	local nMatches, mKey, mt = 0, nil, registry['_LOADLIB']
 
	for key, ud in pairs(registry) do
		if type(key) == 'string' and type(ud) == 'userdata' and getmetatable(ud) == mt and string.find(key, "LOADLIB: .*" .. m) then
			nMatches = nMatches + 1
			if nMatches > 1 then
				return false, "More than one possible key for module '" .. m .. "'. Can't decide which one to erase."
			end
			mKey = key
		end
	end
 
	if mKey then
		registry[mKey] = nil
	end 
	return true
end


local benchLogic = {}

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables
local layers -- Local reference to display layers 
local overlayImage 
local backImage

local results

local meter

local screenGroup

local theCO

local startValue
local endValue

local benchmarkFileName
local benchModule

local iterations
local numOps

local maxIter

local benchName 
local benchType
local prep

local cleanup
local theBenchmark

local system_getTimer = system.getTimer

function benchLogic:create( benchmarkName )
	screenGroup = display.newGroup()	

	meter = display.newGroup()
	--screenGroup:insert( meter)

	meter.back = display.newRect( meter, w-90, 10, 80, 40 )
	meter.back:setFillColor(0,0,0)
	meter.back.strokeWidth = 2
	meter.back:setStrokeColor(255,255,0)

	meter.count = display.newText( meter, "prepare", 0,0, native.systemFontBold, 18 )
	meter.count.x = meter.back.x
	meter.count.y = meter.back.y

	benchModule = require( "benchmarks." .. benchmarkName )
	dprint(2,"benchmarks." .. benchmarkName, benchModule )

	benchmarkFileName = benchmarkName
	benchType	      = benchModule.benchtype

	iterations        = benchModule.iterations or 30
	numOps            = benchModule.numOps or 100000
	maxIter		      = benchModule.maxIter or 6000	
	benchName         = benchModule.name
	prep              = benchModule.prep
	cleanup           = benchModule.cleanup
	theBenchmark      = benchModule.bench 

	if( prep ) then prep( screenGroup ) end

	--collectgarbage( "collect" )		
	--collectgarbage( "stop" )		

end

function benchLogic:run( co )
	results = {}
	results.benchName = benchName
	results.benchType = benchType

	results.values = {}

	theCO = co
	timer.performWithDelay( 1, 
		function()	
			if(benchType == "ops") then
				self:runOPS( )	

			elseif(benchType == "mem") then
				self:runMEM( )	

			elseif(benchType == "fps") then
				self:runFPS( )	

			end 
		end )
end

-- Operations/Second Measurement
--
local curIter = 0 
local onOPS
onOPS = function()

	dprint(3,round( 100 * curIter / iterations ) .. "%")
	meter.count.text = round( 100 * curIter / iterations ) .. "%"

	curIter = curIter + 1

	if( curIter > iterations ) then
		Runtime:removeEventListener( "enterFrame", onOPS )

		
		timer.performWithDelay( resumeDelay,
			function()	
				dprint(3,"\n\nResuming....\n\n")
				coroutine.resume( theCO )			
			end )
	else
		startValue = system_getTimer()
		theBenchmark( numOps )
		endValue = system_getTimer()		
		local durationMS = endValue-startValue
		results.values[#results.values+1] = durationMS
	end
end


function benchLogic:runOPS( )
	results.iterations = iterations
	results.numOps = numOps

	curIter = 0

	timer.performWithDelay( runDelay, 
		function()
			Runtime:addEventListener( "enterFrame", onOPS )  -- EFM add delay here for official runs
		end ) 	
end


-- Memory Usage Measurement
--
local curMemIter = -4 -- Do three warmup runs
local onMEM
onMEM = function()


	if(curMemIter > 0 ) then
		dprint(3,round( 100 * curMemIter / iterations ) .. "%")
		meter.count.text = round( 100 * curMemIter / iterations ) .. "%"
	end
	
	curMemIter = curMemIter + 1
	
	if( curMemIter > iterations ) then
		Runtime:removeEventListener( "enterFrame", onMEM )

		
		timer.performWithDelay( resumeDelay,
			function()	
				dprint(3,"\n\nResuming....\n\n")
				coroutine.resume( theCO )			
			end )
	elseif(curMemIter > 0) then
		collectgarbage()
		startValue = collectgarbage("count")
		theBenchmark( numOps )
		endValue = collectgarbage("count")
		collectgarbage() -- EFM
		local memCost = endValue-startValue
		dprint(3,#results.values+1, startValue,endValue, memCost)
		results.values[#results.values+1] = memCost
	else
		collectgarbage()
		startValue = collectgarbage("count")
		theBenchmark( numOps )
		endValue = collectgarbage("count")
		collectgarbage() -- EFM
		local memCost = endValue-startValue
		dprint(3,startValue,endValue, memCost)
	end
end


function benchLogic:runMEM( )
	results.iterations = iterations
	results.numOps = numOps

	curMemIter = -4 -- Do three warmup runs

	timer.performWithDelay( runDelay, 
		function()
			Runtime:addEventListener( "enterFrame", onMEM )  -- EFM add delay here for official runs
		end ) 	
end



-- Frames/Second Measurement
--
local frameCount = 0
local totalFPS = 0
local onFPS

local measuring = false
local lastTime = 0
local curTime = 0

onFPS = function( event )

	curTime = event.time

	if( not measuring ) then
		measuring = true
		lastTime = curTime
		results.startTime = curTime
	
	elseif( frameCount >= iterations ) then
		Runtime:removeEventListener( "enterFrame", onFPS )

		results.frameCount = frameCount
		results.stopTime = lastTime
		
		timer.performWithDelay( resumeDelay,
			function()	
				dprint(3,"\n\nResuming....\n\n")
				coroutine.resume( theCO )			
			end )
	else
		
		frameCount = frameCount + 1
		results.values[frameCount] = curTime - lastTime

		dprint(3,frameCount, curTime)

		dprint(3,curTime, lastTime, curTime - lastTime)

		meter.count.text = frameCount .. " / " .. iterations

		if( numOps > 0 ) then
			theBenchmark( curTime, numOps )
		end

		lastTime = curTime
	
	end
	return true
end

function benchLogic:runFPS( )	
	measuring = false
	frameCount = 0
	totalFPS = 0


	timer.performWithDelay( runDelay, 
		function()
			Runtime:addEventListener( "enterFrame", onFPS )  -- EFM add delay here for official runs
		end ) 
end




function benchLogic:destroy()

	-- 0. Remove the meter
	if(meter) then
		if(meter.removeSelf) then
			meter:removeSelf()
		end
		meter = nil
	end

	-- 1. Call the user's cleanup code
	if( cleanup ) then cleanup() end

	-- 2. Remove the screen group to clean up any display objects that may have been created
	screenGroup:removeSelf()
	screenGroup = nil

	-- 3. unrequire the benchmark module (Releases the memory associated with this test module.)
	unrequire( "benchmarks." .. benchmarkFileName )

	-- 4. Force garbage collection
	--collectgarbage( "restart" )		
	collectgarbage( "collect" )
end

function benchLogic:getResults()
	return results
end


function benchLogic:accumulate()
	
	--  Accumulate results from Operations/Sec Test
	--
	if(benchType == "ops") then

		results.totalDuration = 0
		results.totalOperations = results.iterations * results.numOps
		local OPS = 0

		for i = 1, #results.values do
			results.totalDuration = results.totalDuration + results.values[i]
		end

		if( results.totalDuration > 0) then
			OPS = round( (results.totalOperations / results.totalDuration) * 1000, 2 )
			results.totalOperationsPerSecond = OPS
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

			results.OPSMessage = OPS .. suffix .. " ops/s"		
		else
			results.totalOperationsPerSecond = -1
			results.OPSMessage = "too fast"
		end

	--  Accumulate results from Mem Usage Test
	--
	elseif(benchType == "mem") then

		local totalMem = 0
		local rValues = results.values

		for i = 1, #rValues do
			totalMem = totalMem + rValues[i]
		end

		results.averageMem = totalMem/#rValues
		results.averageMemPerSample = results.averageMem/results.numOps
		results.perKB = 1/ results.averageMemPerSample
		results.memMsg = "Mem for " .. numOps .. " units: " .. round(results.averageMem,2) .. "KB; "..
		                 round(results.perKB,2) .. " units per KB; " .. 
						 round(results.averageMemPerSample,2) .. "KB per unit"
		 
		 
	--  Accumulate results from Frames/Sec Test
	--
	elseif(benchType == "fps") then
		
		results.perFrameFPS = {}

		local frameTime = 0
		local minFPS = 99999
		local maxFPS = 0
		local curFPS = 0
		local lastTime = 0

		for i = 1, #results.values do
			dprint(3,"frameTime", frameTime)
			frameTime = results.values[i]
			dprint(3,i,frameTime)
			curFPS = 1000/frameTime
			results.perFrameFPS[i] = curFPS
			if(curFPS > maxFPS) then maxFPS = curFPS end
			if(curFPS < minFPS) then minFPS = curFPS end
		end

		results.totalFrameTimes = results.stopTime - results.startTime
		results.minFPS = minFPS
		results.maxFPS = maxFPS
		results.avgFPS = (1000 * results.frameCount) / results.totalFrameTimes

		dprint(2,"totalFrameTimes ",results.totalFrameTimes, results.startTime, results.stopTime)

		local mean, stddev = mean_and_stddev( results.perFrameFPS )
		--local mean, stddev = mean_and_stddev( results.values )
	
		results.mean = mean
		results.stddev = stddev

	end 
end

return benchLogic