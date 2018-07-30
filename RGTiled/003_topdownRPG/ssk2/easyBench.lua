-- =============================================================
-- Copyright Roaming Gamer, LLC. 2008-2018 (All Rights Reserved)
-- =============================================================
local getTimer  = system.getTimer

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

-- ==
--    round(val, n) - Rounds a number to the nearest decimal places. (http://lua-users.org/wiki/FormattingNumbers)
--    val - The value to round.
--    n - Number of decimal places to round to.
-- ==
local function round(val, n)
  if (n) then
    return math.floor( (val * 10^n) + 0.5) / (10^n)
  else
    return math.floor(val+0.5)
  end
end

if( not _G.ssk ) then
	_G.ssk = {}
end
local easyBench = {}
_G.ssk.easyBench = easyBench

local beginTime = 0
local endTime = 0

easyBench.start = function()
	beginTime = getTimer()
end

easyBench.stop = function()
	endTime = getTimer()
end

easyBench.getTime = function()
	return (endTime-beginTime)
end

easyBench.getMetrics = function( iterations, decimalPlaces )
	iterations = iterations or 1
	decimalPlaces = decimalPlaces or 2

	local ms = (endTime-beginTime)
	local perMS = iterations/ms
	local perS = perMS * 1000

	return ms, round(ms/1000,decimalPlaces), round(perMS,decimalPlaces), round(perS,decimalPlaces)
end

-- FROM SIMPLE BENCH
local getTimer = system.getTimer
local fnn 
local round


-- Functions for measuring execution times
--
local function measureExcutionTime( func, iter )	
	local func = func
	local startTime
	local endTime
	if( iter ) then
		startTime = getTimer()
		for i = 1, iter do
			func()
		end
		endTime = getTimer()
	else
		startTime = getTimer()
		func()
		endTime = getTimer()	
	end

	return endTime - startTime
end

local function measureVSTime( func1, func2, iter )
	local time1 = measureExcutionTime( func1, iter )
	local time2 = measureExcutionTime( func2, iter )
	local delta = time1-time2
	if( math.abs(delta) < 0.01 ) then return time1, time2, delta, 0 end
	if( delta > 0 ) then
		local speedup = round( 1/(delta/time2), 4) * 100
		return time1,time2,delta,speedup
	else
		local speedup = round( 1/(delta/time1), 4) * 100
		return time1,time2,delta,speedup
	end
end

-- Functions for measuring memory usage an deltas
--
local lastMem 
local function getMemCount( collect )
	local collect = fnn( collect, true )
	if( collect ) then
		collectgarbage( "collect" )
	end

	local curMem = collectgarbage("count")
	if(lastMem == nil) then lastMem = curMem end
	local delta = curMem - lastMem
	lastMem = curMem
	return curMem,lastMem
end

-- Helper functions
--
local mFloor = math.floor
round = function (val, n)
  if (n) then
    return mFloor( (val * 10^n) + 0.5) / (10^n)
  else
    return mFloor(val+0.5)
  end
end

fnn = function ( ... ) 
	for i = 1, #arg do
		local theArg = arg[i]
		if(theArg ~= nil) then return theArg end
	end
	return nil
end

--[[ USAGE SAMPLE

--
-- 
-- 
local round 		= bench.round
local mRand 		= math.random
local subVec 		= math2d.subVec
local angle2Vec 	= math2d.angle2Vec
local angle2Vec2 	= math2d.angle2Vec2
local vec2Angle 	= math2d.vec2Angle
local normVec 		= math2d.normVec

local lenVecR 		= rmath2d.length


local mSqrt = math.sqrt
local vec = { x = 100, y = 100 }

-- Slow version
local function test1( iter)
	for i = 1, 100000 do
		lenVecR( vec )		
	end
end

-- Faster Version
local function test2()
	for i = 1, 100000 do
		mSqrt(vec.x*vec.x+vec.y*vec.y)
	end
end


-- Measuring attempt 1 (one iteration per test)
--
local time1,time2,delta,speedup = bench.measureABTime( test1, test2 )
print( "\nSingle run 100,000 calculations.")
print( "Test 1: " .. round(time1/1000,2) .. " seconds.")
print( "Test 2: " .. round(time2/1000,2) .. " seconds.")
print( "Test 2 is " .. speedup .. " percent faster .")
if( speedup == 0 ) then
	print( "Tests may have run too fast to measure appreciable speedup.")
end

]]


easyBench.measureTime = measureExcutionTime
easyBench.measureABTime = measureVSTime
easyBench.getMemCount = getMemCount
easyBench.round = round


return easyBench