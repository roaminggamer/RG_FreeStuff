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
	local speedup = round( delta/time1, 4) * 100
	return time1,time2,delta,speedup
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
round = function (val, n)
  if (n) then
    return math.floor( (val * 10^n) + 0.5) / (10^n)
  else
    return math.floor(val+0.5)
  end
end

fnn = function ( ... ) 
	for i = 1, #arg do
		local theArg = arg[i]
		if(theArg ~= nil) then return theArg end
	end
	return nil
end

-- Package it all as a module.
--
local public = {}
public.measureTime = measureExcutionTime
public.measureABTime = measureVSTime
public.getMemCount = getMemCount
public.round = round
return public

