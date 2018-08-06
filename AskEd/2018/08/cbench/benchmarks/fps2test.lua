-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
local benchtype = "fpstarget" -- Measures Raw Operations Per Second
local name = "FPS Test"
local benchOuter = 30 -- Times to run benchmark
local benchInner = 10000 -- Number of innner loops to run

local targetFPS = 30
local maxIter = 6000

local mRand = math.random

local payload = {}

local localGroup

-- Any prep work you need to do before starting the benchmark  (not measured)
local function prep( group )
	local w = w - 10
	local h = h - 10

	localGroup = group

	for i = 1, 20000 do
		local x = mRand( 10, w )
		local y = mRand( 10, h )
		tmp = display.newCircle( group, x, y, 20 )
		tmp:setFillColor( mRand(),mRand(),mRand() )

		payload[#payload+1] = tmp
	end

end

-- This function increases the workload
local function incr(  )
	local w = w - 10
	local h = h - 10

	for i = 1, 200 do
		local x = mRand( 10, w )
		local y = mRand( 10, h )
		tmp = display.newCircle( localGroup, x, y, 20 )
		tmp:setFillColor( mRand(),mRand(),mRand() )

		payload[#payload+1] = tmp
	end
end

-- This function decreases the workload
local function decr(  )
	local tmp
	for i = 1, 100 do
		if(#payload > 0) then
			tmp = payload[#payload]
			tmp:removeSelf()
			payload[#payload] = nil
		end
	end
end



-- This function returns the final 'count' for whatever test you were doing.
local function getCount( group )
	return #payload
end


-- Any cleanup work you need to do after the benchmark (not measured)
local function cleanup( group )
	localGroup = nil
	payload = {}
end

-- The actual benchmark (measured)
local  lastTime = -1
local function bench( time, numOps )
	-- DO ANY WORK HERE
end

-- DO NOT EDIT BELOW THIS LINE
local public = {}
public.benchtype = benchtype
public.name = name
public.prep = prep
public.incr = incr
public.decr = decr
public.getCount = getCount
public.targetFPS = targetFPS
public.maxIter = maxIter
public.cleanup = cleanup
public.bench = bench
public.iterations = benchOuter
public.numOps = benchInner

return public
